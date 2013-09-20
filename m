Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3ITRMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:12:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51496 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab3ITRMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:12:06 -0400
Date: Fri, 20 Sep 2013 18:11:51 +0100
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH] lockref: use cmpxchg64 explicitly for lockless updates
Message-ID: <20130920171151.GB6859@mudshark.cambridge.arm.com>
References: <1379614006-3844-1-git-send-email-will.deacon@arm.com>
 <CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
 <20130920100806.GA5015@mudshark.cambridge.arm.com>
 <20130920154518.GE5015@mudshark.cambridge.arm.com>
 <CA+55aFxh-ueQgpY9sgizTBxqKqrGCTcAM-tw_50LG9wmakziPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxh-ueQgpY9sgizTBxqKqrGCTcAM-tw_50LG9wmakziPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 05:00:19PM +0100, Linus Torvalds wrote:
> On Fri, Sep 20, 2013 at 10:45 AM, Will Deacon <will.deacon@arm.com> wrote:
> > If we can guarantee that the CODE just messes around with the lockref, those
> > barriers probably aren't needed...
> 
> Yes. I've been thyinking about the barrier issue, and as far as I can
> see, as long as the lockref code only ever messes with the reference
> count, a totally unordered cmpxchg is fine.

The only problem then is the use of cmpxchg64 by the sched_clock code.
Whilst most sched_clock() implementations probably have barrier semantics
due to I/O access, that's certainly not true everywhere so I don't think
the cmpxchg64 there can be relaxed safely.

We could add cmpxchg64_relaxed (at the risk of confusing it with the relaxed
I/O accessors, which aren't well defined)? That might help Tony with ia64
too.

> And at least right now we indeed only ever mess with the reference count.
> 
> I have been idly toying with the concept of using the cmpxchg also for
> possibly taking the lock (for the "xyz_or_lock" versions), but every
> time I look at it it seems unlikely to help, and it would require
> memory ordering and various architecture-dependent issues, so I
> suspect it's never going to make much sense. So yes, an unordered
> cmpxchg64 should be perfectly fine.

Yikes, using cmpxchg for the locking sounds scary. For the contended case, I
think spinlocks would be better since they might have back-off and/or
fairness logic which we'd lose if we somehow moved exclusively to cmpxchg.

> > As for AIM7/re-aim, I'm having a hard time getting repeatable numbers out of
> > it to establish a baseline, so it's not proving to be especially helpful.
> 
> That's fine, and yeah, I doubt the t.c improvement really shows
> anywhere else (it's kind of extreme), but your numbers are certainly
> already sufficient to say "ok, it makes sense even on 32-bit
> machines".

Great, thanks.

Will
