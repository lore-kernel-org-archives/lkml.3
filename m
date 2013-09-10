Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3IJTPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:15:45 -0400
Received: from 1wt.eu ([62.212.114.60]:37513 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab3IJTPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:15:42 -0400
Date: Tue, 10 Sep 2013 21:15:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Rich, Jason" <jason.rich@tekcomms.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic at _blk_run_queue on 2.6.32
Message-ID: <20130910191537.GB27957@1wt.eu>
References: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net> <20130710202729.GA18877@1wt.eu> <636295BFF4A001418A00F46569A2CD2B1624BA1A@US-PLNO-EXM01-P.global.tektronix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <636295BFF4A001418A00F46569A2CD2B1624BA1A@US-PLNO-EXM01-P.global.tektronix.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Tue, Sep 10, 2013 at 06:04:01PM +0000, Rich, Jason wrote:
> Greeting Willy,
> You helped me out with this particular issue about 2 months ago.

Yes I remember this.

> What we found is that my particular panic appears to be addressed by a
> specific commit you referred me to:
> b485462 [SCSI] Stop accepting SCSI requests before removing a device

That's really nice. The commit message there clearly describes a bug that
would probably be suitable for backporting anyway to 3.0 and up. I want to
thank you for all the efforts you're making to get rid of this bug, it's
above average and a good example of how to improve the kernel's quality.

> Without going into too much detail, I'm not able to jump directly to that
> hash because I have about 7 different drivers failing to compile due to other
> changes between 2.6.32.61 and that hash.  In particular, some header files
> were renamed, others deleted and replaced by newer features.  To go through
> and update my proprietary drivers is as big of a headache as just getting
> this scsi panic fixed on top of patch 61.

This reminds me old very bad memories that taught me to never ever accept
to run any proprietary driver anymore, and I select my hardware based on
this. My freedom to go back and forth kernel versions is more important
than using the latest shiny hardware.

> I've spent the last couple of weeks playing with getting the scsi fix applied
> on top of patch 61 and am having a very difficult time.  There are so many
> dependencies from prior commits to the scsi code it is making it quite
> difficult to determine what exactly I need.  

Just seen that, it looks like b485462 depends on requeue_work which was
introduced in 9937a5e2f (2.6.39), itself depending on c21e6beb (2.6.39
as well).

> I'm hoping you might be able to help me out with some advice or perhaps you
> are familiar enough with the scsi code as to help me apply the concept of the
> fix to the top of patch 61.

No I'm not familiar, each time I dig in most parts, it's to diagnose an issue
in a stable branch :-)

However what I can say is that 9937a5e2f was emitted to address an issue
introduced as a side effect of c21e6beb. Thus, my understanding is that in
b485462, the changes to __scsi_remove_device() involving cancel_work_sync()
directly derive from 9937a5e2f being already merged. As such, I would suggest
that you try to apply the patch without the cancel_work_sync() part. I would
even try without the change to __scsi_remove_device().

Have you tried to only backport the __scsi_queue_insert() changes ? If it
works it would be much more suitable for a branch like 2.6.32.

> I have attached the patch I've come up with so
> far, but this is obviously missing other dependencies as I keep ending up
> with panics.  It goes without saying that this code is very foreign to me and
> I don't completely understand what it is doing.

Welcome :-) There is no better school for learning the kernel's internals
than trying to fix an obscure bug that hits you. The only thing is that you'd
prefer an easily reproducible one to progress faster!

> I know your time is valuable so I've attached the patch I've been working on
> so far, however, this code causes its own kernel panic and should not be run
> on a live system.  That said, perhaps it will give you a baseline as to what
> I'm trying to do.  Again, this patch is based off on the official 2.6.32.61
> tag.

OK so please try first with only the first half of patch b485462, then if it
still fails, please add the second part without the call to cancel_work().

Then whatever the result, we'll have to bring the participants to this patch
into the discussion to validate if it should be backported or not, and if they
think your fix might uncover a new bug.

Thanks!
Willy

