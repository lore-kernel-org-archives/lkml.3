Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaHRJvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:51:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaHRJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Cherian <george.cherian@ti.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 087/137] can: c_can_platform: Fix raminit, use devm_ioremap() instead of devm_ioremap_resource()
Date: Mon, 18 Aug 2014 10:32:28 +0100
Message-Id: <1408354398-10226-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Cherian <george.cherian@ti.com>

commit 33cf75656923ff11d67a937a4f8e9344f58cea77 upstream.

The raminit register is shared register for both can0 and can1. Since commit:

    32766ff net: can: Convert to use devm_ioremap_resource

devm_ioremap_resource() is used to map raminit register. When using both
interfaces the mapping for the can1 interface fails, leading to a non
functional can interface.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/c_can/c_can_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index c6f838d922a5..5d39bc152c5e 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -194,7 +194,8 @@ static int c_can_plat_probe(struct platform_device *pdev)
 			priv->instance = pdev->id;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		priv->raminit_ctrlreg = devm_ioremap_resource(&pdev->dev, res);
+		priv->raminit_ctrlreg = devm_ioremap(&pdev->dev, res->start,
+						     resource_size(res));
 		if (IS_ERR(priv->raminit_ctrlreg) || priv->instance < 0)
 			dev_info(&pdev->dev, "control memory is not used for raminit\n");
 		else
-- 
1.9.1

