Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaEAAgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:36:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56626 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaEAAgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:36:06 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 06/15] hwspinlock/omap: enable module before reading SYSSTATUS register
Date: Wed, 30 Apr 2014 19:34:27 -0500
Message-ID: <1398904476-26200-7-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of hwspinlocks are determined based on the value read
from the IP block's SYSSTATUS register. However, the module may
not be enabled and clocked, and the read may result in a bus error.

This particular issue is seen rather easily on AM33XX, since the
module wakeup is software controlled, and it is disabled out of
reset. Make sure the module is enabled and clocked before reading
the SYSSTATUS register.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/hwspinlock/omap_hwspinlock.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 9f56fb2..7764291 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -101,10 +101,29 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	if (!io_base)
 		return -ENOMEM;
 
+	/*
+	 * make sure the module is enabled and clocked before reading
+	 * the module SYSSTATUS register
+	 */
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
+		goto iounmap_base;
+	}
+
 	/* Determine number of locks */
 	i = readl(io_base + SYSSTATUS_OFFSET);
 	i >>= SPINLOCK_NUMLOCKS_BIT_OFFSET;
 
+	/*
+	 * runtime PM will make sure the clock of this module is
+	 * enabled again iff at least one lock is requested
+	 */
+	ret = pm_runtime_put_sync(&pdev->dev);
+	if (ret < 0)
+		goto iounmap_base;
+
 	/* one of the four lsb's must be set, and nothing else */
 	if (hweight_long(i & 0xf) != 1 || i > 8) {
 		ret = -EINVAL;
@@ -124,12 +143,6 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
 		hwlock->priv = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
 
-	/*
-	 * runtime PM will make sure the clock of this module is
-	 * enabled iff at least one lock is requested
-	 */
-	pm_runtime_enable(&pdev->dev);
-
 	ret = hwspin_lock_register(bank, &pdev->dev, &omap_hwspinlock_ops,
 						base_id, num_locks);
 	if (ret)
@@ -138,9 +151,9 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	return 0;
 
 reg_fail:
-	pm_runtime_disable(&pdev->dev);
 	kfree(bank);
 iounmap_base:
+	pm_runtime_disable(&pdev->dev);
 	iounmap(io_base);
 	return ret;
 }
-- 
1.9.2

