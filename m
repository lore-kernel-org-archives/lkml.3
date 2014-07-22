Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaGVK5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46593 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbaGVK5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/28] phy: qcom-apq8064: fix possible timeout without check
Date: Tue, 22 Jul 2014 16:26:46 +0530
Message-ID: <1406026611-30493-24-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch fixes a possible timeout in poll loop without actually
checking the register before return. In theory the there is a possibility
of loop being scheduled after a long lock/delay, which would then force
the loop to exit without actually checking the register.

Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-qcom-apq8064-sata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-qcom-apq8064-sata.c b/drivers/phy/phy-qcom-apq8064-sata.c
index d7c01aa..b3ef7d8 100644
--- a/drivers/phy/phy-qcom-apq8064-sata.c
+++ b/drivers/phy/phy-qcom-apq8064-sata.c
@@ -91,7 +91,7 @@ static int read_poll_timeout(void __iomem *addr, u32 mask)
 		 usleep_range(DELAY_INTERVAL_US, DELAY_INTERVAL_US + 50);
 	} while (!time_after(jiffies, timeout));
 
-	return -ETIMEDOUT;
+	return (readl_relaxed(addr) & mask) ? 0 : -ETIMEDOUT;
 }
 
 static int qcom_apq8064_sata_phy_init(struct phy *generic_phy)
-- 
1.7.9.5

