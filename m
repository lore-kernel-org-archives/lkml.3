Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaIWT76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:59:58 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:47064 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbaIWT7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:59:54 -0400
X-ASG-Debug-ID: 1411502392-0759e761297407d0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 1/2] tty: omap-serial: pull out calculation from baud_is_mode16
Date: Tue, 23 Sep 2014 21:54:39 +0200
X-ASG-Orig-Subj: [PATCH 1/2] tty: omap-serial: pull out calculation from baud_is_mode16
Message-ID: <1411502080-19769-2-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411502080-19769-1-git-send-email-frans.klaver@xsens.com>
References: <1411502080-19769-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411502392
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9797
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

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/tty/serial/omap-serial.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d017cec..ae935ce 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -239,6 +239,22 @@ static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
 }
 
 /*
+ * Calculate the absolute difference between the desired and actual baud
+ * rate for the given mode.
+ */
+static inline int calculate_baud_abs_diff(struct uart_port *port,
+				unsigned int baud, unsigned int mode)
+{
+	unsigned int n = port->uartclk / (mode * baud);
+	int abs_diff = baud - (port->uartclk / (mode * n));
+
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
@@ -252,14 +268,8 @@ static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
 static bool
 serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 {
-	unsigned int n13 = port->uartclk / (13 * baud);
-	unsigned int n16 = port->uartclk / (16 * baud);
-	int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
-	int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
-	if (baudAbsDiff13 < 0)
-		baudAbsDiff13 = -baudAbsDiff13;
-	if (baudAbsDiff16 < 0)
-		baudAbsDiff16 = -baudAbsDiff16;
+	int baudAbsDiff13 = calculate_baud_abs_diff(port, baud, 13);
+	int baudAbsDiff16 = calculate_baud_abs_diff(port, baud, 16);
 
 	return (baudAbsDiff13 >= baudAbsDiff16);
 }
-- 
2.1.0

