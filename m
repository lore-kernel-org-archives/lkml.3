Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaBGMzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:55:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaBGLt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 095/233] serial: 8250: enable UART_BUG_NOMSR for Tegra
Date: Fri,  7 Feb 2014 11:45:14 +0000
Message-Id: <1391773652-25214-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/8250/8250_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 86c00b1c..d28d7af 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2670,6 +2670,10 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
 
+	/* HW bugs may trigger IRQ while IIR == NO_INT */
+	if (port->type == PORT_TEGRA)
+		up->bugs |= UART_BUG_NOMSR;
+
 	if (port->type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
 		autoconfig_irq(up);
 
-- 
1.8.3.2

