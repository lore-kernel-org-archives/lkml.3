Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3HMHeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:34:22 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:63428 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3HMHeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:34:21 -0400
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <9a92eee58fefc1b8e3b4771ecf210d29@mail.gmail.com> <20130813073304.GA15495@kroah.com>
In-Reply-To: <20130813073304.GA15495@kroah.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Ac6X9yX3V8+p0ftOSQ2onRtX7uhcCAAADJqA
Date: Tue, 13 Aug 2013 13:04:21 +0530
Message-ID: <f94820b47d924f0de5b3a421876d1dce@mail.gmail.com>
Subject: RE: BUG REPORT - IDR wraps around at 30-bits - works very bad with NFSD/SCTP
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I added this later, but realized I couldn’t compile.

Working version of the example is

#include <linux/module.h>
#include <linux/init.h>
#include <linux/version.h>
#include <linux/idr.h>

static int log_idr_entry(int id, void *ptr, void *data)
{
        int     *expected_val = (int *)ptr;

        pr_info("\tIDR Actual ID[%d] %s Expected Value[%d]\n", id, (id ==
*expected_val)?"==":"!=", *expected_val);
        return 0;
}

static void process_idr_entry(struct idr *stateids, int min_stateid)
{
        int             new_stid;
        int             error;

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
        struct idr      stateids;

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

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org]
Sent: Tuesday, August 13, 2013 1:03 PM
To: Shyam Kaushik
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG REPORT - IDR wraps around at 30-bits - works very bad
with NFSD/SCTP

On Tue, Aug 13, 2013 at 12:31:29PM +0530, Shyam Kaushik wrote:
>         pr_info("%d\n", MAX_INT);

How did this line build, there is no MAX_INT in the kernel tree.

odd.

greg k-h

-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 2013.0.2904 / Virus Database: 3211/6571 - Release Date: 08/12/13
