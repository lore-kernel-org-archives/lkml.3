Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaJWIRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:17:13 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3977 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaJWIRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:17:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 23 Oct 2014 01:13:09 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/panel: simple: Update calls to gpiod_get*()
Date: Thu, 23 Oct 2014 17:16:58 +0900
Message-ID: <1414052218-20157-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
References: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new flags argument to calls of (devm_)gpiod_get*() and
remove any direction setting code afterwards.

Currently both forms (with or without the flags argument)
are valid thanks to transitional macros in
<linux/gpio/consumer.h>. These macros will be removed once
all consumers are updated and the flags argument will become
compulsary.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 23de22f8c820..83d93062930d 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -247,21 +247,14 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
 	if (IS_ERR(panel->supply))
 		return PTR_ERR(panel->supply);
 
-	panel->enable_gpio = devm_gpiod_get_optional(dev, "enable");
+	panel->enable_gpio = devm_gpiod_get_optional(dev, "enable",
+						     GPIOD_OUT_LOW);
 	if (IS_ERR(panel->enable_gpio)) {
 		err = PTR_ERR(panel->enable_gpio);
 		dev_err(dev, "failed to request GPIO: %d\n", err);
 		return err;
 	}
 
-	if (panel->enable_gpio) {
-		err = gpiod_direction_output(panel->enable_gpio, 0);
-		if (err < 0) {
-			dev_err(dev, "failed to setup GPIO: %d\n", err);
-			return err;
-		}
-	}
-
 	backlight = of_parse_phandle(dev->of_node, "backlight", 0);
 	if (backlight) {
 		panel->backlight = of_find_backlight_by_node(backlight);
-- 
2.1.2

