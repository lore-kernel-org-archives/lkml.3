Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3CJSMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:12:41 -0400
Received: from mail.tpi.com ([70.99.223.143]:2219 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab3CJSMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:12:40 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH linux-next] mfd: max8925: max8925_backlight_probe: Silence 'statement with no effect' warning
Date: Sun, 10 Mar 2013 12:12:25 -0600
Message-Id: <1362939145-88329-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 47ec340cb8e232671e7c4a4689ff32c3bdf329da 'mfd: max8925: Support dt for backlight'
caused a gcc warning if CONFIG_OF is not defined:

drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]

gcc version 4.6.3

Convert max8925_backlight_dt_init() to an 'inline void' since it is only
called from one place where the return code is ignored. Protect the
guts of the function with '#ifdef CONFIG_OF'.

Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/video/backlight/max8925_bl.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 5ca11b0..199f887 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -101,10 +101,10 @@ static const struct backlight_ops max8925_backlight_ops = {
 	.get_brightness	= max8925_backlight_get_brightness,
 };
 
-#ifdef CONFIG_OF
-static int max8925_backlight_dt_init(struct platform_device *pdev,
+static inline void max8925_backlight_dt_init(struct platform_device *pdev,
 			      struct max8925_backlight_pdata *pdata)
 {
+#ifdef CONFIG_OF
 	struct device_node *nproot = pdev->dev.parent->of_node, *np;
 	int dual_string;
 
@@ -118,11 +118,8 @@ static int max8925_backlight_dt_init(struct platform_device *pdev,
 
 	of_property_read_u32(np, "maxim,max8925-dual-string", &dual_string);
 	pdata->dual_string = dual_string;
-	return 0;
-}
-#else
-#define max8925_backlight_dt_init(x, y)	(-1)
 #endif
+}
 
 static int max8925_backlight_probe(struct platform_device *pdev)
 {
-- 
1.7.9.5

