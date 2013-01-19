Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3ASJwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:52:47 -0500
Received: from mail1.windriver.com ([147.11.146.13]:54665 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3ASJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:52:25 -0500
From: Liang Li <liang.li@windriver.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <liang.li@windriver.com>, <dvhart@linux.intel.com>,
        <bruce.ashfield@windriver.com>, <tomoya.rohm@gmail.com>,
        <feng.tang@intel.com>, <alan@linux.intel.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] pch_uart: add sysrq support
Date: Sat, 19 Jan 2013 17:52:11 +0800
Message-ID: <1358589131-28187-3-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1358589131-28187-1-git-send-email-liang.li@windriver.com>
References: <1358589131-28187-1-git-send-email-liang.li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When send break to the uart port, we always get 'frame error', but we
can not just reset receive fifo in such case, otherwise the sysrq cmd
will not be received correctly.

When we handle sysrq output via pch_console_write, the priv lock has
already been taken so no need to take the lock in pch_console_write.

Signed-off-by: Liang Li <liang.li@windriver.com>
---
 drivers/tty/serial/pch_uart.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 2e99f79..f2d67df 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -14,18 +14,21 @@
  *along with this program; if not, write to the Free Software
  *Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
  */
+#if defined(CONFIG_SERIAL_PCH_UART_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
 #include <linux/kernel.h>
 #include <linux/serial_reg.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/console.h>
 #include <linux/serial_core.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/dmi.h>
-#include <linux/console.h>
 #include <linux/nmi.h>
 #include <linux/delay.h>
 
@@ -552,12 +555,24 @@ static int pch_uart_hal_read(struct eg20t_port *priv, unsigned char *buf,
 {
 	int i;
 	u8 rbr, lsr;
+	struct uart_port *port = &priv->port;
 
 	lsr = ioread8(priv->membase + UART_LSR);
 	for (i = 0, lsr = ioread8(priv->membase + UART_LSR);
-	     i < rx_size && lsr & UART_LSR_DR;
+	     i < rx_size && lsr & (UART_LSR_DR | UART_LSR_BI);
 	     lsr = ioread8(priv->membase + UART_LSR)) {
 		rbr = ioread8(priv->membase + PCH_UART_RBR);
+
+		if (lsr & UART_LSR_BI) {
+			port->icount.brk++;
+			if (uart_handle_break(port))
+				continue;
+		}
+		if (port->sysrq) {
+			if (uart_handle_sysrq_char(port, rbr))
+				continue;
+		}
+
 		buf[i++] = rbr;
 	}
 	return i;
@@ -1033,16 +1048,11 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 
 static void pch_uart_err_ir(struct eg20t_port *priv, unsigned int lsr)
 {
-	u8 fcr = ioread8(priv->membase + UART_FCR);
 	struct uart_port *port = &priv->port;
 	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
 	char   *error_msg[5] = {};
 	int    i = 0;
 
-	/* Reset FIFO */
-	fcr |= UART_FCR_CLEAR_RCVR;
-	iowrite8(fcr, priv->membase + UART_FCR);
-
 	if (lsr & PCH_UART_LSR_ERR)
 		error_msg[i++] = "Error data in FIFO\n";
 
@@ -1568,7 +1578,8 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 
 	local_irq_save(flags);
 	if (priv->port.sysrq) {
-		spin_lock(&priv->lock);
+		/* call to uart_handle_sysrq_char already took the priv lock */
+		priv_locked = 0;
 		/* serial8250_handle_port() already took the port lock */
 		port_locked = 0;
 	} else if (oops_in_progress) {
-- 
1.7.11.4

