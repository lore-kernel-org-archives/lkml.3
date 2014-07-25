Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaGYOul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:50:41 -0400
Received: from gnurou.org ([207.192.72.5]:49385 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaGYOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:50:40 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/panel: simple: Use devm_gpiod_get_optional()
Date: Fri, 25 Jul 2014 23:47:25 +0900
Message-Id: <1406299645-29043-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new devm_gpiod_get_optional() to simplify the probe code.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a251361..91bf566 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -185,16 +185,14 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
 	if (IS_ERR(panel->supply))
 		return PTR_ERR(panel->supply);
 
-	panel->enable_gpio = devm_gpiod_get(dev, "enable");
+	panel->enable_gpio = devm_gpiod_get_optional(dev, "enable");
 	if (IS_ERR(panel->enable_gpio)) {
 		err = PTR_ERR(panel->enable_gpio);
-		if (err != -ENOENT) {
-			dev_err(dev, "failed to request GPIO: %d\n", err);
-			return err;
-		}
+		dev_err(dev, "failed to request GPIO: %d\n", err);
+		return err;
+	}
 
-		panel->enable_gpio = NULL;
-	} else {
+	if (panel->enable_gpio) {
 		err = gpiod_direction_output(panel->enable_gpio, 0);
 		if (err < 0) {
 			dev_err(dev, "failed to setup GPIO: %d\n", err);
-- 
2.0.2

