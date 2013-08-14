Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab3HNJNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:13:35 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57962
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932294Ab3HNJLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908335"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/29] drivers/remoteproc/da8xx_remoteproc.c: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:28 +0200
Message-Id: <1376471493-22215-25-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

Move the call to platform_get_resource adjacent to the call to
devm_ioremap_resource to make the connection between them more clear.

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
 drivers/remoteproc/da8xx_remoteproc.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/remoteproc/da8xx_remoteproc.c b/drivers/remoteproc/da8xx_remoteproc.c
index 129f7b9..bb41ee0 100644
--- a/drivers/remoteproc/da8xx_remoteproc.c
+++ b/drivers/remoteproc/da8xx_remoteproc.c
@@ -201,23 +201,11 @@ static int da8xx_rproc_probe(struct platform_device *pdev)
 	}
 
 	bootreg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!bootreg_res) {
-		dev_err(dev,
-			"platform_get_resource(IORESOURCE_MEM, 0): NULL\n");
-		return -EADDRNOTAVAIL;
-	}
-
-	chipsig_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!chipsig_res) {
-		dev_err(dev,
-			"platform_get_resource(IORESOURCE_MEM, 1): NULL\n");
-		return -EADDRNOTAVAIL;
-	}
-
 	bootreg = devm_ioremap_resource(dev, bootreg_res);
 	if (IS_ERR(bootreg))
 		return PTR_ERR(bootreg);
 
+	chipsig_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	chipsig = devm_ioremap_resource(dev, chipsig_res);
 	if (IS_ERR(chipsig))
 		return PTR_ERR(chipsig);

