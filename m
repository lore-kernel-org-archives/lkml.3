Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3IPIdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:33:32 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:57794 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab3IPId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:33:28 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 6/9] of/irq: Propagate errors in of_irq_to_resource_table()
Date: Mon, 16 Sep 2013 10:32:03 +0200
Message-Id: <1379320326-13241-7-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379320326-13241-1-git-send-email-treding@nvidia.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all helpers return precise error codes, this function can
propagate these errors to the caller properly.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/of/irq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 57396fd..c33a7fd 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -418,11 +418,17 @@ int of_irq_count(struct device_node *dev)
 int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
 		int nr_irqs)
 {
-	int i;
+	int i, ret;
+
+	for (i = 0; i < nr_irqs; i++, res++) {
+		ret = __of_irq_to_resource(dev, i, res);
+		if (ret <= 0) {
+			if (ret < 0)
+				return ret;
 
-	for (i = 0; i < nr_irqs; i++, res++)
-		if (!of_irq_to_resource(dev, i, res))
 			break;
+		}
+	}
 
 	return i;
 }
-- 
1.8.4

