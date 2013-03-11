Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3CKIqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:46:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:55186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab3CKIqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:46:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="303703684"
Subject: [PATCH 2/3] genirq: Do not consider the irqs with disabling and
 IRQF_NO_SUSPEND
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1363024396.31506.60.camel@cliu38-desktop-build>
References: <1363024396.31506.60.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Mar 2013 01:57:11 +0800
Message-ID: <1363024631.31506.64.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to commit 9c6079aa1bf(genirq: Do not consider disabled
wakeup irqs), we should not break the suspend when one irq is pending
but has been disabled before suspending.

But there is another case missed, that one irq with flag IRQF_NO_SUSPEND,
which has been disabled before suspending, and irq pending there,
in this case, we still should not break the suspending, otherwise,
the suspend abort over and over.

Here also checking if the desc->istate & IRQS_SUSPENDED is true.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/pm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index cb228bf..1470c1b 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -109,7 +109,8 @@ int check_wakeup_irqs(void)
 		 * can abort suspend.
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



