Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3HMHBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:01:30 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64555 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3HMHB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:01:28 -0400
From: Shyam Kaushik <shyam@zadarastorage.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Ac6X8k59hs3hR1G+T7+M7pmVA7CvDwAABCbAAAAgZ9A=
Date: Tue, 13 Aug 2013 12:31:29 +0530
Message-ID: <9a92eee58fefc1b8e3b4771ecf210d29@mail.gmail.com>
Subject: BUG REPORT - IDR wraps around at 30-bits - works very bad with NFSD/SCTP
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

We are using Ubuntu linux kernel 3.2.0-25-generic & 3.8.13-030813-generic
in our environments, but I think this bug is still present in mainline
kernel. Clients of IDR rollover at MAX_INT (NFSD & SCTP in kernel do this)
& others on MAX_IDR_MASK. This is ideally 2^31. But there is some BUG
within IDR that it wraps over at 2^30.

NFSD uses IDR for maintaining its stateids & tracks min_stateid with a
static variable which keeps incrementing. So over a period of time NFSD
could run into the issue that it allocates an ID with IDR, but IDR cant
locate this ID, resulting in NFSD constantly sending BAD_STATEIDS to all
its clients.

Following short driver (which closely resembles NFSD usage of IDR) shows
the BUG within IDR:

#include <linux/module.h>
#include <linux/init.h>
#include <linux/version.h>
#include <linux/idr.h>

static int log_idr_entry(int id, void *ptr, void *data)
{
        int     *expected_val = (int *)ptr;

        pr_info("\tIDR Actual ID[%d] %s Expected Value[%d]\n", id, (id ==
*expected_val)?"==":"!=", *expected_val);
        return 0;
}

static void process_idr_entry(struct idr *stateids, int min_stateid)
{
        int             new_stid;
        int             error;

        pr_info("\nProcessing for min_stateid[%d]\n", min_stateid);
        if (!idr_pre_get(stateids, GFP_KERNEL)) {
                pr_info("Failed to pre-get\n");
                return;
        }

        error = idr_get_new_above(stateids, &new_stid, min_stateid,
&new_stid);
        if (error) {
                pr_info("Failed to get new id\n");
                idr_remove(stateids, new_stid);
                return;
        }

        pr_info("Allocated new_stid[%d]\n", new_stid);

        if (!idr_find(stateids, new_stid))
                pr_info("BUG: Cant find ID[%d]\n", new_stid);

        pr_info("Dumping entries in IDR\n");
        idr_for_each(stateids, &log_idr_entry, NULL);
        idr_remove(stateids, new_stid);
}

void driver_exit(void)
{
}

int driver_init(void)
{
        struct idr      stateids;

        pr_info("%d\n", MAX_INT);
        idr_init(&stateids);
        process_idr_entry(&stateids, 0/*min_stateid*/);
        process_idr_entry(&stateids, 1073741823/*min_stateid*/);
        process_idr_entry(&stateids, 1073741824/*min_stateid*/);
        idr_remove_all(&stateids);
        idr_destroy(&stateids);
        return 0;
}

module_init(driver_init);
module_exit(driver_exit);


Upon loading the driver, the following message shows up
[71641.440846] Processing for min_stateid[0]
[71641.440857] Allocated new_stid[0]
[71641.440859] Dumping entries in IDR
[71641.440861]  IDR Actual ID[0] == Expected Value[0]
[71641.440864]
[71641.440864] Processing for min_stateid[1073741823]
[71641.440867] Allocated new_stid[1073741823]
[71641.440868] Dumping entries in IDR
[71641.440876]  IDR Actual ID[1073741823] == Expected Value[1073741823]
[71641.440878]
[71641.440878] Processing for min_stateid[1073741824]
[71641.440883] Allocated new_stid[1073741824]
[71641.440884] BUG: Cant find ID[1073741824]
[71641.440886] Dumping entries in IDR
[71641.440887]  IDR Actual ID[0] != Expected Value[1073741824]

i.e. when we allocate a stated==1073741824, IDR internally has it as 0.

--Shyam
