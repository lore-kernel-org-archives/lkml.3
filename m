Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaKQX7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:59:08 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:35270 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaKQX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:59:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411172335100.3909@nanos>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<alpine.DEB.2.11.1411142326510.3909@nanos>
	<CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
	<CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com>
	<alpine.DEB.2.11.1411172303070.3909@nanos>
	<alpine.DEB.2.11.1411172335100.3909@nanos>
Date: Mon, 17 Nov 2014 15:59:03 -0800
X-Google-Sender-Auth: 6xDH3w1GtOFiOLJ0l55mJHUZvR4
Message-ID: <CA+55aFxq3-2qb76-xaR-sid9nxLYK7rcnm08w2NQzUcgPFKz2A@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 2:43 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> No, that won't work for synchronous calls:\

Right you are.

> So a combo of both (Jens and yours) might do the trick. Patch below.

Yeah, I guess that would work. The important part is that *if*
somebody really reuses the csd, we'd better have a release barrier
(which csd_unlock() does, although badly - but this probably isn't
that performance-critical) *before* we call the function, because
otherwise there's no real serialization for the reuse.

Of course, most of these things are presumably always per-cpu data
structures, so the whole worry about "csd" being accessed from
different CPU's probably doesn't even exist, and this all works fine
as-is anyway, even in the presense of odd memory ordering issues.

Judging from Jens' later email, it looks like we simply don't need
this code at all any more, though, and we could just revert the
commit.

NOTE! I don't think this actually has anything to do with the actual
problem that Dave saw. I just reacted to that WARN_ON() when I was
looking at the code, and it made me go "that looks extremely
suspicious".

Particularly on x86, with strong memory ordering, I don't think that
any random accesses to 'csd' after the call to 'csd->func()' could
actually matter. I just felt very nervous about the claim that
somebody can reuse the csd immediately, that smelled bad to me from a
*conceptual* standpoint, even if I suspect it works perfectly fine in
practice.

Anyway, I've found *another* race condition, which (again) doesn't
actually seem to be an issue on x86.

In particular, "csd_lock()" does things pretty well, in that it does a
smp_mb() after setting the lock bit, so certainly nothing afterwards
will leak out of that locked region.

But look at csd_lock_wait(). It just does

        while (csd->flags & CSD_FLAG_LOCK)
                cpu_relax();

and basically there's no memory barriers there. Now, on x86, this is a
non-issue, since all reads act as an acquire, but at least in *theory*
we have this completely unordered read going on. So any subsequent
memory oeprations (ie after the return from generic_exec_single()
could in theory see data from *before* the read.

So that whole kernel/smp.c locking looks rather dubious. The smp_mb()
in csd_lock() is overkill (a "smp_store_release()" should be
sufficient), and I think that the read of csd->flags in csd_unlock()
should be a smp_load_acquire().

Again, none of this has anything to do with Dave's problem. The memory
ordering issues really cannot be an issue on x86, I'm just saying that
there's code there that makes me a bit uncomfortable.

                     Linus
