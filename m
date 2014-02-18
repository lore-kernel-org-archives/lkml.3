Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaBRWrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:47:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaBRWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.13 03/40] crypto: s390 - fix concurrency issue in aes-ctr mode
Date: Tue, 18 Feb 2014 14:47:04 -0800
Message-Id: <20140218224433.435115576@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.vnet.ibm.com>

commit 0519e9ad89e5cd6e6b08398f57c6a71d9580564c upstream.

The aes-ctr mode uses one preallocated page without any concurrency
protection. When multiple threads run aes-ctr encryption or decryption
this can lead to data corruption.

The patch introduces locking for the page and a fallback solution with
slower en/decryption performance in concurrency situations.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/crypto/aes_s390.c |   65 +++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 19 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/spinlock.h>
 #include "crypt_s390.h"
 
 #define AES_KEYLEN_128		1
@@ -32,6 +33,7 @@
 #define AES_KEYLEN_256		4
 
 static u8 *ctrblk;
+static DEFINE_SPINLOCK(ctrblk_lock);
 static char keylen_flag;
 
 struct s390_aes_ctx {
@@ -758,43 +760,67 @@ static int ctr_aes_set_key(struct crypto
 	return aes_set_key(tfm, in_key, key_len);
 }
 
+static unsigned int __ctrblk_init(u8 *ctrptr, unsigned int nbytes)
+{
+	unsigned int i, n;
+
+	/* only use complete blocks, max. PAGE_SIZE */
+	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(AES_BLOCK_SIZE - 1);
+	for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
+		memcpy(ctrptr + i, ctrptr + i - AES_BLOCK_SIZE,
+		       AES_BLOCK_SIZE);
+		crypto_inc(ctrptr + i, AES_BLOCK_SIZE);
+	}
+	return n;
+}
+
 static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 			 struct s390_aes_ctx *sctx, struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt_block(desc, walk, AES_BLOCK_SIZE);
-	unsigned int i, n, nbytes;
-	u8 buf[AES_BLOCK_SIZE];
-	u8 *out, *in;
+	unsigned int n, nbytes;
+	u8 buf[AES_BLOCK_SIZE], ctrbuf[AES_BLOCK_SIZE];
+	u8 *out, *in, *ctrptr = ctrbuf;
 
 	if (!walk->nbytes)
 		return ret;
 
-	memcpy(ctrblk, walk->iv, AES_BLOCK_SIZE);
+	if (spin_trylock(&ctrblk_lock))
+		ctrptr = ctrblk;
+
+	memcpy(ctrptr, walk->iv, AES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		while (nbytes >= AES_BLOCK_SIZE) {
-			/* only use complete blocks, max. PAGE_SIZE */
-			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
-						 nbytes & ~(AES_BLOCK_SIZE - 1);
-			for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
-				memcpy(ctrblk + i, ctrblk + i - AES_BLOCK_SIZE,
-				       AES_BLOCK_SIZE);
-				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
-			}
-			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
-			if (ret < 0 || ret != n)
+			if (ctrptr == ctrblk)
+				n = __ctrblk_init(ctrptr, nbytes);
+			else
+				n = AES_BLOCK_SIZE;
+			ret = crypt_s390_kmctr(func, sctx->key, out, in,
+					       n, ctrptr);
+			if (ret < 0 || ret != n) {
+				if (ctrptr == ctrblk)
+					spin_unlock(&ctrblk_lock);
 				return -EIO;
+			}
 			if (n > AES_BLOCK_SIZE)
-				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
+				memcpy(ctrptr, ctrptr + n - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
-			crypto_inc(ctrblk, AES_BLOCK_SIZE);
+			crypto_inc(ctrptr, AES_BLOCK_SIZE);
 			out += n;
 			in += n;
 			nbytes -= n;
 		}
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	}
+	if (ctrptr == ctrblk) {
+		if (nbytes)
+			memcpy(ctrbuf, ctrptr, AES_BLOCK_SIZE);
+		else
+			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
+		spin_unlock(&ctrblk_lock);
+	}
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
@@ -802,14 +828,15 @@ static int ctr_aes_crypt(struct blkciphe
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
-				       AES_BLOCK_SIZE, ctrblk);
+				       AES_BLOCK_SIZE, ctrbuf);
 		if (ret < 0 || ret != AES_BLOCK_SIZE)
 			return -EIO;
 		memcpy(out, buf, nbytes);
-		crypto_inc(ctrblk, AES_BLOCK_SIZE);
+		crypto_inc(ctrbuf, AES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
+		memcpy(walk->iv, ctrbuf, AES_BLOCK_SIZE);
 	}
-	memcpy(walk->iv, ctrblk, AES_BLOCK_SIZE);
+
 	return ret;
 }
 


