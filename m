Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3CKIsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:48:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:34242 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab3CKIst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="299784978"
Subject: [PATCH 3/3] genirq: Give warning in case calling irq_set_irq_wake
 with _NO_SUSPEND flag
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1363024396.31506.60.camel@cliu38-desktop-build>
References: <1363024396.31506.60.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Mar 2013 01:59:13 +0800
Message-ID: <1363024753.31506.66.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When one irq is setup with flag IRQF_NO_SUSPEND, it is pointless
to call irq_set_irq_wake().

Because check_wakeup_irqs() is just checking the irq which has pending
but is in IRQS_SUSPENDED state when do syscore_suspend().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/manage.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..94c5af9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -513,6 +513,14 @@ int irq_set_irq_wake(unsigned int irq, unsigned int on)
 	if (!desc)
 		return -EINVAL;
 
+	/* Checking if the flag IRQF_NO_SUSPEND is set,
+	 * if set, drivers do not need to call irq_set_irq_wake(),
+	 * it is pointless.
+	 */
+	if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+		WARN(1, "IRQ %d with flag IRQF_NO_SUSPEND, no need to call here\n",
+			irq);
+
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
-- 
1.7.0.4



