Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3FEPzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:55:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27229 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab3FEPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:55:18 -0400
MIME-Version: 1.0
Message-ID: <1370447678-22367-8-git-send-email-konrad.wilk@oracle.com>
Date: Wed, 5 Jun 2013 08:54:36 -0700 (PDT)
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/9] xen/time: Don't leak interrupt name when offlining.
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the user does:
    echo 0 > /sys/devices/system/cpu/cpu1/online
    echo 1 > /sys/devices/system/cpu/cpu1/online

kmemleak reports:
kmemleak: 7 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

One of the leaks is from xen/time:

unreferenced object 0xffff88003fa51280 (size 32):
  comm "swapper/0", pid 1, jiffies 4294667339 (age 1027.789s)
  hex dump (first 32 bytes):
    74 69 6d 65 72 31 00 00 00 00 00 00 00 00 00 00  timer1..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81660721>] kmemleak_alloc+0x21/0x50
    [<ffffffff81190aac>] __kmalloc_track_caller+0xec/0x2a0
    [<ffffffff812fe1bb>] kvasprintf+0x5b/0x90
    [<ffffffff812fe228>] kasprintf+0x38/0x40
    [<ffffffff81041ec1>] xen_setup_timer+0x51/0xf0
    [<ffffffff8166339f>] xen_cpu_up+0x5f/0x3e8
    [<ffffffff8166bbf5>] _cpu_up+0xd1/0x14b
    [<ffffffff8166bd48>] cpu_up+0xd9/0xec
    [<ffffffff81ae6e4a>] smp_init+0x4b/0xa3
    [<ffffffff81ac4981>] kernel_init_freeable+0xdb/0x1e6
    [<ffffffff8165ce39>] kernel_init+0x9/0xf0
    [<ffffffff8167edfc>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

This patch fixes it by stashing away the 'name' in the per-cpu
data structure and freeing it when offlining the CPU.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/time.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 5190687..011f1bf 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -14,6 +14,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/math64.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
@@ -402,7 +403,7 @@ static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
 
 void xen_setup_timer(int cpu)
 {
-	const char *name;
+	char *name;
 	struct clock_event_device *evt;
 	int irq;
 
@@ -425,6 +426,7 @@ void xen_setup_timer(int cpu)
 
 	evt->cpumask = cpumask_of(cpu);
 	evt->irq = irq;
+	per_cpu(xen_clock_events, cpu).name = name;
 }
 
 void xen_teardown_timer(int cpu)
@@ -434,6 +436,8 @@ void xen_teardown_timer(int cpu)
 	evt = &per_cpu(xen_clock_events, cpu).evt;
 	unbind_from_irqhandler(evt->irq, NULL);
 	evt->irq = -1;
+	kfree(per_cpu(xen_clock_events, cpu).name);
+	per_cpu(xen_clock_events, cpu).name = NULL;
 }
 
 void xen_setup_cpu_clockevents(void)
-- 
1.8.1.4

