Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3JGLnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:43:06 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:34751 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3JGLjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:39:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/12] pwm-backlight: Track enable state
Date: Mon,  7 Oct 2013 13:37:37 +0200
Message-Id: <1381145866-445-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381145866-445-1-git-send-email-treding@nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow up patches will add support for more complex means of powering
the backlight on and off such as using a regulator. To prevent calls to
the regulator API from becoming unbalanced, keep track of the enabled
state internally.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/video/backlight/pwm_bl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index ab9d5e6..4053efb 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -27,6 +27,7 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	bool			enabled;
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -40,6 +41,9 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
 {
 	int duty_cycle, err;
 
+	if (pb->enabled)
+		return;
+
 	if (pb->levels) {
 		duty_cycle = pb->levels[brightness];
 		max = pb->levels[max];
@@ -52,12 +56,18 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
 
 	pwm_config(pb->pwm, duty_cycle, pb->period);
 	pwm_enable(pb->pwm);
+	pb->enabled = true;
 }
 
 static void pwm_backlight_power_off(struct pwm_bl_data *pb)
 {
+	if (!pb->enabled)
+		return;
+
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
+
+	pb->enabled = false;
 }
 
 static int pwm_backlight_update_status(struct backlight_device *bl)
@@ -216,6 +226,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	pb->check_fb = data->check_fb;
 	pb->exit = data->exit;
 	pb->dev = &pdev->dev;
+	pb->enabled = false;
 
 	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
 	if (IS_ERR(pb->pwm)) {
-- 
1.8.4

