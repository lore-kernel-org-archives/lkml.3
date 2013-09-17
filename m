Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3IQTcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:32:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56108 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3IQTb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:58 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 7/9] hwspinlock/omap: enable module before reading SYSSTATUS register
Date: Tue, 17 Sep 2013 14:31:13 -0500
Message-ID: <57ff4cb6204462488e9d15bd497edbc72bd42ed9.1379445653.git.s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <cover.1379445653.git.s-anna@ti.com>
References: <cover.1379445653.git.s-anna@ti.com>
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
 drivers/hwspinlock/omap_hwspinlock.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 1c99391..f73b00f 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -106,10 +106,23 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	if (!io_base)
 		return -ENOMEM;
 
+	/*
+	 * make sure the module is enabled and clocked before reading
+	 * the module SYSSTATUS register
+	 */
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	/* Determine number of locks */
 	i = readl(io_base + SYSSTATUS_OFFSET);
 	i >>= SPINLOCK_NUMLOCKS_BIT_OFFSET;
 
+	/*
+	 * runtime PM will make sure the clock of this module is
+	 * enabled again iff at least one lock is requested
+	 */
+	pm_runtime_put(&pdev->dev);
+
 	/* one of the four lsb's must be set, and nothing else */
 	if (hweight_long(i & 0xf) != 1 || i > 8) {
 		ret = -EINVAL;
@@ -129,12 +142,6 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
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
@@ -143,9 +150,9 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
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
1.8.3.3

