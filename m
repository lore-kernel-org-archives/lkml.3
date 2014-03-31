Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaCaRvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:51:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36327 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaCaRvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:51:36 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-9e-5339ab273e08
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pata_at91: fix ata_host_activate() failure handling
Date: Mon, 31 Mar 2014 19:51:14 +0200
Message-id: <3354637.ASvWtLs5Rq@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jQV311ZbBBs/2K1lsenyN1eLYjkdM
	Fpd3zWGzWL7iKbPFt8vN7BbrHr5gsvi1/CijA7vHgl9bWTxeXbjD4rFpVSebx+Yl9R4Tb09j
	8fi8SS6ALYrLJiU1J7MstUjfLoEr49jM2YwF7ZwVt/93szcwXmXvYuTgkBAwkeh/L9nFyAlk
	iklcuLeerYuRi0NIYDqjxP1nvawQTguTxILZO5hBqtgErCQmtq9iBLFFBGQlrkx7yAhSxCzw
	gVHi4YZ1YAlhAReJ7TdvMIHYLAKqEmf/PmAF2cYroCnxtccFJCwq4CmxY/tKNhCbV0BQ4sfk
	eywgNrOAvMS+/VNZIWwtifU7jzNNYOSbhaRsFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIDt5n0jsYVzVYHGIU4GBU4uG1KLcMFmJNLCuuzD3EKMHBrCTCu3UBUIg3JbGy
	KrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAOj124jSxv/Iml36aSy
	VXXRn74c/lFRtyqkV//V3eJPcjr3T0eY/KpOv9KSmZh3S1tj+wX9N9n7dpydfV8hJS3N5ug7
	uV3FOfpnP23c3rhgauS+3nDWj+1XMv6lspn/YClb4Ntd1aoV8lhR9t+zoALd7MuH2HYV+LAc
	2bZqPXeErc3aS1bNBw8rsRRnJBpqMRcVJwIAn3s2oFoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing clk_put() call to ata_host_activate() failure path.

Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/pata_at91.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: b/drivers/ata/pata_at91.c
===================================================================
--- a/drivers/ata/pata_at91.c	2014-03-14 16:45:04.196724381 +0100
+++ b/drivers/ata/pata_at91.c	2014-03-31 17:46:40.127677782 +0200
@@ -407,12 +407,13 @@ static int pata_at91_probe(struct platfo
 
 	host->private_data = info;
 
-	return ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
-			gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
-			irq_flags, &pata_at91_sht);
+	ret = ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
+				gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
+				irq_flags, &pata_at91_sht);
+	if (ret)
+		goto err_put;
 
-	if (!ret)
-		return 0;
+	return 0;
 
 err_put:
 	clk_put(info->mck);

