Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaETVFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:05:55 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:50680 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750754AbaETVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:05:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:4321:5007:6119:6120:7652:7901:7903:9592:10004:10400:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13018:13019:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: body40_8a7d63be1cb38
X-Filterd-Recvd-Size: 4466
Message-ID: <1400619950.26709.39.camel@joe-AO725>
Subject: [PATCH] serial: samsung: Neaten dbg uses
From: Joe Perches <joe@perches.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 May 2014 14:05:50 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add format and argument checking and fix misuses in the dbg macro.

Add __printf
Use %pR for resource
Add #include guard to samsung.h
Move static functions from .h to .c
Use vscnprintf instead of length unguarded vsprintf

Signed-off-by: Joe Perches <joe@perches.com>
---

compiled (no warnings)/untested.

 drivers/tty/serial/samsung.c | 35 +++++++++++++++++++++++++++++------
 drivers/tty/serial/samsung.h | 23 +++--------------------
 2 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 1f5505e..3293377 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -53,6 +53,29 @@
 
 #include "samsung.h"
 
+#if	defined(CONFIG_SERIAL_SAMSUNG_DEBUG) &&	\
+	defined(CONFIG_DEBUG_LL) &&		\
+	!defined(MODULE)
+
+extern void printascii(const char *);
+
+__printf(1, 2)
+static void dbg(const char *fmt, ...)
+{
+	va_list va;
+	char buff[256];
+
+	va_start(va, fmt);
+	vscnprintf(buff, sizeof(buf), fmt, va);
+	va_end(va);
+
+	printascii(buff);
+}
+
+#else
+#define dbg(fmt, ...) do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)
+#endif
+
 /* UART name and device definitions */
 
 #define S3C24XX_SERIAL_NAME	"ttySAC"
@@ -468,8 +491,8 @@ static int s3c24xx_serial_startup(struct uart_port *port)
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 	int ret;
 
-	dbg("s3c24xx_serial_startup: port=%p (%08lx,%p)\n",
-	    port->mapbase, port->membase);
+	dbg("s3c24xx_serial_startup: port=%p (%08llx,%p)\n",
+	    port, (unsigned long long)port->mapbase, port->membase);
 
 	rx_enabled(port) = 1;
 
@@ -514,8 +537,8 @@ static int s3c64xx_serial_startup(struct uart_port *port)
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 	int ret;
 
-	dbg("s3c64xx_serial_startup: port=%p (%08lx,%p)\n",
-	    port->mapbase, port->membase);
+	dbg("s3c64xx_serial_startup: port=%p (%08llx,%p)\n",
+	    port, (unsigned long long)port->mapbase, port->membase);
 
 	wr_regl(port, S3C64XX_UINTM, 0xf);
 
@@ -1160,7 +1183,7 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 		return -EINVAL;
 	}
 
-	dbg("resource %p (%lx..%lx)\n", res, res->start, res->end);
+	dbg("resource %pR)\n", res);
 
 	port->membase = devm_ioremap(port->dev, res->start, resource_size(res));
 	if (!port->membase) {
@@ -1203,7 +1226,7 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 		wr_regl(port, S3C64XX_UINTSP, 0xf);
 	}
 
-	dbg("port: map=%08x, mem=%08x, irq=%d (%d,%d), clock=%ld\n",
+	dbg("port: map=%08x, mem=%p, irq=%d (%d,%d), clock=%u\n",
 	    port->mapbase, port->membase, port->irq,
 	    ourport->rx_irq, ourport->tx_irq, port->uartclk);
 
diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index 8827e54..eb071dd 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -1,3 +1,6 @@
+#ifndef __SAMSUNG_H
+#define __SAMSUNG_H
+
 /*
  * Driver for Samsung SoC onboard UARTs.
  *
@@ -77,24 +80,4 @@ struct s3c24xx_uart_port {
 #define wr_regb(port, reg, val) __raw_writeb(val, portaddr(port, reg))
 #define wr_regl(port, reg, val) __raw_writel(val, portaddr(port, reg))
 
-#if defined(CONFIG_SERIAL_SAMSUNG_DEBUG) && \
-    defined(CONFIG_DEBUG_LL) && \
-    !defined(MODULE)
-
-extern void printascii(const char *);
-
-static void dbg(const char *fmt, ...)
-{
-	va_list va;
-	char buff[256];
-
-	va_start(va, fmt);
-	vsprintf(buff, fmt, va);
-	va_end(va);
-
-	printascii(buff);
-}
-
-#else
-#define dbg(x...) do { } while (0)
 #endif




