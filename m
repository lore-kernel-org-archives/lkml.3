Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbbATNAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:00:51 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:50118 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbATNAu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 20 Jan 2015 08:00:50 -0500
Message-Id: <54BE5F8E02000078000570A7@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 20 Jan 2015 13:00:46 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, <akpm@linux-foundation.org>,
        <mingo@redhat.com>
Subject: [PATCH v2] irqflags: fix (at least latent) code generation
 issue
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditional in local_irq_restore() otherwise can cause code bloat
(the if and else blocks may get translated into separate code paths
despite the generated code being identical, dependent on compiler
internal heuristics). Note that this adjustment gets the code in sync
with the comment preceding it (which was slightly wrong from at least
from 2.6.37 onwards).

The code bloat was observed in reality with an experimental x86 patch.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
v2: Deal with architectures not defining raw_irqs_disabled() by
    retaining the CONFIG_TRACE_IRQFLAGS_SUPPORT-dependent
    implementations of irqs_disabled(). Move out of either conditional
    the already identical definitions of local_save_flags() and
    irqs_disabled_flags().
---
 include/linux/irqflags.h |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- 3.19-rc5/include/linux/irqflags.h
+++ 3.19-rc5-irqflags/include/linux/irqflags.h
@@ -85,7 +85,7 @@
  * The local_irq_*() APIs are equal to the raw_local_irq*()
  * if !TRACE_IRQFLAGS.
  */
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+#ifdef CONFIG_TRACE_IRQFLAGS
 #define local_irq_enable() \
 	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
@@ -107,22 +107,6 @@
 			raw_local_irq_restore(flags);	\
 		}					\
 	} while (0)
-#define local_save_flags(flags)				\
-	do {						\
-		raw_local_save_flags(flags);		\
-	} while (0)
-
-#define irqs_disabled_flags(flags)			\
-	({						\
-		raw_irqs_disabled_flags(flags);		\
-	})
-
-#define irqs_disabled()					\
-	({						\
-		unsigned long _flags;			\
-		raw_local_save_flags(_flags);		\
-		raw_irqs_disabled_flags(_flags);	\
-	})
 
 #define safe_halt()				\
 	do {					\
@@ -131,7 +115,7 @@
 	} while (0)
 
 
-#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
+#else /* !CONFIG_TRACE_IRQFLAGS */
 
 #define local_irq_enable()	do { raw_local_irq_enable(); } while (0)
 #define local_irq_disable()	do { raw_local_irq_disable(); } while (0)
@@ -140,11 +124,28 @@
 		raw_local_irq_save(flags);			\
 	} while (0)
 #define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
-#define local_save_flags(flags)	do { raw_local_save_flags(flags); } while (0)
-#define irqs_disabled()		(raw_irqs_disabled())
-#define irqs_disabled_flags(flags) (raw_irqs_disabled_flags(flags))
 #define safe_halt()		do { raw_safe_halt(); } while (0)
 
+#endif /* CONFIG_TRACE_IRQFLAGS */
+
+#define local_save_flags(flags)	raw_local_save_flags(flags)
+
+/*
+ * Some architectures don't define arch_irqs_disabled(), so even if either
+ * definition would be fine we need to use different ones for the time being
+ * to avoid build issues.
+ */
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+#define irqs_disabled()					\
+	({						\
+		unsigned long _flags;			\
+		raw_local_save_flags(_flags);		\
+		raw_irqs_disabled_flags(_flags);	\
+	})
+#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
+#define irqs_disabled()	raw_irqs_disabled()
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
+#define irqs_disabled_flags(flags) raw_irqs_disabled_flags(flags)
+
 #endif



