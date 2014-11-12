Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbaKLEc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:32:29 -0500
Received: from mail.eperm.de ([89.247.134.16]:54391 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654AbaKLEcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:32:23 -0500
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
Subject: [PATCH v3 08/13] crypto: Documentation - cipher data structures
Date: Wed, 12 Nov 2014 05:27:49 +0100
Message-ID: <3358305.5Vc9d54oXu@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of struct crypto_alg together with various other
data structures needed by cipher developers is documented wit all
parameters that can be set by a developer of a transformation. All
parameters that are internal to the crypto API are marked as such.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 246 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 243 insertions(+), 3 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index d45e949..752360e 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -127,6 +127,13 @@ struct skcipher_givcrypt_request;
 
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
 
+/**
+ * DOC: Block Cipher Context Data Structures
+ *
+ * These data structures define the operating context for each block cipher
+ * type.
+ */
+
 struct crypto_async_request {
 	struct list_head list;
 	crypto_completion_t complete;
@@ -194,9 +201,63 @@ struct hash_desc {
 	u32 flags;
 };
 
-/*
- * Algorithms: modular crypto algorithm implementations, managed
- * via crypto_register_alg() and crypto_unregister_alg().
+/**
+ * DOC: Block Cipher Algorithm Definitions
+ *
+ * These data structures define modular crypto algorithm implementations,
+ * managed via crypto_register_alg() and crypto_unregister_alg().
+ */
+
+/**
+ * struct ablkcipher_alg - asynchronous block cipher definition
+ * @min_keysize: Minimum key size supported by the transformation. This is the
+ *		 smallest key length supported by this transformation algorithm.
+ *		 This must be set to one of the pre-defined values as this is
+ *		 not hardware specific. Possible values for this field can be
+ *		 found via git grep "_MIN_KEY_SIZE" include/crypto/
+ * @max_keysize: Maximum key size supported by the transformation. This is the
+ *		 largest key length supported by this transformation algorithm.
+ *		 This must be set to one of the pre-defined values as this is
+ *		 not hardware specific. Possible values for this field can be
+ *		 found via git grep "_MAX_KEY_SIZE" include/crypto/
+ * @setkey: Set key for the transformation. This function is used to either
+ *	    program a supplied key into the hardware or store the key in the
+ *	    transformation context for programming it later. Note that this
+ *	    function does modify the transformation context. This function can
+ *	    be called multiple times during the existence of the transformation
+ *	    object, so one must make sure the key is properly reprogrammed into
+ *	    the hardware. This function is also responsible for checking the key
+ *	    length for validity. In case a software fallback was put in place in
+ *	    the @cra_init call, this function might need to use the fallback if
+ *	    the algorithm doesn't support all of the key sizes.
+ * @encrypt: Encrypt a scatterlist of blocks. This function is used to encrypt
+ *	     the supplied scatterlist containing the blocks of data. The crypto
+ *	     API consumer is responsible for aligning the entries of the
+ *	     scatterlist properly and making sure the chunks are correctly
+ *	     sized. In case a software fallback was put in place in the
+ *	     @cra_init call, this function might need to use the fallback if
+ *	     the algorithm doesn't support all of the key sizes. In case the
+ *	     key was stored in transformation context, the key might need to be
+ *	     re-programmed into the hardware in this function. This function
+ *	     shall not modify the transformation context, as this function may
+ *	     be called in parallel with the same transformation object.
+ * @decrypt: Decrypt a single block. This is a reverse counterpart to @encrypt
+ *	     and the conditions are exactly the same.
+ * @givencrypt: Update the IV for encryption. With this function, a cipher
+ *	        implementation may provide the function on how to update the IV
+ *	        for encryption.
+ * @givdecrypt: Update the IV for decryption. This is the reverse of
+ *	        @givencrypt .
+ * @geniv: The transformation implementation may use an "IV generator" provided
+ *	   by the kernel crypto API. Several use cases have a predefined
+ *	   approach how IVs are to be updated. For such use cases, the kernel
+ *	   crypto API provides ready-to-use implementations that can be
+ *	   referenced with this variable.
+ * @ivsize: IV size applicable for transformation. The consumer must provide an
+ *	    IV of exactly that size to perform the encrypt or decrypt operation.
+ *
+ * All fields except @givencrypt , @givdecrypt , @geniv and @ivsize are
+ * mandatory and must be filled.
  */
 struct ablkcipher_alg {
 	int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -213,6 +274,32 @@ struct ablkcipher_alg {
 	unsigned int ivsize;
 };
 
+/**
+ * struct aead_alg - AEAD cipher definition
+ * @maxauthsize: Set the maximum authentication tag size supported by the
+ *		 transformation. A transformation may support smaller tag sizes.
+ *		 As the authentication tag is a message digest to ensure the
+ *		 integrity of the encrypted data, a consumer typically wants the
+ *		 largest authentication tag possible as defined by this
+ *		 variable.
+ * @setauthsize: Set authentication size for the AEAD transformation. This
+ *		 function is used to specify the consumer requested size of the
+ * 		 authentication tag to be either generated by the transformation
+ *		 during encryption or the size of the authentication tag to be
+ *		 supplied during the decryption operation. This function is also
+ *		 responsible for checking the authentication tag size for
+ *		 validity.
+ * @setkey: see struct ablkcipher_alg
+ * @encrypt: see struct ablkcipher_alg
+ * @decrypt: see struct ablkcipher_alg
+ * @givencrypt: see struct ablkcipher_alg
+ * @givdecrypt: see struct ablkcipher_alg
+ * @geniv: see struct ablkcipher_alg
+ * @ivsize: see struct ablkcipher_alg
+ *
+ * All fields except @givencrypt , @givdecrypt , @geniv and @ivsize are
+ * mandatory and must be filled.
+ */
 struct aead_alg {
 	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
 	              unsigned int keylen);
@@ -228,6 +315,18 @@ struct aead_alg {
 	unsigned int maxauthsize;
 };
 
+/**
+ * struct blkcipher_alg - synchronous block cipher definition
+ * @min_keysize: see struct ablkcipher_alg
+ * @max_keysize: see struct ablkcipher_alg
+ * @setkey: see struct ablkcipher_alg
+ * @encrypt: see struct ablkcipher_alg
+ * @decrypt: see struct ablkcipher_alg
+ * @geniv: see struct ablkcipher_alg
+ * @ivsize: see struct ablkcipher_alg
+ *
+ * All fields except @geniv and @ivsize are mandatory and must be filled.
+ */
 struct blkcipher_alg {
 	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
 	              unsigned int keylen);
@@ -245,6 +344,53 @@ struct blkcipher_alg {
 	unsigned int ivsize;
 };
 
+/**
+ * struct cipher_alg - single-block symmetric ciphers definition
+ * @cia_min_keysize: Minimum key size supported by the transformation. This is
+ *		     the smallest key length supported by this transformation
+ *		     algorithm. This must be set to one of the pre-defined
+ *		     values as this is not hardware specific. Possible values
+ *		     for this field can be found via git grep "_MIN_KEY_SIZE"
+ *		     include/crypto/
+ * @cia_max_keysize: Maximum key size supported by the transformation. This is
+ *		    the largest key length supported by this transformation
+ *		    algorithm. This must be set to one of the pre-defined values
+ *		    as this is not hardware specific. Possible values for this
+ *		    field can be found via git grep "_MAX_KEY_SIZE"
+ *		    include/crypto/
+ * @cia_setkey: Set key for the transformation. This function is used to either
+ *	        program a supplied key into the hardware or store the key in the
+ *	        transformation context for programming it later. Note that this
+ *	        function does modify the transformation context. This function
+ *	        can be called multiple times during the existence of the
+ *	        transformation object, so one must make sure the key is properly
+ *	        reprogrammed into the hardware. This function is also
+ *	        responsible for checking the key length for validity.
+ * @cia_encrypt: Encrypt a single block. This function is used to encrypt a
+ *		 single block of data, which must be @cra_blocksize big. This
+ *		 always operates on a full @cra_blocksize and it is not possible
+ *		 to encrypt a block of smaller size. The supplied buffers must
+ *		 therefore also be at least of @cra_blocksize size. Both the
+ *		 input and output buffers are always aligned to @cra_alignmask.
+ *		 In case either of the input or output buffer supplied by user
+ *		 of the crypto API is not aligned to @cra_alignmask, the crypto
+ *		 API will re-align the buffers. The re-alignment means that a
+ *		 new buffer will be allocated, the data will be copied into the
+ *		 new buffer, then the processing will happen on the new buffer,
+ *		 then the data will be copied back into the original buffer and
+ *		 finally the new buffer will be freed. In case a software
+ *		 fallback was put in place in the @cra_init call, this function
+ *		 might need to use the fallback if the algorithm doesn't support
+ *		 all of the key sizes. In case the key was stored in
+ *		 transformation context, the key might need to be re-programmed
+ *		 into the hardware in this function. This function shall not
+ *		 modify the transformation context, as this function may be
+ *		 called in parallel with the same transformation object.
+ * @cia_decrypt: Decrypt a single block. This is a reverse counterpart to
+ *		 @cia_encrypt, and the conditions are exactly the same.
+ *
+ * All fields are mandatory and must be filled.
+ */
 struct cipher_alg {
 	unsigned int cia_min_keysize;
 	unsigned int cia_max_keysize;
@@ -261,6 +407,25 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
 
+/**
+ * struct rng_alg - random number generator definition
+ * @rng_make_random: The function defined by this variable obtains a random
+ *		     number. The random number generator transform must generate
+ *		     the random number out of the context provided with this
+ *		     call.
+ * @rng_reset: Reset of the random number generator by clearing the entire state.
+ *	       With the invocation of this function call, the random number
+ *             generator shall completely reinitialize its state. If the random
+ *	       number generator requires a seed for setting up a new state,
+ *	       the seed must be provided by the consumer while invoking this
+ *	       function. The required size of the seed is defined with
+ *	       @seedsize .
+ * @seedsize: The seed size required for a random number generator
+ *	      initialization defined with this variable. Some random number
+ *	      generators like the SP800-90A DRBG does not require a seed as the
+ *	      seeding is implemented internally without the need of support by
+ *	      the consumer. In this case, the seed size is set to zero.
+ */
 struct rng_alg {
 	int (*rng_make_random)(struct crypto_rng *tfm, u8 *rdata,
 			       unsigned int dlen);
@@ -277,6 +442,81 @@ struct rng_alg {
 #define cra_compress	cra_u.compress
 #define cra_rng		cra_u.rng
 
+/**
+ * struct crypto_alg - definition of a cryptograpic cipher algorithm
+ * @cra_flags: Flags describing this transformation. See include/linux/crypto.h
+ *	       CRYPTO_ALG_* flags for the flags which go in here. Those are
+ *	       used for fine-tuning the description of the transformation
+ *	       algorithm.
+ * @cra_blocksize: Minimum block size of this transformation. The size in bytes
+ *		   of the smallest possible unit which can be transformed with
+ *		   this algorithm. The users must respect this value.
+ *		   In case of HASH transformation, it is possible for a smaller
+ *		   block than @cra_blocksize to be passed to the crypto API for
+ *		   transformation, in case of any other transformation type, an
+ * 		   error will be returned upon any attempt to transform smaller
+ *		   than @cra_blocksize chunks.
+ * @cra_ctxsize: Size of the operational context of the transformation. This
+ *		 value informs the kernel crypto API about the memory size
+ *		 needed to be allocated for the transformation context.
+ * @cra_alignmask: Alignment mask for the input and output data buffer. The data
+ *		   buffer containing the input data for the algorithm must be
+ *		   aligned to this alignment mask. The data buffer for the
+ *		   output data must be aligned to this alignment mask. Note that
+ *		   the Crypto API will do the re-alignment in software, but
+ *		   only under special conditions and there is a performance hit.
+ *		   The re-alignment happens at these occasions for different
+ *		   @cra_u types: cipher -- For both input data and output data
+ *		   buffer; ahash -- For output hash destination buf; shash --
+ *		   For output hash destination buf.
+ *		   This is needed on hardware which is flawed by design and
+ *		   cannot pick data from arbitrary addresses.
+ * @cra_priority: Priority of this transformation implementation. In case
+ *		  multiple transformations with same @cra_name are available to
+ *		  the Crypto API, the kernel will use the one with highest
+ *		  @cra_priority.
+ * @cra_name: Generic name (usable by multiple implementations) of the
+ *	      transformation algorithm. This is the name of the transformation
+ *	      itself. This field is used by the kernel when looking up the
+ *	      providers of particular transformation.
+ * @cra_driver_name: Unique name of the transformation provider. This is the
+ *		     name of the provider of the transformation. This can be any
+ *		     arbitrary value, but in the usual case, this contains the
+ *		     name of the chip or provider and the name of the
+ *		     transformation algorithm.
+ * @cra_type: Type of the cryptographic transformation. This is a pointer to
+ *	      struct crypto_type, which implements callbacks common for all
+ *	      trasnformation types. There are multiple options:
+ *	      &crypto_blkcipher_type, &crypto_ablkcipher_type,
+ *	      &crypto_ahash_type, &crypto_aead_type, &crypto_rng_type.
+ *	      This field might be empty. In that case, there are no common
+ *	      callbacks. This is the case for: cipher, compress, shash.
+ * @cra_u: Callbacks implementing the transformation. This is a union of
+ *	   multiple structures. Depending on the type of transformation selected
+ *	   by @cra_type and @cra_flags above, the associated structure must be
+ *	   filled with callbacks. This field might be empty. This is the case
+ *	   for ahash, shash.
+ * @cra_init: Initialize the cryptographic transformation object. This function
+ *	      is used to initialize the cryptographic transformation object.
+ *	      This function is called only once at the instantiation time, right
+ *	      after the transformation context was allocated. In case the
+ *	      cryptographic hardware has some special requirements which need to
+ *	      be handled by software, this function shall check for the precise
+ *	      requirement of the transformation and put any software fallbacks
+ *	      in place.
+ * @cra_exit: Deinitialize the cryptographic transformation object. This is a
+ *	      counterpart to @cra_init, used to remove various changes set in
+ *	      @cra_init.
+ * @cra_module: Owner of this transformation implementation. Set to THIS_MODULE
+ * @cra_list: internally used
+ * @cra_users: internally used
+ * @cra_refcnt: internally used
+ * @cra_destroy: internally used
+ *
+ * The struct crypto_alg describes a generic Crypto API algorithm and is common
+ * for all of the transformations. Any variable not documented here shall not
+ * be used by a cipher implementation as it is internal to the Crypto API.
+ */
 struct crypto_alg {
 	struct list_head cra_list;
 	struct list_head cra_users;
-- 
2.1.0


