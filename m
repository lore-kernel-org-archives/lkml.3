Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3ITPpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:45:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50276 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab3ITPpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:45:30 -0400
Date: Fri, 20 Sep 2013 16:45:18 +0100
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH] lockref: use cmpxchg64 explicitly for lockless updates
Message-ID: <20130920154518.GE5015@mudshark.cambridge.arm.com>
References: <1379614006-3844-1-git-send-email-will.deacon@arm.com>
 <CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
 <20130920100806.GA5015@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920100806.GA5015@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 11:08:06AM +0100, Will Deacon wrote:
> On Thu, Sep 19, 2013 at 07:11:32PM +0100, Linus Torvalds wrote:
> > From a performance standpoint, lockref really is expected to mainly
> > help with big machines. Only insane people would do big machines with
> > 32-bit kernels these days.
> 
> Our definitions of "big" machines probably differ significantly, but it
> would be interesting to see if this *does* make a difference on some of the
> multi-cluster ARMv7 hardware.

[...]

> > In other words, I'd actually like to see some numbers if there are
> > loads where this actually helps and matters...
> 
> That's fair enough; I just saw the new lockref stuff, thought "that's a cool
> hack" then looked at playing with it on ARM. I'll go see what this AIM7
> thing is all about...

Right, turns out I can get some interesting numbers from your simple t.c
program on my dual-cluster, 5 CPU ARMv7 machine. The new cmpxchg-based lockref
code gives ~50% improvement, but the fun part is that implementing cmpxchg64
without memory barriers doubles this win to ~100% over current mainline.

If we can guarantee that the CODE just messes around with the lockref, those
barriers probably aren't needed...

As for AIM7/re-aim, I'm having a hard time getting repeatable numbers out of
it to establish a baseline, so it's not proving to be especially helpful.

Will
