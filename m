Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaJaJK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:10:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:32873 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaJaJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:10:19 -0400
X-Auth-Info: wDdFubwgnNa8/VRfaY5r5rDItd8bOu+YTxdSLf3zR9Q=
From: Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] kernel crypto API interface specification
Date: Fri, 31 Oct 2014 10:09:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Stephan Mueller <smueller@chronox.de>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7502136.9BkWHTZ0th@myon.chronox.de> <201410310401.04278.marex@denx.de> <20141031072353.GC7563@gondor.apana.org.au>
In-Reply-To: <20141031072353.GC7563@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201410311009.52713.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 31, 2014 at 08:23:53 AM, Herbert Xu wrote:
> On Fri, Oct 31, 2014 at 04:01:04AM +0100, Marek Vasut wrote:
> > I can share the last state of the document I wrote. Currently,
> > it is not possible for me to keep up with my workload and do
> > anything else, so that's all I can do.
> 
> Posting your latest revision would be great.

Please see below, mine is much less complete than Stephan's though
and likely contains some bugs.

Linux Crypto API :: Drivers
===========================

This document outlines how to implement drivers for cryptographic hardware.
The Linux Crypto API supports different types of transformations and we will
explain here how to write drivers for each one of them.

Note: Transformation and algorithm are used interchangably

Note: We support multiple transformation types:
      CIPHER ....... Simple single-block cipher
      BLKCIPHER .... Synchronous multi-block cipher
      ABLKCIPHER ... Asynchronous multi-block cipher
      SHASH ........ Synchronous multi-block hash
      AHASH ........ Asynchronous multi-block hash
      AEAD ......... Authenticated Encryption with Associated Data (MAC)
      COMPRESS ..... Compression
      RNG .......... Random Number Generation

0) Terminology
--------------
 - The transformation implementation is an actual code or interface to hardware
   which implements a certain trasformation with percisely defined behavior.
 - The transformation object (TFM) is an instance of a transformation
   implementation. There can be multiple transformation objects associated with
   a single transformation implementation. Each of those transformation objects
   is held by a crypto API consumer. Transformation object is allocated when a
   crypto API consumer requests a transformation implementation. The consumer
   is then provided with a structure, which contains a transformation object
   (TFM).
 - The transformation context is private data associated with the transformation
   object.

1) The struct crypto_alg description
------------------------------------
 The struct crypto_alg describes a generic Crypto API algorithm and is common
 for all of the transformations. We will first explain what each entry means
 as this is a fundamental building block. We will not follow the order of
 fields as defined in include/linux/crypto.h , but will instead explain them
 in logical order.

  .cra_name .......... Name of the transformation algorithm .
                       - This is the name of the transformation itself. This
                         field is used by the kernel when looking up the
                         providers of particular transformation.
                       - Examples: "md5", "cbc(cast5)", "rfc4106(gcm(aes))"
                       - You can find a good approximation for values of this
                         field by running:
                         $ git grep tcrypt_test crypto/tcrypt.c
  .cra_driver_name ... Name of the transformation provider .
                       - This is the name of the provider of the transformation.
                         This can be any arbitrary value, but in the usual case,
                         this contains the name of the chip or provider and the
                         name of the transformation algorithm.
                       - Examples: "sha1-dcp", "atmel-ecb-aes"
  .cra_priority ...... Priority of this transformation implementation.
                       - In case multiple transformations with same .cra_name
                         are available to the Crypto API, the kernel will use
                         the one with highest .cra_priority .
                       - The software implementations of transformations have
                         this field set to 0 so they are picked only in case
                         no other higher-priority implementation is available.
  .cra_module ........ Owner of this transformation implementation.
                       - Set to THIS_MODULE .

  .cra_blocksize ..... Minimum block size of this transformation.
                       - The size in bytes of the smallest possible unit which
                         can be transformed with this algorithm. The users must
                         respect this value.
                       - In case of HASH transformation, it is possible for a
                         smaller block than .cra_blocksize to be passed to the
                         crypto API for transformation, in case of any other
                         transformation type, an error will be returned upon
                         any attempt to transform smaller than .cra_blocksize
                         chunks.
                       - Examples: SHA1_BLOCK_SIZE, AES_BLOCK_SIZE
                       - You can find predefined values for this field in the
                         kernel source tree with:
                         $ git grep _BLOCK_SIZE include/crypto/
  .cra_alignmask ..... Alignment mask for the input and output data buffer.
                       - The data buffer containing the input data for the
                         algorithm must be aligned to this alignment mask.
                       - The data buffer for the output data must be aligned
                         to this alignment mask.
                       - Note that the Crypto API will do the re-alignment
                         in software, but only under special conditions and
                         there is a performance hit. The re-alignment happens
                         at these occassions for different .cra_u types:
                          cipher: For both input data and output data buffer
                          ahash:  For output hash destination buffer
                          shash:  For output hash destination buffer

                          /* FIXME ... others ? */

                       - This is needed on hardware which is flawed by design
                         and cannot pick data from arbitrary addresses.
  .cra_ctxsize ....... Size of the transformation context.
                       - This is the size of data, which are associated with
                         the transformation object. These data are valid
                         during the entire existence of the transformation
                         object. These data can only ever be modified by the
                         driver.
                       - The driver can retrieve a pointer to these data via
                         the crypto_tfm_ctx() function .

  .cra_type .......... Type of the cryptographic transformation.
                       - This is a pointer to struct crypto_type, which
                         implements callbacks common for all trasnformation
                         types.
                       - There are multiple options:
                           crypto_blkcipher_type .... Sync block cipher
                           crypto_ablkcipher_type ... Async block cipher
                           crypto_ahash_type ........ Async hash
                           crypto_aead_type ......... AEAD
                           crypto_rng_type .......... Random number generator
                       - This field might be empty. In that case, there are
                         no common callbacks. This is the case for:
                           cipher ................... Single-block cipher
                           compress ................. Compression
                           shash .................... Sync hash
  .cra_flags ......... Flags describing this transformation.
                       - See include/linux/crypto.h CRYPTO_ALG_* flags for
                         the flags which go in here. Those are used for
                         fine-tuning the description of the transformation
                         algorithm.
  .cra_u ............. Callbacks implementing the transformation.
                       - This is a union of multiple structures. Depending
                         on the type of transformation selected by .cra_type
                         and .cra_flags above, the associated structure must
                         be filled with callbacks.
                       - There are multiple options:
                           .cipher ....... Cipher
                           .blkcipher .... Sync block cipher
                           .ablkcipher ... Async block cipher
                           .aead ......... AEAD
                           .compress ..... Compression
                           .rng .......... Random number generator
                       - This field might be empty. This is the case for:
                           ahash ......... Async hash
                           shash ......... Sync hash
  .cra_init() ........ Initialize the cryptographic transformation object.
                       - This function is used to initialize the cryptographic
                         transformation object. This function is called
                         only once at the instantiation time, right after the
                         transformation context was allocated.
                       - In case the cryptographic hardware has some special
                         requirements which need to be handled by software,
                         this function shall check for the precise requirement
                         of the transformation and put any software fallbacks
                         in place.
  .cra_exit() ........ Deinitialize the cryptographic transformation object.
                       - This is a counterpart to .cra_init(), used to remove
                         various changes set in .cra_init() .

  .cra_list .......... List header.
                       - This internal field of the crypto API is used as a
                         list head. It allows for this structure to be added
                         into the list of other crypto algorithms.
  .cra_users ......... List of all users of this transformation.
                       - This internal field to the crypto API is used to
                         track all the users which are currently using this
                         particular transformation implementation.
  .cra_refcnt ........ Reference counter for this structure.
                       - This internal field of the crypto API is used to
                         count number of references of this structure so it
                         can be checked when removal is requested.
  .cra_destroy() ..... Deallocate resources of the crypto transformation.
                       - This is used internally by the crypto API. When
                         there are multiple spawns of the algorithm, this
                         is set for all of then and when the refcount
                         reaches zero, this function is called to dealloc
                         all the remaining data.

2) Registering and unregistering transformation
-----------------------------------------------
 There are three distinct types of registration functions in the Crypto API.
 One is used to register a generic cryptographic transformation, while the
 other two are specific to HASH transformations and COMPRESSion . We will
 discuss the latter two in a separate chapter, here we will only look at
 the generic ones.

 The generic registration functions can be found in include/linux/crypto.h
 and their definition can be seen below. The former function registers a
 single transformation, while the latter works on an array of transformation
 descriptions. The latter is useful when registering transformations in bulk.

   int crypto_register_alg(struct crypto_alg *alg);
   int crypto_register_algs(struct crypto_alg *algs, int count);

 The counterparts to those functions are listed below.

   int crypto_unregister_alg(struct crypto_alg *alg);
   int crypto_unregister_algs(struct crypto_alg *algs, int count);

 Notice that both registration and unregistration functions do return a value,
 so make sure to handle errors.

3) Single-block ciphers [CIPHER]
--------------------------------
 Example of transformations: aes, arc4, ...

 This section describes the simplest of all transformation implementations,
 that being the CIPHER type. The CIPHER type is used for transformations
 which operate on exactly one block at a time and there are no dependencies
 between blocks at all.

 3.1) Registration specifics
 ---------------------------
  The registration of [CIPHER] algorithm is specific in that struct crypto_alg
  field .cra_type is empty. The .cra_u.cipher has to be filled in with proper
  callbacks to implement this transformation.

 3.2) Fields in struct cipher_alg explained
 ------------------------------------------
  This section explains the .cra_u.cipher fields and how they are called.
  All of the fields are mandatory and must be filled:

   .cia_min_keysize ... Minimum key size supported by the transformation.
                        - This is the smallest key length supported by this
                          transformation algorithm. This must be set to one
                          of the pre-defined values as this is not hardware
                          specific.
                        - Possible values for this field can be found via:
                          $ git grep "_MIN_KEY_SIZE" include/crypto/
   .cia_max_keysize ... Maximum key size supported by the transformation.
                        - This is the largest key length supported by this
                          transformation algorithm. This must be set to one
                          of the pre-defined values as this is not hardware
                          specific.
                        - Possible values for this field can be found via:
                          $ git grep "_MAX_KEY_SIZE" include/crypto/
   .cia_setkey() ...... Set key for the transformation.
                        - This function is used to either program a supplied
                          key into the hardware or store the key in the
                          transformation context for programming it later. Note
                          that this function does modify the transformation
                          context.
                        - This function can be called multiple times during
                          the existence of the transformation object, so one
                          must make sure the key is properly reprogrammed
                          into the hardware.
                        - This function is also responsible for checking the
                          key length for validity.
                        - In case a software fallback was put in place in
                          the .cra_init() call, this function might need to
                          use the fallback if the algorithm doesn't support
                          all of the key sizes.
   .cia_encrypt() ..... Encrypt a single block.
                        - This function is used to encrypt a single block of
                          data, which must be .cra_blocksize big. This always
                          operates on a full .cra_blocksize and it is not
                          possible to encrypt a block of smaller size. The
                          supplied buffers must therefore also be at least
                          of .cra_blocksize size.
                        - Both the input and output buffers are always aligned
                          to .cra_alignmask . In case either of the input or
                          output buffer supplied by user of the crypto API is
                          not aligned to .cra_alignmask, the crypto API will
                          re-align the buffers. The re-alignment means that a
                          new buffer will be allocated, the data will be copied
                          into the new buffer, then the processing will happen
                          on the new buffer, then the data will be copied back
                          into the original buffer and finally the new buffer
                          will be freed.
                        - In case a software fallback was put in place in
                          the .cra_init() call, this function might need to
                          use the fallback if the algorithm doesn't support
                          all of the key sizes.
                        - In case the key was stored in transformation context,
                          the key might need to be re-programmed into the
                          hardware in this function.
                        - This function shall not modify the transformation
                          context, as this function may be called in parallel
                          with the same transformation object.
   .cia_decrypt() ..... Decrypt a single block.
                        - This is a reverse counterpart to .cia_encrypt(), and
                          the conditions are exactly the same.

  Here are schematics of how these functions are called when operated from
  other part of the kernel. Note that the .cia_setkey() call might happen
  before or after any of these schematics happen, but must not happen during
  any of these are in-flight.

         KEY ---.    PLAINTEXT ---.
                v                 v
          .cia_setkey() -> .cia_encrypt()
                                  |
                                  '-----> CIPHERTEXT

  Please note that a pattern where .cia_setkey() is called multiple times
  is also valid:

  KEY1 --.    PLAINTEXT1 --.         KEY2 --.    PLAINTEXT2 --.
         v                 v                v                 v
   .cia_setkey() -> .cia_encrypt() -> .cia_setkey() -> .cia_encrypt()
                           |                                  |
                           '---> CIPHERTEXT1                  '---> CIPHERTEXT2

4) Multi-block ciphers [BLKCIPHER] [ABLKCIPHER]
-----------------------------------------------
 Example of transformations: cbc(aes), ecb(arc4), ...

 This section describes the multi-block cipher transformation implementations
 for both synchronous [BLKCIPHER] and asynchronous [ABLKCIPHER] case. The
 multi-block ciphers are used for transformations which operate on scatterlists
 of data supplied to the transformation functions. They output the result into
 a scatterlist of data as well.

 4.1) Registration specifics
 ---------------------------
  The registration of [BLKCIPHER] or [ABLKCIPHER] algorithm is one of the most
  standard procedures throughout the crypto API. There are no specifics for
  this case other that re-aligning of input and output buffers does not happen
  automatically within the crypto API, but is the responsibility of the crypto
  API consumer. The crypto API consumer shall use crypto_blkcipher_alignmask()
  or crypto_ablkcipher_alignmask() respectively to determine the needs of the
  transformation object and prepare the scatterlist with data accordingly.

 4.2) Fields in struct blkcipher_alg and struct ablkcipher_alg explained
 -----------------------------------------------------------------------
  This section explains the .cra_u.blkcipher and .cra_u.cra_ablkcipher fields
  and how they are called. Please note that this is very similar to the basic
  CIPHER case for all but minor details. All of the fields but .geniv are
  mandatory and must be filled:

   .min_keysize ... Minimum key size supported by the transformation.
                    - This is the smallest key length supported by this
                      transformation algorithm. This must be set to one
                      of the pre-defined values as this is not hardware
                      specific.
                    - Possible values for this field can be found via:
                      $ git grep "_MIN_KEY_SIZE" include/crypto/
   .max_keysize ... Maximum key size supported by the transformation.
                    - This is the largest key length supported by this
                      transformation algorithm. This must be set to one
                      of the pre-defined values as this is not hardware
                      specific.
                    - Possible values for this field can be found via:
                      $ git grep "_MAX_KEY_SIZE" include/crypto/
   .setkey() ...... Set key for the transformation.
                    - This function is used to either program a supplied
                      key into the hardware or store the key in the
                      transformation context for programming it later. Note
                      that this function does modify the transformation
                      context.
                    - This function can be called multiple times during
                      the existence of the transformation object, so one
                      must make sure the key is properly reprogrammed
                      into the hardware.
                    - This function is also responsible for checking the
                      key length for validity.
                    - In case a software fallback was put in place in
                      the .cra_init() call, this function might need to
                      use the fallback if the algorithm doesn't support
                      all of the key sizes.
   .encrypt() ..... Encrypt a scatterlist of blocks.
                    - This function is used to encrypt the supplied
                      scatterlist containing the blocks of data. The crypto
                      API consumer is responsible for aligning the entries
                      of the scatterlist properly and making sure the
                      chunks are correctly sized.
                    - In case a software fallback was put in place in
                      the .cra_init() call, this function might need to
                      use the fallback if the algorithm doesn't support
                      all of the key sizes.
                    - In case the key was stored in transformation context,
                      the key might need to be re-programmed into the
                      hardware in this function.
                    - This function shall not modify the transformation
                      context, as this function may be called in parallel
                      with the same transformation object.
   .decrypt() ..... Decrypt a single block.
                    - This is a reverse counterpart to .encrypt(), and the
                      conditions are exactly the same.

  Please refer to section 3.2) for schematics of the block cipher usage.
  The usage patterns are exactly the same for [ABLKCIPHER] and [BLKCIPHER]
  as they are for plain [CIPHER].

  4.3) Specifics of asynchronous multi-block cipher
  -------------------------------------------------
  There are a couple of specifics to the [ABLKCIPHER] interface.

  First of all, some of the drivers will want to use the Generic ScatterWalk
  in case the hardware needs to be fed separate chunks of the scatterlist
  which contains the plaintext and will contain the ciphertext. Please refer
  to the section 9.1) of this document on the description and usage of the
  Generic ScatterWalk interface.

  It is recommended to enqueue cryptographic transformation requests into
  generic crypto queues. This allows for these requests to be processed in
  sequence as the cryptographic hardware becomes free. For details on the
  crypto queues, please refer to section 9.2) further down in this text.

5) Hashing [HASH]
-----------------
 Example of transformations: crc32, md5, sha1, sha256,...

 5.1) Registering and unregistering the transformation
 -----------------------------------------------------
  There are multiple ways to register a HASH transformation, depending on
  whether the transformation is synchronous [SHASH] or asynchronous [AHASH]
  and the amount of HASH transformations we are registering. You can find
  the prototypes defined in include/crypto/internal/hash.h :

   int crypto_register_ahash(struct ahash_alg *alg);

   int crypto_register_shash(struct shash_alg *alg);
   int crypto_register_shashes(struct shash_alg *algs, int count);

  The respective counterparts for unregistering the HASH transformation are
  as follows:

   int crypto_unregister_ahash(struct ahash_alg *alg);

   int crypto_unregister_shash(struct shash_alg *alg);
   int crypto_unregister_shashes(struct shash_alg *algs, int count);

 5.2) Common fields of struct shash_alg and ahash_alg explained
 --------------------------------------------------------------
  For definition of these structures, please refer to include/crypto/hash.h .
  We will now explain the meaning of each field:

   .init() ......... Initialize the transformation context.
                     - Intended only to initialize the state of the HASH
                       transformation at the begining. This shall fill in
                       the internal structures used during the entire duration
                       of the whole transformation.
                     - No data processing happens at this point.
   .update() ....... Push chunk of data into the driver for transformation.
                     - This function actually pushes blocks of data from upper
                       layers into the driver, which then passes those to the
                       hardware as seen fit.
                     - This function must not finalize the HASH transformation,
                       this only adds more data into the transformation.
                     - This function shall not modify the transformation
                       context, as this function may be called in parallel
                       with the same transformation object.
                     - Data processing can happen synchronously [SHASH] or
                       asynchronously [AHASH] at this point.
   .final() ....... Retrieve result from the driver.
                     - This function finalizes the transformation and retrieves
                       the resulting hash from the driver and pushes it back to
                       upper layers.
                     - No data processing happens at this point.
   .finup() ........ Combination of update()+final() .
                     - This function is effectively a combination of update()
                       and final() calls issued in sequence.
                     - As some hardware cannot do update() and final()
                       separately, this callback was added to allow such
                       hardware to be used at least by IPsec.
                     - Data processing can happen synchronously [SHASH] or
                       asynchronously [AHASH] at this point.
   .digest() ....... Combination of init()+update()+final() .
                     - This function effectively behaves as the entire chain
                       of operations, init(), update() and final() issued in
                       sequence.
                     - Just like .finup(), this was added for hardware which
                       cannot do even the .finup(), but can only do the whole
                       transformation in one run.
                     - Data processing can happen synchronously [SHASH] or
                       asynchronously [AHASH] at this point.

   .setkey() ....... Set optional key used by the hashing algorithm .
                     - Intended to push optional key used by the hashing
                       algorithm from upper layers into the driver.
                     - This function can store the key in the transformation
                       context or can outright program it into the hardware.
                       In the former case, one must be careful to program
                       the key into the hardware at appropriate time and one
                       must be careful that .setkey() can be called multiple
                       times during the existence of the transformation
                       object.
                     - Not all hashing algorithms do implement this function.
                       -> SHAx/MDx/CRCx do NOT implement this function.
                       -> HMAC(MDx)/HMAC(SHAx) do implement this function.
                     - This function must be called before any other of the
                       init()/update()/final()/finup()/digest() is called.
                     - No data processing happens at this point.

   .export() ....... Export partial state of the transformation .
                     - This function dumps the entire state of the ongoing
                       transformation into a provided block of data so it
                       can be .import()ed back later on.
                     - This is useful in case you want to save partial result
                       of the transformation after processing certain amount
                       of data and reload this partial result multiple times
                       later on for multiple re-use.
                     - No data processing happens at this point.
   .import() ....... Import partial state of the transformation .
                     - This function loads the entire state of the ongoing
                       transformation from a provided block of data so the
                       transformation can continue from this point onward.
                     - No data processing happens at this point.

  Here are schematics of how these functions are called when operated from
  other part of the kernel. Note that the .setkey() call might happen before
  or after any of these schematics happen, but must not happen during any of
  these are in-flight. Please note that calling .init() followed immediatelly
  by .finish() is also a perfectly valid transformation.

   I)   DATA -----------.
                        v
         .init() -> .update() -> .final()      ! .update() might not be called
                     ^    |         |            at all in this scenario.
                     '----'         '---> HASH

   II)  DATA -----------.-----------.
                        v           v
         .init() -> .update() -> .finup()      ! .update() may not be called
                     ^    |         |            at all in this scenario.
                     '----'         '---> HASH

   III) DATA -----------.
                        v
                    .digest()                  ! The entire process is handled
                        |                        by the .digest() call.
                        '---------------> HASH

  Here is a schematic of how the .export()/.import() functions are called when
  used from another part of the kernel.

   KEY--.                 DATA--.
        v                       v                  ! .update() may not be called
    .setkey() -> .init() -> .update() -> .export()   at all in this scenario.
                             ^     |         |
                             '-----'         '--> PARTIAL_HASH

   ----------- other transformations happen here -----------

   PARTIAL_HASH--.   DATA1--.
                 v          v
             .import -> .update() -> .final()     ! .update() may not be called
                         ^    |         |           at all in this scenario.
                         '----'         '--> HASH1

   PARTIAL_HASH--.   DATA2-.
                 v         v
             .import -> .finup()
                           |
                           '---------------> HASH2

 5.3) The struct hash_alg_common fields and it's mirror in struct shash_alg
 --------------------------------------------------------------------------
  This structure defines various size constraints and generic properties of
  the hashing algorithm that is being implemented. Let us first inspect the
  size properties:

   digestsize .... Size of the result of the transformation.
                   - A buffer of this size must be available to the .final()
                     and .finup() calls, so they can store the resulting hash
                     into it.
                   - For various predefined sizes, search include/crypto/
                     using 'git grep _DIGEST_SIZE include/crypto' .
   statesize ..... Size of the block for partial state of the transformation.
                   - A buffer of this size must be passed to the .export()
                     function as it will save the partial state of the
                     transformation into it. On the other side, the .import()
                     function will load the state from a buffer of this size
                     as well.

/* FIXME */

  We will now discuss HASH-specific details of struct crypto_alg . In order
  to understand the rest of the text, please read the section 1) at the
  begining of this documentation first.

/* FIXME ... this needs expanding */

  5.4) Specifics of asynchronous HASH transformation
  --------------------------------------------------
  There are a couple of specifics to the [AHASH] interface.

  First of all, some of the drivers will want to use the Generic ScatterWalk
  in case the hardware needs to be fed separate chunks of the scatterlist
  which contains the input data. The buffer containing the resulting hash will
  always be properly aligned to .cra_alignmask so there is no need to worry
  about this. Please refer to the section 9.1) of this document of the
  description and usage of the Generic ScatterWalk interface.

  It is recommended to enqueue cryptographic transformation requests into
  generic crypto queues. This allows for these requests to be processed in
  sequence as the cryptographic hardware becomes free. For details on the
  crypto queues, please refer to section 9.2) further down in this text.

6) Authenticated Encryption with Associated Data (MAC) [AEAD]
-------------------------------------------------------------

7) Compression [COMPRESS]
-------------------------

8) Random Number Generation [RNG]
---------------------------------

9) Additional helper interfaces
-------------------------------
 This section outlines specific helpers available across various types of
 cryptographic transformation implementations, which are not specific to a
 particular transformation type.

 9.1) Generic ScatterWalk
 ------------------------

 9.2) Crypto Request Queue
 -------------------------

/* FIXME -- others? Multi-queue API ? ... */
