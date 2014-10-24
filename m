Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaJXKZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:25:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJXKZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:25:49 -0400
Date: Fri, 24 Oct 2014 12:25:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Michal Marek <mmarek@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: kernel: clockevents: shift out-of-bounds
Message-ID: <20141024102539.GG12706@worktop.programming.kicks-ass.net>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <5444ED06.6030008@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5444ED06.6030008@samsung.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 03:07:50PM +0400, Andrey Ryabinin wrote:
> 
> On kernel with UBSan enabled I've got following:
> 
>      UBSan: Undefined behaviour in ../kernel/time/clockevents.c:75:34
>      shift exponent 32 is to large for 32-bit type 'unsigned int'
>      CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc7+ #39
>      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>       0000000000000000 0000000000000000 0000000000000001 ffffffff83003db0
>       ffffffff82a30940 0000000000000020 ffffffff83003dc0 ffffffff819502e9
>       ffffffff83003e40 ffffffff81950735 ffff88013f003233 0000000000000000
>      Call Trace:
>      dump_stack (/home/andrew/linux/lib/dump_stack.c:52)
>      ubsan_epilogue (/home/andrew/linux/lib/ubsan.c:122)
>      __ubsan_handle_shift_out_of_bounds (/home/andrew/linux/lib/ubsan.c:390)
>      ? hpet_enable (/home/andrew/linux/arch/x86/kernel/hpet.c:862)
>      cev_delta2ns (/home/andrew/linux/kernel/time/clockevents.c:75 (discriminator 1))
>      clockevents_config.part.2 (/home/andrew/linux/kernel/time/clockevents.c:421)
>      ? __clocksource_select (/home/andrew/linux/kernel/time/clocksource.c:607 /home/andrew/linux/kernel/time/clocksource.c:631)
>      clockevents_config_and_register (/home/andrew/linux/kernel/time/clockevents.c:440)
>      hpet_enable (/home/andrew/linux/arch/x86/kernel/hpet.c:305 /home/andrew/linux/arch/x86/kernel/hpet.c:891)
>      hpet_time_init (/home/andrew/linux/arch/x86/kernel/time.c:79)
>      x86_late_time_init (/home/andrew/linux/arch/x86/kernel/time.c:87)
>      start_kernel (/home/andrew/linux/init/main.c:637)
>      ? early_idt_handlers (/home/andrew/linux/arch/x86/kernel/head_64.S:344)
>      x86_64_start_reservations (/home/andrew/linux/arch/x86/kernel/head64.c:194)
>      x86_64_start_kernel (/home/andrew/linux/arch/x86/kernel/head64.c:183)
> 
> I guess it should be 1ULL here instead of 1U:
>             (!ismax || evt->mult <= (1U << evt->shift)))

Probably so indeed, clocks_calc_mult_shift() has max return value of 32,
which will indeed trigger that overflow.
