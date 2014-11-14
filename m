Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaKNWzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:55:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:55473 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaKNWze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:55:34 -0500
Date: Fri, 14 Nov 2014 23:55:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411142326510.3909@nanos>
References: <20141114213124.GB3344@redhat.com> <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Linus Torvalds wrote:
> On Fri, Nov 14, 2014 at 1:31 PM, Dave Jones <davej@redhat.com> wrote:
> > I'm not sure how long this goes back (3.17 was fine afair) but I'm
> > seeing these several times a day lately..
>
> Plus, judging by the fact that there's a stale "leave_mm+0x210/0x210"
> (wouldn't that be the *next* function, namely do_flush_tlb_all())
> pointer on the stack, I suspect that whole range-flushing doesn't even
> trigger, and we are flushing everything.

This stale entry is not relevant here because the thing is stuck in
generic_exec_single().
 
> > NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c129:25570]
> > RIP: 0010:[<ffffffff9c11e98a>]  [<ffffffff9c11e98a>] generic_exec_single+0xea/0x1d0

> > Call Trace:
> >  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
> >  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
> >  [<ffffffff9c11ead6>] smp_call_function_single+0x66/0x110
> >  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
> >  [<ffffffff9c11f021>] smp_call_function_many+0x2f1/0x390
> >  [<ffffffff9c049300>] flush_tlb_mm_range+0xe0/0x370

flush_tlb_mm_range()
	.....
out:
        if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
                flush_tlb_others(mm_cpumask(mm), mm, start, end);

which calls

      smp_call_function_many() via native_flush_tlb_others()

which is either inlined or not on the stack the invocation of
smp_call_function_many() is a tail call.

So from smp_call_function_many() we end up via
smp_call_function_single() in generic_exec_single().

So the only ways to get stuck there are:

     csd_lock(csd);
and
     csd_lock_wait(csd);

The called function is flush_tlb_func() and I really can't see why
that would get stuck at all.

So this looks more like a smp function call fuckup.

I assume Dave is running that stuff on KVM. So it might be worth while
to look at the IPI magic there.

Thanks,

	tglx

