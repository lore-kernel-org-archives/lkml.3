Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3G3NYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:24:49 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:45634 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3G3NYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:24:47 -0400
Date: Tue, 30 Jul 2013 21:24:14 +0800
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        djbw@fb.com
Subject: Re: [patch 3/3] raid5: only wakeup necessary threads
Message-ID: <20130730132414.GB30352@kernel.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055425.056034691@kernel.org>
 <20130730124655.GB2599@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730124655.GB2599@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 08:46:55AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jul 30, 2013 at 01:52:10PM +0800, shli@kernel.org wrote:
> > If there are no enough stripes to handle, we'd better now always queue all
> > available work_structs. If one worker can only handle small or even none
> > stripes, it will impact request merge and create lock contention.
> > 
> > With this patch, the number of work_struct running will depend on pending
> > stripes number. Not some statistics info used in the patch are accessed without
> > locking protection. Yhis should doesn't matter, we just try best to avoid queue
> > unnecessary work_struct.
> 
> I haven't really followed the code but two general comments.
> 
> * Stacking drivers in general should always try to keep the bios
>   passing through in the same order that they are received.  The order
>   of bios is an important information to the io scheduler and io
>   scheduling will suffer badly if the bios are shuffled by the
>   stacking driver.  It'd probably be a good idea to have a mechanism
>   to keep the issue order intact even when multiple workers are
>   employed.

In the raid5 case, it's very hard to keep the order the bios passed in, because
we need read some disks, calculate parity, and write some disks, the timing
could break any kind of order. Besides the workqueue handles 8 stripes one
time, so I suppose this keeps some order if there is.
 
> * While limiting the number of work_struct dynamically could be
>   beneficial and it's upto Neil, it'd be nice if you can accompany it
>   with some numbers so that whether such optimization actually is
>   worthwhile or not can be decided.  The same goes for the whole
>   series, I suppose.

Sure, I can add the number in next post. Basically if I let 8 worker running
for 7 disks raid5 setup, multi-threading is 4x ~ 5x faster.

Thanks,
Shaohua
