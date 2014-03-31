Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaCaRyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:54:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25408 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaCaRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:54:18 -0400
Date: Mon, 31 Mar 2014 19:53:56 +0200
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] pata_octeon_cf: fix ata_host_activate() failure handling
To: Tejun Heo <tj@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-ide@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <5439252.0G82yiBcdS@amdc1032>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7Bit
X-AuditID: cbfee61a-b7fb26d00000724f-a6-5339abc8a298
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jQd0Tqy2DDT691bc4tuMRk8XlXXPY
	LDo3bWW0uLRHxeLX8qOMDqwem1Z1snkcXbmWyePzJrkA5igum5TUnMyy1CJ9uwSujG8PlzEW
	7OCouDNzCmsDYxN7FyMnh4SAicSGhTPZIGwxiQv31gPZXBxCAtMZJc486GOBcFqYJL6v/soK
	UsUmYCUxsX0VI4gtIiArcWXaQzCbWaBW4t/CjUBTOTiEBTwlHv8NAwmzCKhK3D7wBizMK6AJ
	NCYVJCwKVLFj+0qwvbwCghI/Jt9jgZgiL7Fv/1RWCFtLYv3O40wTGPlmISmbhaRsFpKyBYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCA/GZ1A7GlQ0WhxgFOBiVeHgtyi2DhVgTy4or
	cw8xSnAwK4nwbl0AFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbL
	xMEp1cC4/1aCN6MHz4buRqVVk1QTLm5Uvrjm/Z55gbPE79lZNq3faZYd4lV7dW2yhtwurq1u
	h7vfPrW/sHbW1oeSj/6mzBWJz3P2X76de/p6NtYP0V/Zz0hrVNktkRaaefSS8on0t7P1I2c3
	/7DRudxlK2I24dS1VNNmsWURgfPslUTvPZPmt07V+KapxFKckWioxVxUnAgA7vM8BkACAAA=
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing kfree() call to ata_host_activate() failure path.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/pata_octeon_cf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: b/drivers/ata/pata_octeon_cf.c
===================================================================
--- a/drivers/ata/pata_octeon_cf.c	2014-03-14 16:45:04.320724377 +0100
+++ b/drivers/ata/pata_octeon_cf.c	2014-03-31 18:58:44.367604046 +0200
@@ -1020,13 +1020,16 @@ static int octeon_cf_probe(struct platfo
 
 	ata_port_desc(ap, "cmd %p ctl %p", base, ap->ioaddr.ctl_addr);
 
-
 	dev_info(&pdev->dev, "version " DRV_VERSION" %d bit%s.\n",
 		 is_16bit ? 16 : 8,
 		 cf_port->is_true_ide ? ", True IDE" : "");
 
-	return ata_host_activate(host, irq, irq_handler,
-				 IRQF_SHARED, &octeon_cf_sht);
+	rv = ata_host_activate(host, irq, irq_handler,
+			       IRQF_SHARED, &octeon_cf_sht);
+	if (rv)
+		goto free_cf_port;
+
+	return 0;
 
 free_cf_port:
 	kfree(cf_port);

