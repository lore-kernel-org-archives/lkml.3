Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaJTQAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:00:22 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46105 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaJTQAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:00:19 -0400
Date: Mon, 20 Oct 2014 17:00:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
Message-ID: <20141020160009.GK23751@e104818-lin.cambridge.arm.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
 <1413617580.29249.9.camel@linux-t7sj.site>
 <1413662314.17869.11.camel@linux-t7sj.site>
 <CA+55aFzmsF4F-SOO4OzZDbreaQ4X4RUCQksv_ONu59BbyZ8Ocg@mail.gmail.com>
 <1413684978.17869.18.camel@linux-t7sj.site>
 <alpine.DEB.2.11.1410201106260.4121@nanos>
 <20141020104926.GD23751@e104818-lin.cambridge.arm.com>
 <CA+55aFxjFpPWMn=w1orFk3k7-ZaWwFoLsv7y37X5zamd428BsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxjFpPWMn=w1orFk3k7-ZaWwFoLsv7y37X5zamd428BsQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 04:32:00PM +0100, Linus Torvalds wrote:
> On Mon, Oct 20, 2014 at 3:49 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > Since you mention symmetry, something like below makes the barriers more
> > explicit.
> 
> Borken, for two reasons:
> 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index f3a3a071283c..5b9d857d0816 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -143,9 +143,7 @@
> >  static inline void futex_get_mm(union futex_key *key)
> >  {
> >         atomic_inc(&key->private.mm->mm_count);
> > -       /*
> > -        * Ensure futex_get_mm() implies a full barrier such that
> > -        * get_futex_key() implies a full barrier. This is relied upon
> > -        * as full barrier (B), see the ordering comment above.
> > -        */
> > -       smp_mb__after_atomic();
> >  }
> 
> So the thing is, this means that we can't take advantage of the fact
> that "atomic_inc" is already an atomic. So this is just a performance
> breakage. But:

OK, I looked at this from an ARM perspective only and it would not make
any difference. But it seems that MIPS makes a distinction between
"before" and "after" barriers with "before" defined as wmb in some
configuration, so the hunk below would break it.

> >  static inline int hb_waiters_pending(struct futex_hash_bucket *hb)
> >  {
> > +       /*
> > +        * Full barrier (B), see the ordering comment above.
> > +        */
> > +       smp_mb__before_atomic();
> >  #ifdef CONFIG_SMP
> >         return atomic_read(&hb->waiters);
> 
> This is just entirely broken.
> 
> "atomic_read()" isn't really an "atomic op" at all. despite the name,
> it's just a read that is basically ACCESS_ONCE.
> 
> So smp_mb__before_atomic() doesn't work for atomic_read(), and the
> code is nonsensical and doesn't work. It would need to be a full
> memory barrier.

Looking at the semantics of smp_mb__*_atomic(), it would indeed have to
be a full smp_mb() here.

-- 
Catalin
