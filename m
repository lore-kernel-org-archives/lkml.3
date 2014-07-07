Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaGGIxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:53:16 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:46718
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751399AbaGGIxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:53:14 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ruchika Gupta <ruchika.gupta@freescale.com>,
        Garg Vakul-B16394 <vakul@freescale.com>,
        Cristian Stoica <cristian.stoica@freescale.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] crypto: caam - fix memleak in caam_jr module
Date: Mon, 7 Jul 2014 11:52:41 +0300
Message-ID: <1404723161-30180-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(26826002)(21056001)(33646001)(102836001)(4396001)(85306003)(80022001)(20776003)(64706001)(47776003)(50466002)(62966002)(104166001)(46102001)(77982001)(79102001)(76482001)(88136002)(19580405001)(19580395003)(83322001)(87936001)(106466001)(87286001)(84676001)(36756003)(68736004)(69596002)(44976005)(6806004)(95666004)(104016002)(107046002)(99396002)(50986999)(81156004)(105606002)(92726001)(92566001)(86362001)(50226001)(85852003)(89996001)(77156001)(83072002)(110136001)(97736001)(229853001)(81342001)(93916002)(31966008)(74662001)(48376002)(74502001)(81542001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB468;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak that appears when caam_jr module is unloaded.

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
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
1.8.3.1

