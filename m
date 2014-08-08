Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaHHVAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:00:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155AbaHHUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cristian Stoica <cristian.stoica@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/259] crypto: caam - fix memleak in caam_jr module
Date: Fri,  8 Aug 2014 13:38:33 -0700
Message-Id: <1407530482-4483-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Stoica <cristian.stoica@freescale.com>

commit 0378c9a855bfa395f595fbfb049707093e270f69 upstream.

This patch fixes a memory leak that appears when caam_jr module is unloaded.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/crypto/caam/jr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1d80bd3..b512a4b 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -453,8 +453,8 @@ static int caam_jr_probe(struct platform_device *pdev)
 	int error;
 
 	jrdev = &pdev->dev;
-	jrpriv = kmalloc(sizeof(struct caam_drv_private_jr),
-			 GFP_KERNEL);
+	jrpriv = devm_kmalloc(jrdev, sizeof(struct caam_drv_private_jr),
+			      GFP_KERNEL);
 	if (!jrpriv)
 		return -ENOMEM;
 
@@ -487,10 +487,8 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
-	if (error) {
-		kfree(jrpriv);
+	if (error)
 		return error;
-	}
 
 	jrpriv->dev = jrdev;
 	spin_lock(&driver_data.jr_alloc_lock);
-- 
1.9.1

