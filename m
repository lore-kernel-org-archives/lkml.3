Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaKRAPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:15:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:36391 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaKRAPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:15:15 -0500
Date: Tue, 18 Nov 2014 01:15:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFxq3-2qb76-xaR-sid9nxLYK7rcnm08w2NQzUcgPFKz2A@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411180107030.3909@nanos>
References: <20141114213124.GB3344@redhat.com> <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com> <alpine.DEB.2.11.1411142326510.3909@nanos> <CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
 <CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com> <alpine.DEB.2.11.1411172303070.3909@nanos> <alpine.DEB.2.11.1411172335100.3909@nanos> <CA+55aFxq3-2qb76-xaR-sid9nxLYK7rcnm08w2NQzUcgPFKz2A@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Linus Torvalds wrote:
> On Mon, Nov 17, 2014 at 2:43 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > So a combo of both (Jens and yours) might do the trick. Patch below.
> 
> Yeah, I guess that would work. The important part is that *if*
> somebody really reuses the csd, we'd better have a release barrier
> (which csd_unlock() does, although badly - but this probably isn't
> that performance-critical) *before* we call the function, because
> otherwise there's no real serialization for the reuse.

Indeed.
 
> Of course, most of these things are presumably always per-cpu data
> structures, so the whole worry about "csd" being accessed from
> different CPU's probably doesn't even exist, and this all works fine
> as-is anyway, even in the presense of odd memory ordering issues.
> 
> Judging from Jens' later email, it looks like we simply don't need
> this code at all any more, though, and we could just revert the
> commit.

Right. Reverting it is the proper solution for now. Though we should
really think about the async seperation later. It makes a lot of
sense.

> NOTE! I don't think this actually has anything to do with the actual
> problem that Dave saw. I just reacted to that WARN_ON() when I was
> looking at the code, and it made me go "that looks extremely
> suspicious".

One thing I was looking into today is the increased use of irq_work
which uses IPIs as well. Not sure whether that's related, but I it's
not from my radar yet.

But the possible compiler wreckage (or exposed kernel wreckage) is
frightening in several aspects ...

> Particularly on x86, with strong memory ordering, I don't think that
> any random accesses to 'csd' after the call to 'csd->func()' could
> actually matter. I just felt very nervous about the claim that
> somebody can reuse the csd immediately, that smelled bad to me from a
> *conceptual* standpoint, even if I suspect it works perfectly fine in
> practice.
> 
> Anyway, I've found *another* race condition, which (again) doesn't
> actually seem to be an issue on x86.
> 
> In particular, "csd_lock()" does things pretty well, in that it does a
> smp_mb() after setting the lock bit, so certainly nothing afterwards
> will leak out of that locked region.
> 
> But look at csd_lock_wait(). It just does
> 
>         while (csd->flags & CSD_FLAG_LOCK)
>                 cpu_relax();
> 
> and basically there's no memory barriers there. Now, on x86, this is a
> non-issue, since all reads act as an acquire, but at least in *theory*
> we have this completely unordered read going on. So any subsequent
> memory oeprations (ie after the return from generic_exec_single()
> could in theory see data from *before* the read.

True.
 
> So that whole kernel/smp.c locking looks rather dubious. The smp_mb()
> in csd_lock() is overkill (a "smp_store_release()" should be
> sufficient), and I think that the read of csd->flags in csd_unlock()
> should be a smp_load_acquire().
> 
> Again, none of this has anything to do with Dave's problem. The memory
> ordering issues really cannot be an issue on x86, I'm just saying that
> there's code there that makes me a bit uncomfortable.

Right you are and we should fix it asap.

Thanks,

	tglx
