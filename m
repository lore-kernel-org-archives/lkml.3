Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaHHL3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:29:00 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:58356
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756158AbaHHL2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:28:55 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 3/3] crypto: testmgr.c: delay execution of set-up code
Date: Fri, 8 Aug 2014 14:27:52 +0300
Message-ID: <1407497272-9161-3-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
References: <53E496E4.9070207@freescale.com>
 <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(102836001)(229853001)(48376002)(104166001)(19580395003)(97736001)(33646002)(104016003)(50466002)(68736004)(81542001)(84676001)(6806004)(83322001)(19580405001)(106466001)(4396001)(44976005)(62966002)(50226001)(85852003)(83072002)(105606002)(93916002)(92726001)(95666004)(47776003)(86362001)(89996001)(64706001)(81342001)(88136002)(20776003)(92566001)(87936001)(21056001)(36756003)(99396002)(50986999)(76176999)(74662001)(77156001)(31966008)(74502001)(26826002)(87286001)(79102001)(107046002)(77982001)(85306004)(80022001)(46102001)(76482001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0609;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare IV array only if the dependent code is executed.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 36f45ff..365f8a3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -969,16 +969,15 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
+		if (template[i].np && !template[i].also_non_np)
+			continue;
+
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, MAX_IVLEN);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-		if (template[i].np && !template[i].also_non_np)
-			continue;
-
 		j++;
-
 		ret = -EINVAL;
 		if (WARN_ON(align_offset + template[i].ilen > PAGE_SIZE))
 			goto out;
@@ -1046,16 +1045,15 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		if (align_offset != 0)
 			break;
 
+		if (!template[i].np)
+			continue;
+
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, MAX_IVLEN);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-		if (!template[i].np)
-			continue;
-
 		j++;
-
 		crypto_ablkcipher_clear_flags(tfm, ~0);
 		if (template[i].wk)
 			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-- 
1.8.3.1

