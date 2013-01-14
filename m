Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3ANPWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:22:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab3ANPWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:22:39 -0500
Date: Mon, 14 Jan 2013 10:22:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        tj <tj@kernel.org>
Subject: Re: Re: [PATCH] blkcg: Before starting a new slice, firstly count
 bps/iops limit in func tg_may_dispatch.
Message-ID: <20130114152233.GB2380@redhat.com>
References: <201301111711251317275@gmail.com>
 <50F0211D.7040209@kernel.dk>
 <20130111191726.GB12019@redhat.com>
 <201301141015538278161@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301141015538278161@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:15:58AM +0800, majianpeng wrote:

[..]
> >Index: linux-2.6/block/blk-throttle.c
> >===================================================================
> >--- linux-2.6.orig/block/blk-throttle.c	2012-10-18 01:52:28.000000000 -0400
> >+++ linux-2.6/block/blk-throttle.c	2013-01-14 03:40:41.355731375 -0500
> >@@ -648,8 +648,14 @@ static bool tg_may_dispatch(struct throt
> > 	 * If previous slice expired, start a new one otherwise renew/extend
> > 	 * existing slice to make sure it is at least throtl_slice interval
> > 	 * long since now.
> >+	 *
> >+	 * Start a new slice only if there is no bio queued in that direction.
> >+	 * That bio is waiting to be dispatched and slice needs to be
> >+	 * extended. It might happen that bio waited to be dispatched but
> >+	 * workqueue execution got little late it might restart a new slice
> >+	 * instead of taking all the waited time into account.
> > 	 */
> >-	if (throtl_slice_used(td, tg, rw))
> >+	if (throtl_slice_used(td, tg, rw) && !tg->nr_queued[rw])
> > 		throtl_start_new_slice(td, tg, rw);
> > 	else {
> > 		if (time_before(tg->slice_end[rw], jiffies + throtl_slice))
> Hi vivek,
> 	Your patch is ok.But i had a question:
> What's condition tg->nr_queued[rw] = 0, but bio is not null?

When a new bio is about to be queued in an empty group (look at
blk_throtl_bio). At that time, tg->nr_queued[rw] might be 0 if no other
bio is already queued.

Thanks
Vivek
