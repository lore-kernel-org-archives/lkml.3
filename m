Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaFEEpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:45:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaFEEVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Behme <dirk.behme@de.bosch.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Xinyu Chen <xinyu.chen@freescale.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 129/214] tty: serial: imx: dont reinit clock in imx_setup_ufcr()
Date: Wed,  4 Jun 2014 21:18:12 -0700
Message-Id: <20140605041657.046525230@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Behme <dirk.behme@de.bosch.com>

commit 7be0670f7b9198382938a03ff3db7f47ef6b4780 upstream.

Remove the clock configuration from imx_setup_ufcr(). This
isn't needed here and will cause garbage output if done.

To be be sure that we only touch the bits we want (TXTL and RXTL)
we have to mask out all other bits of the UFCR register. Add
one non-existing bit macro for this, too (bit 6, DCEDTE on i.MX6).

Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>
CC: Troy Kisky <troy.kisky@boundarydevices.com>
CC: Xinyu Chen <xinyu.chen@freescale.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: deleted code in imx_setup_ufcr() refers to
 sport->clk not sport->clk_per]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -131,6 +131,7 @@
 #define  UCR4_OREN  	 (1<<1)  /* Receiver overrun interrupt enable */
 #define  UCR4_DREN  	 (1<<0)  /* Recv data ready interrupt enable */
 #define  UFCR_RXTL_SHF   0       /* Receiver trigger level shift */
+#define  UFCR_DCEDTE	 (1<<6)  /* DCE/DTE mode select */
 #define  UFCR_RFDIV      (7<<7)  /* Reference freq divider mask */
 #define  UFCR_RFDIV_REG(x)	(((x) < 7 ? 6 - (x) : 6) << 7)
 #define  UFCR_TXTL_SHF   10      /* Transmitter trigger level shift */
@@ -666,22 +667,11 @@ static void imx_break_ctl(struct uart_po
 static int imx_setup_ufcr(struct imx_port *sport, unsigned int mode)
 {
 	unsigned int val;
-	unsigned int ufcr_rfdiv;
-
-	/* set receiver / transmitter trigger level.
-	 * RFDIV is set such way to satisfy requested uartclk value
-	 */
-	val = TXTL << 10 | RXTL;
-	ufcr_rfdiv = (clk_get_rate(sport->clk) + sport->port.uartclk / 2)
-			/ sport->port.uartclk;
-
-	if(!ufcr_rfdiv)
-		ufcr_rfdiv = 1;
-
-	val |= UFCR_RFDIV_REG(ufcr_rfdiv);
 
+	/* set receiver / transmitter trigger level */
+	val = readl(sport->port.membase + UFCR) & (UFCR_RFDIV | UFCR_DCEDTE);
+	val |= TXTL << UFCR_TXTL_SHF | RXTL;
 	writel(val, sport->port.membase + UFCR);
-
 	return 0;
 }
 


