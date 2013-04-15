Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3DOFp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:45:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60165 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3DOFp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:45:27 -0400
X-AuditID: 9c930197-b7b50ae00000018c-cb-516b93f5dbb5
From: Jongsung Kim <neidhard.kim@lge.com>
Organization: LG Electronics
To: linux@arm.linux.org.uk, gregkh@linuxfoundation.org, jslaby@suse.cz
Subject: [RESEND][PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
Date: Mon, 15 Apr 2013 14:45:25 +0900
User-Agent: KMail/1.12.4 (Linux/2.6.32-358.2.1.el6.x86_64; KDE/4.3.4; x86_64; ; )
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304151445.25151.neidhard.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest r1p5-revision of the ARM PL011 UART has 32-byte FIFOs,
while all earlier ones have 16-byte FIFOs. This patch suggests
a way to set the FIFO-size correctly & flexibly by using a member
function named get_fifosize, rather than using the fifosize member
variable. The function takes the UARTPeriphID, and returns the
correct FIFO size.

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
---
 drivers/tty/serial/amba-pl011.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 3ea5408..22af0c8 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -72,32 +72,44 @@
 /* There is by now at least one vendor with differing details, so handle it */
 struct vendor_data {
 	unsigned int		ifls;
-	unsigned int		fifosize;
 	unsigned int		lcrh_tx;
 	unsigned int		lcrh_rx;
 	bool			oversampling;
 	bool			dma_threshold;
 	bool			cts_event_workaround;
+
+	unsigned int (*get_fifosize)(unsigned int periphid);
 };
 
+static unsigned int get_fifosize_arm(unsigned int periphid)
+{
+	unsigned int rev = (periphid >> 20) & 0xf;
+	return rev < 3 ? 16 : 32;
+}
+
 static struct vendor_data vendor_arm = {
 	.ifls			= UART011_IFLS_RX4_8|UART011_IFLS_TX4_8,
-	.fifosize		= 16,
 	.lcrh_tx		= UART011_LCRH,
 	.lcrh_rx		= UART011_LCRH,
 	.oversampling		= false,
 	.dma_threshold		= false,
 	.cts_event_workaround	= false,
+	.get_fifosize		= get_fifosize_arm,
 };
 
+static unsigned int get_fifosize_st(unsigned int periphid)
+{
+	return 64;
+}
+
 static struct vendor_data vendor_st = {
 	.ifls			= UART011_IFLS_RX_HALF|UART011_IFLS_TX_HALF,
-	.fifosize		= 64,
 	.lcrh_tx		= ST_UART011_LCRH_TX,
 	.lcrh_rx		= ST_UART011_LCRH_RX,
 	.oversampling		= true,
 	.dma_threshold		= true,
 	.cts_event_workaround	= true,
+	.get_fifosize		= get_fifosize_st,
 };
 
 static struct uart_amba_port *amba_ports[UART_NR];
@@ -2010,7 +2022,7 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
 	uap->old_cr = 0;
-	uap->fifosize = vendor->fifosize;
+	uap->fifosize = vendor->get_fifosize(dev->periphid);
 	uap->port.dev = &dev->dev;
 	uap->port.mapbase = dev->res.start;
 	uap->port.membase = base;
