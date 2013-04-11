Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936846Ab3DKANp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:13:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937330Ab3DKAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 07/30] tty: serial/samsung: fix modular build
Date: Thu, 11 Apr 2013 02:04:49 +0200
Message-Id: <1365638712-1028578-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:kv0JpWfD0gdXp1beP2bUeb7YRh/IlPWCypUsyi5OMnx
 1Xta0lcWIhISiv5PjkoldOHfOqLGiFuw0239a2H3Kom7dLBAGm
 f58lB1zCf6gpCCyfJxqKl2+YdBWxxv0prY5fv0bWWeSRiPcJY6
 Fs0xYXCV5g2bJvKn4vFmykMpZeAuktMEx2wyHDmEakh7bw92Om
 3hNLpzkb0fTeNv0VHiqC4FOxcOQnFKYWW3YWmg5rmRkvD9lyqC
 a/zX3fSHJabIb6x0XTCNkJsg1O841L+DcAtoCrh7vT8xpr7KLh
 BN/QS6pZBep4P4uoQE0Hue0eNhbez04HjZ/v+Sk0VZKARO+gw4
 df/+qx9Bbr0JBje1JqCITEa4Z/ymCWbJZfkqnVCYijPQF+OMKE
 Sqetz42/alq0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few bugs in the samsung serial driver when built as a
loadable module, which makes the console code unavailable, as well as
giving no access to the 'printascii' early debug function. This adds
the appropriate compile time conditionals.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung.c | 4 ++--
 drivers/tty/serial/samsung.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 729a60d..a3277ca 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -894,7 +894,7 @@ console_initcall(s3c24xx_serial_console_init);
 #define S3C24XX_SERIAL_CONSOLE NULL
 #endif
 
-#ifdef CONFIG_CONSOLE_POLL
+#if defined(CONFIG_SERIAL_SAMSUNG_CONSOLE) && defined(CONFIG_CONSOLE_POLL)
 static int s3c24xx_serial_get_poll_char(struct uart_port *port);
 static void s3c24xx_serial_put_poll_char(struct uart_port *port,
 			 unsigned char c);
@@ -918,7 +918,7 @@ static struct uart_ops s3c24xx_serial_ops = {
 	.request_port	= s3c24xx_serial_request_port,
 	.config_port	= s3c24xx_serial_config_port,
 	.verify_port	= s3c24xx_serial_verify_port,
-#ifdef CONFIG_CONSOLE_POLL
+#if defined(CONFIG_SERIAL_SAMSUNG_CONSOLE) && defined(CONFIG_CONSOLE_POLL)
 	.poll_get_char = s3c24xx_serial_get_poll_char,
 	.poll_put_char = s3c24xx_serial_put_poll_char,
 #endif
diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index 1a4bca3..00a499e 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -76,7 +76,9 @@ struct s3c24xx_uart_port {
 #define wr_regb(port, reg, val) __raw_writeb(val, portaddr(port, reg))
 #define wr_regl(port, reg, val) __raw_writel(val, portaddr(port, reg))
 
-#ifdef CONFIG_SERIAL_SAMSUNG_DEBUG
+#if defined(CONFIG_SERIAL_SAMSUNG_DEBUG) && \
+    defined(CONFIG_DEBUG_LL) && \
+    !defined(MODULE)
 
 extern void printascii(const char *);
 
-- 
1.8.1.2

