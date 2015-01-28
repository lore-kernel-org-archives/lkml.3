Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507AbbA1CQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:16:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376AbbA1B2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 22/32] sata_dwc_460ex: fix resource leak on error path
Date: Tue, 27 Jan 2015 17:26:52 -0800
Message-Id: <20150128012630.291811510@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 4aaa71873ddb9faf4b0c4826579e2f6d18ff9ab4 upstream.

DMA mapped IO should be unmapped on the error path in probe() and
unconditionally on remove().

Fixes: 62936009f35a ([libata] Add 460EX on-chip SATA driver, sata_dwc_460ex)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_dwc_460ex.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -797,7 +797,7 @@ static int dma_dwc_init(struct sata_dwc_
 	if (err) {
 		dev_err(host_pvt.dwc_dev, "%s: dma_request_interrupts returns"
 			" %d\n", __func__, err);
-		goto error_out;
+		return err;
 	}
 
 	/* Enabe DMA */
@@ -808,11 +808,6 @@ static int dma_dwc_init(struct sata_dwc_
 		sata_dma_regs);
 
 	return 0;
-
-error_out:
-	dma_dwc_exit(hsdev);
-
-	return err;
 }
 
 static int sata_dwc_scr_read(struct ata_link *link, unsigned int scr, u32 *val)
@@ -1662,7 +1657,7 @@ static int sata_dwc_probe(struct platfor
 	char *ver = (char *)&versionr;
 	u8 *base = NULL;
 	int err = 0;
-	int irq, rc;
+	int irq;
 	struct ata_host *host;
 	struct ata_port_info pi = sata_dwc_port_info[0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -1725,7 +1720,7 @@ static int sata_dwc_probe(struct platfor
 	if (irq == NO_IRQ) {
 		dev_err(&ofdev->dev, "no SATA DMA irq\n");
 		err = -ENODEV;
-		goto error_out;
+		goto error_iomap;
 	}
 
 	/* Get physical SATA DMA register base address */
@@ -1734,14 +1729,16 @@ static int sata_dwc_probe(struct platfor
 		dev_err(&ofdev->dev, "ioremap failed for AHBDMA register"
 			" address\n");
 		err = -ENODEV;
-		goto error_out;
+		goto error_iomap;
 	}
 
 	/* Save dev for later use in dev_xxx() routines */
 	host_pvt.dwc_dev = &ofdev->dev;
 
 	/* Initialize AHB DMAC */
-	dma_dwc_init(hsdev, irq);
+	err = dma_dwc_init(hsdev, irq);
+	if (err)
+		goto error_dma_iomap;
 
 	/* Enable SATA Interrupts */
 	sata_dwc_enable_interrupts(hsdev);
@@ -1759,9 +1756,8 @@ static int sata_dwc_probe(struct platfor
 	 * device discovery process, invoking our port_start() handler &
 	 * error_handler() to execute a dummy Softreset EH session
 	 */
-	rc = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
-
-	if (rc != 0)
+	err = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
+	if (err)
 		dev_err(&ofdev->dev, "failed to activate host");
 
 	dev_set_drvdata(&ofdev->dev, host);
@@ -1770,7 +1766,8 @@ static int sata_dwc_probe(struct platfor
 error_out:
 	/* Free SATA DMA resources */
 	dma_dwc_exit(hsdev);
-
+error_dma_iomap:
+	iounmap((void __iomem *)host_pvt.sata_dma_regs);
 error_iomap:
 	iounmap(base);
 error_kmalloc:
@@ -1791,6 +1788,7 @@ static int sata_dwc_remove(struct platfo
 	/* Free SATA DMA resources */
 	dma_dwc_exit(hsdev);
 
+	iounmap((void __iomem *)host_pvt.sata_dma_regs);
 	iounmap(hsdev->reg_base);
 	kfree(hsdev);
 	kfree(host);


