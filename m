Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913AbaD3NHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:07:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933638AbaD3NHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:07:09 -0400
From: Jan Moskyto Matejka <mq@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH] [linux-next] serial: sc16is7xx: fix defined-but-not-used warnings
Date: Wed, 30 Apr 2014 15:07:04 +0200
Message-Id: <1398863224-19900-1-git-send-email-mq@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/sc16is7xx.c:1060:12: warning: 'sc16is7xx_probe' defined but not used [-Wunused-function]
 static int sc16is7xx_probe(struct device *dev,
            ^
drivers/tty/serial/sc16is7xx.c:1176:12: warning: 'sc16is7xx_remove' defined but not used [-Wunused-function]
 static int sc16is7xx_remove(struct device *dev)
            ^
drivers/tty/serial/sc16is7xx.c:1215:29: warning: 'regcfg' defined but not used [-Wunused-variable]
 static struct regmap_config regcfg = {
                             ^

Fixed these warnings by #ifdef-ing them to CONFIG_REGMAP_I2C and
recursively #ifdef-ing also some other functions that got defined but not used.

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 drivers/tty/serial/sc16is7xx.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 7206a64..bd76277 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -389,6 +389,7 @@ static const struct sc16is7xx_devtype sc16is762_devtype = {
 	.nr_uart	= 2,
 };
 
+#ifdef CONFIG_REGMAP_I2C
 static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg >> SC16IS7XX_REG_SHIFT) {
@@ -418,6 +419,7 @@ static bool sc16is7xx_regmap_precious(struct device *dev, unsigned int reg)
 
 	return false;
 }
+#endif
 
 static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 {
@@ -466,6 +468,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	return DIV_ROUND_CLOSEST(clk / 16, div);
 }
 
+#ifdef CONFIG_REGMAP_I2C
 static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 				unsigned int iir)
 {
@@ -588,7 +591,9 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 }
+#endif
 
+#ifdef CONFIG_REGMAP_I2C
 static void sc16is7xx_port_irq(struct sc16is7xx_port *s, int portno)
 {
 	struct uart_port *port = &s->p[portno].port;
@@ -651,6 +656,7 @@ static void sc16is7xx_wq_proc(struct work_struct *ws)
 	sc16is7xx_handle_tx(&one->port);
 	mutex_unlock(&s->mutex);
 }
+#endif
 
 static void sc16is7xx_stop_tx(struct uart_port* port)
 {
@@ -716,6 +722,7 @@ static unsigned int sc16is7xx_get_mctrl(struct uart_port *port)
 	return TIOCM_DSR | TIOCM_CAR;
 }
 
+#ifdef CONFIG_REGMAP_I2C
 static void sc16is7xx_md_proc(struct work_struct *ws)
 {
 	struct sc16is7xx_one *one = to_sc16is7xx_one(ws, md_work);
@@ -725,6 +732,7 @@ static void sc16is7xx_md_proc(struct work_struct *ws)
 			      (one->port.mctrl & TIOCM_LOOP) ?
 				      SC16IS7XX_MCR_LOOP_BIT : 0);
 }
+#endif
 
 static void sc16is7xx_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
@@ -1006,6 +1014,7 @@ static const struct uart_ops sc16is7xx_ops = {
 	.pm		= sc16is7xx_pm,
 };
 
+#ifdef CONFIG_REGMAP_I2C
 #ifdef CONFIG_GPIOLIB
 static int sc16is7xx_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
@@ -1200,6 +1209,7 @@ static int sc16is7xx_remove(struct device *dev)
 
 	return ret;
 }
+#endif
 
 static const struct of_device_id __maybe_unused sc16is7xx_dt_ids[] = {
 	{ .compatible = "nxp,sc16is740",	.data = &sc16is74x_devtype, },
@@ -1212,6 +1222,7 @@ static const struct of_device_id __maybe_unused sc16is7xx_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, sc16is7xx_dt_ids);
 
+#ifdef CONFIG_REGMAP_I2C
 static struct regmap_config regcfg = {
 	.reg_bits = 7,
 	.pad_bits = 1,
@@ -1221,7 +1232,6 @@ static struct regmap_config regcfg = {
 	.precious_reg = sc16is7xx_regmap_precious,
 };
 
-#ifdef CONFIG_REGMAP_I2C
 static int sc16is7xx_i2c_probe(struct i2c_client *i2c,
 			       const struct i2c_device_id *id)
 {
-- 
1.8.4.5

