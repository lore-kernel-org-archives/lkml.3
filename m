Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3FEP5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:57:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26727 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab3FEPyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/9] xen/smp: Don't leak interrupt name when offlining.
Date: Wed,  5 Jun 2013 11:54:33 -0400
Message-Id: <1370447678-22367-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the user does:
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online

kmemleak reports:
kmemleak: 7 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

unreferenced object 0xffff88003fa51240 (size 32):
  comm "swapper/0", pid 1, jiffies 4294667339 (age 1027.789s)
  hex dump (first 32 bytes):
    72 65 73 63 68 65 64 31 00 00 00 00 00 00 00 00  resched1........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81660721>] kmemleak_alloc+0x21/0x50
    [<ffffffff81190aac>] __kmalloc_track_caller+0xec/0x2a0
    [<ffffffff812fe1bb>] kvasprintf+0x5b/0x90
    [<ffffffff812fe228>] kasprintf+0x38/0x40
    [<ffffffff81047ed1>] xen_smp_intr_init+0x41/0x2c0
    [<ffffffff816636d3>] xen_cpu_up+0x393/0x3e8
    [<ffffffff8166bbf5>] _cpu_up+0xd1/0x14b
    [<ffffffff8166bd48>] cpu_up+0xd9/0xec
    [<ffffffff81ae6e4a>] smp_init+0x4b/0xa3
    [<ffffffff81ac4981>] kernel_init_freeable+0xdb/0x1e6
    [<ffffffff8165ce39>] kernel_init+0x9/0xf0
    [<ffffffff8167edfc>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

This patch fixes some of it by using the 'struct xen_common_irq->name'
field to stash away the char so that it can be freed when
the interrupt line is destroyed.
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 6a483cd..37fbe71 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -107,19 +107,27 @@ static void xen_smp_intr_free(unsigned int cpu)
 	if (per_cpu(xen_resched_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu).irq, NULL);
 		per_cpu(xen_resched_irq, cpu).irq = -1;
+		kfree(per_cpu(xen_resched_irq, cpu).name);
+		per_cpu(xen_resched_irq, cpu).name = NULL;
 	}
 	if (per_cpu(xen_callfunc_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu).irq, NULL);
 		per_cpu(xen_callfunc_irq, cpu).irq = -1;
+		kfree(per_cpu(xen_callfunc_irq, cpu).name);
+		per_cpu(xen_callfunc_irq, cpu).name = NULL;
 	}
 	if (per_cpu(xen_debug_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu).irq, NULL);
 		per_cpu(xen_debug_irq, cpu).irq = -1;
+		kfree(per_cpu(xen_debug_irq, cpu).name);
+		per_cpu(xen_debug_irq, cpu).name = NULL;
 	}
 	if (per_cpu(xen_callfuncsingle_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu).irq,
 				       NULL);
 		per_cpu(xen_callfuncsingle_irq, cpu).irq = -1;
+		kfree(per_cpu(xen_callfuncsingle_irq, cpu).name);
+		per_cpu(xen_callfuncsingle_irq, cpu).name = NULL;
 	}
 	if (xen_hvm_domain())
 		return;
@@ -127,12 +135,14 @@ static void xen_smp_intr_free(unsigned int cpu)
 	if (per_cpu(xen_irq_work, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu).irq, NULL);
 		per_cpu(xen_irq_work, cpu).irq = -1;
+		kfree(per_cpu(xen_irq_work, cpu).name);
+		per_cpu(xen_irq_work, cpu).name = NULL;
 	}
 };
 static int xen_smp_intr_init(unsigned int cpu)
 {
 	int rc;
-	const char *resched_name, *callfunc_name, *debug_name;
+	char *resched_name, *callfunc_name, *debug_name;
 
 	resched_name = kasprintf(GFP_KERNEL, "resched%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
@@ -144,6 +154,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_resched_irq, cpu).irq = rc;
+	per_cpu(xen_resched_irq, cpu).name = resched_name;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfunc%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
@@ -155,6 +166,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_callfunc_irq, cpu).irq = rc;
+	per_cpu(xen_callfunc_irq, cpu).name = callfunc_name;
 
 	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
 	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
@@ -163,6 +175,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_debug_irq, cpu).irq = rc;
+	per_cpu(xen_debug_irq, cpu).name = debug_name;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
@@ -174,6 +187,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_callfuncsingle_irq, cpu).irq = rc;
+	per_cpu(xen_callfuncsingle_irq, cpu).name = callfunc_name;
 
 	/*
 	 * The IRQ worker on PVHVM goes through the native path and uses the
@@ -192,6 +206,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_irq_work, cpu).irq = rc;
+	per_cpu(xen_irq_work, cpu).name = callfunc_name;
 
 	return 0;
 
-- 
1.8.1.4

