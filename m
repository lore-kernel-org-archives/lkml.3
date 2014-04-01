Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaDAGdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:33:14 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61494 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAGdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403311522080.14882@ionos.tec.linutronix.de>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1403311522080.14882@ionos.tec.linutronix.de>
Date: Tue, 1 Apr 2014 12:03:11 +0530
Message-ID: <CAKohpon-YbK05yZMsJ68pTycFrU6UsBvmRyssS_j6RZeaVdD7w@mail.gmail.com>
Subject: Re: [PATCH 00/16] timers/hrtimers: Minor cleanups: Part II
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2014 19:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> And those cleanups make the compiler generate worse code at least on
> x86_64:
>
>    text      data      bss      dec     hex    filename
>    7475      554       0        8029    1f5d   kernel/hrtimer.o
>    7706      554       0        8260    2044   kernel/hrtimer.o
>
> So just removing parameters and return values because you can get the
> same information from a datastructure is not necessarily a good thing.

So here is the patch by patch analysis (With x86_64_defconfig):

Initial details:
   text   data    bss    dec    hex filename
   7989    408      0   8397   20cd ../bx86/kernel/hrtimer.o

> 73a6cd8 hrtimer: replace 'tab' with 'space' after comma ','
> 04223a8 hrtimer: Coalesce format fragments in printk()
> 52fac3f hrtimer: call hrtimer_set_expires_range() from hrtimer_set_expires_range_ns()
> 535a552 hrtimer: use base->index instead of basenum in switch_hrtimer_base()
   7989    408      0   8397   20cd ../bx86/kernel/hrtimer.o

> f3a2cdd hrtimer: no need to rewrite '1' to hrtimer_hres_enabled
   7974    408      0   8382   20be ../bx86/kernel/hrtimer.o

This one actually made a smaller :)

> 479d66f hrtimer: don't rewrite same value to expires_next in hrtimer_force_reprogram()
   7990    408      0   8398   20ce ../bx86/kernel/hrtimer.o
> 0e134df hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
   8006    408      0   8414   20de ../bx86/kernel/hrtimer.o

So, reading from a per-cpu variable is efficient as compared to
base->hres_active. In that case this patch can be dropped :)

> 0030ddd hrtimer: remove dummy definition of hrtimer_force_reprogram()
   8006    408      0   8414   20de ../bx86/kernel/hrtimer.o
> 4a0c909 hrtimer: don't check state of base->hres_active in hrtimer_switch_to_hres()
   8022    408      0   8430   20ee ../bx86/kernel/hrtimer.o

This one actually removed some code, how come it is bigger :(

> 213bc01 hrtimer: remove clock_was_set_delayed() from hrtimer.h
   8006    408      0   8414   20de ../bx86/kernel/hrtimer.o

Though this one made it shorter, we probably need to drop it as
clock_was_set_delayed() is now used in kernel/time/timekeeping.c

> 3defaf8 hrtimer: don't emulate notifier call to initialize timer base
   8071    408      0   8479   211f ../bx86/kernel/hrtimer.o

I thought this will surely generate a smaller text segment :(

> e438576 hrtimer: use ffs() to iterate over valid bits from active_bases
   8151    408      0   8559   216f ../bx86/kernel/hrtimer.o
> 1ab3d15 timer: simplify CPU_UP_PREPARE notifier code path
> c5111c9 timer: don't emulate notifier call to initialize timer base
> a576aa9 hrtimer: move unlock_hrtimer_base() upwards
> 9ea8619 hrtimer: reorder code in __remove_hrtimer()
> 2619470 hrtimer: Create hrtimer_get_monoexpires()
   8135    408      0   8543   215f ../bx86/kernel/hrtimer.o

> b64d746 hrtimer: remove 'base' parameter from remove_timer() and __remove_timer()
   8183    408      0   8591   218f ../bx86/kernel/hrtimer.o
> ced918e2 hrtimer: remove 'base' parameter from switch_hrtimer_base()
   8135    408      0   8543   215f ../bx86/kernel/hrtimer.o
> f046106b hrtimer: remove 'base' parameter from enqueue_hrtimer()
   8119    408      0   8527   214f ../bx86/kernel/hrtimer.o
> b102337 hrtimer: remove 'base' parameter from hrtimer_{enqueue_}reprogram()
   8135    408      0   8543   215f ../bx86/kernel/hrtimer.o

So, these are the four patches that have removed parameters from
routines. and it started with 8135 and ended up with 8135 :)

> d43b5d1 hrtimer: make switch_hrtimer_base() return void
   8199    408      0   8607   219f ../bx86/kernel/hrtimer.o
> cd08cd9 hrtimer: make lock_hrtimer_base() return void
   8199    408      0   8607   219f ../bx86/kernel/hrtimer.o
> 74a3a18 hrtimer: make enqueue_hrtimer() return void
   8167    408      0   8575   217f ../bx86/kernel/hrtimer.o
> b5cb057 hrtimer: don't check if timer is queued in __remove_hrtimer()
   8135    408      0   8543   215f ../bx86/kernel/hrtimer.o
> b56d3fc hrtimer: rewrite switch_hrtimer_base() to remove extra indentation level
> fccd30d hrtimer: rewrite remove_hrtimer() to remove extra indentation level
> d4a6c58 hrtimer: replace base by new_base to get resolution: __hrtimer_start_range_ns()
> 24bf5c0 hrtimer: create base_on_this_cpu()
> 3f690eb hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
   8135    408      0   8543   215f ../bx86/kernel/hrtimer.o

And finally we ended up at 8135 :)
