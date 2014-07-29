Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaG2PDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:03:31 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:33148 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaG2PCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:02:42 -0400
X-ASG-Debug-ID: 1406646160-0759e7416beb1680002-xx1T2L
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
Subject: [PATCH 2/3] tty: omap-serial: use threaded interrupt handler
Date: Tue, 29 Jul 2014 17:02:31 +0200
X-ASG-Orig-Subj: [PATCH 2/3] tty: omap-serial: use threaded interrupt handler
Message-ID: <1406646152-24698-3-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406646152-24698-1-git-send-email-frans.klaver@xsens.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1406646152-24698-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1406646160
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

At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 1600 uart
rx buffer overflows within 30 seconds. Threading the interrupt handling reduces
this to about 170 overflows in 10 minutes.

In practice this therefore reduces the need for hardware flow control,
meaning the sending side doesn't have to buffer as much either.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/tty/serial/omap-serial.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index e454b7c..ff2d931 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -569,6 +569,21 @@ static void serial_omap_rdi(struct uart_omap_port *up, unsigned int lsr)
 }
 
 /**
+ * serial_omap_fast_irq() - schedule interrupt handling
+ */
+static irqreturn_t serial_omap_fast_irq(int irq, void *dev_id)
+{
+	struct uart_omap_port *up = dev_id;
+	unsigned int iir = serial_in(up, UART_IIR);
+	if (iir & UART_IIR_NO_INT) {
+		return IRQ_NONE;
+	}
+
+	disable_irq_nosync(up->port.irq);
+	return IRQ_WAKE_THREAD;
+}
+
+/**
  * serial_omap_irq() - This handles the interrupt from one port
  * @irq: uart port irq number
  * @dev_id: uart port info
@@ -578,18 +593,12 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 	struct uart_omap_port *up = dev_id;
 	unsigned int iir, lsr;
 	unsigned int type;
-	irqreturn_t ret = IRQ_NONE;
 	int max_count = 256;
 
 	spin_lock(&up->port.lock);
 	pm_runtime_get_sync(up->dev);
 
 	do {
-		iir = serial_in(up, UART_IIR);
-		if (iir & UART_IIR_NO_INT)
-			break;
-
-		ret = IRQ_HANDLED;
 		lsr = serial_in(up, UART_LSR);
 
 		/* extract IRQ type from IIR register */
@@ -618,17 +627,21 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 		default:
 			break;
 		}
+
+		iir = serial_in(up, UART_IIR);
 	} while (!(iir & UART_IIR_NO_INT) && max_count--);
 
 	spin_unlock(&up->port.lock);
 
 	tty_flip_buffer_push(&up->port.state->port);
 
+	enable_irq(up->port.irq);
+
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
 	up->port_activity = jiffies;
 
-	return ret;
+	return IRQ_HANDLED;
 }
 
 static unsigned int serial_omap_tx_empty(struct uart_port *port)
@@ -725,15 +738,17 @@ static int serial_omap_startup(struct uart_port *port)
 	/*
 	 * Allocate the IRQ
 	 */
-	retval = request_irq(up->port.irq, serial_omap_irq, up->port.irqflags,
-				up->name, up);
+	retval = request_threaded_irq(up->port.irq, serial_omap_fast_irq,
+					serial_omap_irq, up->port.irqflags,
+					up->name, up);
 	if (retval)
 		return retval;
 
 	/* Optional wake-up IRQ */
 	if (up->wakeirq) {
-		retval = request_irq(up->wakeirq, serial_omap_irq,
-				     up->port.irqflags, up->name, up);
+		retval = request_threaded_irq(up->wakeirq, serial_omap_fast_irq,
+					serial_omap_irq, up->port.irqflags,
+					up->name, up);
 		if (retval) {
 			free_irq(up->port.irq, up);
 			return retval;
-- 
1.9.3

