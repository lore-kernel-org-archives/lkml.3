Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaKDIXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:23:13 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:59446 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDIXK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 4 Nov 2014 03:23:10 -0500
Message-Id: <54589AFA0200007800044A77@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 04 Nov 2014 08:23:06 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, <akpm@linux-foundation.org>,
        <mingo@redhat.com>
Subject: [PATCH] irqflags: fix (at least latent) code generation issue
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

The code bloat was observed in reality with an experimental x86 patch
I'm about to post as RFC.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 include/linux/irqflags.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 3.18-rc3/include/linux/irqflags.h
+++ 3.18-rc3-irqflags/include/linux/irqflags.h
@@ -85,7 +85,7 @@
  * The local_irq_*() APIs are equal to the raw_local_irq*()
  * if !TRACE_IRQFLAGS.
  */
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+#ifdef CONFIG_TRACE_IRQFLAGS
 #define local_irq_enable() \
 	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
@@ -131,7 +131,7 @@
 	} while (0)
 
 
-#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
+#else /* !CONFIG_TRACE_IRQFLAGS */
 
 #define local_irq_enable()	do { raw_local_irq_enable(); } while (0)
 #define local_irq_disable()	do { raw_local_irq_disable(); } while (0)
@@ -145,6 +145,6 @@
 #define irqs_disabled_flags(flags) (raw_irqs_disabled_flags(flags))
 #define safe_halt()		do { raw_safe_halt(); } while (0)
 
-#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
+#endif /* CONFIG_TRACE_IRQFLAGS */
 
 #endif



