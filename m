Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaBQJAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:00:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52621 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaBQI7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:36 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 5/8] phy-core: phy_get: Leave error logging to the caller
Date: Mon, 17 Feb 2014 14:29:22 +0530
Message-ID: <1392627565-1829-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

In various cases errors may be expected, ie probe-deferral or a call to
phy_get from a driver where the use of a phy is optional.

Rather then adding all sort of complicated checks for this, and/or adding
special functions like devm_phy_get_optional, simply don't log an error,
and let deciding if get_phy returning an error really should result in a
dev_err up to the caller.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 5f5b0f4..b355553 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -404,17 +404,11 @@ struct phy *phy_get(struct device *dev, const char *string)
 		index = of_property_match_string(dev->of_node, "phy-names",
 			string);
 		phy = of_phy_get(dev, index);
-		if (IS_ERR(phy)) {
-			dev_err(dev, "unable to find phy\n");
-			return phy;
-		}
 	} else {
 		phy = phy_lookup(dev, string);
-		if (IS_ERR(phy)) {
-			dev_err(dev, "unable to find phy\n");
-			return phy;
-		}
 	}
+	if (IS_ERR(phy))
+		return phy;
 
 	if (!try_module_get(phy->ops->owner))
 		return ERR_PTR(-EPROBE_DEFER);
-- 
1.7.10.4

