Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935442AbaBDWRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:17:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650AbaBDVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Deneen <mdeneen@gmail.com>, Leilei Zhao <leilei.zhao@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.12 057/133] tty/serial: at91: reset rx_ring when port is shutdown
Date: Tue,  4 Feb 2014 13:07:38 -0800
Message-Id: <20140204210738.643731956@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Deneen <mdeneen@gmail.com>

commit bb7e73c598fb226c75f7625088a8f6a45a0fc892 upstream.

When using RX DMA, the driver won't pass any data to the uart layer
until the buffer is flipped. When the port is shutdown, the dma buffers
are unmapped, but the head and tail of the ring buffer are not reseted.
Since the serial console will keep the port open, this will only
present itself when the uart is not shared.

To reproduce the issue, with an unpatched driver, run a getty on /dev/ttyS0
with no serial console and exit. Getty will exit, and when the new one returns
you will be unable to log in.  If you hold down a key long enough to fill the
DMA buffer and flip it, you can then log in.

Signed-off-by: Mark Deneen <mdeneen@gmail.com>
Acked-by: Leilei Zhao <leilei.zhao@atmel.com>
[nicolas.ferre@atmel.com: adapt to mainline kernel, handle !DMA case]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/atmel_serial.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1660,6 +1660,12 @@ static void atmel_shutdown(struct uart_p
 		atmel_port->release_tx(port);
 
 	/*
+	 * Reset ring buffer pointers
+	 */
+	atmel_port->rx_ring.head = 0;
+	atmel_port->rx_ring.tail = 0;
+
+	/*
 	 * Free the interrupt
 	 */
 	free_irq(port->irq, port);


