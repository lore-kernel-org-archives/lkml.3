Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044Ab3DCSFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:05:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53543 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763018Ab3DCSFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:05:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] mfd: wm5102: Don't wait for boot when boot sequencer is disabled
Date: Wed,  3 Apr 2013 19:05:21 +0100
Message-Id: <1365012321-7673-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365012321-7673-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130403180423.GA6985@opensource.wolfsonmicro.com>
 <1365012321-7673-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

As we are using a custom boot sequence we don't need to wait for the
standard boot sequence in device init when the normal write sequence is
disabled.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 69e9796..2b6a994 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -590,10 +590,24 @@ int arizona_dev_init(struct arizona *arizona)
 		}
 	}
 
-	ret = arizona_wait_for_boot(arizona);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Device failed initial boot: %d\n", ret);
-		goto err_reset;
+	switch (arizona->type) {
+	case WM5102:
+		ret = regmap_read(arizona->regmap, 0x19, &val);
+		if (ret != 0)
+			dev_err(dev,
+				"Failed to check write sequencer state: %d\n",
+				ret);
+		else if (val & 0x01)
+			break;
+		/* Fall through */
+	default:
+		ret = arizona_wait_for_boot(arizona);
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Device failed initial boot: %d\n", ret);
+			goto err_reset;
+		}
+		break;
 	}
 
 	if (apply_patch) {
-- 
1.7.10.4

