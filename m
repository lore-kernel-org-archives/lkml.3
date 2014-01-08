Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbaAHV1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:27:23 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:51784 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaAHV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:27:19 -0500
Date: Wed, 8 Jan 2014 16:28:20 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm working on getting the hardware performance counters working on a 
Raspberry-Pi (BCM2835/ARM1176).  

The counters are there, but the overflow interrupt is not hooked up so the 
init code disables perf_event.

The following patch enables perf_event and it works fine for simple 
"perf stat" type workloads.  perf record and anything requiring sampling 
doesn't work (as expected).

I thought I would have to add a periodic timer to catch counter overflows, 
but it turns out that's unnecessary.  From what I can tell even though the
nPMUIRQ interrupt is not hooked up, the overflows are marked in the status 
register and this is noticed and handled at context-switch time.  So as 
long as the counters overflow less frequently than the context switch 
interval the registers don't overflow.

So my question, is a patch like this acceptable?

Should the perf_event interface handle setups like this better and work 
fine in aggregate mode but return ENOTSUP if a sampled or overflow event 
is attempted?

Vince


Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index d85055c..ff1a752 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -97,8 +97,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 	if (irqs < 1) {
-		pr_err("no irqs for PMUs defined\n");
-		return -ENODEV;
+		printk_once("no irqs for PMUs defined, enabling anyway\n");
+		return 0;
 	}
 
 	for (i = 0; i < irqs; ++i) {
