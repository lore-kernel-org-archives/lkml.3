Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3JARTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:19:51 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4535 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab3JARTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:19:49 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Heikki Krogerus" <heikki.krogerus@linux.intel.com>
cc: "Tim Kryger" <tim.kryger@linaro.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Date: Tue, 1 Oct 2013 10:18:08 -0700
Message-ID: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E55DE2B2L890423793-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When configured with UART_16550_COMPATIBLE=NO or in versions prior to
the introduction of this option, the Designware UART will ignore writes
to the LCR if the UART is busy.  The current workaround saves a copy of
the last written LCR and re-writes it in the ISR for a special interrupt
that is raised when a write was ignored.

Unfortunately, interrupts are typically disabled prior to performing a
sequence of register writes that include the LCR so the point at which
the retry occurs is too late.  An example is serial8250_do_set_termios()
where an ignored LCR write results in the baud divisor not being set and
instead a garbage character is sent out the transmitter.

Furthermore, since serial_port_out() offers no way to indicate failure,
a serious effort must be made to ensure that the LCR is actually updated
before returning back to the caller.  This is difficult, however, as a
UART that was busy during the first attempt is likely to still be busy
when a subsequent attempt is made unless some extra action is taken.

This updated workaround reads back the LCR after each write to confirm
that the new value was accepted by the hardware.  Should the hardware
ignore a write, the TX/RX FIFOs are cleared and the receive buffer read
before attempting to rewrite the LCR out of the hope that doing so will
force the UART into an idle state.  While this may seem unnecessarily
aggressive, writes to the LCR are used to change the baud rate, parity,
stop bit, or data length so the data that may be lost is likely not
important.  Admittedly, this is far from ideal but it seems to be the
best that can be done given the hardware limitations.

Lastly, the revised workaround doesn't touch the LCR in the ISR, so it
avoids the possibility of a "serial8250: too much work for irq" lock up.
This problem is rare in real situations but can be reproduced easily by
wiring up two UARTs and running the following commands.

  # stty -F /dev/ttyS1 echo
  # stty -F /dev/ttyS2 echo
  # cat /dev/ttyS1 &
  [1] 375
  # echo asdf > /dev/ttyS1
  asdf

  [   27.700000] serial8250: too much work for irq96
  [   27.700000] serial8250: too much work for irq96
  [   27.710000] serial8250: too much work for irq96
  [   27.710000] serial8250: too much work for irq96
  [   27.720000] serial8250: too much work for irq96
  [   27.720000] serial8250: too much work for irq96
  [   27.730000] serial8250: too much work for irq96
  [   27.730000] serial8250: too much work for irq96
  [   27.740000] serial8250: too much work for irq96

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---

Changes in v2:
  - Rebased on tty-next
  - Updated commit messsage to mention UART_16550_COMPATIBLE
  - Removed potentially unnecessary read of LSR and MSR
  - Only attempt workaround when LCR write is ignored

 drivers/tty/serial/8250/8250_dw.c | 41 ++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index d04a037..4658e3e 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -57,7 +57,6 @@
 
 struct dw8250_data {
 	u8			usr_reg;
-	int			last_lcr;
 	int			last_mcr;
 	int			line;
 	struct clk		*clk;
@@ -77,17 +76,33 @@ static inline int dw8250_modify_msr(struct uart_port *p, int offset, int value)
 	return value;
 }
 
+static void dw8250_force_idle(struct uart_port *p)
+{
+	serial8250_clear_and_reinit_fifos(container_of
+					  (p, struct uart_8250_port, port));
+	(void)p->serial_in(p, UART_RX);
+}
+
 static void dw8250_serial_out(struct uart_port *p, int offset, int value)
 {
 	struct dw8250_data *d = p->private_data;
 
-	if (offset == UART_LCR)
-		d->last_lcr = value;
-
 	if (offset == UART_MCR)
 		d->last_mcr = value;
 
 	writeb(value, p->membase + (offset << p->regshift));
+
+	/* Make sure LCR write wasn't ignored */
+	if (offset == UART_LCR) {
+		int tries = 1000;
+		while (tries--) {
+			if (value == p->serial_in(p, UART_LCR))
+				return;
+			dw8250_force_idle(p);
+			writeb(value, p->membase + (UART_LCR << p->regshift));
+		}
+		dev_err(p->dev, "Couldn't set LCR to %d\n", value);
+	}
 }
 
 static unsigned int dw8250_serial_in(struct uart_port *p, int offset)
@@ -108,13 +123,22 @@ static void dw8250_serial_out32(struct uart_port *p, int offset, int value)
 {
 	struct dw8250_data *d = p->private_data;
 
-	if (offset == UART_LCR)
-		d->last_lcr = value;
-
 	if (offset == UART_MCR)
 		d->last_mcr = value;
 
 	writel(value, p->membase + (offset << p->regshift));
+
+	/* Make sure LCR write wasn't ignored */
+	if (offset == UART_LCR) {
+		int tries = 1000;
+		while (tries--) {
+			if (value == p->serial_in(p, UART_LCR))
+				return;
+			dw8250_force_idle(p);
+			writel(value, p->membase + (UART_LCR << p->regshift));
+		}
+		dev_err(p->dev, "Couldn't set LCR to %d\n", value);
+	}
 }
 
 static unsigned int dw8250_serial_in32(struct uart_port *p, int offset)
@@ -132,9 +156,8 @@ static int dw8250_handle_irq(struct uart_port *p)
 	if (serial8250_handle_irq(p, iir)) {
 		return 1;
 	} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
-		/* Clear the USR and write the LCR again. */
+		/* Clear the USR */
 		(void)p->serial_in(p, d->usr_reg);
-		p->serial_out(p, UART_LCR, d->last_lcr);
 
 		return 1;
 	}
-- 
1.8.0.1


