Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaK0RKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:10:48 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55488 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaK0RK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:10:29 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM
Subject: [PATCH RFC 1/2] preempt: track pagefault_disable() calls in the preempt counter
Date: Thu, 27 Nov 2014 18:10:16 +0100
Message-Id: <1417108217-42687-2-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1417108217-42687-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
 <1417108217-42687-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112717-0041-0000-0000-00000247D676
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's track the levels of pagefault_disable() calls in a separate part of the
preempt counter. Also update the regular preempt counter to keep the existing
pagefault infrastructure working (can be demangeled and cleaned up later).

This change is needed to detect whether we are running in a simple atomic
context or in pagefault_disable() context.

Cleanup the PREEMPT_ACTIVE defines and fix the preempt count documentation on
the way.

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 include/linux/preempt_mask.h | 24 +++++++++++++++++++-----
 include/linux/uaccess.h      | 21 ++++++++++++++-------
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index dbeec4d..9d6e7f7 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -4,11 +4,15 @@
 #include <linux/preempt.h>
 
 /*
- * We put the hardirq and softirq counter into the preemption
+ * We put the hardirq, softirq and pagefault_disable counter into the preemption
  * counter. The bitmask has the following meaning:
  *
  * - bits 0-7 are the preemption count (max preemption depth: 256)
  * - bits 8-15 are the softirq count (max # of softirqs: 256)
+ * - bits 16-19 are the hardirq count (max # of hardirqs: 16)
+ * - bit 20 is the nmi flag
+ * - bit 21 is the preempt_active flag
+ * - bits 22-25 are the pagefault count (max pagefault disable depth: 16)
  *
  * The hardirq count could in theory be the same as the number of
  * interrupts in the system, but we run all interrupt handlers with
@@ -21,16 +25,21 @@
  * HARDIRQ_MASK:	0x000f0000
  *     NMI_MASK:	0x00100000
  * PREEMPT_ACTIVE:	0x00200000
+ * PAGEFAULT_MASK:	0x03C00000
  */
 #define PREEMPT_BITS	8
 #define SOFTIRQ_BITS	8
 #define HARDIRQ_BITS	4
 #define NMI_BITS	1
+#define PREEMPT_ACTIVE_BITS	1
+#define PAGEFAULT_BITS	4
 
 #define PREEMPT_SHIFT	0
 #define SOFTIRQ_SHIFT	(PREEMPT_SHIFT + PREEMPT_BITS)
 #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)
 #define NMI_SHIFT	(HARDIRQ_SHIFT + HARDIRQ_BITS)
+#define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
+#define PAGEFAULT_SHIFT	(PREEMPT_ACTIVE_SHIFT + PREEMPT_ACTIVE_BITS)
 
 #define __IRQ_MASK(x)	((1UL << (x))-1)
 
@@ -38,18 +47,17 @@
 #define SOFTIRQ_MASK	(__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
 #define HARDIRQ_MASK	(__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
 #define NMI_MASK	(__IRQ_MASK(NMI_BITS)     << NMI_SHIFT)
+#define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
+#define PAGEFAULT_MASK	(__IRQ_MASK(PAGEFAULT_BITS) << PAGEFAULT_SHIFT)
 
 #define PREEMPT_OFFSET	(1UL << PREEMPT_SHIFT)
 #define SOFTIRQ_OFFSET	(1UL << SOFTIRQ_SHIFT)
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
 #define NMI_OFFSET	(1UL << NMI_SHIFT)
+#define PAGEFAULT_OFFSET (1UL << PAGEFAULT_SHIFT)
 
 #define SOFTIRQ_DISABLE_OFFSET	(2 * SOFTIRQ_OFFSET)
 
-#define PREEMPT_ACTIVE_BITS	1
-#define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
-#define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
-
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
 #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK \
@@ -71,6 +79,12 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
+/*
+ * Are we in pagefault_disable context?
+ */
+#define pagefault_disabled()	(preempt_count() & PAGEFAULT_MASK)
+
+
 #if defined(CONFIG_PREEMPT_COUNT)
 # define PREEMPT_CHECK_OFFSET 1
 #else
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index ecd3319..a2ba6e6 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -4,18 +4,24 @@
 #include <linux/preempt.h>
 #include <asm/uaccess.h>
 
+#define __pagefault_count_inc() preempt_count_add(PAGEFAULT_OFFSET)
+#define __pagefault_count_dec() preempt_count_sub(PAGEFAULT_OFFSET)
+
 /*
- * These routines enable/disable the pagefault handler in that
- * it will not take any locks and go straight to the fixup table.
+ * These routines enable/disable the pagefault handler. If disabled, it will
+ * not take any locks and go straight to the fixup table.
+ *
+ * We increase the preempt and the pagefault count, to be able to distinguish
+ * whether we run in simple atomic context or in a real pagefault_disable context.
+ *
+ * For now, after pagefault_disabled() has been called, we run in atomic
+ * context. User access methods will not sleep.
  *
- * They have great resemblance to the preempt_disable/enable calls
- * and in fact they are identical; this is because currently there is
- * no other way to make the pagefault handlers do this. So we do
- * disable preemption but we don't necessarily care about that.
  */
 static inline void pagefault_disable(void)
 {
 	preempt_count_inc();
+	__pagefault_count_inc();
 	/*
 	 * make sure to have issued the store before a pagefault
 	 * can hit.
@@ -25,12 +31,13 @@ static inline void pagefault_disable(void)
 
 static inline void pagefault_enable(void)
 {
-#ifndef CONFIG_PREEMPT
 	/*
 	 * make sure to issue those last loads/stores before enabling
 	 * the pagefault handler again.
 	 */
 	barrier();
+	__pagefault_count_dec();
+#ifndef CONFIG_PREEMPT
 	preempt_count_dec();
 #else
 	preempt_enable();
-- 
1.8.5.5

