Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaGWSHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:07:46 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44144 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGWSHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
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
	<20140723170324.GZ3935@laptop>
	<CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
Date: Wed, 23 Jul 2014 11:07:40 -0700
X-Google-Sender-Auth: eY0McPtFeXtGsN3Fykx-V0lKtcY
Message-ID: <CA+55aFz9z=58iEj3qx4Oip=iPYxzgSaPe945Xzd8Z60_v1EEzQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> A cpumask_var is TOTALLY DIFFERENT. It's *either* a cpumask _or_ just
> a pointer to an externally allocated cpumask.
>
> sched_init() definitely does _not_ allocate a cpumask_var.

I take that back. It does end up allocating it properly, it just
avoids all the correct abstractions.

In general, the rule of thumb should be:

 - stack allocations should use "cpumask_var_t cpus" and they
absolutely *have* to be paired with an "alloc_cpumask_var(&cpus,
GFP_KERNEL)". Having a "struct cpumask" on stack is very wrong.

 - random single nonstack allocations should probably just use a plain
"struct cpumask" (or cpumask_t, but we really shouldn't use typedef's
unless they actively abstract some per-config *changing* type).

 - dynamic allocations that are size-conscious (because there's a lot
of them) should allocate a "struct cpumask *" by using
"cpumask_size()". They have a pointer anyway, they allocate things
dynamically anyway, extra indirection through a cpumask_var_t would
just be unnecessary.

 - *static* per-cpu allocations might want to use "cpumask_var_t" (to
avoid having a full "struct cpumask_t") along with doing a
"zalloc_cpumask_var_node(..)" for each cpu.

sched_init() follows that last pattern, except it open-codes that
zalloc_cpumask_var_node() in an odd way that confused me.

So I take my patch back. It's wrong, because it only allocates that
cpumask_size() if CONFIG_CPUMASK_OFFSTACK is true.

Ugh, that code really is unreadable.

               Linus
