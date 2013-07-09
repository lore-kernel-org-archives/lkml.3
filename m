Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3GIOYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:24:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13753 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3GIOYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:24:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Jul 2013 07:23:31 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] irq: enable suspended EARLY_RESUME irqs forcefully if not resumed
Date: Tue, 9 Jul 2013 20:02:23 +0530
Message-ID: <1373380343-10143-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When system enters into suspend, it disable all irqs in single
function call. This disables EARLY_RESUME irqs also along with
normal irqs.

The EARLY_RESUME irqs get enabled in sys_core_ops->resume and
non-EARLY_RESUME irqs get enabled in normal system resume path.

When suspend_noirq failed or suspend is aborted for any reason,
the EARLY_RESUME irqs do not get enabled as sys_core_ops->resume()
call did not happen. It only enables the non-EARLY_RESUME irqs in normal
disable for remaining life of system.

Add checks on normal irq_resume() whether EARLY_RESUME irqs have been
enabled or not and if not then enable it forcefully.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 kernel/irq/pm.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index cb228bf..e8a1427 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -13,6 +13,8 @@
 
 #include "internals.h"
 
+static bool early_resume_irq_suspended;
+
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
@@ -37,6 +39,7 @@ void suspend_device_irqs(void)
 	for_each_irq_desc(irq, desc)
 		if (desc->istate & IRQS_SUSPENDED)
 			synchronize_irq(irq);
+	early_resume_irq_suspended = true;
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
@@ -67,6 +70,7 @@ static void resume_irqs(bool want_early)
 static void irq_pm_syscore_resume(void)
 {
 	resume_irqs(true);
+	early_resume_irq_suspended = false;
 }
 
 static struct syscore_ops irq_pm_syscore_ops = {
@@ -87,9 +91,15 @@ device_initcall(irq_pm_init_ops);
  * Enable all non-%IRQF_EARLY_RESUME interrupt lines previously
  * disabled by suspend_device_irqs() that have the IRQS_SUSPENDED flag
  * set as well as those with %IRQF_FORCE_RESUME.
+ * Also enable IRQF_EARLY_RESUME irqs if it is not enabled by syscore_ops
+ * resume path.
  */
 void resume_device_irqs(void)
 {
+	if (early_resume_irq_suspended) {
+		pr_err("%s: Resuming IRQF_EARLY_RESUME forcefully\n", __func__);
+		irq_pm_syscore_resume();
+	}
 	resume_irqs(false);
 }
 EXPORT_SYMBOL_GPL(resume_device_irqs);
-- 
1.7.1.1

