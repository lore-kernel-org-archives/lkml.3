Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbaHHVf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:35:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaHHUrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Cherian <george.cherian@ti.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 189/259] can: c_can_platform: Fix raminit, use devm_ioremap() instead of devm_ioremap_resource()
Date: Fri,  8 Aug 2014 13:40:12 -0700
Message-Id: <1407530482-4483-190-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/c_can/c_can_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index d66ac26..873b83a 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -194,7 +194,8 @@ static int c_can_plat_probe(struct platform_device *pdev)
 			priv->instance = pdev->id;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		priv->raminit_ctrlreg = devm_ioremap_resource(&pdev->dev, res);
+		priv->raminit_ctrlreg = devm_ioremap(&pdev->dev, res->start,
+						     resource_size(res));
 		if (IS_ERR(priv->raminit_ctrlreg) || (int)priv->instance < 0)
 			dev_info(&pdev->dev, "control memory is not used for raminit\n");
 		else
-- 
1.9.1

