Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab3CULkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:40:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:7762 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab3CULkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:40:43 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <fabio.porcedda@gmail.com>, <laurent.navet@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 2/7] pcmcia: at91_cf: convert to dev_ print functions
Date: Thu, 21 Mar 2013 12:40:12 +0100
Message-ID: <5bfe14c97ee9eb20976f6933169962993dafc9f4.1363865228.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1363865228.git.nicolas.ferre@atmel.com>
References: <cover.1363865228.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

Convert all pr_* functions to equivalent dev_* functions and
drop the driver_name variable.

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/pcmcia/at91_cf.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 1b2c631..4eec14b 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -41,8 +41,6 @@
 
 /*--------------------------------------------------------------------------*/
 
-static const char driver_name[] = "at91_cf";
-
 struct at91_cf_socket {
 	struct pcmcia_socket	socket;
 
@@ -76,7 +74,7 @@ static irqreturn_t at91_cf_irq(int irq, void *_cf)
 		/* kick pccard as needed */
 		if (present != cf->present) {
 			cf->present = present;
-			pr_debug("%s: card %s\n", driver_name,
+			dev_dbg(&cf->pdev->dev, "card %s\n",
 					present ? "present" : "gone");
 			pcmcia_parse_events(&cf->socket, SS_DETECT);
 		}
@@ -134,8 +132,8 @@ at91_cf_set_socket(struct pcmcia_socket *sock, struct socket_state_t *s)
 	/* toggle reset if needed */
 	gpio_set_value(cf->board->rst_pin, s->flags & SS_RESET);
 
-	pr_debug("%s: Vcc %d, io_irq %d, flags %04x csc %04x\n",
-		driver_name, s->Vcc, s->io_irq, s->flags, s->csc_mask);
+	dev_dbg(&cf->pdev->dev, "Vcc %d, io_irq %d, flags %04x csc %04x\n",
+				s->Vcc, s->io_irq, s->flags, s->csc_mask);
 
 	return 0;
 }
@@ -171,10 +169,10 @@ static int at91_cf_set_io_map(struct pcmcia_socket *s, struct pccard_io_map *io)
 	 */
 	if (!(io->flags & (MAP_16BIT | MAP_AUTOSZ))) {
 		csr |= AT91_SMC_DBW_8;
-		pr_debug("%s: 8bit i/o bus\n", driver_name);
+		dev_dbg(&cf->pdev->dev, "8bit i/o bus\n");
 	} else {
 		csr |= AT91_SMC_DBW_16;
-		pr_debug("%s: 16bit i/o bus\n", driver_name);
+		dev_dbg(&cf->pdev->dev, "16bit i/o bus\n");
 	}
 	at91_ramc_write(0, AT91_SMC_CSR(cf->board->chipselect), csr);
 
@@ -242,7 +240,7 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 	status = gpio_request(board->det_pin, "cf_det");
 	if (status < 0)
 		goto fail0;
-	status = request_irq(gpio_to_irq(board->det_pin), at91_cf_irq, 0, driver_name, cf);
+	status = request_irq(gpio_to_irq(board->det_pin), at91_cf_irq, 0, "at91_cf detect", cf);
 	if (status < 0)
 		goto fail00;
 	device_init_wakeup(&pdev->dev, 1);
@@ -268,7 +266,7 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 		if (status < 0)
 			goto fail0c;
 		status = request_irq(gpio_to_irq(board->irq_pin), at91_cf_irq,
-				IRQF_SHARED, driver_name, cf);
+				IRQF_SHARED, "at91_cf", cf);
 		if (status < 0)
 			goto fail0d;
 		cf->socket.pci_irq = gpio_to_irq(board->irq_pin);
@@ -284,12 +282,12 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 	}
 
 	/* reserve chip-select regions */
-	if (!request_mem_region(io->start, resource_size(io), driver_name)) {
+	if (!request_mem_region(io->start, resource_size(io), "at91_cf")) {
 		status = -ENXIO;
 		goto fail1;
 	}
 
-	pr_info("%s: irqs det #%d, io #%d\n", driver_name,
+	dev_info(&pdev->dev, "irqs det #%d, io #%d\n",
 		gpio_to_irq(board->det_pin), gpio_to_irq(board->irq_pin));
 
 	cf->socket.owner = THIS_MODULE;
@@ -391,7 +389,7 @@ static int at91_cf_resume(struct platform_device *pdev)
 
 static struct platform_driver at91_cf_driver = {
 	.driver = {
-		.name		= (char *) driver_name,
+		.name		= "at91_cf",
 		.owner		= THIS_MODULE,
 	},
 	.remove		= __exit_p(at91_cf_remove),
-- 
1.8.0

