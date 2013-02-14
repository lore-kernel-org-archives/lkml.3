Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038Ab3BNW1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:27:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab3BNW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Qing Xu <qingx@marvell.com>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/9] mfd: max8925: fix trivial build warning for non-dt
Date: Thu, 14 Feb 2013 23:26:53 +0100
Message-Id: <1360880818-4071454-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Xsz5trwr1E0CJo3Y83RZDqL6b+1JyoBaxnC+5TlK2Jn
 t7/Xp9Px3C8ZIPsWPjqF0+FeDvF1NLMNCEXg5dWC83dqPLz0xI
 1vfwyuv8HOtFzChbPBIJcny2xMqjY5awdQ6EbNcUG9j1tHrZi6
 mcF0nJjeHinQMqKXc2ug3/8abAazleo/1Cu9rARSBDAbWts3Kn
 JyXRagR0WYy9e8uMWhrZQW7DC0HUX9hiEM/ld4wx0r/QVorD7G
 XRzrb+STU0b4xuTTVJ/WBV1nJNQLWap9bI0Fn30UxqrewkomWN
 RWg1yxLBJv85EyDPNU0W0Dbyjw+emvtsmX6WX1N15RWq993WAT
 TFCnpyNdzNXfJ5iENVe25wJBhUVo+1gbsrSadBD3w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch fe527ea5a "mfd: max8925: Support dt for backlight"
added a new function for DT probing but introduced a
build warning for the case where CONFIG_OF is disabled:

drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]

A much nicer fix is to use the IS_ENABLED keyword to
have the same effect of dropping the device tree specific
function when it's not needed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Qing Xu <qingx@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/video/backlight/max8925_bl.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 5ca11b0..9958fb1 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -101,14 +101,13 @@ static const struct backlight_ops max8925_backlight_ops = {
 	.get_brightness	= max8925_backlight_get_brightness,
 };
 
-#ifdef CONFIG_OF
 static int max8925_backlight_dt_init(struct platform_device *pdev,
 			      struct max8925_backlight_pdata *pdata)
 {
 	struct device_node *nproot = pdev->dev.parent->of_node, *np;
 	int dual_string;
 
-	if (!nproot)
+	if (!nproot || !IS_ENABLED(CONFIG_OF))
 		return -ENODEV;
 	np = of_find_node_by_name(nproot, "backlight");
 	if (!np) {
@@ -120,9 +119,6 @@ static int max8925_backlight_dt_init(struct platform_device *pdev,
 	pdata->dual_string = dual_string;
 	return 0;
 }
-#else
-#define max8925_backlight_dt_init(x, y)	(-1)
-#endif
 
 static int max8925_backlight_probe(struct platform_device *pdev)
 {
-- 
1.8.1.2

