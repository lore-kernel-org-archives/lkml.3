Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3AVNlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:41:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42821 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3AVNkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:40:23 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Richard Purdie <rpurdie@rpsys.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 2/4] pwm_backlight: Validate dft_brightness in main probe function
Date: Tue, 22 Jan 2013 14:39:54 +0100
Message-ID: <1358861996-27194-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the dft_brightness validity check from the DT parsing function to the
main probe. In this way we can validate it in case we are booting with or
without DT.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/video/backlight/pwm_bl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index f0d6854..2a81c24 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -135,12 +135,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		if (ret < 0)
 			return ret;
 
-		if (value >= data->max_brightness) {
-			dev_warn(dev, "invalid default brightness level: %u, using %u\n",
-				 value, data->max_brightness - 1);
-			value = data->max_brightness - 1;
-		}
-
 		data->dft_brightness = value;
 	}
 
@@ -249,6 +243,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
+	if (data->dft_brightness > data->max_brightness) {
+		dev_warn(&pdev->dev,
+			 "invalid default brightness level: %u, using %u\n",
+			 data->dft_brightness, data->max_brightness);
+		data->dft_brightness = data->max_brightness;
+	}
 	bl->props.brightness = data->dft_brightness;
 	backlight_update_status(bl);
 
-- 
1.8.1.1

