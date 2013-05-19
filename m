Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3ESF6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 01:58:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38694 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3ESF6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 01:58:42 -0400
Message-ID: <1368943117.3455.4.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: Don't override the error code in probe error
 handling
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org
Date: Sun, 19 May 2013 13:58:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, we return 0 in probe error paths when gpiochip_remove() returns 0.
Also show error message if gpiochip_remove() fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/pinctrl/pinctrl-coh901.c     | 3 ++-
 drivers/pinctrl/pinctrl-sunxi.c      | 3 ++-
 drivers/pinctrl/vt8500/pinctrl-wmt.c | 3 +--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 20da215..ea98df9 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -830,7 +830,8 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 err_no_range:
-	err = gpiochip_remove(&gpio->chip);
+	if (gpiochip_remove(&gpio->chip))
+		dev_err(&pdev->dev, "failed to remove gpio chip\n");
 err_no_chip:
 err_no_domain:
 err_no_port:
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index c52fc2c..c058529 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -2000,7 +2000,8 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 
 gpiochip_error:
-	ret = gpiochip_remove(pctl->chip);
+	if (gpiochip_remove(pctl->chip))
+		dev_err(&pdev->dev, "failed to remove gpio chip\n");
 pinctrl_error:
 	pinctrl_unregister(pctl->pctl_dev);
 	return ret;
diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index e877082..fb30edf3 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -609,8 +609,7 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
 	return 0;
 
 fail_range:
-	err = gpiochip_remove(&data->gpio_chip);
-	if (err)
+	if (gpiochip_remove(&data->gpio_chip))
 		dev_err(&pdev->dev, "failed to remove gpio chip\n");
 fail_gpio:
 	pinctrl_unregister(data->pctl_dev);
-- 
1.8.1.2



