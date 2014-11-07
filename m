Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaKGOQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:16:24 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54228 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752821AbaKGOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:15:07 -0500
Message-ID: <545CD3CF.4070901@arm.com>
Date: Fri, 07 Nov 2014 14:14:39 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/5] serial: pl011: Avoid assumptions about buffer size when
 refilling TX DMA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The existing code assumed that PL011_DMA_BUFFER_SIZE == UART_XMIT_SIZE,
which may not always be the case.  This allows for these two being
different sizes and not copying too much data.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 drivers/tty/serial/amba-pl011.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index a285196..d8d067a 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -501,7 +501,11 @@ static int pl011_dma_tx_refill(struct uart_amba_port *uap)
 		memcpy(&dmatx->buf[0], &xmit->buf[xmit->tail], count);
 	else {
 		size_t first = UART_XMIT_SIZE - xmit->tail;
-		size_t second = xmit->head;
+		size_t second;
+
+		if (first > count)
+			first = count;
+		second = count - first;
 
 		memcpy(&dmatx->buf[0], &xmit->buf[xmit->tail], first);
 		if (second)
-- 
1.7.1

