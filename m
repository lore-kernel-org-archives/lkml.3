Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaHSMQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:16:51 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:51116 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaHSMO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:14:59 -0400
X-ASG-Debug-ID: 1408450496-0759e7416b47640e0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Felipe Balbi <balbi@ti.com>
CC: Frans Klaver <frans.klaver@xsens.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Frans Klaver <fransklaver@gmail.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tty: omap-serial: prevent division by zero
Date: Tue, 19 Aug 2014 14:14:46 +0200
X-ASG-Orig-Subj: [PATCH 2/4] tty: omap-serial: prevent division by zero
Message-ID: <1408450488-4083-3-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408450488-4083-1-git-send-email-frans.klaver@xsens.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1408450496
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.8612
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the chosen baud rate is large enough (e.g. 3.5 megabaud), the
calculated n values in calculate_baud_abs_diff may become 0. This causes
a division by zero when calculating the difference between calculated
and desired baud rates. To prevent this, cap n on 1.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/tty/serial/omap-serial.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index ae935ce..14a0167 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -246,8 +246,12 @@ static inline int calculate_baud_abs_diff(struct uart_port *port,
 				unsigned int baud, unsigned int mode)
 {
 	unsigned int n = port->uartclk / (mode * baud);
-	int abs_diff = baud - (port->uartclk / (mode * n));
+	int abs_diff;
 
+	if (n == 0)
+		n = 1;
+
+	abs_diff = baud - (uartclk / (mode * n));
 	if (abs_diff < 0)
 		abs_diff = -abs_diff;
 
-- 
1.9.3

