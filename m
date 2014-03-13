Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaCMW7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:59:20 -0400
Received: from mailout.micron.com ([137.201.242.129]:38612 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaCMW7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:59:19 -0400
Message-ID: <532237F4.3010309@micron.com>
Date: Thu, 13 Mar 2014 15:57:56 -0700
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, <asamymuthupa@micron.com>
Subject: [PATCH] mtip32xx: switch to vmalloc() to mitigate high order allocation
 failures
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20564.002
X-TM-AS-Result: No--6.623500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mtip_port kmalloc() allocation is relatively high order, in particular since the recent doubling of the size of the scatterlist container.  The allocation has been shown to fail during SRSI under fragmented or low memory conditions.  Switching to vmalloc() mitigates the problem.  Converted both mtip_port and driver_data allocations for consistency.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 624e9d9..f55e3e5 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3116,7 +3116,7 @@ static int mtip_free_orphan(struct driver_data *dd)
 			dd->queue = NULL;
 		}
 	}
-	kfree(dd);
+	vfree(dd);
 	return 0;
 }
 
@@ -3495,8 +3495,7 @@ static int mtip_hw_init(struct driver_data *dd)
 
 	hba_setup(dd);
 
-	dd->port = kzalloc_node(sizeof(struct mtip_port), GFP_KERNEL,
-				dd->numa_node);
+	dd->port = vzalloc_node(sizeof(struct mtip_port), dd->numa_node);
 	if (!dd->port) {
 		dev_err(&dd->pdev->dev,
 			"Memory allocation: port structure\n");
@@ -3680,7 +3679,7 @@ out2:
 
 out1:
 	/* Free the memory allocated for the for structure. */
-	kfree(dd->port);
+	vfree(dd->port);
 
 	return rv;
 }
@@ -3724,7 +3723,7 @@ static int mtip_hw_exit(struct driver_data *dd)
 	mtip_dma_free(dd);
 
 	/* Free the memory allocated for the for structure. */
-	kfree(dd->port);
+	vfree(dd->port);
 	dd->port = NULL;
 
 	return 0;
@@ -4512,7 +4511,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 		my_node, pcibus_to_node(pdev->bus), dev_to_node(&pdev->dev),
 		cpu_to_node(smp_processor_id()), smp_processor_id());
 
-	dd = kzalloc_node(sizeof(struct driver_data), GFP_KERNEL, my_node);
+	dd = vzalloc_node(sizeof(struct driver_data), my_node);
 	if (dd == NULL) {
 		dev_err(&pdev->dev,
 			"Unable to allocate memory for driver data\n");
@@ -4670,7 +4669,7 @@ setmask_err:
 	pcim_iounmap_regions(pdev, 1 << MTIP_ABAR);
 
 iomap_err:
-	kfree(dd);
+	vfree(dd);
 	pci_set_drvdata(pdev, NULL);
 	return rv;
 done:
@@ -4731,7 +4730,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&dev_lock, flags);
 
 	if (!dd->sr)
-		kfree(dd);
+		vfree(dd);
 	else
 		set_bit(MTIP_DDF_REMOVE_DONE_BIT, &dd->dd_flag);
 
