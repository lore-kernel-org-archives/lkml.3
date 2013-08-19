Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3HSLW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:22:57 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:50168
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab3HSLVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:21:02 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24233028"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] serial: st-asc: replace devm_request_and_ioremap by devm_ioremap_resource
Date: Mon, 19 Aug 2013 13:20:36 +0200
Message-Id: <1376911241-27720-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use devm_ioremap_resource instead of devm_request_and_ioremap.

This was done using the semantic patch
scripts/coccinelle/api/devm_ioremap_resource.cocci
and various manual modifications to move associated calls to
platform_get_resource closer to the resulting call to devm_ioremap_resource
and to remove the associated error handling code.

The initialization of port->mapbase is also moved lower, to take advantage
of the NULL test on res performed by devm_ioremap_resource.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/tty/serial/st-asc.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index 2ff4b1b..e0ec11d 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -665,26 +665,20 @@ static int asc_init_port(struct asc_port *ascport,
 			  struct platform_device *pdev)
 {
 	struct uart_port *port = &ascport->port;
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	if (!res) {
-		dev_err(&pdev->dev, "Unable to get io resource\n");
-		return -ENODEV;
-	}
+	struct resource *res;
 
 	port->iotype	= UPIO_MEM;
 	port->flags	= UPF_BOOT_AUTOCONF;
 	port->ops	= &asc_uart_ops;
 	port->fifosize	= ASC_FIFO_SIZE;
 	port->dev	= &pdev->dev;
-	port->mapbase	= res->start;
 	port->irq	= platform_get_irq(pdev, 0);
 
-	port->membase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!port->membase) {
-		dev_err(&pdev->dev, "Unable to request io memory\n");
-		return -ENODEV;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	port->membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(port->membase))
+		return PTR_ERR(port->membase);
+	port->mapbase = res->start;
 
 	spin_lock_init(&port->lock);
 

