Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaGWRDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:03:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaGWRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:03:33 -0400
Date: Wed, 23 Jul 2014 19:03:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723170324.GZ3935@laptop>
References: <20140723082819.GR3935@laptop>
 <20140723092536.GO12054@laptop.lan>
 <53CF80EE.5050702@daenzer.net>
 <53CF844A.5050106@arm.com>
 <20140723111110.GT3935@laptop>
 <20140723113021.GP12054@laptop.lan>
 <20140723142454.GQ12054@laptop.lan>
 <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
 <20140723155526.GW3935@laptop>
 <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:54:23AM -0700, Linus Torvalds wrote:
> On Wed, Jul 23, 2014 at 8:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> I haven't seen the full oops, can you forward the screenshot? The
> >> exact register state might give some clues.
> >
> > Sure, here goes.
> 
> So the length is fine, and the disassembly shows that it is fixed (16
> 32-bit words - why the heck does it use "movsl" rather than "movsq",
> whatever).
> 
> The problem is %rdi, which has the value ffff10043c803e8c, which isn't
> canonical. Which is why it GP-faults.
> 
> That value is loaded from the stack:
> 
>         mov    -0x88(%rbp),%rdi
> 
> so apparently the original "__get_cpu_var(load_balance_mask)" is
> already corrupted, or something has corrupted it on the stack since
> loading (but that looks unlikely).
> 
> And I wonder if I have a clue. Look, load_balance_mask is a
> "cpumask_var_t", but I don't see a "alloc_cpumask_var()" for it.
> That's broken with CONFIG_CPUMASK_OFFSTACK.

kernel/sched/core.c:sched_init()

plays horrible allocation tricks.. which I suppose we should clean up,
sched_init() appears to be called late enough to use regular per-cpu
allocations.

> I think you actually want "load_balance_mask" to be a "struct cpumask *", no?
> 
> Alternatively, keep it a "cpumask_var_t", but then you need to use
> __get_cpu_pointer() to get the address of it, and use
> "alloc_cpumask_var()" to allocate area for the OFFSTACK case.

I'm always terminally confused on that interface.. but this code hasn't
changed in a long while and I would expect other crashes if this was
really funky like that.
