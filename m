Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaKBUqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:46:05 -0500
Received: from mail.eperm.de ([89.247.134.16]:54209 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbaKBUnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:43:49 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 06/11] crypto: Documentation - documentation of crypto_alg
Date: Sun, 02 Nov 2014 21:38:55 +0100
Message-ID: <3999140.fjkrqlGA9E@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <6375771.bx7QqLJLuR@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of struct crypto_alg is documented for all parameters
that can be set by a developer of a transformation. All parameters that
are internal to the crypto API are marked as such.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 include/linux/crypto.h | 157 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 137 insertions(+), 20 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index d45e949..e1a84fd 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -277,22 +277,104 @@ struct rng_alg {
 #define cra_compress	cra_u.compress
 #define cra_rng		cra_u.rng
 
+/**
+ * The struct crypto_alg describes a generic Crypto API algorithm and is common
+ * for all of the transformations. The flags marked as internal shall not
+ * be set or modified by a transformation implementation.
+ */
 struct crypto_alg {
-	struct list_head cra_list;
-	struct list_head cra_users;
-
-	u32 cra_flags;
-	unsigned int cra_blocksize;
+	struct list_head cra_list; /** <Internal to the Crypto API */
+	struct list_head cra_users; /** <Internal to the Crypto API */
+
+	u32 cra_flags; /** <Flags describing this transformation. See
+			* include/linux/crypto.h CRYPTO_ALG_* flags for the
+			* flags which go in here. Those are used for
+			* fine-tuning the description of the transformation
+			* algorithm.
+			*/
+	unsigned int cra_blocksize; /** <Minimum block size of this
+				     * transformation. The size in bytes of the
+				     * smallest possible unit which
+				     * can be transformed with this algorithm.
+				     * The users must respect this value.
+				     * In case of HASH transformation, it is
+				     * possible for a smaller block than
+				     * .cra_blocksize to be passed to the
+				     * crypto API for transformation, in case
+				     * of any other transformation type, an
+				     * error will be returned upon any attempt
+				     * to transform smaller than .cra_blocksize
+				     * chunks.
+				     */
 	unsigned int cra_ctxsize;
-	unsigned int cra_alignmask;
-
-	int cra_priority;
-	atomic_t cra_refcnt;
-
-	char cra_name[CRYPTO_MAX_ALG_NAME];
-	char cra_driver_name[CRYPTO_MAX_ALG_NAME];
-
-	const struct crypto_type *cra_type;
+	unsigned int cra_alignmask; /** <Alignment mask for the input and
+				     * output data buffer. The data buffer
+				     * containing the input data for the
+				     * algorithm must be aligned to this
+				     * alignment mask. The data buffer for the
+				     * output data must be aligned to this
+				     * alignment mask. Note that the Crypto API
+				     * will do the re-alignment in software, but
+				     * only under special conditions and there
+				     * is a performance hit. The re-alignment
+				     * happens at these occasions for different
+				     * .cra_u types:
+				     * cipher: For both input data and output
+				     *         data buffer
+				     * ahash:  For output hash destination buf
+				     * shash:  For output hash destination buf
+				     * This is needed on hardware which is
+				     * flawed by design and cannot pick data
+				     * from arbitrary addresses.
+				     */
+
+	int cra_priority; /** <Priority of this transformation implementation.
+			   * In case multiple transformations with same
+			   *.cra_name are available to the Crypto API, the
+			   * kernel will use the one with highest .cra_priority
+			   */
+	atomic_t cra_refcnt; /** <Internal to the Crypto API */
+
+	char cra_name[CRYPTO_MAX_ALG_NAME]; /** <Generic name (usable by
+					     * multiple implementations) of the
+					     * transformation algorithm. This is
+					     * the name of the transformation
+					     * itself. This field is used by the
+					     * kernel when looking up the
+					     * providers of particular
+					     * transformation.
+					     */
+	char cra_driver_name[CRYPTO_MAX_ALG_NAME]; /** <Unique name of the
+						    * transformation provider.
+						    * This is the name of the
+						    * provider of the
+						    * transformation. This can
+						    * be any arbitrary value,
+						    * but in the usual case,
+						    * this contains the name of
+						    * the chip or provider and
+						    * the name of the
+						    * transformation algorithm.
+						    */
+
+	const struct crypto_type *cra_type; /** <Type of the cryptographic
+					     * transformation. This is a pointer
+					     * to struct crypto_type, which
+					     * implements callbacks common for
+					     * all trasnformation types. There
+					     * are multiple options:
+					     *  crypto_blkcipher_type
+					     *  crypto_ablkcipher_type
+					     *  crypto_ahash_type
+					     *  crypto_aead_type
+					     *  crypto_rng_type
+					     * This field might be empty. In
+					     * that case, there are no common
+					     * callbacks. This is the case for:
+					     *  cipher
+					     *  compress
+					     *  shash
+					     */
 
 	union {
 		struct ablkcipher_alg ablkcipher;
@@ -301,13 +383,48 @@ struct crypto_alg {
 		struct cipher_alg cipher;
 		struct compress_alg compress;
 		struct rng_alg rng;
-	} cra_u;
-
-	int (*cra_init)(struct crypto_tfm *tfm);
-	void (*cra_exit)(struct crypto_tfm *tfm);
-	void (*cra_destroy)(struct crypto_alg *alg);
+	} cra_u; /** <Callbacks implementing the transformation. This is a union
+		  * of multiple structures. Depending on the type of
+		  * transformation selected by .cra_type and .cra_flags above,
+		  * the associated structure must be filled with callbacks.
+		  * This field might be empty. This is the case for:
+		  *  ahash
+		  *  shash
+		  */
+
+	int (*cra_init)(struct crypto_tfm *tfm); /** <Initialize the
+						  * cryptographic transformation
+						  * object. This function is
+						  * used to initialize the
+						  * cryptographic transformation
+						  * object. This function is
+						  * called only once at the
+						  * instantiation time, right
+						  * after the transformation
+						  * context was allocated.
+						  * In case the cryptographic
+						  * hardware has some special
+						  * requirements which need to
+						  * be handled by software, this
+						  * function shall check for the
+						  * precise requirement of the
+						  * transformation and put any
+						  * software fallbacks in place.
+						  */
+	void (*cra_exit)(struct crypto_tfm *tfm); /** <Deinitialize the
+						   * cryptographic
+						   * transformation object.
+						   * This is a counterpart to
+						   * .cra_init(), used to remove
+						   * various changes set in
+						   * .cra_init().
+						   */
+	void (*cra_destroy)(struct crypto_alg *alg); /** <Internal to the Crypto
+						      * API */
 	
-	struct module *cra_module;
+	struct module *cra_module; /** <Owner of this transformation
+				    * implementation. Set to THIS_MODULE
+				    */
 };
 
 /*
-- 
2.1.0


