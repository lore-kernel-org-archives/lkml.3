Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaDNQ2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:28:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57996 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaDNQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:28:51 -0400
Date: Mon, 14 Apr 2014 18:28:37 +0200
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] pata_octeon_cf: use devm_kzalloc() to allocate cf_port
To: Tejun Heo <tj@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, David Daney <david.daney@cavium.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1927612.nfmGqcZdLy@amdc1032>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7Bit
X-AuditID: cbfee61a-b7fb26d00000724f-7d-534c0cc12d5b
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd2DPD7BBh0t2hb7ew8zWxzb8YjJ
	4vKuOWwWnZu2Mlo8WXiGyeLSHhWLX8uPMjqwe8z4vYjFY9OqTjaPoyvXMnns/N7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxsEtD9gL1stUTHj+hrmBcZlYFyMHh4SAicTEBy5djJxAppjEhXvr
	2boYuTiEBBYxStxtXg3ltDBJfDvzggWkik3ASmJi+ypGEFtEQFbiyrSHjCBFzAInGSX2nT7M
	DpIQFnCXWL7hLDOIzSKgKvH03VuwZl4BTYkDhy6zgtiiAp4SO7avZIOIC0r8mHwPrIZZQF5i
	3/6prBC2lsT6nceZJjDyzUJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BAftM6kdjCsbLA4xCnAwKvHwTnjnHSzEmlhWXJl7iFGCg1lJhNd1K1CINyWxsiq1KD++qDQn
	tfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDYyfnxn/1GibOX4ya+uXmuT6vqBDY
	/XfPgW2GQve86kLX2K3YLfb6zLTHbb8WTdoxZe4pBo/nifNmdmrvmuVVuG0567zCOtfIyKO2
	r1+/Ukuec6srvb7ggtdM4WvSWYZhe7USptZISn+Xr7H1++a4zju0S/rxjsADPLITWO/lH/Z7
	/m7SEb18JSWW4oxEQy3mouJEAJ5AKcJWAgAA
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a nice side effect this fixes the cf_port leak on
dma_coerce_mask_and_coherent() or ata_host_activate()
failure.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/ata/pata_octeon_cf.c |   50 ++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

Index: b/drivers/ata/pata_octeon_cf.c
===================================================================
--- a/drivers/ata/pata_octeon_cf.c	2014-04-14 18:07:45.952340776 +0200
+++ b/drivers/ata/pata_octeon_cf.c	2014-04-14 18:23:58.000359028 +0200
@@ -865,7 +865,7 @@ static int octeon_cf_probe(struct platfo
 	if (node == NULL)
 		return -EINVAL;
 
-	cf_port = kzalloc(sizeof(*cf_port), GFP_KERNEL);
+	cf_port = devm_kzalloc(&pdev->dev, sizeof(*cf_port), GFP_KERNEL);
 	if (!cf_port)
 		return -ENOMEM;
 
@@ -881,10 +881,9 @@ static int octeon_cf_probe(struct platfo
 	n_size = of_n_size_cells(node);
 
 	reg_prop = of_find_property(node, "reg", &reg_len);
-	if (!reg_prop || reg_len < sizeof(__be32)) {
-		rv = -EINVAL;
-		goto free_cf_port;
-	}
+	if (!reg_prop || reg_len < sizeof(__be32))
+		return -EINVAL;
+
 	cs_num = reg_prop->value;
 	cf_port->cs0 = be32_to_cpup(cs_num);
 
@@ -901,16 +900,13 @@ static int octeon_cf_probe(struct platfo
 				res_dma = platform_get_resource(dma_dev, IORESOURCE_MEM, 0);
 				if (!res_dma) {
 					of_node_put(dma_node);
-					rv = -EINVAL;
-					goto free_cf_port;
+					return -EINVAL;
 				}
 				cf_port->dma_base = (u64)devm_ioremap_nocache(&pdev->dev, res_dma->start,
 									 resource_size(res_dma));
-
 				if (!cf_port->dma_base) {
 					of_node_put(dma_node);
-					rv = -EINVAL;
-					goto free_cf_port;
+					return -EINVAL;
 				}
 
 				irq_handler = octeon_cf_interrupt;
@@ -921,41 +917,34 @@ static int octeon_cf_probe(struct platfo
 			of_node_put(dma_node);
 		}
 		res_cs1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (!res_cs1) {
-			rv = -EINVAL;
-			goto free_cf_port;
-		}
+		if (!res_cs1)
+			return -EINVAL;
+
 		cs1 = devm_ioremap_nocache(&pdev->dev, res_cs1->start,
 					   resource_size(res_cs1));
-
 		if (!cs1)
-			goto free_cf_port;
+			return rv;
+
+		if (reg_len < (n_addr + n_size + 1) * sizeof(__be32))
+			return -EINVAL;
 
-		if (reg_len < (n_addr + n_size + 1) * sizeof(__be32)) {
-			rv = -EINVAL;
-			goto free_cf_port;
-		}
 		cs_num += n_addr + n_size;
 		cf_port->cs1 = be32_to_cpup(cs_num);
 	}
 
 	res_cs0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	if (!res_cs0) {
-		rv = -EINVAL;
-		goto free_cf_port;
-	}
+	if (!res_cs0)
+		return -EINVAL;
 
 	cs0 = devm_ioremap_nocache(&pdev->dev, res_cs0->start,
 				   resource_size(res_cs0));
-
 	if (!cs0)
-		goto free_cf_port;
+		return rv;
 
 	/* allocate host */
 	host = ata_host_alloc(&pdev->dev, 1);
 	if (!host)
-		goto free_cf_port;
+		return rv;
 
 	ap = host->ports[0];
 	ap->private_data = cf_port;
@@ -1020,17 +1009,12 @@ static int octeon_cf_probe(struct platfo
 
 	ata_port_desc(ap, "cmd %p ctl %p", base, ap->ioaddr.ctl_addr);
 
-
 	dev_info(&pdev->dev, "version " DRV_VERSION" %d bit%s.\n",
 		 is_16bit ? 16 : 8,
 		 cf_port->is_true_ide ? ", True IDE" : "");
 
 	return ata_host_activate(host, irq, irq_handler,
 				 IRQF_SHARED, &octeon_cf_sht);
-
-free_cf_port:
-	kfree(cf_port);
-	return rv;
 }
 
 static void octeon_cf_shutdown(struct device *dev)

