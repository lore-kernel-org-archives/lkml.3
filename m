Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3DPGwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:52:16 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:38568 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120Ab3DPGwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:52:14 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 3/3] pwm: pxa: add device tree support
Date: Tue, 16 Apr 2013 02:51:55 -0400
Message-ID: <1366095115-21864-4-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366095115-21864-1-git-send-email-chao.xie@marvell.com>
References: <1366095115-21864-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the deice tree support for pwm-pxa.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/pwm/pwm-pxa.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index eafca4a..345aa83 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -18,6 +18,8 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/pwm.h>
 
 #include <asm/div64.h>
@@ -135,12 +137,34 @@ static struct pwm_ops pxa_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
+static struct of_device_id pxa_pwm_of_match[] = {
+	{
+		.compatible = "mrvl,pxa25x-pwm",
+		.data = (void *)0
+	}, {
+		.compatible = "mrvl,pxa27x-pwm",
+		.data = (void *)HAS_SECONDARY_PWM
+	}, {
+		.compatible = "mrvl,pxa168-pwm",
+		.data = (void *)0
+	}, {
+		.compatible = "mrvl,pxa910-pwm",
+		.data = (void *)0
+	},
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, pxa_pwm_of_match);
+
 static int pwm_probe(struct platform_device *pdev)
 {
 	const struct platform_device_id *id = platform_get_device_id(pdev);
+	const struct of_device_id *of_id =
+			of_match_device(pxa_pwm_of_match, &pdev->dev);
 	struct pxa_pwm_chip *pwm;
 	struct resource *r;
 	int ret = 0;
+	unsigned int npwm;
 
 	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
 	if (pwm == NULL) {
@@ -157,7 +181,12 @@ static int pwm_probe(struct platform_device *pdev)
 	pwm->chip.dev = &pdev->dev;
 	pwm->chip.ops = &pxa_pwm_ops;
 	pwm->chip.base = -1;
-	pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
+	if (of_id)
+		npwm = (unsigned int)(of_id->data);
+	else
+		npwm = id->driver_data;
+
+	pwm->chip.npwm = (npwm & HAS_SECONDARY_PWM) ? 2 : 1;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
-- 
1.7.4.1

