Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3AVNkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:40:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33719 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab3AVNk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:40:28 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Richard Purdie <rpurdie@rpsys.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 3/4] pwm_backlight: Refactor the DT parsing code
Date: Tue, 22 Jan 2013 14:39:55 +0100
Message-ID: <1358861996-27194-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to support the whole range of the PWM device in a similar way
it is possible when we boot in legacy mode (non DT mode).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/video/backlight/pwm_bl.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 2a81c24..df2d115 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -100,7 +100,7 @@ static int pwm_backlight_parse_dt(struct device *dev,
 {
 	struct device_node *node = dev->of_node;
 	struct property *prop;
-	int length;
+	int num_levels = 0;
 	u32 value;
 	int ret;
 
@@ -110,26 +110,27 @@ static int pwm_backlight_parse_dt(struct device *dev,
 	memset(data, 0, sizeof(*data));
 
 	/* determine the number of brightness levels */
-	prop = of_find_property(node, "brightness-levels", &length);
+	prop = of_find_property(node, "brightness-levels", &num_levels);
 	if (!prop)
 		return -EINVAL;
 
-	data->max_brightness = length / sizeof(u32);
+	num_levels /= sizeof(u32);
 
 	/* read brightness levels from DT property */
-	if (data->max_brightness > 0) {
-		size_t size = sizeof(*data->levels) * data->max_brightness;
+	if (num_levels > 0) {
+		size_t size = sizeof(*data->levels) * num_levels;
 
 		data->levels = devm_kzalloc(dev, size, GFP_KERNEL);
 		if (!data->levels)
 			return -ENOMEM;
 
 		ret = of_property_read_u32_array(node, "brightness-levels",
-						 data->levels,
-						 data->max_brightness);
+						 data->levels, num_levels);
 		if (ret < 0)
 			return ret;
 
+		data->max_brightness = num_levels;
+
 		ret = of_property_read_u32(node, "default-brightness-level",
 					   &value);
 		if (ret < 0)
-- 
1.8.1.1

