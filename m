Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaIJTbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:31:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:35422 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaIJTbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:31:01 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/16] tty: serial: 8250_core: use the ->line argument as a hint in serial8250_find_match_or_unused()
Date: Wed, 10 Sep 2014 21:29:59 +0200
Message-Id: <1410377411-26656-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony noticed that the old omap-serial driver picked the uart "number"
based on the hint given from device tree or platform device's id.
The 8250 based omap driver doesn't do this because the core code does
not honour the ->line argument which is passed by the driver.

This patch aims to keep the same behaviour as with omap-serial. The
function will first try to use the line suggested ->line argument and
then fallback to the old strategy in case the port is taken.

That means the the third uart will always be ttyS2 even if the previous
two have not been enabled in DT.

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 547afde9fdda..ac88e66df65d 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -3516,6 +3516,11 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 		if (uart_match_port(&serial8250_ports[i].port, port))
 			return &serial8250_ports[i];
 
+	/* try line number first if still available */
+	i = port->line;
+	if (i < nr_uarts && serial8250_ports[i].port.type == PORT_UNKNOWN &&
+			serial8250_ports[i].port.iobase == 0)
+		return &serial8250_ports[i];
 	/*
 	 * We didn't find a matching entry, so look for the first
 	 * free entry.  We look for one which hasn't been previously
-- 
2.1.0

