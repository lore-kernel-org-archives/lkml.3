Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaHSRbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:31:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:29190 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbaHSR3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:29:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="560674440"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 11/12] serial: 8250: don't use slave_id of dma_slave_config
Date: Tue, 19 Aug 2014 20:29:22 +0300
Message-Id: <1408469363-15901-12-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That field has been deprecated in favour of getting the necessary information
from ACPI or DT.

However, we still need to deal systems that are PCI only (no ACPI to back up)
like Intel Bay Trail. In order to support such systems, we explicitly bind
setup() to the appropriate DMA filter function and its corresponding parameter.
Then when serial8250_request_dma() doesn't find the channel via ACPI or DT, it
falls back to use the given filter function.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/tty/serial/8250/8250.h     |  6 ++---
 drivers/tty/serial/8250/8250_dw.c  |  7 +-----
 drivers/tty/serial/8250/8250_pci.c | 51 ++++++++++++++++++++++++++++++--------
 3 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 1b08c91..c3c7091 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -16,13 +16,13 @@
 #include <linux/dmaengine.h>
 
 struct uart_8250_dma {
+	/* Filter function */
 	dma_filter_fn		fn;
+
+	/* Parameter to the filter function */
 	void			*rx_param;
 	void			*tx_param;
 
-	int			rx_chan_id;
-	int			tx_chan_id;
-
 	struct dma_slave_config	rxconf;
 	struct dma_slave_config	txconf;
 
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 4db7987..6664de2 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -216,10 +216,7 @@ out:
 
 static bool dw8250_dma_filter(struct dma_chan *chan, void *param)
 {
-	struct dw8250_data *data = param;
-
-	return chan->chan_id == data->dma.tx_chan_id ||
-	       chan->chan_id == data->dma.rx_chan_id;
+	return false;
 }
 
 static void dw8250_setup_port(struct uart_8250_port *up)
@@ -399,8 +396,6 @@ static int dw8250_probe(struct platform_device *pdev)
 	if (!IS_ERR(data->rst))
 		reset_control_deassert(data->rst);
 
-	data->dma.rx_chan_id = -1;
-	data->dma.tx_chan_id = -1;
 	data->dma.rx_param = data;
 	data->dma.tx_param = data;
 	data->dma.fn = dw8250_dma_filter;
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 61830b1..a00c9de 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -25,6 +25,9 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 
+#include <linux/dmaengine.h>
+#include <linux/platform_data/dma-dw.h>
+
 #include "8250.h"
 
 /*
@@ -1427,7 +1430,13 @@ byt_set_termios(struct uart_port *p, struct ktermios *termios,
 
 static bool byt_dma_filter(struct dma_chan *chan, void *param)
 {
-	return chan->chan_id == *(int *)param;
+	struct dw_dma_slave *dws = param;
+
+	if (dws->dma_dev != chan->device->dev)
+		return false;
+
+	chan->private = dws;
+	return true;
 }
 
 static int
@@ -1435,35 +1444,55 @@ byt_serial_setup(struct serial_private *priv,
 		 const struct pciserial_board *board,
 		 struct uart_8250_port *port, int idx)
 {
+	struct pci_dev *pdev = priv->dev;
+	struct device *dev = port->port.dev;
 	struct uart_8250_dma *dma;
+	struct dw_dma_slave *tx_param, *rx_param;
+	struct pci_dev *dma_dev;
 	int ret;
 
-	dma = devm_kzalloc(port->port.dev, sizeof(*dma), GFP_KERNEL);
+	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
 	if (!dma)
 		return -ENOMEM;
 
-	switch (priv->dev->device) {
+	tx_param = devm_kzalloc(dev, sizeof(*tx_param), GFP_KERNEL);
+	if (!tx_param)
+		return -ENOMEM;
+
+	rx_param = devm_kzalloc(dev, sizeof(*rx_param), GFP_KERNEL);
+	if (!rx_param)
+		return -ENOMEM;
+
+	switch (pdev->device) {
 	case PCI_DEVICE_ID_INTEL_BYT_UART1:
-		dma->rx_chan_id = 3;
-		dma->tx_chan_id = 2;
+		rx_param->src_id = 3;
+		tx_param->dst_id = 2;
 		break;
 	case PCI_DEVICE_ID_INTEL_BYT_UART2:
-		dma->rx_chan_id = 5;
-		dma->tx_chan_id = 4;
+		rx_param->src_id = 5;
+		tx_param->dst_id = 4;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	dma->rxconf.slave_id = dma->rx_chan_id;
+	rx_param->src_master = 1;
+	rx_param->dst_master = 0;
+
 	dma->rxconf.src_maxburst = 16;
 
-	dma->txconf.slave_id = dma->tx_chan_id;
+	tx_param->src_master = 1;
+	tx_param->dst_master = 0;
+
 	dma->txconf.dst_maxburst = 16;
 
+	dma_dev = pci_get_slot(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
+	rx_param->dma_dev = &dma_dev->dev;
+	tx_param->dma_dev = &dma_dev->dev;
+
 	dma->fn = byt_dma_filter;
-	dma->rx_param = &dma->rx_chan_id;
-	dma->tx_param = &dma->tx_chan_id;
+	dma->rx_param = rx_param;
+	dma->tx_param = tx_param;
 
 	ret = pci_default_setup(priv, board, port, idx);
 	port->port.iotype = UPIO_MEM;
-- 
2.1.0

