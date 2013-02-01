Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3BAUo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:44:26 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21468 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab3BAUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:21 -0500
Message-ID: <201302012043.r11KhKcs024369@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 13:01:36 -0500
Subject: [PATCH] tile: avoid defining INT_MASK macro in <arch/interrupts.h>
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, this name conflicts with a different use of
the name in various places through the tree, so don't provide
it for the kernel.  We preserve it for userspace to avoid
breaking any userspace code that relies on this definition.

This fixes a number of compile errors for various drivers that
are enabled by "allyesconfig".

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/irqflags.h            |   32 +--
 arch/tile/include/uapi/arch/interrupts_32.h |  394 ++++++++++++++-------------
 arch/tile/include/uapi/arch/interrupts_64.h |  346 +++++++++++------------
 arch/tile/kernel/stack.c                    |    2 +-
 4 files changed, 383 insertions(+), 391 deletions(-)

diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index b4e96fe..241c0bb 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -18,32 +18,20 @@
 #include <arch/interrupts.h>
 #include <arch/chip.h>
 
-#if !defined(__tilegx__) && defined(__ASSEMBLY__)
-
 /*
  * The set of interrupts we want to allow when interrupts are nominally
  * disabled.  The remainder are effectively "NMI" interrupts from
  * the point of view of the generic Linux code.  Note that synchronous
  * interrupts (aka "non-queued") are not blocked by the mask in any case.
  */
-#if CHIP_HAS_AUX_PERF_COUNTERS()
-#define LINUX_MASKABLE_INTERRUPTS_HI \
-	(~(INT_MASK_HI(INT_PERF_COUNT) | INT_MASK_HI(INT_AUX_PERF_COUNT)))
-#else
-#define LINUX_MASKABLE_INTERRUPTS_HI \
-	(~(INT_MASK_HI(INT_PERF_COUNT)))
-#endif
-
-#else
-
-#if CHIP_HAS_AUX_PERF_COUNTERS()
-#define LINUX_MASKABLE_INTERRUPTS \
-	(~(INT_MASK(INT_PERF_COUNT) | INT_MASK(INT_AUX_PERF_COUNT)))
-#else
 #define LINUX_MASKABLE_INTERRUPTS \
-	(~(INT_MASK(INT_PERF_COUNT)))
-#endif
+	(~((_AC(1,ULL) << INT_PERF_COUNT) | (_AC(1,ULL) << INT_AUX_PERF_COUNT)))
 
+#if CHIP_HAS_SPLIT_INTR_MASK()
+/* The same macro, but for the two 32-bit SPRs separately. */
+#define LINUX_MASKABLE_INTERRUPTS_LO (-1)
+#define LINUX_MASKABLE_INTERRUPTS_HI \
+	(~((1 << (INT_PERF_COUNT - 32)) | (1 << (INT_AUX_PERF_COUNT - 32))))
 #endif
 
 #ifndef __ASSEMBLY__
@@ -126,7 +114,7 @@
  * to know our current state.
  */
 DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
-#define INITIAL_INTERRUPTS_ENABLED INT_MASK(INT_MEM_ERROR)
+#define INITIAL_INTERRUPTS_ENABLED (1ULL << INT_MEM_ERROR)
 
 /* Disable interrupts. */
 #define arch_local_irq_disable() \
@@ -165,7 +153,7 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 
 /* Prevent the given interrupt from being enabled next time we enable irqs. */
 #define arch_local_irq_mask(interrupt) \
-	(__get_cpu_var(interrupts_enabled_mask) &= ~INT_MASK(interrupt))
+	(__get_cpu_var(interrupts_enabled_mask) &= ~(1ULL << (interrupt)))
 
 /* Prevent the given interrupt from being enabled immediately. */
 #define arch_local_irq_mask_now(interrupt) do { \
@@ -175,7 +163,7 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 
 /* Allow the given interrupt to be enabled next time we enable irqs. */
 #define arch_local_irq_unmask(interrupt) \
-	(__get_cpu_var(interrupts_enabled_mask) |= INT_MASK(interrupt))
+	(__get_cpu_var(interrupts_enabled_mask) |= (1ULL << (interrupt)))
 
 /* Allow the given interrupt to be enabled immediately, if !irqs_disabled. */
 #define arch_local_irq_unmask_now(interrupt) do { \
@@ -250,7 +238,7 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 /* Disable interrupts. */
 #define IRQ_DISABLE(tmp0, tmp1)					\
 	{							\
-	 movei  tmp0, -1;					\
+	 movei  tmp0, LINUX_MASKABLE_INTERRUPTS_LO;		\
 	 moveli tmp1, lo16(LINUX_MASKABLE_INTERRUPTS_HI)	\
 	};							\
 	{							\
diff --git a/arch/tile/include/uapi/arch/interrupts_32.h b/arch/tile/include/uapi/arch/interrupts_32.h
index 96b5710..2efe3f6 100644
--- a/arch/tile/include/uapi/arch/interrupts_32.h
+++ b/arch/tile/include/uapi/arch/interrupts_32.h
@@ -15,6 +15,7 @@
 #ifndef __ARCH_INTERRUPTS_H__
 #define __ARCH_INTERRUPTS_H__
 
+#ifndef __KERNEL__
 /** Mask for an interrupt. */
 /* Note: must handle breaking interrupts into high and low words manually. */
 #define INT_MASK_LO(intno) (1 << (intno))
@@ -23,6 +24,7 @@
 #ifndef __ASSEMBLER__
 #define INT_MASK(intno) (1ULL << (intno))
 #endif
+#endif
 
 
 /** Where a given interrupt executes */
@@ -92,216 +94,216 @@
 
 #ifndef __ASSEMBLER__
 #define QUEUED_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_DMATLB_MISS) | \
-    INT_MASK(INT_DMATLB_ACCESS) | \
-    INT_MASK(INT_SNITLB_MISS) | \
-    INT_MASK(INT_SN_NOTIFY) | \
-    INT_MASK(INT_SN_FIREWALL) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_DMA_NOTIFY) | \
-    INT_MASK(INT_IDN_CA) | \
-    INT_MASK(INT_UDN_CA) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DMA_ASID) | \
-    INT_MASK(INT_SNI_ASID) | \
-    INT_MASK(INT_DMA_CPL) | \
-    INT_MASK(INT_SN_CPL) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_DMATLB_MISS) | \
+    (1ULL << INT_DMATLB_ACCESS) | \
+    (1ULL << INT_SNITLB_MISS) | \
+    (1ULL << INT_SN_NOTIFY) | \
+    (1ULL << INT_SN_FIREWALL) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_DMA_NOTIFY) | \
+    (1ULL << INT_IDN_CA) | \
+    (1ULL << INT_UDN_CA) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DMA_ASID) | \
+    (1ULL << INT_SNI_ASID) | \
+    (1ULL << INT_DMA_CPL) | \
+    (1ULL << INT_SN_CPL) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
     0)
 #define NONQUEUED_INTERRUPTS ( \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_SN_ACCESS) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_IDN_REFILL) | \
-    INT_MASK(INT_UDN_REFILL) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
-    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_SN_ACCESS) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_IDN_REFILL) | \
+    (1ULL << INT_UDN_REFILL) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
+    (1ULL << INT_SN_STATIC_ACCESS) | \
     0)
 #define CRITICAL_MASKED_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_DMATLB_MISS) | \
-    INT_MASK(INT_DMATLB_ACCESS) | \
-    INT_MASK(INT_SNITLB_MISS) | \
-    INT_MASK(INT_SN_NOTIFY) | \
-    INT_MASK(INT_SN_FIREWALL) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_DMA_NOTIFY) | \
-    INT_MASK(INT_IDN_CA) | \
-    INT_MASK(INT_UDN_CA) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_DMATLB_MISS) | \
+    (1ULL << INT_DMATLB_ACCESS) | \
+    (1ULL << INT_SNITLB_MISS) | \
+    (1ULL << INT_SN_NOTIFY) | \
+    (1ULL << INT_SN_FIREWALL) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_DMA_NOTIFY) | \
+    (1ULL << INT_IDN_CA) | \
+    (1ULL << INT_UDN_CA) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
     0)
 #define CRITICAL_UNMASKED_INTERRUPTS ( \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_SN_ACCESS) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_IDN_REFILL) | \
-    INT_MASK(INT_UDN_REFILL) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DMA_ASID) | \
-    INT_MASK(INT_SNI_ASID) | \
-    INT_MASK(INT_DMA_CPL) | \
-    INT_MASK(INT_SN_CPL) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
-    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_SN_ACCESS) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_IDN_REFILL) | \
+    (1ULL << INT_UDN_REFILL) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DMA_ASID) | \
+    (1ULL << INT_SNI_ASID) | \
+    (1ULL << INT_DMA_CPL) | \
+    (1ULL << INT_SN_CPL) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
+    (1ULL << INT_SN_STATIC_ACCESS) | \
     0)
 #define MASKABLE_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_IDN_REFILL) | \
-    INT_MASK(INT_UDN_REFILL) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_DMATLB_MISS) | \
-    INT_MASK(INT_DMATLB_ACCESS) | \
-    INT_MASK(INT_SNITLB_MISS) | \
-    INT_MASK(INT_SN_NOTIFY) | \
-    INT_MASK(INT_SN_FIREWALL) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_DMA_NOTIFY) | \
-    INT_MASK(INT_IDN_CA) | \
-    INT_MASK(INT_UDN_CA) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_IDN_REFILL) | \
+    (1ULL << INT_UDN_REFILL) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_DMATLB_MISS) | \
+    (1ULL << INT_DMATLB_ACCESS) | \
+    (1ULL << INT_SNITLB_MISS) | \
+    (1ULL << INT_SN_NOTIFY) | \
+    (1ULL << INT_SN_FIREWALL) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_DMA_NOTIFY) | \
+    (1ULL << INT_IDN_CA) | \
+    (1ULL << INT_UDN_CA) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
     0)
 #define UNMASKABLE_INTERRUPTS ( \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_SN_ACCESS) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DMA_ASID) | \
-    INT_MASK(INT_SNI_ASID) | \
-    INT_MASK(INT_DMA_CPL) | \
-    INT_MASK(INT_SN_CPL) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
-    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_SN_ACCESS) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DMA_ASID) | \
+    (1ULL << INT_SNI_ASID) | \
+    (1ULL << INT_DMA_CPL) | \
+    (1ULL << INT_SN_CPL) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
+    (1ULL << INT_SN_STATIC_ACCESS) | \
     0)
 #define SYNC_INTERRUPTS ( \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_SN_ACCESS) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_IDN_REFILL) | \
-    INT_MASK(INT_UDN_REFILL) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
-    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_SN_ACCESS) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_IDN_REFILL) | \
+    (1ULL << INT_UDN_REFILL) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
+    (1ULL << INT_SN_STATIC_ACCESS) | \
     0)
 #define NON_SYNC_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_DMATLB_MISS) | \
-    INT_MASK(INT_DMATLB_ACCESS) | \
-    INT_MASK(INT_SNITLB_MISS) | \
-    INT_MASK(INT_SN_NOTIFY) | \
-    INT_MASK(INT_SN_FIREWALL) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_DMA_NOTIFY) | \
-    INT_MASK(INT_IDN_CA) | \
-    INT_MASK(INT_UDN_CA) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DMA_ASID) | \
-    INT_MASK(INT_SNI_ASID) | \
-    INT_MASK(INT_DMA_CPL) | \
-    INT_MASK(INT_SN_CPL) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_DMATLB_MISS) | \
+    (1ULL << INT_DMATLB_ACCESS) | \
+    (1ULL << INT_SNITLB_MISS) | \
+    (1ULL << INT_SN_NOTIFY) | \
+    (1ULL << INT_SN_FIREWALL) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_DMA_NOTIFY) | \
+    (1ULL << INT_IDN_CA) | \
+    (1ULL << INT_UDN_CA) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DMA_ASID) | \
+    (1ULL << INT_SNI_ASID) | \
+    (1ULL << INT_DMA_CPL) | \
+    (1ULL << INT_SN_CPL) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
     0)
 #endif /* !__ASSEMBLER__ */
 #endif /* !__ARCH_INTERRUPTS_H__ */
diff --git a/arch/tile/include/uapi/arch/interrupts_64.h b/arch/tile/include/uapi/arch/interrupts_64.h
index 5bb58b2..13c9f91 100644
--- a/arch/tile/include/uapi/arch/interrupts_64.h
+++ b/arch/tile/include/uapi/arch/interrupts_64.h
@@ -15,6 +15,7 @@
 #ifndef __ARCH_INTERRUPTS_H__
 #define __ARCH_INTERRUPTS_H__
 
+#ifndef __KERNEL__
 /** Mask for an interrupt. */
 #ifdef __ASSEMBLER__
 /* Note: must handle breaking interrupts into high and low words manually. */
@@ -22,6 +23,7 @@
 #else
 #define INT_MASK(intno) (1ULL << (intno))
 #endif
+#endif
 
 
 /** Where a given interrupt executes */
@@ -85,192 +87,192 @@
 
 #ifndef __ASSEMBLER__
 #define QUEUED_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_AUX_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_IPI_3) | \
-    INT_MASK(INT_IPI_2) | \
-    INT_MASK(INT_IPI_1) | \
-    INT_MASK(INT_IPI_0) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_AUX_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_IPI_3) | \
+    (1ULL << INT_IPI_2) | \
+    (1ULL << INT_IPI_1) | \
+    (1ULL << INT_IPI_0) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
     0)
 #define NONQUEUED_INTERRUPTS ( \
-    INT_MASK(INT_SINGLE_STEP_3) | \
-    INT_MASK(INT_SINGLE_STEP_2) | \
-    INT_MASK(INT_SINGLE_STEP_1) | \
-    INT_MASK(INT_SINGLE_STEP_0) | \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_ILL_TRANS) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
+    (1ULL << INT_SINGLE_STEP_3) | \
+    (1ULL << INT_SINGLE_STEP_2) | \
+    (1ULL << INT_SINGLE_STEP_1) | \
+    (1ULL << INT_SINGLE_STEP_0) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_ILL_TRANS) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
     0)
 #define CRITICAL_MASKED_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_SINGLE_STEP_3) | \
-    INT_MASK(INT_SINGLE_STEP_2) | \
-    INT_MASK(INT_SINGLE_STEP_1) | \
-    INT_MASK(INT_SINGLE_STEP_0) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_AUX_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_IPI_3) | \
-    INT_MASK(INT_IPI_2) | \
-    INT_MASK(INT_IPI_1) | \
-    INT_MASK(INT_IPI_0) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_SINGLE_STEP_3) | \
+    (1ULL << INT_SINGLE_STEP_2) | \
+    (1ULL << INT_SINGLE_STEP_1) | \
+    (1ULL << INT_SINGLE_STEP_0) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_AUX_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_IPI_3) | \
+    (1ULL << INT_IPI_2) | \
+    (1ULL << INT_IPI_1) | \
+    (1ULL << INT_IPI_0) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
     0)
 #define CRITICAL_UNMASKED_INTERRUPTS ( \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_ILL_TRANS) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_ILL_TRANS) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
     0)
 #define MASKABLE_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_SINGLE_STEP_3) | \
-    INT_MASK(INT_SINGLE_STEP_2) | \
-    INT_MASK(INT_SINGLE_STEP_1) | \
-    INT_MASK(INT_SINGLE_STEP_0) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_AUX_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_IPI_3) | \
-    INT_MASK(INT_IPI_2) | \
-    INT_MASK(INT_IPI_1) | \
-    INT_MASK(INT_IPI_0) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_SINGLE_STEP_3) | \
+    (1ULL << INT_SINGLE_STEP_2) | \
+    (1ULL << INT_SINGLE_STEP_1) | \
+    (1ULL << INT_SINGLE_STEP_0) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_AUX_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_IPI_3) | \
+    (1ULL << INT_IPI_2) | \
+    (1ULL << INT_IPI_1) | \
+    (1ULL << INT_IPI_0) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
     0)
 #define UNMASKABLE_INTERRUPTS ( \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_ILL_TRANS) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_ILL_TRANS) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
     0)
 #define SYNC_INTERRUPTS ( \
-    INT_MASK(INT_SINGLE_STEP_3) | \
-    INT_MASK(INT_SINGLE_STEP_2) | \
-    INT_MASK(INT_SINGLE_STEP_1) | \
-    INT_MASK(INT_SINGLE_STEP_0) | \
-    INT_MASK(INT_IDN_COMPLETE) | \
-    INT_MASK(INT_UDN_COMPLETE) | \
-    INT_MASK(INT_ITLB_MISS) | \
-    INT_MASK(INT_ILL) | \
-    INT_MASK(INT_GPV) | \
-    INT_MASK(INT_IDN_ACCESS) | \
-    INT_MASK(INT_UDN_ACCESS) | \
-    INT_MASK(INT_SWINT_3) | \
-    INT_MASK(INT_SWINT_2) | \
-    INT_MASK(INT_SWINT_1) | \
-    INT_MASK(INT_SWINT_0) | \
-    INT_MASK(INT_ILL_TRANS) | \
-    INT_MASK(INT_UNALIGN_DATA) | \
-    INT_MASK(INT_DTLB_MISS) | \
-    INT_MASK(INT_DTLB_ACCESS) | \
+    (1ULL << INT_SINGLE_STEP_3) | \
+    (1ULL << INT_SINGLE_STEP_2) | \
+    (1ULL << INT_SINGLE_STEP_1) | \
+    (1ULL << INT_SINGLE_STEP_0) | \
+    (1ULL << INT_IDN_COMPLETE) | \
+    (1ULL << INT_UDN_COMPLETE) | \
+    (1ULL << INT_ITLB_MISS) | \
+    (1ULL << INT_ILL) | \
+    (1ULL << INT_GPV) | \
+    (1ULL << INT_IDN_ACCESS) | \
+    (1ULL << INT_UDN_ACCESS) | \
+    (1ULL << INT_SWINT_3) | \
+    (1ULL << INT_SWINT_2) | \
+    (1ULL << INT_SWINT_1) | \
+    (1ULL << INT_SWINT_0) | \
+    (1ULL << INT_ILL_TRANS) | \
+    (1ULL << INT_UNALIGN_DATA) | \
+    (1ULL << INT_DTLB_MISS) | \
+    (1ULL << INT_DTLB_ACCESS) | \
     0)
 #define NON_SYNC_INTERRUPTS ( \
-    INT_MASK(INT_MEM_ERROR) | \
-    INT_MASK(INT_IDN_FIREWALL) | \
-    INT_MASK(INT_UDN_FIREWALL) | \
-    INT_MASK(INT_TILE_TIMER) | \
-    INT_MASK(INT_AUX_TILE_TIMER) | \
-    INT_MASK(INT_IDN_TIMER) | \
-    INT_MASK(INT_UDN_TIMER) | \
-    INT_MASK(INT_IDN_AVAIL) | \
-    INT_MASK(INT_UDN_AVAIL) | \
-    INT_MASK(INT_IPI_3) | \
-    INT_MASK(INT_IPI_2) | \
-    INT_MASK(INT_IPI_1) | \
-    INT_MASK(INT_IPI_0) | \
-    INT_MASK(INT_PERF_COUNT) | \
-    INT_MASK(INT_AUX_PERF_COUNT) | \
-    INT_MASK(INT_INTCTRL_3) | \
-    INT_MASK(INT_INTCTRL_2) | \
-    INT_MASK(INT_INTCTRL_1) | \
-    INT_MASK(INT_INTCTRL_0) | \
-    INT_MASK(INT_BOOT_ACCESS) | \
-    INT_MASK(INT_WORLD_ACCESS) | \
-    INT_MASK(INT_I_ASID) | \
-    INT_MASK(INT_D_ASID) | \
-    INT_MASK(INT_DOUBLE_FAULT) | \
+    (1ULL << INT_MEM_ERROR) | \
+    (1ULL << INT_IDN_FIREWALL) | \
+    (1ULL << INT_UDN_FIREWALL) | \
+    (1ULL << INT_TILE_TIMER) | \
+    (1ULL << INT_AUX_TILE_TIMER) | \
+    (1ULL << INT_IDN_TIMER) | \
+    (1ULL << INT_UDN_TIMER) | \
+    (1ULL << INT_IDN_AVAIL) | \
+    (1ULL << INT_UDN_AVAIL) | \
+    (1ULL << INT_IPI_3) | \
+    (1ULL << INT_IPI_2) | \
+    (1ULL << INT_IPI_1) | \
+    (1ULL << INT_IPI_0) | \
+    (1ULL << INT_PERF_COUNT) | \
+    (1ULL << INT_AUX_PERF_COUNT) | \
+    (1ULL << INT_INTCTRL_3) | \
+    (1ULL << INT_INTCTRL_2) | \
+    (1ULL << INT_INTCTRL_1) | \
+    (1ULL << INT_INTCTRL_0) | \
+    (1ULL << INT_BOOT_ACCESS) | \
+    (1ULL << INT_WORLD_ACCESS) | \
+    (1ULL << INT_I_ASID) | \
+    (1ULL << INT_D_ASID) | \
+    (1ULL << INT_DOUBLE_FAULT) | \
     0)
 #endif /* !__ASSEMBLER__ */
 #endif /* !__ARCH_INTERRUPTS_H__ */
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index b2f44c2..ba2b36c 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -112,7 +112,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 		       p->pc, p->sp, p->ex1);
 		p = NULL;
 	}
-	if (!kbt->profile || (INT_MASK(p->faultnum) & QUEUED_INTERRUPTS) == 0)
+	if (!kbt->profile || ((1ULL << p->faultnum) & QUEUED_INTERRUPTS) == 0)
 		return p;
 	return NULL;
 }
-- 
1.7.10.3

