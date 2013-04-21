Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3DUSGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:06:35 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:27869
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab3DUSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:06:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI103dK1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLMAAT-02-0UR-02
X-M-MSG: 
Date: Sun, 21 Apr 2013 13:06:27 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <mingo@kernel.org>, <hpa@zytor.com>, <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <acme@ghostprotocols.net>, <jolsa@redhat.com>, <tglx@linutronix.de>,
        <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf/x86/amd: Add support for AMD NB and L2I "
 uncore" counters
Message-ID: <20130421180627.GA21049@jshin-Toonie>
References: <20130419213428.GA8229@jshin-Toonie>
 <tip-c43ca5091a374c1f6778bd7e4a39a5a10735a917@git.kernel.org>
 <20130421170232.GA4172@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130421170232.GA4172@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 07:02:32PM +0200, Borislav Petkov wrote:
> On Sun, Apr 21, 2013 at 05:48:36AM -0700, tip-bot for Jacob Shin wrote:
> > Commit-ID:  c43ca5091a374c1f6778bd7e4a39a5a10735a917
> > Gitweb:     http://git.kernel.org/tip/c43ca5091a374c1f6778bd7e4a39a5a10735a917
> > Author:     Jacob Shin <jacob.shin@amd.com>
> > AuthorDate: Fri, 19 Apr 2013 16:34:28 -0500
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Sun, 21 Apr 2013 11:01:24 +0200
> > 
> > perf/x86/amd: Add support for AMD NB and L2I "uncore" counters
> > 
> > Add support for AMD Family 15h [and above] northbridge
> > performance counters. MSRs 0xc0010240 ~ 0xc0010247 are shared
> > across all cores that share a common northbridge.
> > 
> > Add support for AMD Family 16h L2 performance counters. MSRs
> > 0xc0010230 ~ 0xc0010237 are shared across all cores that share a
> > common L2 cache.
> > 
> > We do not enable counter overflow interrupts. Sampling mode and
> > per-thread events are not supported.
> 
> Something's fishy with lockdep here:
> 
> [    1.217368] perf: AMD NB counters detected
> [    1.217438] ------------[ cut here ]------------
> [    1.217497] WARNING: at kernel/lockdep.c:2590 trace_hardirqs_on_caller+0x1b9/0x1f0()
> [    1.217572] Hardware name: To be filled by O.E.M.
> [    1.217624] Modules linked in:
> [    1.217705] Pid: 0, comm: swapper/1 Not tainted 3.9.0-rc7+ #2
> [    1.217760] Call Trace:
> [    1.217810]  <IRQ>  [<ffffffff8103bd2f>] warn_slowpath_common+0x7f/0xc0
> [    1.217926]  [<ffffffff81130905>] ? new_slab+0x225/0x2a0
> [    1.217981]  [<ffffffff8103bd8a>] warn_slowpath_null+0x1a/0x20
> [    1.218038]  [<ffffffff8109aac9>] trace_hardirqs_on_caller+0x1b9/0x1f0
> [    1.218095]  [<ffffffff8109ab0d>] trace_hardirqs_on+0xd/0x10
> [    1.218149]  [<ffffffff81130905>] new_slab+0x225/0x2a0
> [    1.218205]  [<ffffffff815959d8>] __slab_alloc.isra.57.constprop.60+0x31e/0x454
> [    1.218281]  [<ffffffff8107a813>] ? local_clock+0x43/0x50
> [    1.218365]  [<ffffffff810a62ee>] ? generic_smp_call_function_single_interrupt+0x7e/0x110
> [    1.218441]  [<ffffffff810984e8>] ? trace_hardirqs_off_caller+0x28/0x120
> [    1.218497]  [<ffffffff81131f05>] kmem_cache_alloc_trace+0xb5/0x1f0
> [    1.218552]  [<ffffffff810a62ee>] ? generic_smp_call_function_single_interrupt+0x7e/0x110
> [    1.218629]  [<ffffffff8158b4e1>] amd_uncore_alloc.isra.7+0x1f/0x29
> [    1.218683]  [<ffffffff8158b505>] amd_uncore_cpu_up_prepare+0x1a/0xac
> [    1.218739]  [<ffffffff81a9dfe8>] init_cpu_already_online+0x14/0x26
> [    1.218794]  [<ffffffff8107a813>] ? local_clock+0x43/0x50
> [    1.218848]  [<ffffffff810a630d>] generic_smp_call_function_single_interrupt+0x9d/0x110
> [    1.218924]  [<ffffffff81027157>] smp_call_function_single_interrupt+0x27/0x40
> [    1.219000]  [<ffffffff8159e56f>] call_function_single_interrupt+0x6f/0x80
> [    1.219620]  <EOI>  [<ffffffff8100b515>] ? default_idle+0x25/0x270
> [    1.219735]  [<ffffffff8100b513>] ? default_idle+0x23/0x270
> [    1.219789]  [<ffffffff8100c146>] arch_cpu_idle+0x26/0x30
> [    1.219844]  [<ffffffff8108cf1e>] cpu_startup_entry+0x7e/0x3d0
> [    1.219898]  [<ffffffff8158d2c4>] start_secondary+0x1b7/0x1bb
> [    1.219956] ---[ end trace abe5f11379b64afd ]---
> [    1.220059] LVT offset 0 assigned for vector 0x400
> [    1.220140] perf: AMD IBS detected (0x000000ff)

This should fix it. Sorry about that,

Thanks!!

>From 2ac60428e58f7bfd7dec4baa772f523eeedfecc6 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Sun, 21 Apr 2013 12:58:21 -0500
Subject: [PATCH 1/1] perf, amd: fix lockdep warning, don't __GFP_FS alloc
 with IRQs disabled

Fix lockdep warning by not calling kzalloc in smp_call_function_single.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 6dc6227..c0c661a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -498,7 +498,6 @@ static void __init init_cpu_already_online(void *dummy)
 {
 	unsigned int cpu = smp_processor_id();
 
-	amd_uncore_cpu_up_prepare(cpu);
 	amd_uncore_cpu_starting(cpu);
 	amd_uncore_cpu_online(cpu);
 }
@@ -535,8 +534,10 @@ static int __init amd_uncore_init(void)
 
 	get_online_cpus();
 	/* init cpus already online before registering for hotplug notifier */
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
+		amd_uncore_cpu_up_prepare(cpu);
 		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
+	}
 
 	register_cpu_notifier(&amd_uncore_cpu_notifier_block);
 	put_online_cpus();
-- 
1.7.9.5


