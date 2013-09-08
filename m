Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab3IHDTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56089 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031Ab3IHDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.427694887@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [040/121] serial/mxs-auart: fix race condition in interrupt handler
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit d970d7fe65adff5efe75b4a73c4ffc9be57089f7 upstream.

The handler needs to ack the pending events before actually handling them.
Otherwise a new event might come in after it it considered non-pending or
handled and is acked then without being handled. So this event is only
noticed when the next interrupt happens.

Without this patch an i.MX28 based machine running an rt-patched kernel
regularly hangs during boot.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/mxs-auart.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -374,11 +374,18 @@ static void mxs_auart_settermios(struct
 
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
@@ -397,12 +404,6 @@ static irqreturn_t mxs_auart_irq_handle(
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
 

