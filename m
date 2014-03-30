Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaC3Xog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:44:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37365 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893AbaC3Xob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:44:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Olof Johansson" <olof@lixom.net>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.276168328@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 025/200] serial: 8250: enable UART_BUG_NOMSR for Tegra
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 3685f19e07802ec4207b52465c408f185b66490e upstream.

Tegra chips have 4 or 5 identical UART modules embedded. UARTs C..E have
their MODEM-control signals tied off to a static state. However UARTs A
and B can optionally route those signals to/from package pins, depending
on the exact pinmux configuration.

When these signals are not routed to package pins, false interrupts may
trigger either temporarily, or permanently, all while not showing up in
the IIR; it will read as NO_INT. This will eventually lead to the UART
IRQ being disabled due to unhandled interrupts. When this happens, the
kernel may print e.g.:

    irq 68: nobody cared (try booting with the "irqpoll" option)

In order to prevent this, enable UART_BUG_NOMSR. This prevents
UART_IER_MSI from being enabled, which prevents the false interrupts
from triggering.

In practice, this is not needed under any of the following conditions:

* On Tegra chips after Tegra30, since the HW bug has apparently been
  fixed.

* On UARTs C..E since their MODEM control signals are tied to the correct
  static state which doesn't trigger the issue.

* On UARTs A..B if the MODEM control signals are routed out to package
  pins, since they will then carry valid signals.

However, we ignore these exceptions for now, since they are only relevant
if a board actually hooks up more than a 4-wire UART, and no currently
supported board does this. If we ever support a board that does, we can
refine the algorithm that enables UART_BUG_NOMSR to take those exceptions
into account, and/or read a flag from DT/... that indicates that the
board has hooked up and pinmux'd more than a 4-wire UART.

Reported-by: Olof Johansson <olof@lixom.net> # autotester
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Adjust filename
 - s/port->/up->port./]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/8250.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2701,6 +2701,10 @@ static void serial8250_config_port(struc
 	if (up->port.type == PORT_16550A && up->port.iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
 
+	/* HW bugs may trigger IRQ while IIR == NO_INT */
+	if (up->port.type == PORT_TEGRA)
+		up->bugs |= UART_BUG_NOMSR;
+
 	if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
 		autoconfig_irq(up);
 

