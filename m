Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3DUSFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:05:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36393 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3DUSFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:05:22 -0400
Date: Sun, 21 Apr 2013 20:05:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/amd: Add support for AMD NB and L2I "
 uncore" counters
Message-ID: <20130421180509.GB4559@pd.tnic>
References: <20130419213428.GA8229@jshin-Toonie>
 <tip-c43ca5091a374c1f6778bd7e4a39a5a10735a917@git.kernel.org>
 <20130421170232.GA4172@pd.tnic>
 <20130421173326.GA17311@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130421173326.GA17311@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 12:33:26PM -0500, Jacob Shin wrote:
> > [    1.217368] perf: AMD NB counters detected
> > [    1.217438] ------------[ cut here ]------------
> > [    1.217497] WARNING: at kernel/lockdep.c:2590 trace_hardirqs_on_caller+0x1b9/0x1f0()
> > [    1.217572] Hardware name: To be filled by O.E.M.
> > [    1.217624] Modules linked in:
> > [    1.217705] Pid: 0, comm: swapper/1 Not tainted 3.9.0-rc7+ #2
> > [    1.217760] Call Trace:
> > [    1.217810]  <IRQ>  [<ffffffff8103bd2f>] warn_slowpath_common+0x7f/0xc0
> > [    1.217926]  [<ffffffff81130905>] ? new_slab+0x225/0x2a0
> > [    1.217981]  [<ffffffff8103bd8a>] warn_slowpath_null+0x1a/0x20
> > [    1.218038]  [<ffffffff8109aac9>] trace_hardirqs_on_caller+0x1b9/0x1f0
> > [    1.218095]  [<ffffffff8109ab0d>] trace_hardirqs_on+0xd/0x10
> > [    1.218149]  [<ffffffff81130905>] new_slab+0x225/0x2a0
> > [    1.218205]  [<ffffffff815959d8>] __slab_alloc.isra.57.constprop.60+0x31e/0x454
> > [    1.218281]  [<ffffffff8107a813>] ? local_clock+0x43/0x50
> > [    1.218365]  [<ffffffff810a62ee>] ? generic_smp_call_function_single_interrupt+0x7e/0x110
> > [    1.218441]  [<ffffffff810984e8>] ? trace_hardirqs_off_caller+0x28/0x120
> > [    1.218497]  [<ffffffff81131f05>] kmem_cache_alloc_trace+0xb5/0x1f0
> > [    1.218552]  [<ffffffff810a62ee>] ? generic_smp_call_function_single_interrupt+0x7e/0x110
> > [    1.218629]  [<ffffffff8158b4e1>] amd_uncore_alloc.isra.7+0x1f/0x29
> > [    1.218683]  [<ffffffff8158b505>] amd_uncore_cpu_up_prepare+0x1a/0xac
> > [    1.218739]  [<ffffffff81a9dfe8>] init_cpu_already_online+0x14/0x26
> > [    1.218794]  [<ffffffff8107a813>] ? local_clock+0x43/0x50
> > [    1.218848]  [<ffffffff810a630d>] generic_smp_call_function_single_interrupt+0x9d/0x110
> > [    1.218924]  [<ffffffff81027157>] smp_call_function_single_interrupt+0x27/0x40
> > [    1.219000]  [<ffffffff8159e56f>] call_function_single_interrupt+0x6f/0x80
> > [    1.219620]  <EOI>  [<ffffffff8100b515>] ? default_idle+0x25/0x270
> > [    1.219735]  [<ffffffff8100b513>] ? default_idle+0x23/0x270
> > [    1.219789]  [<ffffffff8100c146>] arch_cpu_idle+0x26/0x30
> > [    1.219844]  [<ffffffff8108cf1e>] cpu_startup_entry+0x7e/0x3d0
> > [    1.219898]  [<ffffffff8158d2c4>] start_secondary+0x1b7/0x1bb
> > [    1.219956] ---[ end trace abe5f11379b64afd ]---
> > [    1.220059] LVT offset 0 assigned for vector 0x400
> > [    1.220140] perf: AMD IBS detected (0x000000ff)
> > 
> 
> Hm .. I think maybe during _init hotplug lock is already held? Let me
> investigate ASAP:
> 
> +static int __init amd_uncore_init(void)
> +{
> 
> ..snip..
> 
> +	get_online_cpus();
> +	/* init cpus already online before registering for hotplug notifier */
> +	for_each_online_cpu(cpu)
> +		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
> +
> +	register_cpu_notifier(&amd_uncore_cpu_notifier_block);
> +	put_online_cpus();
> 
> ..snip..
> 
> +device_initcall(amd_uncore_init);

Well, AFAICT, you're sending IPIs to each core to do
init_cpu_already_online() which does amd_uncore_alloc() and landing in
the slab allocator. It then, along its path, enables interrupts but
you're still executing the IPI handler so interrupts should remain
off, actually. So maybe you shouldn't be allocating memory in the IRQ
handler.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
