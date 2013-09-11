Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3IKFbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:31:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab3IKE5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:23 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=BO0hCkrCBJEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Tx_wdi_WTGcA:10 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=XNN-oNMjSfgA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042913.717564358@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [129/251] serial/mxs-auart: fix race condition in interrupt handler
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0129-serial-mxs-auart-fix-race-condition-in-interrupt-han.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

[ Upstream commit d970d7fe65adff5efe75b4a73c4ffc9be57089f7 ]

The handler needs to ack the pending events before actually handling them.
Otherwise a new event might come in after it it considered non-pending or
handled and is acked then without being handled. So this event is only
noticed when the next interrupt happens.

Without this patch an i.MX28 based machine running an rt-patched kernel
regularly hangs during boot.

Cc: stable@vger.kernel.org # v2.6.39+
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/serial/mxs-auart.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 3a667ee..634be9b 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -381,11 +381,18 @@ static void mxs_auart_settermios(struct uart_port *u,
 
 static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 {
-	u32 istatus, istat;
+	u32 istat;
 	struct mxs_auart_port *s = context;
 	u32 stat = readl(s->port.membase + AUART_STAT);
 
-	istatus = istat = readl(s->port.membase + AUART_INTR);
+	istat = readl(s->port.membase + AUART_INTR);
+
+	/* ack irq */
+	writel(istat & (AUART_INTR_RTIS
+		| AUART_INTR_TXIS
+		| AUART_INTR_RXIS
+		| AUART_INTR_CTSMIS),
+			s->port.membase + AUART_INTR_CLR);
 
 	if (istat & AUART_INTR_CTSMIS) {
 		uart_handle_cts_change(&s->port, stat & AUART_STAT_CTS);
@@ -404,12 +411,6 @@ static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 		istat &= ~AUART_INTR_TXIS;
 	}
 
-	writel(istatus & (AUART_INTR_RTIS
-		| AUART_INTR_TXIS
-		| AUART_INTR_RXIS
-		| AUART_INTR_CTSMIS),
-			s->port.membase + AUART_INTR_CLR);
-
 	return IRQ_HANDLED;
 }
 
-- 
1.7.10.4


