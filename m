Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaFWJER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:04:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55468 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/111] hwmon: (ntc_thermistor) Fix OF device ID mapping
Date: Mon, 23 Jun 2014 10:30:58 +0200
Message-Id: <1b2b80af293d868bdb762fa896d5b851248ba566.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ead82d6792ef5c600d535bca6ec50a4da14ff7c7 upstream.

The mapping from OF device IDs to platform device IDs is wrong.
TYPE_NCPXXWB473 is 0, TYPE_NCPXXWL333 is 1, so
ntc_thermistor_id[TYPE_NCPXXWB473] is { "ncp15wb473", TYPE_NCPXXWB473 }
while
ntc_thermistor_id[TYPE_NCPXXWL333] is { "ncp18wb473", TYPE_NCPXXWB473 }.

So the name is wrong for all but the "ntc,ncp15wb473" entry, and the
type is wrong for the "ntc,ncp15wl333" entry.

So map the entries by index, it is neither elegant nor robust but at
least it is correct.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 9e8269de hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/ntc_thermistor.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index 6b4413ce4d39..e76feb86a1d4 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -44,6 +44,7 @@ struct ntc_compensation {
 	unsigned int	ohm;
 };
 
+/* Order matters, ntc_match references the entries by index */
 static const struct platform_device_id ntc_thermistor_id[] = {
 	{ "ncp15wb473", TYPE_NCPXXWB473 },
 	{ "ncp18wb473", TYPE_NCPXXWB473 },
@@ -163,15 +164,15 @@ static int ntc_adc_iio_read(struct ntc_thermistor_platform_data *pdata)
 
 static const struct of_device_id ntc_match[] = {
 	{ .compatible = "ntc,ncp15wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[0] },
 	{ .compatible = "ntc,ncp18wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[1] },
 	{ .compatible = "ntc,ncp21wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[2] },
 	{ .compatible = "ntc,ncp03wb473",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+		.data = &ntc_thermistor_id[3] },
 	{ .compatible = "ntc,ncp15wl333",
-		.data = &ntc_thermistor_id[TYPE_NCPXXWL333] },
+		.data = &ntc_thermistor_id[4] },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, ntc_match);
-- 
2.0.0

