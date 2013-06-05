Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3FEPyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:54:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37899 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3FEPyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/9] xen/spinlock: Don't leak interrupt name when offlining.
Date: Wed,  5 Jun 2013 11:54:34 -0400
Message-Id: <1370447678-22367-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the user does:
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online

kmemleak reports:
kmemleak: 7 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

unreferenced object 0xffff88003fa51260 (size 32):
  comm "swapper/0", pid 1, jiffies 4294667339 (age 1027.789s)
  hex dump (first 32 bytes):
    73 70 69 6e 6c 6f 63 6b 31 00 00 00 00 00 00 00  spinlock1.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81660721>] kmemleak_alloc+0x21/0x50
    [<ffffffff81190aac>] __kmalloc_track_caller+0xec/0x2a0
    [<ffffffff812fe1bb>] kvasprintf+0x5b/0x90
    [<ffffffff812fe228>] kasprintf+0x38/0x40
    [<ffffffff81663789>] xen_init_lock_cpu+0x61/0xbe
    [<ffffffff816633a6>] xen_cpu_up+0x66/0x3e8
    [<ffffffff8166bbf5>] _cpu_up+0xd1/0x14b
    [<ffffffff8166bd48>] cpu_up+0xd9/0xec
    [<ffffffff81ae6e4a>] smp_init+0x4b/0xa3
    [<ffffffff81ac4981>] kernel_init_freeable+0xdb/0x1e6
    [<ffffffff8165ce39>] kernel_init+0x9/0xf0
    [<ffffffff8167edfc>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

Instead of doing it like the "xen/smp: Don't leak interrupt name when offlining"
patch did (which has a per-cpu structure which contains both the
IRQ number and char*) we use a per-cpu pointers to a *char.

The reason is that the "__this_cpu_read(lock_kicker_irq);" macro
blows up with "__bad_size_call_parameter()" as the size of the
returned structure is not within the parameters of what it expects
and optimizes for.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/spinlock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 3002ec1..d6c1857 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -7,6 +7,7 @@
 #include <linux/debugfs.h>
 #include <linux/log2.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 
 #include <asm/paravirt.h>
 
@@ -165,6 +166,7 @@ static int xen_spin_trylock(struct arch_spinlock *lock)
 	return old == 0;
 }
 
+static DEFINE_PER_CPU(char *, irq_name);
 static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
 
@@ -385,6 +387,7 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 	if (irq >= 0) {
 		disable_irq(irq); /* make sure it's never delivered */
 		per_cpu(lock_kicker_irq, cpu) = irq;
+		per_cpu(irq_name, cpu) = name;
 	}
 
 	printk("cpu %d spinlock event irq %d\n", cpu, irq);
@@ -401,6 +404,8 @@ void xen_uninit_lock_cpu(int cpu)
 
 	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
 	per_cpu(lock_kicker_irq, cpu) = -1;
+	kfree(per_cpu(irq_name, cpu));
+	per_cpu(irq_name, cpu) = NULL;
 }
 
 void __init xen_init_spinlocks(void)
-- 
1.8.1.4

