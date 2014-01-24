Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaAXWSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:18:17 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42124 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbaAXWSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:18:10 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z579ehzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZXF9U-08-47N-02
X-M-MSG: 
Subject: [PATCH 1/4] crypto: ccp - Allow for selective disablement of crypto
 API algorithms
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jan 2014 16:17:56 -0600
Message-ID: <20140124221756.1894.88768.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
References: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce module parameters that allow for disabling of a
crypto algorithm by not registering the algorithm with the
crypto API.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |   37 +++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 2636f04..b3f22b0 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/ccp.h>
@@ -24,6 +25,14 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
 MODULE_DESCRIPTION("AMD Cryptographic Coprocessor crypto API support");
 
+static unsigned int aes_disable;
+module_param(aes_disable, uint, 0444);
+MODULE_PARM_DESC(aes_disable, "Disable use of AES - any non-zero value");
+
+static unsigned int sha_disable;
+module_param(sha_disable, uint, 0444);
+MODULE_PARM_DESC(sha_disable, "Disable use of SHA - any non-zero value");
+
 
 /* List heads for the supported algorithms */
 static LIST_HEAD(hash_algs);
@@ -337,21 +346,25 @@ static int ccp_register_algs(void)
 {
 	int ret;
 
-	ret = ccp_register_aes_algs(&cipher_algs);
-	if (ret)
-		return ret;
+	if (!aes_disable) {
+		ret = ccp_register_aes_algs(&cipher_algs);
+		if (ret)
+			return ret;
 
-	ret = ccp_register_aes_cmac_algs(&hash_algs);
-	if (ret)
-		return ret;
+		ret = ccp_register_aes_cmac_algs(&hash_algs);
+		if (ret)
+			return ret;
 
-	ret = ccp_register_aes_xts_algs(&cipher_algs);
-	if (ret)
-		return ret;
+		ret = ccp_register_aes_xts_algs(&cipher_algs);
+		if (ret)
+			return ret;
+	}
 
-	ret = ccp_register_sha_algs(&hash_algs);
-	if (ret)
-		return ret;
+	if (!sha_disable) {
+		ret = ccp_register_sha_algs(&hash_algs);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }


