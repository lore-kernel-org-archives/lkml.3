Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaEPNfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:35:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbaEPNfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:35:52 -0400
Date: Fri, 16 May 2014 06:34:57 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-651fb13943304be2008b43adf813fa62435423d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154337.643399187@linutronix.de>
References: <20140507154337.643399187@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] tile: serial: Use irq_alloc/free_hwirq
Git-Commit-ID: 651fb13943304be2008b43adf813fa62435423d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  651fb13943304be2008b43adf813fa62435423d7
Gitweb:     http://git.kernel.org/tip/651fb13943304be2008b43adf813fa62435423d7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:15 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:20 +0200

tile: serial: Use irq_alloc/free_hwirq

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20140507154337.643399187@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/tty/serial/tilegx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/tilegx.c b/drivers/tty/serial/tilegx.c
index f92d7e6..613ccf0 100644
--- a/drivers/tty/serial/tilegx.c
+++ b/drivers/tty/serial/tilegx.c
@@ -359,8 +359,8 @@ static int tilegx_startup(struct uart_port *port)
 		}
 
 		/* Create our IRQs. */
-		port->irq = create_irq();
-		if (port->irq < 0)
+		port->irq = irq_alloc_hwirq(-1);
+		if (!port->irq)
 			goto err_uart_dest;
 		tile_irq_activate(port->irq, TILE_IRQ_PERCPU);
 
@@ -395,7 +395,7 @@ static int tilegx_startup(struct uart_port *port)
 err_free_irq:
 	free_irq(port->irq, port);
 err_dest_irq:
-	destroy_irq(port->irq);
+	irq_free_hwirq(port->irq);
 err_uart_dest:
 	gxio_uart_destroy(context);
 	ret = -ENXIO;
@@ -435,7 +435,7 @@ static void tilegx_shutdown(struct uart_port *port)
 
 	if (port->irq > 0) {
 		free_irq(port->irq, port);
-		destroy_irq(port->irq);
+		irq_free_hwirq(port->irq);
 		port->irq = 0;
 	}
 
