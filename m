Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaDXBec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:34:32 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:15733 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDXBe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:34:29 -0400
From: Wuqixuan <wuqixuan@huawei.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lizefan <lizefan@huawei.com>, qixuan wu <wuqixuan@gmail.com>
Subject: [PATCH] ARM: armv6 & armv7 no need update SCTLR for alignment
Thread-Topic: [PATCH] ARM: armv6 & armv7 no need update SCTLR for alignment
Thread-Index: Ac9fXQ///zCnr49JQyK9Rg6XQe4XrQ==
Date: Thu, 24 Apr 2014 01:32:32 +0000
Message-ID: <BB7C62C2B0732E4DA93834A501E846456C8F1D93@szxema505-mbx.china.huawei.com>
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

Now in the code, when interrupt and exception disturbs the user-space, always
update SCTLR with cr_alignment. In our ARMv7 Cortex A15 SOC, the statements  
bracketed by CONFIG_ALIGNMENT_TRAP need about 100 cycles. it impacts our 
high realtime interrupt requirement scenario. Considering in ARMv6 and ARMv7 
versions, cr_alignment and cr_no_alignment are always same without A bit, 
they are initialized by clearing A bit in alignment_init. So there is no 
need to update SCTLR if interrupt and exception disturbs the user-space
in vector_swi function or alignment_trap macro, in the ARMv6 and ARMv7 chip. 
The patch has already verified in our ARMv7 Cortex A15 SOC. 
Signed-off-by: Wuqixuan <wuqixuan@huawei.com>
---
 arch/arm/kernel/entry-common.S |    4 ++--
 arch/arm/kernel/entry-header.S |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index a2dcafd..4b7686a 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -366,7 +366,7 @@ ENTRY(vector_swi)
 #endif
  zero_fp
 
-#ifdef CONFIG_ALIGNMENT_TRAP
+#if defined(CONFIG_ALIGNMENT_TRAP) && !(__LINUX_ARM_ARCH__ >= 6)
  ldr ip, __cr_alignment
  ldr ip, [ip]
  mcr p15, 0, ip, c1, c0  @ update control register
@@ -490,7 +490,7 @@ __sys_trace_return:
  b ret_slow_syscall
 
  .align 5
-#ifdef CONFIG_ALIGNMENT_TRAP
+#if defined(CONFIG_ALIGNMENT_TRAP) && !(__LINUX_ARM_ARCH__ >= 6)
  .type __cr_alignment, #object
 __cr_alignment:
  .word cr_alignment
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 1420725..5eb9e59 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -38,7 +38,7 @@
  .endm
 
  .macro alignment_trap, rtemp
-#ifdef CONFIG_ALIGNMENT_TRAP
+#if defined(CONFIG_ALIGNMENT_TRAP) && !(__LINUX_ARM_ARCH__ >= 6)
  ldr \rtemp, .LCcralign
  ldr \rtemp, [\rtemp]
  mcr p15, 0, \rtemp, c1, c0
-- 
1.7.6