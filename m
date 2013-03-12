Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3CLArm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:47:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:16663 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab3CLAri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:47:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,827,1355126400"; 
   d="scan'208";a="213037963"
Subject: [PATCH 2/3] genirq: Do not consider the irqs with IRQF_NO_SUSPEND
 in check_wakeup_irqs()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1363024631.31506.64.camel@cliu38-desktop-build>
References: <1363024396.31506.60.camel@cliu38-desktop-build>
	 <1363024631.31506.64.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Mar 2013 17:58:14 +0800
Message-ID: <1363082294.7518.4.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to commit 9c6079aa1bf(genirq: Do not consider disabled
wakeup irqs), we should not break the suspend when one interrupt has
been disabled before suspending and is pending there.

But there is another case missed:
If an interrupt which is marked IRQF_NO_SUSPEND has been disabled
before suspend invocation then desc->depth is 1 and therefor it should
not be checked for IRQS_PENDING in check_wakeup_irqs().

Here also checking if the desc->istate & IRQS_SUSPENDED is true to avoid
this case.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/pm.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index cb228bf..f02a03d 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -107,9 +107,16 @@ int check_wakeup_irqs(void)
 		 * Only interrupts which are marked as wakeup source
 		 * and have not been disabled before the suspend check
 		 * can abort suspend.
+		 *
+		 * Meanwhile, if an interrupt which is marked IRQF_NO_SUSPEND
+		 * has been disabled before suspend invocation then
+		 * desc->depth is 1 and therefor it should not be checked
+		 * for IRQS_PENDING, so also adding the checking of
+		 * desc->istate & IRQS_SUSPENDED for this case.
 		 */
 		if (irqd_is_wakeup_set(&desc->irq_data)) {
-			if (desc->depth == 1 && desc->istate & IRQS_PENDING)
+			if (desc->depth == 1 && (desc->istate & IRQS_PENDING)
+				&& (desc->istate & IRQS_SUSPENDED))
 				return -EBUSY;
 			continue;
 		}
-- 
1.7.0.4



