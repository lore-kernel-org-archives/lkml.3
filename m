Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaKLEcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:32:46 -0500
Received: from mail.eperm.de ([89.247.134.16]:54421 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaKLEcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:32:42 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marek Vasut <marex@denx.de>, "David S. Miller" <davem@davemloft.net>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "Joy M. Latten" <jmlatten@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 05/13] crypto: Documentation - hash data structures
Date: Wed, 12 Nov 2014 05:26:03 +0100
Message-ID: <4953641.UTgIXoZCd4@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hash data structures needed to be filled in by cipher developers are
documented.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/hash.h | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 74b13ec..bf458fc 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -17,6 +17,28 @@
 
 struct crypto_ahash;
 
+/**
+ * DOC: Message Digest Algorithm Definitions
+ *
+ * These data structures define modular message digest algorithm
+ * implementations, managed via crypto_register_ahash(),
+ * crypto_register_shash(), crypto_unregister_ahash() and
+ * crypto_unregister_shash().
+ */
+
+/**
+ * struct hash_alg_common - define properties of message digest
+ * @digestsize: Size of the result of the transformation. A buffer of this size
+ *	        must be available to the @final and @finup calls, so they can
+ *	        store the resulting hash into it. For various predefined sizes,
+ *	        search include/crypto/ using
+ *	        git grep _DIGEST_SIZE include/crypto.
+ * @statesize: Size of the block for partial state of the transformation. A
+ *	       buffer of this size must be passed to the @export function as it
+ *	       will save the partial state of the transformation into it. On the
+ *	       other side, the @import function will load the state from a
+ *	       buffer of this size as well.
+ */
 struct hash_alg_common {
 	unsigned int digestsize;
 	unsigned int statesize;
@@ -37,6 +59,62 @@ struct ahash_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+/**
+ * struct ahash_alg - asynchronous message digest definition
+ * @init: Initialize the transformation context. Intended only to initialize the
+ *	  state of the HASH transformation at the begining. This shall fill in
+ *	  the internal structures used during the entire duration of the whole
+ *	  transformation. No data processing happens at this point.
+ * @update: Push a chunk of data into the driver for transformation. This
+ *	   function actually pushes blocks of data from upper layers into the
+ *	   driver, which then passes those to the hardware as seen fit. This
+ *	   function must not finalize the HASH transformation by calculating the
+ *	   final message digest as this only adds more data into the
+ *	   transformation. This function shall not modify the transformation
+ *	   context, as this function may be called in parallel with the same
+ *	   transformation object. Data processing can happen synchronously
+ *	   [SHASH] or asynchronously [AHASH] at this point.
+ * @final: Retrieve result from the driver. This function finalizes the
+ *	   transformation and retrieves the resulting hash from the driver and
+ *	   pushes it back to upper layers. No data processing happens at this
+ *	   point.
+ * @finup: Combination of @update and @final. This function is effectively a
+ *	   combination of @update and @final calls issued in sequence. As some
+ *	   hardware cannot do @update and @final separately, this callback was
+ *	   added to allow such hardware to be used at least by IPsec. Data
+ *	   processing can happen synchronously [SHASH] or asynchronously [AHASH]
+ *	   at this point.
+ * @digest: Combination of @init and @update and @final. This function
+ *	    effectively behaves as the entire chain of operations, @init,
+ *	    @update and @final issued in sequence. Just like @finup, this was
+ *	    added for hardware which cannot do even the @finup, but can only do
+ *	    the whole transformation in one run. Data processing can happen
+ *	    synchronously [SHASH] or asynchronously [AHASH] at this point.
+ * @setkey: Set optional key used by the hashing algorithm. Intended to push
+ *	    optional key used by the hashing algorithm from upper layers into
+ *	    the driver. This function can store the key in the transformation
+ *	    context or can outright program it into the hardware. In the former
+ *	    case, one must be careful to program the key into the hardware at
+ *	    appropriate time and one must be careful that .setkey() can be
+ *	    called multiple times during the existence of the transformation
+ *	    object. Not  all hashing algorithms do implement this function as it
+ *	    is only needed for keyed message digests. SHAx/MDx/CRCx do NOT
+ *	    implement this function. HMAC(MDx)/HMAC(SHAx)/CMAC(AES) do implement
+ *	    this function. This function must be called before any other of the
+ *	    @init, @update, @final, @finup, @digest is called. No data
+ *	    processing happens at this point.
+ * @export: Export partial state of the transformation. This function dumps the
+ *	    entire state of the ongoing transformation into a provided block of
+ *	    data so it can be @import 'ed back later on. This is useful in case
+ *	    you want to save partial result of the transformation after
+ *	    processing certain amount of data and reload this partial result
+ *	    multiple times later on for multiple re-use. No data processing
+ *	    happens at this point.
+ * @import: Import partial state of the transformation. This function loads the
+ *	    entire state of the ongoing transformation from a provided block of
+ *	    data so the transformation can continue from this point onward. No
+ *	    data processing happens at this point.
+ */
 struct ahash_alg {
 	int (*init)(struct ahash_request *req);
 	int (*update)(struct ahash_request *req);
@@ -63,6 +141,23 @@ struct shash_desc {
 		crypto_shash_descsize(ctx)] CRYPTO_MINALIGN_ATTR; \
 	struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
 
+/**
+ * struct shash_alg - synchronous message digest definition
+ * @init: see struct ahash_alg
+ * @update: see struct ahash_alg
+ * @final: see struct ahash_alg
+ * @finup: see struct ahash_alg
+ * @digest: see struct ahash_alg
+ * @export: see struct ahash_alg
+ * @import: see struct ahash_alg
+ * @setkey: see struct ahash_alg
+ * @digestsize: see struct ahash_alg
+ * @statesize: see struct ahash_alg
+ * @dedcsize: Size of the operational state for the message digest. This state
+ * 	      size is the memory size that needs to be allocated for
+ *	      shash_desc.__ctx
+ * @base: internally used
+ */
 struct shash_alg {
 	int (*init)(struct shash_desc *desc);
 	int (*update)(struct shash_desc *desc, const u8 *data,
-- 
2.1.0


