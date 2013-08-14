Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802Ab3HNJPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:15:40 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4384 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197Ab3HNJLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:44 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908325"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Santosh Y <santoshsy@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/29] drivers/scsi/ufs/ufshcd-pltfrm.c: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:18 +0200
Message-Id: <1376471493-22215-15-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

A debugging statement in the error-handling code is removed as well, as it
doesn't seem to give any more information than devm_ioremap_resource
already gives.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/ufs/ufshcd-pltfrm.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index c42db40..ea699b9 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -102,15 +102,8 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		dev_err(dev, "Memory resource not available\n");
-		err = -ENODEV;
-		goto out;
-	}
-
 	mmio_base = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(mmio_base)) {
-		dev_err(dev, "memory map failed\n");
 		err = PTR_ERR(mmio_base);
 		goto out;
 	}

