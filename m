Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3HPWpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:45:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab3HPWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 055/133] serial/mxs-auart: fix race condition in interrupt handler
Date: Fri, 16 Aug 2013 15:33:17 -0700
Message-Id: <1376692475-28413-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

commit d970d7fe65adff5efe75b4a73c4ffc9be57089f7 upstream.

The handler needs to ack the pending events before actually handling them.
Otherwise a new event might come in after it it considered non-pending or
handled and is acked then without being handled. So this event is only
noticed when the next interrupt happens.

Without this patch an i.MX28 based machine running an rt-patched kernel
regularly hangs during boot.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/mxs-auart.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index e55615e..f0d17ee 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -710,11 +710,18 @@ static void mxs_auart_settermios(struct uart_port *u,
 
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
@@ -734,12 +741,6 @@ static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
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
1.8.1.2

