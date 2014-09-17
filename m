Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaIQJft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:35:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:45354 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbaIQJfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:35:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="574328081"
Message-ID: <1410946526.28850.120.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix possible deadlock in erase_worker()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Wed, 17 Sep 2014 12:35:26 +0300
In-Reply-To: <1410853702-11616-1-git-send-email-richard@nod.at>
References: <1410853702-11616-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 09:48 +0200, Richard Weinberger wrote:
> If sync_erase() failes with EINTR, ENOMEM, EAGAIN or
> EBUSY erase_worker() re-schedules the failed work.
> This will lead to a deadlock because erase_worker() is called
> with work_sem held in read mode. And schedule_erase() will take
> this lock again.

There is this code snippet:

        ubi_err("failed to erase PEB %d, error %d", pnum, err);
        kfree(wl_wrk);

        if (err == -EINTR || err == -ENOMEM || err == -EAGAIN ||
            err == -EBUSY) {
                int err1;

                /* Re-schedule the LEB for erasure */
                err1 = schedule_erase(ubi, e, vol_id, lnum, 0);
                if (err1) {
                        err = err1;
                        goto out_ro;
                }
                return err;
        }

How about move 'kfree(wl_wrk)' down, and execute

        __schedule_ubi_work(ubi, wl_wrk)

inside the 'if' clause instead? The fix would seem to be more elegant
then.

Hmm?

-- 
Best Regards,
Artem Bityutskiy

