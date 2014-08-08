Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaHHJbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:31:19 -0400
Received: from [207.46.163.210] ([207.46.163.210]:42844 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756005AbaHHJbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:31:14 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: testmgr.c: remove unused function argument
Date: Fri, 8 Aug 2014 12:30:04 +0300
Message-ID: <1407490204-1438-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(74662001)(95666004)(31966008)(74502001)(64706001)(81342001)(88136002)(81542001)(50986999)(84676001)(77156001)(26826002)(97736001)(47776003)(89996001)(83072002)(20776003)(76482001)(85852003)(93916002)(48376002)(87286001)(229853001)(107046002)(4396001)(80022001)(50226001)(92566001)(92726001)(50466002)(86362001)(6806004)(44976005)(83322001)(19580395003)(19580405001)(21056001)(46102001)(68736004)(102836001)(33646002)(106466001)(79102001)(62966002)(105606002)(36756003)(99396002)(87936001)(104166001)(77982001)(104016003)(85306004);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0610;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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

The argument "req" of do_one_async_hash_op is not used by the
function. This patch removes this argument and renames the
function to match more closely its purpose.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ac2b631..ca70ae8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -178,9 +178,7 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 		free_page((unsigned long)buf[i]);
 }
 
-static int do_one_async_hash_op(struct ahash_request *req,
-				struct tcrypt_result *tr,
-				int ret)
+static int wait_async_op(struct tcrypt_result *tr, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
 		ret = wait_for_completion_interruptible(&tr->completion);
@@ -264,30 +262,26 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 		ahash_request_set_crypt(req, sg, result, template[i].psize);
 		if (use_digest) {
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_digest(req));
+			ret = wait_async_op(&tresult, crypto_ahash_digest(req));
 			if (ret) {
 				pr_err("alg: hash: digest failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
 		} else {
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_init(req));
+			ret = wait_async_op(&tresult, crypto_ahash_init(req));
 			if (ret) {
 				pr_err("alt: hash: init failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_update(req));
+			ret = wait_async_op(&tresult, crypto_ahash_update(req));
 			if (ret) {
 				pr_err("alt: hash: update failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
 				goto out;
 			}
-			ret = do_one_async_hash_op(req, &tresult,
-						   crypto_ahash_final(req));
+			ret = wait_async_op(&tresult, crypto_ahash_final(req));
 			if (ret) {
 				pr_err("alt: hash: final failed on test %d "
 				       "for %s: ret=%d\n", j, algo, -ret);
-- 
1.8.3.1

