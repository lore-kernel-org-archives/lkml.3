Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138AbaGOXPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:15:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899AbaGOXOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cristian Stoica <cristian.stoica@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.15 34/84] crypto: caam - fix memleak in caam_jr module
Date: Tue, 15 Jul 2014 16:17:31 -0700
Message-Id: <20140715231714.229649438@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Stoica <cristian.stoica@freescale.com>

commit 0378c9a855bfa395f595fbfb049707093e270f69 upstream.

This patch fixes a memory leak that appears when caam_jr module is unloaded.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/jr.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -453,8 +453,8 @@ static int caam_jr_probe(struct platform
 	int error;
 
 	jrdev = &pdev->dev;
-	jrpriv = kmalloc(sizeof(struct caam_drv_private_jr),
-			 GFP_KERNEL);
+	jrpriv = devm_kmalloc(jrdev, sizeof(struct caam_drv_private_jr),
+			      GFP_KERNEL);
 	if (!jrpriv)
 		return -ENOMEM;
 
@@ -487,10 +487,8 @@ static int caam_jr_probe(struct platform
 
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
-	if (error) {
-		kfree(jrpriv);
+	if (error)
 		return error;
-	}
 
 	jrpriv->dev = jrdev;
 	spin_lock(&driver_data.jr_alloc_lock);


