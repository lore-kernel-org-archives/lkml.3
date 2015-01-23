Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbbAWAhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:37:36 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:57607 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbbAWAhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:37:33 -0500
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-gpio@vger.kernel.org, gnurou@gmail.com, linus.walleij@linaro.org,
        Wei.Chen@csr.com, Baohua.Song@csr.com,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] gpio: sx150x: Fix compile issue when CONFIG_OF_GPIO is not defined
Date: Thu, 22 Jan 2015 22:37:09 -0200
Message-Id: <1421973429-9663-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the compilation of gpio-sx150x.c fails because
struct gpio_chip members 'of_node' and 'of_gpio_n_cells' do not exist
when CONFIG_OF_GPIO is not defined:

drivers/gpio/gpio-sx150x.c: In function ‘sx150x_init_chip’:
drivers/gpio/gpio-sx150x.c:487:17: error: ‘struct gpio_chip’ has no member named ‘of_node’
  chip->gpio_chip.of_node          = client->dev.of_node;
                 ^
drivers/gpio/gpio-sx150x.c:488:17: error: ‘struct gpio_chip’ has no member named ‘of_gpio_n_cells’
  chip->gpio_chip.of_gpio_n_cells  = 2;
                 ^

This issue was introduced by the commit
04d2264c3bf07f5c3d18165ba78de0a93360c6c0 "gpio: sx150x: add dts support for sx150x driver".

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/gpio/gpio-sx150x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-sx150x.c b/drivers/gpio/gpio-sx150x.c
index 88012e2..b1e2f1c 100644
--- a/drivers/gpio/gpio-sx150x.c
+++ b/drivers/gpio/gpio-sx150x.c
@@ -484,8 +484,10 @@ static void sx150x_init_chip(struct sx150x_chip *chip,
 	chip->gpio_chip.base             = pdata->gpio_base;
 	chip->gpio_chip.can_sleep        = true;
 	chip->gpio_chip.ngpio            = chip->dev_cfg->ngpios;
+#ifdef CONFIG_OF_GPIO
 	chip->gpio_chip.of_node          = client->dev.of_node;
 	chip->gpio_chip.of_gpio_n_cells  = 2;
+#endif
 	if (pdata->oscio_is_gpo)
 		++chip->gpio_chip.ngpio;
 
-- 
2.1.0

