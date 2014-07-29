Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaG2PCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:02:46 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:33123 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbaG2PCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:02:41 -0400
X-ASG-Debug-ID: 1406646159-0759e7416beb1670002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: <linux-serial@vger.kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tty: omap-serial: prevent division by zero
Date: Tue, 29 Jul 2014 17:02:30 +0200
X-ASG-Orig-Subj: [PATCH 1/3] tty: omap-serial: prevent division by zero
Message-ID: <1406646152-24698-2-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406646152-24698-1-git-send-email-frans.klaver@xsens.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1406646152-24698-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1406646159
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.7924
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the chosen baud rate is large enough (e.g. 3.5 megabaud), the
calculated n13 and n16 values in serial_omap_baud_is_mode16 may become
0. This causes a division by zero when calculating the difference
between calculated and desired baud rates. To prevent this, cap n13 and
n16 on 1.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/tty/serial/omap-serial.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d017cec..e454b7c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -254,8 +254,16 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 {
 	unsigned int n13 = port->uartclk / (13 * baud);
 	unsigned int n16 = port->uartclk / (16 * baud);
-	int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
-	int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
+	int baudAbsDiff13;
+	int baudAbsDiff16;
+
+	if (n13 == 0)
+		n13 = 1;
+	if (n16 == 0)
+		n16 = 1;
+
+	baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
+	baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
 	if (baudAbsDiff13 < 0)
 		baudAbsDiff13 = -baudAbsDiff13;
 	if (baudAbsDiff16 < 0)
-- 
1.9.3

