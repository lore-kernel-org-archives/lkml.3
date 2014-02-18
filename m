Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaBRWwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:52:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaBRWra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.13 05/40] crypto: s390 - fix des and des3_ede ctr concurrency issue
Date: Tue, 18 Feb 2014 14:47:06 -0800
Message-Id: <20140218224433.489877282@linuxfoundation.org>
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

commit ee97dc7db4cbda33e4241c2d85b42d1835bc8a35 upstream.

In s390 des and 3des ctr mode there is one preallocated page
used to speed up the en/decryption. This page is not protected
against concurrent usage and thus there is a potential of data
corruption with multiple threads.

The fix introduces locking/unlocking the ctr page and a slower
fallback solution at concurrency situations.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/crypto/des_s390.c |   69 ++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 21 deletions(-)

--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -25,6 +25,7 @@
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
 
 static u8 *ctrblk;
+static DEFINE_SPINLOCK(ctrblk_lock);
 
 struct s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
@@ -368,54 +369,80 @@ static struct crypto_alg cbc_des3_alg =
 	}
 };
 
+static unsigned int __ctrblk_init(u8 *ctrptr, unsigned int nbytes)
+{
+	unsigned int i, n;
+
+	/* align to block size, max. PAGE_SIZE */
+	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(DES_BLOCK_SIZE - 1);
+	for (i = DES_BLOCK_SIZE; i < n; i += DES_BLOCK_SIZE) {
+		memcpy(ctrptr + i, ctrptr + i - DES_BLOCK_SIZE, DES_BLOCK_SIZE);
+		crypto_inc(ctrptr + i, DES_BLOCK_SIZE);
+	}
+	return n;
+}
+
 static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
-			    struct s390_des_ctx *ctx, struct blkcipher_walk *walk)
+			    struct s390_des_ctx *ctx,
+			    struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt_block(desc, walk, DES_BLOCK_SIZE);
-	unsigned int i, n, nbytes;
-	u8 buf[DES_BLOCK_SIZE];
-	u8 *out, *in;
+	unsigned int n, nbytes;
+	u8 buf[DES_BLOCK_SIZE], ctrbuf[DES_BLOCK_SIZE];
+	u8 *out, *in, *ctrptr = ctrbuf;
+
+	if (!walk->nbytes)
+		return ret;
 
-	memcpy(ctrblk, walk->iv, DES_BLOCK_SIZE);
+	if (spin_trylock(&ctrblk_lock))
+		ctrptr = ctrblk;
+
+	memcpy(ctrptr, walk->iv, DES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		while (nbytes >= DES_BLOCK_SIZE) {
-			/* align to block size, max. PAGE_SIZE */
-			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
-				nbytes & ~(DES_BLOCK_SIZE - 1);
-			for (i = DES_BLOCK_SIZE; i < n; i += DES_BLOCK_SIZE) {
-				memcpy(ctrblk + i, ctrblk + i - DES_BLOCK_SIZE,
-				       DES_BLOCK_SIZE);
-				crypto_inc(ctrblk + i, DES_BLOCK_SIZE);
-			}
-			ret = crypt_s390_kmctr(func, ctx->key, out, in, n, ctrblk);
-			if (ret < 0 || ret != n)
+			if (ctrptr == ctrblk)
+				n = __ctrblk_init(ctrptr, nbytes);
+			else
+				n = DES_BLOCK_SIZE;
+			ret = crypt_s390_kmctr(func, ctx->key, out, in,
+					       n, ctrptr);
+			if (ret < 0 || ret != n) {
+				if (ctrptr == ctrblk)
+					spin_unlock(&ctrblk_lock);
 				return -EIO;
+			}
 			if (n > DES_BLOCK_SIZE)
-				memcpy(ctrblk, ctrblk + n - DES_BLOCK_SIZE,
+				memcpy(ctrptr, ctrptr + n - DES_BLOCK_SIZE,
 				       DES_BLOCK_SIZE);
-			crypto_inc(ctrblk, DES_BLOCK_SIZE);
+			crypto_inc(ctrptr, DES_BLOCK_SIZE);
 			out += n;
 			in += n;
 			nbytes -= n;
 		}
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	}
-
+	if (ctrptr == ctrblk) {
+		if (nbytes)
+			memcpy(ctrbuf, ctrptr, DES_BLOCK_SIZE);
+		else
+			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
+		spin_unlock(&ctrblk_lock);
+	}
 	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, ctx->key, buf, in,
-				       DES_BLOCK_SIZE, ctrblk);
+				       DES_BLOCK_SIZE, ctrbuf);
 		if (ret < 0 || ret != DES_BLOCK_SIZE)
 			return -EIO;
 		memcpy(out, buf, nbytes);
-		crypto_inc(ctrblk, DES_BLOCK_SIZE);
+		crypto_inc(ctrbuf, DES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
+		memcpy(walk->iv, ctrbuf, DES_BLOCK_SIZE);
 	}
-	memcpy(walk->iv, ctrblk, DES_BLOCK_SIZE);
 	return ret;
 }
 


