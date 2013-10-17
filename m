Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853Ab3JQVQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:16:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55314 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3JQVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:16:39 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Vlad Lungu <vlad.lungu@windriver.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 04/10] tty: xuartps: Add polled mode support for xuartps
Date: Thu, 17 Oct 2013 14:08:07 -0700
Message-Id: <1382044093-29905-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Lungu <vlad.lungu@windriver.com>

This allows KDB/KGDB to run.

Signed-off-by: Vlad Lungu <vlad.lungu@windriver.com>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
This is squashed from these original patches:
	tty: xuartps: Add polled mode support for xuartps

	This allows KDB/KGDB to run.
	There is a bug somewhere that blocks KDB when paging;
	set the LINES environment variable to a big value and
	scroll in your terminal.

	Signed-off-by: Vlad Lungu <vlad.lungu@windriver.com>

and

	tty: xuartps: Fix poll read

	This fixes the KDB paging issue.

	Signed-off-by: Vlad Lungu <vlad.lungu@windriver.com>

Additionally I fixed a few style issues.
---
 drivers/tty/serial/xilinx_uartps.c | 52 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 5d5557af4d22..62259f37ddda 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -775,6 +775,54 @@ static void xuartps_enable_ms(struct uart_port *port)
 	/* N/A */
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int xuartps_poll_get_char(struct uart_port *port)
+{
+	u32 imr;
+	int c;
+
+	/* Disable all interrupts */
+	imr = xuartps_readl(XUARTPS_IMR_OFFSET);
+	xuartps_writel(imr, XUARTPS_IDR_OFFSET);
+
+	/* Check if FIFO is empty */
+	if (xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_RXEMPTY)
+		c = NO_POLL_CHAR;
+	else /* Read a character */
+		c = (unsigned char) xuartps_readl(XUARTPS_FIFO_OFFSET);
+
+	/* Enable interrupts */
+	xuartps_writel(imr, XUARTPS_IER_OFFSET);
+
+	return c;
+}
+
+static void xuartps_poll_put_char(struct uart_port *port, unsigned char c)
+{
+	u32 imr;
+
+	/* Disable all interrupts */
+	imr = xuartps_readl(XUARTPS_IMR_OFFSET);
+	xuartps_writel(imr, XUARTPS_IDR_OFFSET);
+
+	/* Wait until FIFO is empty */
+	while (!(xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_TXEMPTY))
+		cpu_relax();
+
+	/* Write a character */
+	xuartps_writel(c, XUARTPS_FIFO_OFFSET);
+
+	/* Wait until FIFO is empty */
+	while (!(xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_TXEMPTY))
+		cpu_relax();
+
+	/* Enable interrupts */
+	xuartps_writel(imr, XUARTPS_IER_OFFSET);
+
+	return;
+}
+#endif
+
 /** The UART operations structure
  */
 static struct uart_ops xuartps_ops = {
@@ -807,6 +855,10 @@ static struct uart_ops xuartps_ops = {
 	.config_port	= xuartps_config_port,	/* Configure when driver
 						 * adds a xuartps port
 						 */
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= xuartps_poll_get_char,
+	.poll_put_char	= xuartps_poll_put_char,
+#endif
 };
 
 static struct uart_port xuartps_port[2];
-- 
1.8.4.1

