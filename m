Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaIXH5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:57:02 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:42825 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaIXHzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:55:33 -0400
X-ASG-Debug-ID: 1411545331-0759e7612989fa50002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 2/2] tty: omap-serial: pull out calculation from baud_is_mode16
Date: Wed, 24 Sep 2014 09:55:22 +0200
X-ASG-Orig-Subj: [PATCH 2/2] tty: omap-serial: pull out calculation from baud_is_mode16
Message-ID: <1411545322-22940-3-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411545322-22940-1-git-send-email-frans.klaver@xsens.com>
References: <1411545322-22940-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411545331
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9817
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To determine the correct divisor, we need to know the difference between
the desired baud rate and the actual baud rate. The calculation for this
difference is implemented twice within omap_serial_baud_is_mode16().
Pull out the calculation for easier maintenance.

While at it, remove the CamelCasing from the variable names.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/tty/serial/omap-serial.c | 42 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index e454b7c..18c30ca 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -239,6 +239,26 @@ static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
 }
 
 /*
+ * Calculate the absolute difference between the desired and actual baud
+ * rate for the given mode.
+ */
+static inline int calculate_baud_abs_diff(struct uart_port *port,
+				unsigned int baud, unsigned int mode)
+{
+	unsigned int n = port->uartclk / (mode * baud);
+	int abs_diff;
+
+	if (n == 0)
+		n = 1;
+
+	abs_diff = baud - (port->uartclk / (mode * n));
+	if (abs_diff < 0)
+		abs_diff = -abs_diff;
+
+	return abs_diff;
+}
+
+/*
  * serial_omap_baud_is_mode16 - check if baud rate is MODE16X
  * @port: uart port info
  * @baud: baudrate for which mode needs to be determined
@@ -252,24 +272,10 @@ static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
 static bool
 serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 {
-	unsigned int n13 = port->uartclk / (13 * baud);
-	unsigned int n16 = port->uartclk / (16 * baud);
-	int baudAbsDiff13;
-	int baudAbsDiff16;
-
-	if (n13 == 0)
-		n13 = 1;
-	if (n16 == 0)
-		n16 = 1;
-
-	baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
-	baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
-	if (baudAbsDiff13 < 0)
-		baudAbsDiff13 = -baudAbsDiff13;
-	if (baudAbsDiff16 < 0)
-		baudAbsDiff16 = -baudAbsDiff16;
-
-	return (baudAbsDiff13 >= baudAbsDiff16);
+	int abs_diff_13 = calculate_baud_abs_diff(port, baud, 13);
+	int abs_diff_16 = calculate_baud_abs_diff(port, baud, 16);
+
+	return (abs_diff_13 >= abs_diff_16);
 }
 
 /*
-- 
2.1.0

