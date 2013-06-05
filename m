Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3FEOF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:05:29 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:36781 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755704Ab3FEOF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:05:28 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 2/3] tty: serial: modify PL011 driver to use pinctrl PM helpers
Date: Wed, 5 Jun 2013 15:44:32 +0200
Message-ID: <1370439873-30053-2-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This augments the PL011 UART driver to utilize the new pinctrl
core PM helpers to transition the driver to default and sleep
states, cutting away some boilerplate code.

Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
I'm seeking Greg's ACK on this as well so we can take the
whole refactoring through the pinctrl tree.
---
 drivers/tty/serial/amba-pl011.c | 42 +++--------------------------------------
 1 file changed, 3 insertions(+), 39 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index e2774f9..6ac3254 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -151,10 +151,6 @@ struct pl011_dmatx_data {
 struct uart_amba_port {
 	struct uart_port	port;
 	struct clk		*clk;
-	/* Two optional pin states - default & sleep */
-	struct pinctrl		*pinctrl;
-	struct pinctrl_state	*pins_default;
-	struct pinctrl_state	*pins_sleep;
 	const struct vendor_data *vendor;
 	unsigned int		dmacr;		/* dma control reg */
 	unsigned int		im;		/* interrupt mask */
@@ -1480,12 +1476,7 @@ static int pl011_hwinit(struct uart_port *port)
 	int retval;
 
 	/* Optionaly enable pins to be muxed in and configured */
-	if (!IS_ERR(uap->pins_default)) {
-		retval = pinctrl_select_state(uap->pinctrl, uap->pins_default);
-		if (retval)
-			dev_err(port->dev,
-				"could not set default pins\n");
-	}
+	pinctrl_pm_select_default_state(port->dev);
 
 	/*
 	 * Try to enable the clock producer.
@@ -1611,7 +1602,6 @@ static void pl011_shutdown(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 	unsigned int cr;
-	int retval;
 
 	/*
 	 * disable all interrupts
@@ -1654,13 +1644,7 @@ static void pl011_shutdown(struct uart_port *port)
 	 */
 	clk_disable_unprepare(uap->clk);
 	/* Optionally let pins go into sleep states */
-	if (!IS_ERR(uap->pins_sleep)) {
-		retval = pinctrl_select_state(uap->pinctrl, uap->pins_sleep);
-		if (retval)
-			dev_err(port->dev,
-				"could not set pins to sleep state\n");
-	}
-
+	pinctrl_pm_select_sleep_state(port->dev);
 
 	if (uap->port.dev->platform_data) {
 		struct amba_pl011_data *plat;
@@ -2013,12 +1997,7 @@ static int __init pl011_console_setup(struct console *co, char *options)
 		return -ENODEV;
 
 	/* Allow pins to be muxed in and configured */
-	if (!IS_ERR(uap->pins_default)) {
-		ret = pinctrl_select_state(uap->pinctrl, uap->pins_default);
-		if (ret)
-			dev_err(uap->port.dev,
-				"could not set default pins\n");
-	}
+	pinctrl_pm_select_default_state(uap->port.dev);
 
 	ret = clk_prepare(uap->clk);
 	if (ret)
@@ -2132,21 +2111,6 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 		goto out;
 	}
 
-	uap->pinctrl = devm_pinctrl_get(&dev->dev);
-	if (IS_ERR(uap->pinctrl)) {
-		ret = PTR_ERR(uap->pinctrl);
-		goto out;
-	}
-	uap->pins_default = pinctrl_lookup_state(uap->pinctrl,
-						 PINCTRL_STATE_DEFAULT);
-	if (IS_ERR(uap->pins_default))
-		dev_err(&dev->dev, "could not get default pinstate\n");
-
-	uap->pins_sleep = pinctrl_lookup_state(uap->pinctrl,
-					       PINCTRL_STATE_SLEEP);
-	if (IS_ERR(uap->pins_sleep))
-		dev_dbg(&dev->dev, "could not get sleep pinstate\n");
-
 	uap->clk = devm_clk_get(&dev->dev, NULL);
 	if (IS_ERR(uap->clk)) {
 		ret = PTR_ERR(uap->clk);
-- 
1.7.11.3

