Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaDRJ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:56:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13744 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRJ4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:56:18 -0400
From: Wuqixuan <wuqixuan@huawei.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: armv7 no need update SCTLR for alignment 
Thread-Topic: [PATCH] ARM: armv7 no need update SCTLR for alignment 
Thread-Index: Ac9a6/Vi5insSwQTSHSyvCgLpN/vZQ==
Date: Fri, 18 Apr 2014 09:53:07 +0000
Message-ID: <BB7C62C2B0732E4DA93834A501E846456C8F1A92@szxema505-mbx.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.66.68.202]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Armv7, cr_alignment and cr_no_alignment are always same, in alignment_init both 
cr_alignment and cr_no_alignment will be updated by clearing A bit. So there is no 
meaning to update SCTLR if interrupt and exception disturbs the user-space. 

Signed-off-by: Wuqixuan <wuqixuan@huawei.com>
---
diff -git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -323,12 +323,6 @@
   A710( bne .Larm710bug      )
 
 #endif
-#if defined(CONFIG_ALIGNMENT_TRAP)
+#if defined(CONFIG_ALIGNMENT_TRAP) && !(__LINUX_ARM_ARCH__ >= 7)
 ldr ip, __cr_alignment
 ldr ip, [ip]
 mcr p15, 0, ip, c1, c0  @ update control register
#endif
  enable_irq
 
  get_thread_info tsk
@@ -393,11 +387,6 @@
  b ret_slow_syscall
 
  .align 5
-#ifdef CONFIG_ALIGNMENT_TRAP
+#if defined(CONFIG_ALIGNMENT_TRAP) && !(__LINUX_ARM_ARCH__ >= 7)
 .type __cr_alignment, #object
__cr_alignment:
 .word cr_alignment
#endif
  .ltorg
 
 /*
diff -git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -44,11 +44,6 @@
  .endm
 
  .macro alignment_trap, rtemp
-#ifdef CONFIG_ALIGNMENT_TRAP 
+#if defined(CONFIG_ALIGNMENT_TRAP) && !(__LINUX_ARM_ARCH__ >= 7)
 ldr \rtemp, .LCcralign
 ldr \rtemp, [\rtemp]
 mcr p15, 0, \rtemp, c1, c0
#endif
  .endm
 
  @