Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3JHJeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:34:24 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62341 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3JHJeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:34:20 -0400
Date: Tue, 8 Oct 2013 11:34:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008093416.GA30410@gmail.com>
References: <20131006082340.GA24568@localhost>
 <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
 <20131007021118.GA27927@localhost>
 <20131007051038.GA9764@localhost>
 <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <20131008075816.GA6346@gmail.com>
 <20131008082057.GA19657@localhost>
 <20131008082624.GC7232@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008082624.GC7232@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > After enabling CONFIG_DEBUG_OBJECTS_TIMERS=y, it will issue a WARNING followed by a "BUG: ..."
> 
> Cool!
> 
> > [    2.802167] parport_pc 00:04: reported by Plug and Play ACPI
> > [    2.803818] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
> > [    2.806035] kobject: 'parport_pc.956' (ffff880006dc3820): kobject_release, parent           (null) (delayed)
> > [    2.808626] ------------[ cut here ]------------                                                            
> > [    2.809776] WARNING: CPU: 1 PID: 1 at /c/wfg/linux/lib/debugobjects.c:260 debug_print_object+0x7c/0x8d()
> > [    2.812433] ODEBUG: init active (active state 0) object type: timer_list hint:           (null)         
> > ......
> > [    3.796079] BUG: unable to handle kernel NULL pointer dereference at           (null)
> 
> Mind posting the full backtrace? It should show the actual callsite that 
> zaps the timer. I don't think we got that dump so far, I've only seen 
> timer list corruption backtraces. (but I haven't read the whole thread.)

I see you already posted the dmesg in another part of this thread, so the 
relevant call-trace for parport_pc.c is:

> [    2.812579] Call Trace:
> [    2.812579]  [<ffffffff8184ea6e>] dump_stack+0x4f/0x84
> [    2.812579]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
> [    2.812579]  [<ffffffff81223681>] ? debug_print_object+0x7c/0x8d
> [    2.812579]  [<ffffffff8108f40b>] warn_slowpath_fmt+0x41/0x43
> [    2.812579]  [<ffffffff81223681>] debug_print_object+0x7c/0x8d
> [    2.812579]  [<ffffffff812239e0>] __debug_object_init+0x27c/0x2c6
> [    2.812579]  [<ffffffff81223a1b>] ? __debug_object_init+0x2b7/0x2c6
> [    2.812579]  [<ffffffff81223a3e>] debug_object_init+0x14/0x16
> [    2.812579]  [<ffffffff810992e8>] init_timer_key+0x23/0x65
> [    2.812579]  [<ffffffff8121352f>] kobject_release+0x90/0xba
> [    2.812579]  [<ffffffff812137ac>] kobject_put+0x4d/0x51
> [    2.812579]  [<ffffffff81482cfb>] put_device+0x12/0x14
> [    2.812579]  [<ffffffff814873a2>] platform_device_put+0x12/0x14
> [    2.812579]  [<ffffffff81487727>] platform_device_unregister+0x16/0x1a
> [    2.812579]  [<ffffffff814810f9>] parport_pc_probe_port+0x7c4/0x7d9
> [    2.812579]  [<ffffffff81e36c75>] parport_pc_init+0x2b0/0x317
> [    2.812579]  [<ffffffff81e369c5>] ? parport_setup+0x147/0x147
> [    2.812579]  [<ffffffff81e11e0c>] do_one_initcall+0x8e/0x132
> [    2.812579]  [<ffffffff810a7000>] ? param_array_set+0x7f/0xf2
> [    2.812579]  [<ffffffff810a7275>] ? parse_args+0x1ad/0x26c
> [    2.812579]  [<ffffffff81e11fe2>] kernel_init_freeable+0x132/0x1bc
> [    2.812579]  [<ffffffff81e116e3>] ? do_early_param+0x86/0x86
> [    2.812579]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
> [    2.812579]  [<ffffffff818488c8>] kernel_init+0x9/0xcc
> [    2.812579]  [<ffffffff81859e3c>] ret_from_fork+0x7c/0xb0
> [    2.812579]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
> [    2.812579] ---[ end trace ce7dd707bef7dc3e ]---

It appears a delayed callback is already active for that platform device? 
Looks weird, because in theory platform devices are allocated anew in 
parport_pc_probe_port():

                pdev = platform_device_register_simple("parport_pc",
                                                       base, NULL, 0);
                if (IS_ERR(pdev))
                        return NULL;
                dev = &pdev->dev;

Which is allocated via zalloc(), so no reuse.

and then released if the hardware port is not present:

 out1:
        if (pdev)
                platform_device_unregister(pdev);

Thanks,

	Ingo
