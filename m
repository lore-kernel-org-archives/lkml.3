Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaGDHEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:04:38 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39593 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaGDHEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:04:36 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: linux-gpio@vger.kernel.org
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: =?UTF-8?q?=5BPATCH=20v2=5D=20drivers/gpio/gpio-sch311x=3A=20check=20return=20value=20of=20gpiochip=5Fremove=28=29?=
Date: Fri,  4 Jul 2014 12:32:59 +0530
Message-Id: <1404457379-4193-1-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates the following warning

drivers/gpio/gpio-sch311x.c: In function ‘sch311x_gpio_probe’:
drivers/gpio/gpio-sch311x.c:286:18: warning: ignoring return value of ‘gpiochip_remove’, declared with attribute warn_unused_result

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/gpio/gpio-sch311x.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-sch311x.c b/drivers/gpio/gpio-sch311x.c
index f942b80..74282b9 100644
--- a/drivers/gpio/gpio-sch311x.c
+++ b/drivers/gpio/gpio-sch311x.c
@@ -232,7 +232,7 @@ static int sch311x_gpio_probe(struct platform_device *pdev)
 	struct sch311x_pdev_data *pdata = pdev->dev.platform_data;
 	struct sch311x_gpio_priv *priv;
 	struct sch311x_gpio_block *block;
-	int err, i;
+	int err, i, ret = 0;
 
 	/* we can register all GPIO data registers at once */
 	if (!request_region(pdata->runtime_reg + GP1, 6, DRV_NAME)) {
@@ -282,8 +282,13 @@ static int sch311x_gpio_probe(struct platform_device *pdev)
 exit_err:
 	release_region(pdata->runtime_reg + GP1, 6);
 	/* release already registered chips */
-	for (--i; i >= 0; i--)
-		gpiochip_remove(&priv->blocks[i].chip);
+	for (--i; i >= 0; i--) {
+		ret = gpiochip_remove(&priv->blocks[i].chip);
+
+		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
+		     __func__, ret);
+	}
+
 	return err;
 }
 
-- 
1.7.9.5

