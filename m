Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936802Ab3DJN6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:58:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:65142 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936770Ab3DJN6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="284281443"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 7/9] serial: 8250_dw: Let ACPI code extract the DMA client info
Date: Wed, 10 Apr 2013 16:58:30 +0300
Message-Id: <1365602312-25436-8-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ACPI DMA helpers in dmaengine API can take care of
extracting all the necessary information regarding DMA. The
driver does not need to do this separately any more.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |   75 +++++--------------------------------
 1 file changed, 9 insertions(+), 66 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index de7a186..09aaea2 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -163,66 +163,10 @@ static int dw8250_probe_of(struct uart_port *p)
 }
 
 #ifdef CONFIG_ACPI
-static bool dw8250_acpi_dma_filter(struct dma_chan *chan, void *parm)
-{
-	return chan->chan_id == *(int *)parm;
-}
-
-static acpi_status
-dw8250_acpi_walk_resource(struct acpi_resource *res, void *data)
-{
-	struct uart_port		*p = data;
-	struct uart_8250_port		*port;
-	struct uart_8250_dma		*dma;
-	struct acpi_resource_fixed_dma	*fixed_dma;
-	struct dma_slave_config		*slave;
-
-	port = container_of(p, struct uart_8250_port, port);
-
-	switch (res->type) {
-	case ACPI_RESOURCE_TYPE_FIXED_DMA:
-		fixed_dma = &res->data.fixed_dma;
-
-		/* TX comes first */
-		if (!port->dma) {
-			dma = devm_kzalloc(p->dev, sizeof(*dma), GFP_KERNEL);
-			if (!dma)
-				return AE_NO_MEMORY;
-
-			port->dma = dma;
-			slave = &dma->txconf;
-
-			slave->direction	= DMA_MEM_TO_DEV;
-			slave->dst_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
-			slave->slave_id		= fixed_dma->request_lines;
-			slave->dst_maxburst	= port->tx_loadsz / 4;
-
-			dma->tx_chan_id		= fixed_dma->channels;
-			dma->tx_param		= &dma->tx_chan_id;
-			dma->fn			= dw8250_acpi_dma_filter;
-		} else {
-			dma = port->dma;
-			slave = &dma->rxconf;
-
-			slave->direction	= DMA_DEV_TO_MEM;
-			slave->src_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
-			slave->slave_id		= fixed_dma->request_lines;
-			slave->src_maxburst	= p->fifosize / 4;
-
-			dma->rx_chan_id		= fixed_dma->channels;
-			dma->rx_param		= &dma->rx_chan_id;
-		}
-
-		break;
-	}
-
-	return AE_OK;
-}
-
-static int dw8250_probe_acpi(struct uart_port *p)
+static int dw8250_probe_acpi(struct uart_8250_port *up)
 {
 	const struct acpi_device_id *id;
-	acpi_status status;
+	struct uart_port *p = &up->port;
 
 	id = acpi_match_device(p->dev->driver->acpi_match_table, p->dev);
 	if (!id)
@@ -236,13 +180,12 @@ static int dw8250_probe_acpi(struct uart_port *p)
 	if (!p->uartclk)
 		p->uartclk = (unsigned int)id->driver_data;
 
-	status = acpi_walk_resources(ACPI_HANDLE(p->dev), METHOD_NAME__CRS,
-				     dw8250_acpi_walk_resource, p);
-	if (ACPI_FAILURE(status)) {
-		dev_err_ratelimited(p->dev, "%s failed \"%s\"\n", __func__,
-				    acpi_format_exception(status));
-		return -ENODEV;
-	}
+	up->dma = devm_kzalloc(p->dev, sizeof(*up->dma), GFP_KERNEL);
+	if (!up->dma)
+		return -ENOMEM;
+
+	up->dma->rxconf.src_maxburst = p->fifosize / 4;
+	up->dma->txconf.dst_maxburst = p->fifosize / 4;
 
 	return 0;
 }
@@ -329,7 +272,7 @@ static int dw8250_probe(struct platform_device *pdev)
 		if (err)
 			return err;
 	} else if (ACPI_HANDLE(&pdev->dev)) {
-		err = dw8250_probe_acpi(&uart.port);
+		err = dw8250_probe_acpi(&uart);
 		if (err)
 			return err;
 	} else {
-- 
1.7.10.4

