Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaEUCOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:14:55 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:43273
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751011AbaEUCOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:14:54 -0400
From: Huang Shijie <b32955@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 1/2 bugfix] serial: imx: reset the uart port all the time
Date: Wed, 21 May 2014 08:56:28 +0800
Message-ID: <1400633789-31979-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.8
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(20776003)(4396001)(93916002)(50986999)(19580395003)(92726001)(85852003)(87286001)(83322001)(50226001)(33646001)(92566001)(79102001)(50466002)(77096999)(48376002)(44976005)(6806004)(87936001)(36756003)(64706001)(89996001)(88136002)(83072002)(31966008)(77982001)(99396002)(47776003)(19580405001)(74502001)(81542001)(77156001)(62966002)(102836001)(76482001)(80022001)(74662001)(46102001)(21056001)(81342001)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB422;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=fail (sender IP is 192.88.158.246)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code resets the uart port only when it supports the irda mode.
In actually, we also need to reset the uart port in the non-irda mode.
A hang was caught in the following case:

    UART A transmits data to the other end. But the transmission maybe
    terminated. In some corner case, the TX FIFO maybe not empty.

The kernel will hang at the imx_set_termios():
	............................................................
	while (!(readl(sport->port.membase + USR2) & USR2_TXDC))
		barrier();
	............................................................

This patch resets the uart port all the time in the imx_startup().
And fix the hang.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/tty/serial/imx.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 3b6c1a2..64901d0 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1070,7 +1070,7 @@ static void imx_disable_dma(struct imx_port *sport)
 static int imx_startup(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
-	int retval;
+	int retval, i;
 	unsigned long flags, temp;
 
 	retval = clk_prepare_enable(sport->clk_per);
@@ -1098,17 +1098,15 @@ static int imx_startup(struct uart_port *port)
 
 	writel(temp & ~UCR4_DREN, sport->port.membase + UCR4);
 
-	if (USE_IRDA(sport)) {
-		/* reset fifo's and state machines */
-		int i = 100;
-		temp = readl(sport->port.membase + UCR2);
-		temp &= ~UCR2_SRST;
-		writel(temp, sport->port.membase + UCR2);
-		while (!(readl(sport->port.membase + UCR2) & UCR2_SRST) &&
-		    (--i > 0)) {
-			udelay(1);
-		}
-	}
+	/* Reset fifo's and state machines */
+	i = 100;
+
+	temp = readl(sport->port.membase + UCR2);
+	temp &= ~UCR2_SRST;
+	writel(temp, sport->port.membase + UCR2);
+
+	while (!(readl(sport->port.membase + UCR2) & UCR2_SRST) && (--i > 0))
+		udelay(1);
 
 	/*
 	 * Allocate the IRQ(s) i.MX1 has three interrupts whereas later
-- 
1.7.8

