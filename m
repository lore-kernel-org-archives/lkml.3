Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaJNTzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:55:01 -0400
Received: from mail.eperm.de ([89.247.134.16]:54059 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbaJNTy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:54:56 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel crypto API interface specification
Date: Tue, 14 Oct 2014 21:46:50 +0200
Message-ID: <7502136.9BkWHTZ0th@myon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.16.4-200.fc20.x86_64; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update adds a complete interface documentation of the kernel crypto
API. All cipher types supported by the kernel crypto API are documented.

In addition, kernel and user space example code is provided. The sample
code covers synchronous and asynchronous cipher operation, random
number generation and performing hashing as well as encryption and
decryption in user space.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/crypto-API-spec.txt | 2110 ++++++++++++++++++++++++++++++
 1 file changed, 2110 insertions(+)
 create mode 100644 Documentation/crypto/crypto-API-spec.txt

diff --git a/Documentation/crypto/crypto-API-spec.txt b/Documentation/crypto/crypto-API-spec.txt
new file mode 100644
index 0000000..027fd4f
--- /dev/null
+++ b/Documentation/crypto/crypto-API-spec.txt
@@ -0,0 +1,2110 @@
+Kernel Crypto API Interface Specification
+=========================================
+
+The kernel crypto API offers a rich set of ciphers and methods to invoke these
+ciphers. This document contains a description of the API and provides example
+code.
+
+To understand and properly use the kernel crypto API a brief explanation of the
+structure is given. Based on the architecture, the API can be separated into
+different components. Following the architecture specification the various
+components forming the kernel crypto API are described.
+
+The kernel crypto API refers to all algorithms as "transforms". Therefore, a
+cipher handle variable usually has the name "tfm". Besides cryptographic
+operations, the kernel crypto API also knows compression transforms and handles
+them the same way as ciphers.
+
+The kernel crypto API serves the following entity types:
+
+	* users requesting cryptographic services
+
+	* data transformation implementations (typically ciphers) that
+	  can be called by users
+
+This specification is mainly intended for normal users that need cryptographic
+support. It lists all API calls relevant for these users. This API
+specification, however, does not list all API calls available to data
+transformation implementations ((i.e. implementations of ciphers and other
+transformations (such as CRC or even compression algorithms) that can register
+with the kernel crypto API).
+
+Kernel Crypto API Architecture
+==============================
+
+Cipher types
+------------
+
+The kernel crypto API provides different API calls for the following cipher
+types:
+
+	* Symmetric ciphers
+
+	* AEAD ciphers
+
+	* Message digest, including keyed message digest
+
+	* Random number generation
+
+	* User space interface
+
+Ciphers and Templates
+---------------------
+
+The kernel crypto API provides implementations of raw ciphers. In addition, the
+kernel crypto API provides numerous "templates" that can be used in conjunction
+with the raw ciphers. Templates include all types of block chaining mode, the
+HMAC mechanism, etc.
+
+Raw ciphers can either be directly used by a caller or invoked together with a
+template. A raw cipher may even be called with multiple templates. However,
+templates cannot be used without a raw cipher.
+
+Synchronous and asynchronous operation
+--------------------------------------
+
+The kernel crypto API provides synchronous and asynchronous API calls.
+
+When using a synchronous API call, the caller invokes a cipher operation which
+is performed synchronously by the kernel crypto API. That means, the caller
+waits until the cipher operation completes. Therefore, the kernel crypto
+API calls work like regular function calls. For synchronous operations, the set
+of API calls is small and similar to any other crypto library.
+
+Asynchronous operation is provided by the kernel crypto API which implies that
+the invocation of a cipher operation will complete almost instantly. That
+invocation triggers the cipher operation but it does not signal its completion.
+Before invoking a cipher operation, the caller must provide a callback function
+the kernel crypto API can invoke to signal the completion of the cipher
+operation. Furthermore, the caller must ensure it can handle such asynchronous
+events by applying appropriate locking around its data. The kernel crypto API
+does not perform any special serialization operation to protect the caller's
+data integrity.
+
+Kernel crypto API cipher references and priority
+------------------------------------------------
+
+A cipher is referenced by the caller with a string. That string has the
+following semantics:
+
+	template(raw cipher)
+
+where "template" and "raw cipher" is the aforementioned template and raw cipher,
+respectively. If applicable, additional templates may enclose other templates,
+such as
+
+	template1(template2(raw cipher)))
+
+The kernel crypto API may provide multiple implementations of a template or a
+raw cipher. For example, AES on newer x86_64 hardware has the following
+implementations: AES-NI, assembler implementation, or straight C. Now, when
+using the string "aes" with the kernel crypto API, which cipher implementation
+is used? The answer to that question is the priority number assigned to each
+cipher implementation by the kernel crypto API. When a caller uses the string to
+refer to a cipher during initialization of a cipher handle, the kernel crypto
+API looks up all implementations providing an implementation with that name and
+selects the implementation with the highest priority.
+
+Now, a caller may have the need to refer to a specific cipher implementation and
+thus does not want to rely on the priority-based selection. To accommodate this
+scenario, the kernel crypto API allows the cipher implementation to
+register a unique name in addition to common names. When using that unique name,
+a caller is therefore always sure to refer to the intended cipher
+implementation.
+
+The list of available ciphers is given in /proc/crypto. When reading that file,
+all available ciphers with all possible template to raw cipher permutations are
+listed. Each block listed in /proc/crypto contains the following information:
+
+	* name: the generic name of the cipher that is subject to the
+	  priority-based selection -- this name can be used by the cipher
+	  allocation API calls
+
+	* driver: the unique name of the cipher -- this name can be used by the
+	  cipher allocation API calls
+
+	* module: the kernel module providing the cipher implementation (or
+	  "kernel" for statically linked ciphers)
+
+	* priority: the priority value of the cipher implementation
+
+	* refcnt: the reference count of the respective cipher (i.e. the number
+	  of current users of this cipher)
+
+	* selftest: specification whether the self test for the cipher passed
+
+	* type:
+		- blkcipher for symmetric block ciphers
+		- ablkcipher for asymmetric block ciphers
+		- cipher for raw ciphers
+		- shash for symmetric message digest
+		- ahash for asymmetric message digest
+		- aead for AEAD cipher type
+		- compression for compression type transforms
+		- rng for random number generator
+		- givcipher for cipher with associated IV generator
+
+	* blocksize: blocksize of cipher in bytes
+
+	* keysize: key size in bytes
+
+	* ivsize: IV size in bytes
+
+	* seedsize: required size of seed data for random number generator
+
+	* digestsize: output size of the message digest
+
+	* geniv: IV generation type:
+		- eseqiv for encrypted sequence number based IV generation
+		- seqiv for sequence number based IV generation
+		- chainiv for chain iv generation
+		- <builtin> is a marker that the cipher implements IV generation
+
+Note: /proc/crypto only lists ciphers. This file does not specifies registered
+templates. Therefore, this file also does not specify any permutations of
+templates-cipher combinations.
+
+Key sizes
+---------
+
+When allocating a cipher handle, the caller only specifies the cipher type.
+Symmetric ciphers, however, typically support multiple key sizes (e.g. AES-128
+vs. AES-256). These key sizes are determined with the length of the provided
+key. Thus, the kernel crypto API does not provide a separate way to select
+the particular symmetric cipher key size.
+
+Cipher allocation type and masks
+--------------------------------
+
+The different cipher handle allocation functions allow the specification of a
+type and mask flag. Both parameters have the following meaning (and are
+therefore not covered in the subsequent sections).
+
+The type flag specifies the type of the cipher algorithm. The caller usually
+provides a 0 when the caller wants the default handling. Otherwise, the caller
+may provide the following selections which match the the aforementioned cipher
+types:
+
+	* CRYPTO_ALG_TYPE_CIPHER
+	* CRYPTO_ALG_TYPE_COMPRESS
+	* CRYPTO_ALG_TYPE_AEAD
+	* CRYPTO_ALG_TYPE_BLKCIPHER
+	* CRYPTO_ALG_TYPE_ABLKCIPHER
+	* CRYPTO_ALG_TYPE_GIVCIPHER
+	* CRYPTO_ALG_TYPE_DIGEST
+	* CRYPTO_ALG_TYPE_SHASH
+	* CRYPTO_ALG_TYPE_AHASH
+	* CRYPTO_ALG_TYPE_RNG
+	* CRYPTO_ALG_TYPE_PCOMPRESS
+
+The mask flag restricts the type of cipher. The only allowed flag is
+CRYPTO_ALG_ASYNC to restrict the cipher lookup function to asynchronous ciphers.
+Usually, a caller provides a 0 for the mask flag.
+
+Raw cipher API
+==============
+
+#include <linux/crypto.h>
+
+struct crypto_cipher *crypto_alloc_cipher(const char *alg_name, u32 type,
+					  u32 mask)
+
+Allocate a cipher handle for a raw cipher. The returned struct crypto_cipher is
+the cipher handle that is required for any operation with that raw cipher.
+
+alg_name is the name or driver name of the raw cipher.
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+void crypto_free_cipher(struct crypto_cipher *tfm)
+
+The referenced raw cipher handle is zeroized and subsequently freed.
+
+
+int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
+
+Return true when the raw cipher with the given alg_name and type/mask flags is
+known to the kernel crypto API. Otherwise return false.
+
+
+int crypto_cipher_blocksize(struct crypto_cipher *tfm)
+
+The block size for the raw cipher referenced with the cipher handle tfm is
+returned.
+
+
+int crypto_cipher_setkey(struct crypto_cipher *tfm, const u8 *key,
+			 unsigned int keylen)
+
+The caller provided key referenced with buffer key and the buffer length of
+keylen is set with the raw cipher referenced by the cipher handle tfm. If the
+setting of the key was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+void crypto_cipher_encrypt_one(struct crypto_cipher *tfm, u8 *dst,
+			       const u8 *src)
+
+The raw cipher referenced with tfm is used to encrypt one block of the plaintext
+data pointed to by src and places the ciphertext data into the dst buffer.
+
+
+void crypto_cipher_decrypt_one(struct crypto_cipher *tfm, u8 *dst,
+			       const u8 *src)
+
+The raw cipher referenced with tfm is used to decrypt one block of the plaintext
+data pointed to by src and places the ciphertext data into the dst buffer.
+
+
+Synchronous block cipher API
+============================
+
+Synchronous calls, have a context in the tfm. But since a single tfm can be used
+in multiple calls and in parallel, this info should not be changeable (unless a
+lock is used). This applies, for example, to the symmetric key. However, the iv
+is changeable, so there is an iv field in blkcipher_tfm structure for
+synchronous blkcipher api. So, its the only state info that can be kept for
+synchronous calls without using a big lock across a tfm.
+
+#include <linux/crypto.h>
+
+struct crypto_blkcipher *crypto_alloc_blkcipher(const char *alg_name, u32 type,
+						u32 mask)
+
+Allocate a cipher handle for a block cipher. The returned struct
+crypto_blkcipher is the cipher handle that is required for any operation with
+that block cipher.
+
+alg_name is the name or driver name of the block cipher.
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+void crypto_free_blkcipher(struct crypto_blkcipher *tfm)
+
+The referenced block cipher handle is zeroized and subsequently freed.
+
+
+char *crypto_blkcipher_name(struct crypto_blkcipher *tfm)
+
+Obtain the generic name of the block cipher referenced by the handle.
+
+
+int crypto_has_blkcipher(const char *alg_name, u32 type, u32 mask)
+
+Return true when the block cipher with the given alg_name and type/mask flags is
+known to the kernel crypto API. Otherwise return false.
+
+
+unsigned int crypto_blkcipher_ivsize(struct crypto_blkcipher *tfm)
+
+The size of the IV for the block cipher referenced by the cipher handle tfm is
+returned. This IV size may be zero if the cipher does not need an IV.
+
+
+unsigned int crypto_blkcipher_blocksize(struct crypto_blkcipher *tfm)
+
+The block size for the block cipher referenced with the cipher handle tfm is
+returned.
+
+
+int crypto_blkcipher_setkey(struct crypto_blkcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+
+The caller provided key referenced with buffer key and the buffer length of
+keylen is set with the block cipher referenced by the cipher handle tfm. If the
+setting of the key was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+int crypto_blkcipher_encrypt(struct blkcipher_desc *desc,
+			     struct scatterlist *dst,
+			     struct scatterlist *src,
+			     unsigned int nbytes)
+
+The block cipher referenced with desc is used to encrypt nbytes bytes of the
+plaintext data pointed to by the scatter/gather list src and places the
+ciphertext data into the dst scatter/gather list. If the encryption was
+successful, the function returns 0. Otherwise a negative error code is returned.
+
+The caller must fill desc as follows:
+
+	* desc.tfm is filled with the block cipher handle
+	* desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0
+
+
+int crypto_blkcipher_encrypt_iv(struct blkcipher_desc *desc,
+				struct scatterlist *dst,
+				struct scatterlist *src,
+				unsigned int nbytes)
+
+The block cipher referenced with desc is used to encrypt nbytes bytes of the
+plaintext data pointed to by the scatter/gather list src and places the
+ciphertext data into the dst scatter/gather list. If the encryption was
+successful, the function returns 0. Otherwise a negative error code is returned.
+Note, setting the IV with the API call of crypto_blkcipher_set_iv is not
+required before invoking crypto_blkcipher_encrypt_iv.
+
+The caller must fill desc as follows:
+
+	* desc.tfm is filled with the block cipher handle
+	* desc.info is filled with the IV to be used for the current operation
+	* desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0
+
+
+int crypto_blkcipher_decrypt(struct blkcipher_desc *desc,
+			     struct scatterlist *dst,
+			     struct scatterlist *src,
+			     unsigned int nbytes)
+
+The block cipher referenced with desc is used to decrypt nbytes bytes of the
+plaintext data pointed to by the scatter/gather list src and places the
+ciphertext data into the dst scatter/gather list. If the decryption was
+successful, the function returns 0. Otherwise a negative error code is returned.
+
+The caller must fill desc as follows:
+
+	* desc.tfm is filled with the block cipher handle
+	* desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0
+
+
+int crypto_blkcipher_decrypt_iv(struct blkcipher_desc *desc,
+				struct scatterlist *dst,
+				struct scatterlist *src,
+				unsigned int nbytes)
+
+The block cipher referenced with desc is used to decrypt nbytes bytes of the
+plaintext data pointed to by the scatter/gather list src and places the
+ciphertext data into the dst scatter/gather list. If the decryption was
+successful, the function returns 0. Otherwise a negative error code is returned.
+Note, setting the IV with the API call of crypto_blkcipher_set_iv is not
+required before invoking crypto_blkcipher_decrypt_iv.
+
+The caller must fill desc as follows:
+
+	* desc.tfm is filled with the block cipher handle
+	* desc.info is filled with the IV to be used for the current operation
+	* desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0
+
+
+void crypto_blkcipher_set_iv(struct crypto_blkcipher *tfm, const u8 *src,
+			     unsigned int len)
+
+The caller uses this function to set the IV pointed to by the src buffer of len
+length for the block cipher referenced by the tfm cipher handle.
+
+
+void crypto_blkcipher_get_iv(struct crypto_blkcipher *tfm, u8 *dst,
+			     unsigned int len)
+
+The caller uses this function to obtain the IV set for the block cipher
+referenced by the tfm cipher handle and store it into the user-provided buffer
+dst which has a length of len.
+
+
+Example code
+------------
+
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>	/* scatterlist API */
+#include <linux/random.h>	/* needed for get_random_bytes */
+
+static int test_blkcipher(void)
+{
+	struct crypto_blkcipher *blkcipher = NULL;
+	char *cipher = "cbc(aes)";
+	/* AES 128 */
+	char *key = "\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef";
+	char *iv = "\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef";
+	unsigned int ivsize = 0;
+	char *scratchpad = NULL; /*
+				  * holds plaintext and ciphertext -- in-place
+				  * encryption
+				  */
+	struct scatterlist sg;
+	struct blkcipher_desc desc;
+	int ret = -EFAULT;
+
+	blkcipher = crypto_alloc_blkcipher(cipher, 0, 0);
+	if (IS_ERR(blkcipher)) {
+		printk("could not allocate blkcipher handle for %s\n", cipher);
+		return -PTR_ERR(blkcipher);
+	}
+
+	if (crypto_blkcipher_setkey(blkcipher, key, strlen(key))) {
+		printk("key could not be set\n");
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ivsize = crypto_blkcipher_ivsize(blkcipher);
+	if (ivsize) {
+		if (ivsize != strlen(iv))
+			printk("IV length differs from expected length\n");
+		crypto_blkcipher_set_iv(blkcipher, iv, ivsize);
+	}
+
+	scratchpad = kmalloc(crypto_blkcipher_blocksize(blkcipher), GFP_KERNEL);
+	if (!scratchpad) {
+		printk("could not allocate scratchpad for %s\n", cipher);
+		goto out;
+	}
+	/* get some random data that we want to encrypt */
+	get_random_bytes(scratchpad, crypto_blkcipher_blocksize(blkcipher));
+
+	desc.flags = 0;
+	desc.tfm = blkcipher;
+	sg_init_one(&sg, scratchpad, crypto_blkcipher_blocksize(blkcipher));
+
+	/* encrypt data in place */
+	crypto_blkcipher_encrypt(&desc, &sg, &sg,
+				 crypto_blkcipher_blocksize(blkcipher));
+
+	/*
+	 * decrypt data in place
+	 * crypto_blkcipher_decrypt(&desc, &sg, &sg,
+	 *			 crypto_blkcipher_blocksize(blkcipher));
+	 */
+
+	printk("Cipher operation completed\n");
+	return 0;
+
+out:
+	if (blkcipher)
+		crypto_free_blkcipher(blkcipher);
+	if (scratchpad)
+		kzfree(scratchpad);
+	return ret;
+}
+
+
+Asynchronous block cipher API
+=============================
+
+For the synchronous block cipher API, the discussion of the state maintenance
+shows that the state is kept with the tfm handle. However, for asynchronous
+blkcipher calls, context can be in tfm and in the request. Again, a single tfm
+can be used across multiple calls and in parallel. The ablkcipher_request
+structure stores the IV as discussed below and can store additional state info
+in the context field. This would be important for a crypto driver implementer to
+know, because the driver may need to store certain state information. That
+context data field is unused by the kernel crypto API.
+
+#include <linux/crypto.h>
+
+struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask)
+
+Allocate a cipher handle for an asynchronous block cipher. The returned struct
+crypto_ablkcipher is the cipher handle that is required for any operation with
+that block cipher.
+
+alg_name is the name or driver name of the block cipher of type "ablkcipher".
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+void crypto_free_ablkcipher(struct crypto_ablkcipher *tfm)
+
+The referenced block cipher handle is zeroized and subsequently freed.
+
+
+int crypto_has_ablkcipher(const char *alg_name, u32 type,
+			  u32 mask)
+
+Return true when the block cipher with the given alg_name and type/mask flags is
+known to the kernel crypto API. Otherwise return false.
+
+
+unsigned int crypto_ablkcipher_ivsize(struct crypto_ablkcipher *tfm)
+
+The size of the IV for the block cipher referenced by the cipher handle tfm is
+returned. This IV size may be zero if the cipher does not need an IV.
+
+
+unsigned int crypto_ablkcipher_blocksize(struct crypto_ablkcipher *tfm)
+
+The block size for the block cipher referenced with the cipher handle tfm is
+returned.
+
+
+int crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
+			     const u8 *key, unsigned int keylen)
+
+The caller provided key referenced with buffer key and the buffer length of
+keylen is set with the block cipher referenced by the cipher handle tfm. If the
+setting of the key was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
+
+The block cipher referenced with the ablkcipher_request is used to encrypt
+the data referenced in the ablkcipher_request. Please see below for the
+discussion on creating the ablkcipher_request. If the encryption was
+successful, the function returns 0. Otherwise a negative error code is returned.
+
+
+void *crypto_ablkcipher_ctx(struct crypto_ablkcipher *tfm)
+
+This function accesses the tfm's context to allow the caller to set
+or retrieve the context information. The data type of the pointer must be
+determined by the caller. The kernel crypto API does not use this context
+information. This context information is intended to be used by crypto driver
+implementations and NOT for normal kernel crypto API users.
+
+
+int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
+
+The block cipher referenced with the ablkcipher_request is used to decrypt
+the data referenced in the ablkcipher_request. Please see below for the
+discussion on creating the ablkcipher_request. If the decryption was
+successful, the function returns 0. Otherwise a negative error code is returned.
+
+
+Generating the ablkcipher_request data structure
+------------------------------------------------
+
+The ablkcipher_request data structure contains all pointers for the asynchronous
+cipher operation. This includes the cipher handle, pointer to plaintext and
+ciphertext, asynchronous callback function, etc.
+
+struct ablkcipher_request *ablkcipher_request_alloc(
+				struct crypto_ablkcipher *tfm, gfp_t gfp)
+
+This function performs the allocation of the data structure ablkcipher_request
+and registers the block cipher handle tfm with the request data structure. The
+gfp parameter requires the caller to specify the memory allocation flag
+(typically GFP_KERNEL). If an error occurs during this call, PTR_ERR() returns
+the error code.
+
+
+void ablkcipher_request_free(struct ablkcipher_request *req)
+
+The referenced ablkcipher_request handle is zeroized and subsequently freed.
+
+
+void ablkcipher_request_set_tfm(struct ablkcipher_request *req,
+				struct crypto_ablkcipher *tfm)
+
+This function allows the caller to set a block cipher handle with the
+ablkcipher_request.
+
+
+void ablkcipher_request_set_callback(struct ablkcipher_request *req,
+				     u32 flags, crypto_completion_t complete,
+				     void *data)
+
+This function sets the callback function which is invoked once the cipher
+operation is completed. The callback function is registered with the
+ablkcipher_request and must comply with the following template:
+
+	void callback_function(struct crypto_async_request *req, int error)
+
+This callback function is to be pointed to using the complete parameter. The
+"flags" parameter may specify zero or more of the following flags:
+
+	* CRYPTO_TFM_REQ_MAY_BACKLOG: the request queue may back log and
+	  increase the wait queue beyond the initial maximum size
+	* CRYPTO_TFM_REQ_MAY_SLEEP: the request processing may sleep
+
+The "data" pointer refers to memory that is not used by the kernel crypto API,
+but provided to the callback function for it to use. Here, the caller can
+provide a reference to memory the callback function can operate on. As the
+callback function is invoked asynchronously to the related functionality, it may
+need to access data structures of the related functionality which can be
+referenced using this pointer. The callback function can access the memory via
+the "data" field in the crypto_async_request structure.
+
+
+void ablkcipher_request_set_crypt(struct ablkcipher_request *req,
+				  struct scatterlist *src,
+				  struct scatterlist *dst,
+				  unsigned int nbytes, void *iv)
+
+By using this call, the caller sets the source and destination scatter /
+gather lists. For encryption, the source is treated as the plaintext and the
+destination is the ciphertext. For a decryption operation, the use is
+reversed: the source is the ciphertext and the destination is the plaintext. The
+number of bytes to process from source is referenced with the "nbytes"
+parameter. The IV is set for the cipher operation using the "iv" parameter.
+
+
+void *ablkcipher_request_ctx(struct ablkcipher_request *req)
+
+This function accesses the request's context to allow the caller to set
+or retrieve the context information. The data type of the pointer must be
+determined by the caller. The kernel crypto API does not use this context
+information. This context information is intended to be used by crypto driver
+implementations and NOT for normal kernel crypto API users.
+
+
+Example code
+------------
+
+The following code is an example for the asynchronous block cipher operation.
+
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>	/* scatterlist API */
+#include <linux/random.h>	/* needed for get_random_bytes */
+
+struct tcrypt_result {
+	struct completion completion;
+	int err;
+};
+
+/* tie all data structures together */
+struct ablkcipher_def {
+	struct scatterlist sg;
+	struct crypto_ablkcipher *tfm;
+	struct ablkcipher_request *req;
+	struct tcrypt_result result;
+};
+
+/* Callback function */
+static void test_ablkcipher_cb(struct crypto_async_request *req, int error)
+{
+	struct tcrypt_result *result = req->data;
+
+	if (error == -EINPROGRESS)
+		return;
+	result->err = error;
+	complete(&result->completion);
+	pr_info("Encryption finished successfully\n");
+}
+
+/* Perform encryption or decryption */
+static unsigned int test_ablkcipher_encdec(struct ablkcipher_def *ablk,
+					   int enc)
+{
+	int rc = 0;
+
+	if (enc)
+		rc = crypto_ablkcipher_encrypt(ablk->req);
+	else
+		rc = crypto_ablkcipher_decrypt(ablk->req);
+
+	switch (rc) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		rc = wait_for_completion_interruptible(
+			&ablk->result.completion);
+		if (!rc && !ablk->result.err) {
+			reinit_completion(&ablk->result.completion);
+			break;
+		}
+	default:
+		pr_info("ablkcipher encrypt returned with %d result %d\n",
+		       rc, ablk->result.err);
+		break;
+	}
+	init_completion(&ablk->result.completion);
+
+	return rc;
+}
+
+/* Initialize and trigger cipher operation */
+static int test_ablkcipher(void)
+{
+	struct ablkcipher_def ablk;
+	struct crypto_ablkcipher *ablkcipher = NULL;
+	struct ablkcipher_request *req = NULL;
+	char *scratchpad = NULL;
+	char *ivdata = NULL;
+	unsigned char key[32];
+	int ret = -EFAULT;
+
+	ablkcipher = crypto_alloc_ablkcipher("cbc-aes-aesni", 0, 0);
+	if (IS_ERR(ablkcipher)) {
+		pr_info("could not allocate ablkcipher handle\n");
+		return -PTR_ERR(ablkcipher);
+	}
+
+	req = ablkcipher_request_alloc(ablkcipher, GFP_KERNEL);
+	if (IS_ERR(req)) {
+		pr_info("could not allocate request queue\n");
+		ret = -PTR_ERR(req);
+		goto out;
+	}
+
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					test_ablkcipher_cb,
+					&ablk.result);
+
+	/* AES 256 with random key */
+	get_random_bytes(&key, 32);
+	if (crypto_ablkcipher_setkey(ablkcipher, key, 32)) {
+		pr_info("key could not be set\n");
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	/* IV will be random */
+	ivdata = kmalloc(16, GFP_KERNEL);
+	if (!ivdata) {
+		pr_info("could not allocate ivdata\n");
+		goto out;
+	}
+	get_random_bytes(ivdata, 16);
+
+	/* Input data will be random */
+	scratchpad = kmalloc(16, GFP_KERNEL);
+	if (!scratchpad) {
+		pr_info("could not allocate scratchpad\n");
+		goto out;
+	}
+	get_random_bytes(scratchpad, 16);
+
+	ablk.tfm = ablkcipher;
+	ablk.req = req;
+
+	/* We encrypt one block */
+	sg_init_one(&ablk.sg, scratchpad, 16);
+	ablkcipher_request_set_crypt(req, &ablk.sg, &ablk.sg, 16, ivdata);
+	init_completion(&ablk.result.completion);
+
+	/* encrypt data */
+	ret = test_ablkcipher_encdec(&ablk, 1);
+	if (ret)
+		goto out;
+
+	pr_info("Encryption triggered successfully\n");
+
+out:
+	if (ablkcipher)
+		crypto_free_ablkcipher(ablkcipher);
+	if (req)
+		ablkcipher_request_free(req);
+	if (ivdata)
+		kfree(ivdata);
+	if (scratchpad)
+		kfree(scratchpad);
+	return ret;
+}
+
+
+Synchronous message digest API
+==============================
+
+#include <linux/crypto.h>
+
+struct crypto_hash *crypto_alloc_hash(const char *alg_name, u32 type, u32 mask)
+
+Allocate a cipher handle for a hash. The returned struct crypto_hash is the
+cipher handle that is required for any operation with that hash cipher.
+
+alg_name is the name or driver name of the hash of type "shash".
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+void crypto_free_hash(struct crypto_hash *tfm)
+
+The referenced hash cipher handle is zeroized and subsequently freed.
+
+
+int crypto_hash_blocksize(struct crypto_hash *tfm)
+
+The block size for the hash referenced with the cipher handle tfm is returned.
+
+
+int crypto_hash_digestsize(struct crypto_hash *tfm)
+
+The message digest size for the hash referenced with the cipher handle tfm is
+returned.
+
+
+int crypto_hash_setkey(struct crypto_hash *hash, const u8 *key,
+		       unsigned int keylen)
+
+The caller provided key referenced with buffer key and the buffer length of
+keylen is set with the hash referenced by the cipher handle "hash". The cipher
+handle must point to a keyed hash in order for this function to succeed. If the
+setting of the key was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+
+int crypto_hash_init(struct hash_desc *desc)
+
+The call (re-)initializes the hash referenced by the desc handle. Any
+potentially existing state created by previous operations is discarded.
+
+The caller must fill desc as follows:
+
+	* desc.tfm is filled with the hash cipher handle
+	* desc.flags is filled with either CRYPTO_TFM_REQ_MAY_SLEEP or 0
+
+The function returns 0 on success. In case of an error, it returns the negative
+error value.
+
+
+int crypto_hash_update(struct hash_desc *desc, struct scatterlist *sg, unsigned
+		       int nbytes)
+
+The invocation of crypto_hash_update updates the hash state of the hash cipher
+handle pointed to by desc and the input data pointed to by the scatter/gather
+list sg. Only nbytes of the input data is processed. The function returns 0 on
+success. In case of an error, it returns the negative error value.
+
+
+int crypto_hash_final(struct hash_desc *desc, u8 *out)
+
+With this function, the message digest of the hash state pointed to by desc is
+calculated and placed into the out buffer. The caller must ensure that the out
+buffer has a sufficient size (e.g. by using the crypto_hash_digestsize
+function). The function returns 0 on success. In case of an error, it returns
+the negative error value.
+
+
+int crypto_hash_digest(struct hash_desc *desc, struct scatterlist *sg,
+		       unsigned int nbytes, u8 *out)
+
+This function is a "short-hand" for the function calls of crypto_hash_init,
+crypto_hash_update and crypto_hash_final. The parameters have the same meaning
+as discussed for those separate three functions. The function returns 0 on
+success. In case of an error, it returns the negative error value.
+
+
+Synchronous message digest API with caller-accessible state space
+=================================================================
+
+Considering the discussion of the state maintenance for the block cipher API
+the message digest API is also able to maintain state information for the
+caller. Though, the maintenance of the state is a bit different for the message
+digest API, as both the synchronous and asynchronous message digest APIs
+can store additional context info.
+
+The synchronous message digest API can store user-related context in in its
+shash_desc data structure. Again, this would be important for someone writing a
+crypto driver, with a hash update call where the state can change each time
+update is called.
+
+
+#include <crypto/hash.h>
+
+struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
+					u32 mask)
+
+Allocate a cipher handle for a hash. The returned struct crypto_shash is the
+cipher handle that is required for any operation with that hash cipher.
+
+alg_name is the name or driver name of the hash of type "shash".
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+void crypto_free_shash(struct crypto_shash *tfm)
+
+The referenced hash cipher handle is zeroized and subsequently freed.
+
+
+unsigned int crypto_shash_blocksize(struct crypto_shash *tfm)
+
+The block size for the hash referenced with the cipher handle tfm is returned.
+
+
+unsigned int crypto_shash_digestsize(struct crypto_shash *tfm)
+
+The message digest size for the hash referenced with the cipher handle tfm is
+returned.
+
+
+unsigned int crypto_shash_descsize(struct crypto_shash *tfm)
+
+The size of the operational state the cipher needs during operation is returned
+for the hash referenced with the cipher handle tfm.
+
+
+int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
+			unsigned int keylen);
+
+The caller provided key referenced with buffer key and the buffer length of
+keylen is set with the hash referenced by the cipher handle tfm. This call turns
+the message digest operation into a keyed message digest operation. If the
+setting of the key was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+int crypto_shash_init(struct shash_desc *desc)
+
+The call (re-)initializes the hash referenced by the desc handle. Any
+potentially existing state created by previous operations is discarded.
+
+
+int crypto_shash_update(struct shash_desc *desc, const u8 *data,
+                        unsigned int len)
+
+The invocation of crypto_shash_update updates the hash state of the hash cipher
+handle pointed to by desc (see below for a description of this data structure)
+and the input data pointed to by the "data" pointer. "len" specifies the size of
+"data" in bytes The function returns 0 on success. In case of an error, it
+returns the negative error value.
+
+
+int crypto_shash_final(struct shash_desc *desc, u8 *out)
+
+With this function, the message digest of the hash state pointed to by desc is
+calculated and placed into the out buffer. The caller must ensure that the out
+buffer has a sufficient size (e.g. by using the crypto_shash_digestsize
+function). The function returns 0 on success. In case of an error, it returns
+the negative error value.
+
+
+int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out);
+
+This function returns the message digest of the input data pointed to by the
+buffer data that has the length len. The message digest is copied to the out
+buffer that must be allocated by the caller and must have sufficient space (e.g.
+the caller used crypto_shash_digestsize to determine its size). In essence,
+this function is a "short-hand" for the function call combination of
+crypto_shash_update and crypto_shash_final. The function returns 0 on success.
+In case of an error, it returns the negative error value.
+
+The hash cipher handle shash_desc must be allocated by the caller and must have
+sufficient space adjacent to the shash_desc pointer for the state of the hash
+cipher operation. The following code snippet can be used to allocate the memory.
+
+struct sdesc {
+        struct shash_desc shash;
+        char ctx[];
+};
+
+static struct sdesc *init_sdesc(struct crypto_shash *alg)
+{
+	struct sdesc *sdesc;
+	int size;
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc)
+		return ERR_PTR(-ENOMEM);
+	sdesc->shash.tfm = alg;
+	sdesc->shash.flags = 0x0;
+	return sdesc;
+}
+
+static int calc_hash(const unsigned char *data, unsigned int datalen,
+		     unsigned char *digest) {
+	struct sdesc *sdesc;
+	int ret;
+
+	sdesc = init_sdesc(hashalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		return PTR_ERR(sdesc);
+	}
+
+	ret = crypto_shash_digest(&sdesc->shash, data, datalen, digest);
+	kfree(sdesc);
+	return ret;
+}
+
+
+void *shash_desc_ctx(struct shash_desc *desc)
+
+This function accesses the desc's context to allow the caller to set
+or retrieve the context information. The data type of the pointer must be
+determined by the caller. The kernel crypto API does not use this context
+information. This context information is intended to be used by crypto driver
+implementations and NOT for normal kernel crypto API users.
+
+
+int crypto_shash_export(struct shash_desc *desc, void *out)
+
+This function exports the hash state of the cipher handle desc into the
+caller-allocated output buffer out which must have sufficient size (e.g. by
+calling crypto_shash_descsize). The function returns 0 on success. In case of an
+error, it returns the negative error value.
+
+
+int crypto_shash_import(struct shash_desc *desc, const void *in)
+
+This function imports the hash state of the cipher handle desc from the input
+buffer in. The function returns 0 on success. In case of an error, it returns
+the negative error value.
+
+
+Asynchronous message digest API
+===============================
+
+The asynchronous message digest API can store user-related context in in its
+ahash_desc data structure. Again, this would be important for someone writing a
+crypto driver, with  a hash update call where the state can change each time
+update is called.
+
+
+#include <crypto/hash.h>
+
+struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
+					u32 mask)
+
+Allocate a cipher handle for a hash. The returned struct crypto_ahash is the
+cipher handle that is required for any operation with that hash cipher.
+
+alg_name is the name or driver name of the hash of type "ahash".
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+static inline void crypto_free_ahash(struct crypto_ahash *tfm)
+
+The referenced hash cipher handle is zeroized and subsequently freed.
+
+
+unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
+
+The message digest size for the hash referenced with the cipher handle tfm is
+returned.
+
+
+unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
+
+The size of the operational state the cipher needs during operation is returned
+for the hash referenced with the cipher handle tfm.
+
+
+int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen)
+
+The caller provided key referenced with buffer key and the buffer length of
+keylen is set with the hash referenced by the cipher handle tfm. This call turns
+the message digest operation into a keyed message digest operation. If the
+setting of the key was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+int crypto_ahash_digest(struct ahash_request *req)
+
+The hash referenced with with the ahash_request is used to calculate the message
+digest of the data referenced in the ahash_request. Please see below for the
+discussion on creating the ahash_request. If the message digest generation was
+successful, the function returns 0. Otherwise a negative error code is returned.
+
+
+int crypto_ahash_init(struct ahash_request *req)
+
+The call (re-)initializes the hash referenced by the ahash_request handle.
+Please see below for the discussion on creating the ahash_request. Any
+potentially existing state created by previous operations is discarded. The
+function returns 0 on success. In case of an error, it returns the negative
+error value.
+
+int crypto_ahash_update(struct ahash_request *req)
+
+The invocation of crypto_hash_update updates the hash state of the ahash_request
+handle pointed to by req. This request handle contains the reference to the
+input data to be added to the message digest via a the scatter/gather list.
+Please see below for the discussion on maintaining the ahash_request data
+structure. The function returns 0 on success. In case of an error, it returns
+the negative error value.
+
+
+int crypto_ahash_final(struct ahash_request *req)
+
+With this function, the message digest of the hash state pointed to by
+ahash_request is calculated and placed into the output buffer referenced in the
+request handle. The function returns 0 on success. In case of an error, it
+returns the negative error value.
+
+
+int crypto_ahash_finup(struct ahash_request *req)
+
+The combination of the crypto_ahash_update and crypto_ahash_final is invoked
+with this function. Therefore the caller only needs one invocation to update and
+finalize the message digest calculation. The function returns 0 on success. In
+case of an error, it returns the negative error value.
+
+
+int crypto_ahash_export(struct ahash_request *req, void *out)
+
+This function exports the hash state of the request handle req into the
+caller-allocated output buffer out which must have sufficient size (e.g. by
+calling crypto_ahash_reqsize). The function returns 0 on success. In case of an
+error, it returns the negative error value.
+
+
+int crypto_ahash_import(struct ahash_request *req, const void *in)
+
+This function imports the hash state of the request handle req from the input
+buffer in. The function returns 0 on success. In case of an error, it returns
+the negative error value.
+
+
+Generating the ahash_request data structure
+-------------------------------------------
+
+The ahash_request data structure contains all pointers for the asynchronous
+cipher operation. This includes the cipher handle, pointer to input data and
+message digest buffer, asynchronous callback function, etc. This data structure
+is conceptually very similar to the ablkcipher_request discussed above.
+
+struct ahash_request *ahash_request_alloc(struct crypto_ahash *tfm, gfp_t gfp)
+
+This function performs the allocation of the data structure ahash_request and
+registers the hash cipher handle tfm with the request data structure. If an
+error occurs during this call, PTR_ERR() returns the error code.
+
+
+void ahash_request_free(struct ahash_request *req)
+
+The referenced ablkcipher_request handle is zeroized and subsequently freed.
+
+
+void ahash_request_set_tfm(struct ahash_request *req, struct crypto_ahash *tfm)
+
+This function allows the caller to set a hash cipher handle with the
+ahash_request.
+
+
+void ahash_request_set_callback(struct ahash_request *req,
+				u32 flags,
+				crypto_completion_t complete,
+				void *data)
+
+This function sets the callback function which is invoked once the cipher
+operation is completed. The callback function is registered with the
+ahash_request and must comply with the following template:
+
+	void callback_function(struct crypto_async_request *req, int error)
+
+This callback function is to be pointed to using the complete parameter. The
+flags parameter may specify zero or more of the following flags:
+
+	* CRYPTO_TFM_REQ_MAY_BACKLOG: the request queue may back log and
+	  increase the wait queue beyond the initial maximum size
+	* CRYPTO_TFM_REQ_MAY_SLEEP: the request processing may sleep
+
+The data pointer refers to memory that is not used by the kernel crypto API, but
+provided to the callback function. Here, the caller can provide a reference to
+memory the callback function can operate on.
+
+
+void ahash_request_set_crypt(struct ahash_request *req,
+			     struct scatterlist *src, u8 *result,
+			     unsigned int nbytes)
+
+By using this call, the caller references the source and destination scatter /
+gather lists. The number of bytes to process from source is referenced with the
+nbytes parameter. The message digest is written to the buffer pointed to by the
+result pointer. The caller must ensure that the buffer has sufficient space by,
+for example, calling crypto_ahash_digestsize.
+
+
+void *ahash_request_ctx(struct ahash_request *req)
+
+This function accesses the request's context to allow the caller to set
+or retrieve the context information. The data type of the pointer must be
+determined by the caller. The kernel crypto API does not use this context
+information. This context information is intended to be used by crypto driver
+implementations and NOT for normal kernel crypto API users.
+
+
+Example code
+------------
+
+The example code given for the asynchronous block cipher operation can be used
+as a template where the ablkcipher function calls are swapped with ahash
+function calls.
+
+
+Random number generation API
+============================
+
+#include <crypto/rng.h>
+
+struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
+
+Allocate a cipher handle for a random number generator. The returned struct
+crypto_rng is the cipher handle that is required for any operation with that
+random number generator. For all random number generators, this call creates a
+new private copy of the random number generator that does not share a state with
+other instances. The only exception is the "krng" random number generator which
+is a kernel crypto API use case for the get_random_bytes() function of the
+/dev/random driver.
+
+alg_name is the name or driver name of the random number generator.
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+void crypto_free_rng(struct crypto_rng *tfm)
+
+The referenced random number cipher handle is zeroized and subsequently freed.
+
+
+int crypto_rng_get_bytes(struct crypto_rng *tfm, u8 *rdata, unsigned int dlen)
+
+This function fills the caller-allocated buffer rdata that has the length of
+dlen with random numbers using the random number generator referenced by the tfm
+cipher handle.
+
+The function returns the number of generated random bytes. In case of an error,
+it returns the negative error value.
+
+
+int crypto_rng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+
+The reset function completely re-initializes the random number generator
+referenced by the tfm cipher handle by clearing the current state. The new state
+is initialized with the caller provided seed provided in the seed buffer of slen
+length. The provided seed should have the length of the seed size defined for
+the random number generator.
+
+The function returns 0 on success. In case of an error, it returns the negative
+error value.
+
+
+int crypto_rng_seedsize(struct crypto_rng *tfm)
+
+The function returns the seed size for the random number generator referenced by
+the tfm cipher handle.
+
+
+Example code
+------------
+
+static int get_random_numbers(u8 *buf, unsigned int len)
+{
+	struct crypto_rng *rng = NULL;
+	char *drbg = "drbg_nopr_sha256"; /* Hash DRBG with SHA-256, no PR */
+	int ret;
+
+	if (!buf || !len) {
+		pr_debug("No output buffer provided\n");
+		return -EINVAL;
+	}
+
+	rng = crypto_alloc_rng(drbg, 0, 0);
+	if (IS_ERR(rng)) {
+		pr_debug("could not allocate RNG handle for %s\n", drbg);
+		return -PTR_ERR(rng);
+	}
+
+	ret = crypto_rng_get_bytes(rng, buf, len);
+	if (ret < 0)
+		pr_debug("generation of random numbers failed\n");
+	else if (ret == 0)
+		pr_debug("RNG returned no data");
+	else
+		pr_debug("RNG returned %d bytes of data\n", ret);
+
+out:
+	crypto_free_rng(rng);
+	return ret;
+}
+
+AEAD asynchronous cipher API
+============================
+
+The kernel supports Authenticated Encryption with Associated Data. The most
+prominent examples for this type of encryption is GCM and CCM. However, the
+kernel supports other types of AEAD ciphers which are defined with the
+following cipher string:
+
+	authenc(<keyed message digest>, <block cipher>)
+
+For example: authenc(hmac(sha256), cbc(aes))
+
+
+#include <linux/crypto.h>
+
+struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
+
+Allocate a cipher handle for the AEAD cipher. The returned struct crypto_aead is
+the cipher handle that is required for any operation with that AEAD cipher.
+
+alg_name is the name or driver name of the hash of type "aead".
+
+If an error occurs during this call, PTR_ERR() returns the error code.
+
+
+void crypto_free_aead(struct crypto_aead *tfm)
+
+The referenced AEAD cipher handle is zeroized and subsequently freed.
+
+
+unsigned int crypto_aead_ivsize(struct crypto_aead *tfm)
+
+The size of the IV for the AEAD cipher referenced by the cipher handle tfm is
+returned. This IV size may be zero if the cipher does not need an IV.
+
+
+unsigned int crypto_aead_authsize(struct crypto_aead *tfm)
+
+The maximum size of the authentication data for the AEAD cipher referenced by
+the cipher handle tfm is returned. The authentication data size may be zero if
+the cipher implements a hard-coded maximum.
+
+
+unsigned int crypto_aead_blocksize(struct crypto_aead *tfm)
+
+The block size for the AEAD cipher referenced with the cipher handle tfm is
+returned.
+
+
+int crypto_aead_setkey(struct crypto_aead *tfm, const u8 *key,
+		       unsigned int keylen)
+
+The caller provided key referenced with buffer key and the buffer length of
+keylen is set with the AEAD cipher referenced by the cipher handle tfm. If the
+setting of the key was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+int crypto_aead_encrypt(struct aead_request *req)
+
+The AEAD cipher referenced with the aead_request is used to encrypt the data
+referenced in the aead_request. Please see below for the discussion on creating
+the aead_request. During the encryption operation, the ciphertext as well as
+the associated data is generated.
+
+The created authentication tag is concatenated with the ciphertext. The
+caller must ensure that sufficient memory is available for the ciphertext and
+the authentication tag.
+
+If the encryption was successful, the function returns 0. Otherwise a negative
+error code is returned.
+
+
+int crypto_aead_decrypt(struct aead_request *req)
+
+The AEAD cipher referenced with the aead_request is used to decrypt the data
+referenced in the aead_request. Please see below for the discussion on creating
+the aead_request. If the encryption was successful, the function returns 0.
+Otherwise a negative error code is returned.
+
+The caller must concatenate the ciphertext followed by the authentication tag.
+
+The AEAD cipher operation performs the authentication of the data during the
+decryption operation. Therefore, the crypto_aead_decrypt returns the error of
+-EBADMSG if the authentication of the ciphertext was unsuccessful (i.e. the
+integrity of the ciphertext or the associated data was violated).
+
+
+int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+
+Set the Authentication Tag size. AEAD requires an authentication tag (or MAC)
+in addition to the associated data. The authentication tag is appended
+to the ciphertext. If the setting of the authentication data size was
+successful, the function returns 0. Otherwise a negative error code is returned
+(e.g. set authentication data size is larger than maximum authentication data
+size).
+
+
+Generating the aead_request data structure
+------------------------------------------
+
+The aead_request data structure contains all pointers for the asynchronous
+cipher operation. This includes the cipher handle, pointer to plaintext and
+ciphertext, associated data, asynchronous callback function, etc.
+
+struct aead_request *aead_request_alloc(struct crypto_aead *tfm, gfp_t gfp)
+
+This function performs the allocation of the data structure aead_request
+and registers the AEAD cipher handle tfm with the request data structure. The
+gfp parameter requires the caller to specify the memory allocation flag
+(typically GFP_KERNEL). If an error occurs during this call, PTR_ERR() returns
+the error code.
+
+
+void aead_request_free(struct aead_request *req)
+
+The referenced aead_request handle is zeroized and subsequently freed.
+
+
+void aead_request_set_tfm(struct aead_request *req, struct crypto_aead *tfm)
+
+This function allows the caller to set a block cipher handle with the
+aead_request.
+
+
+void aead_request_set_callback(struct aead_request *req, u32 flags,
+			       crypto_completion_t complete, void *data)
+
+This function sets the callback function which is invoked once the cipher
+operation is completed. The callback function is registered with the
+ablkcipher_request and must comply with the following template:
+
+	void callback_function(struct crypto_async_request *req, int error)
+
+This callback function is to be pointed to using the complete parameter. The
+"flags" parameter may specify zero or more of the following flags:
+
+	* CRYPTO_TFM_REQ_MAY_BACKLOG: the request queue may back log and
+	  increase the wait queue beyond the initial maximum size
+	* CRYPTO_TFM_REQ_MAY_SLEEP: the request processing may sleep
+
+The "data" pointer refers to memory that is not used by the kernel crypto API,
+but provided to the callback function for it to use. Here, the caller can
+provide a reference to memory the callback function can operate on. As the
+callback function is invoked asynchronously to the related functionality, it may
+need to access data structures of the related functionality which can be
+referenced using this pointer. The callback function can access the memory via
+the "data" field in the crypto_async_request structure.
+
+
+void aead_request_set_crypt(struct aead_request *req,
+			    struct scatterlist *src,
+			    struct scatterlist *dst,
+			    unsigned int cryptlen, u8 *iv)
+
+By using this call, the caller sets the source and destination scatter /
+gather lists. For encryption, the source is treated as the plaintext and the
+destination is the ciphertext. For a decryption operation, the use is
+reversed: the source is the ciphertext and the destination is the plaintext. The
+number of bytes to process from source is referenced with the "cryptlen"
+parameter. The IV is set for the cipher operation using the "iv" parameter.
+
+Important note: AEAD requires an authentication tag (MAC). For decryption, the
+caller must concatenate the ciphertext followed by the authentication tag and
+provide the entire data stream to the decryption operation (i.e. the data length
+used for the initialization of the scatterlist and the data length for the
+decryption operation is identical). For encryption, however, the authentication
+tag is created while encrypting the data. The destination buffer must hold
+sufficient space for the ciphertext and the authentication tag while the
+encryption invocation must only point to the plaintext data size. The following
+code snippet should illustrate that:
+
+/*
+ * sg is the pointer to plaintext and will hold the cipher text
+ * authsize is the size of the authentication tag
+ * enc is 1 for encryption, 0 for decryption
+ * ptbuf is the buffer with the plaintext
+ * ptbuflen is the plaintext buffer size
+ */
+buffer = kmalloc(ptbuflen + (enc ? authsize : 0));
+memcpy(buffer, ptbuf, ptbuflen);
+sg_init_one(&sg, buffer, ptbuflen + (enc ? authsize : 0));
+aead_request_set_crypt(req, &sg, &sg, ptbuflen, iv);
+
+
+void aead_request_set_assoc(struct aead_request *req,
+			    struct scatterlist *assoc, unsigned int assoclen)
+
+The scatter / gather list "assoc" points to the associated data and "assoclen"
+specifies the size of the associated data.
+
+For encryption, the pointer must reference memory that is filled with the
+associated data. That associated data must be transported to the entity
+performing the AEAD decryption along with the ciphertext. For decryption, this
+function call allows the caller to set the pointer to the associated data for
+the integrity verification.
+
+
+Example code
+------------
+
+The example code provided for the asynchronous block cipher operation applies
+here as well. The only difference is that for the AEAD operation, the
+aead_request_set_assoc function must be used to set the associated data before
+performing the encryption or decryption operation.
+
+The second deviation from the asynchronous block cipher operation is that the
+caller should explicitly check for -EBADMSG of the crypto_aead_decrypt
+invocation to catch authentication errors.
+
+
+User space API
+==============
+
+The kernel crypto API is accessible from user space. Currently, the following
+ciphers are accessible:
+
+	* Message digest including keyed message digest
+
+	* Symmetric ciphers
+
+The interface is provided via Netlink using the type AF_ALG. In addition, the
+setsockopt option type is SOL_ALG. In case the user space header files do not
+export these flags yet, use the following macros:
+
+#ifndef AF_ALG
+#define AF_ALG 38
+#endif
+#ifndef SOL_ALG
+#define SOL_ALG 279
+#endif
+
+A cipher is accessed with the same name as done for the in-kernel API calls.
+
+To interact with the kernel crypto API, a Netlink socket must be created by
+the user space application. User space invokes the cipher operation with the
+send/write system call family. The result of the cipher operation is obtained
+with the read/recv system call family.
+
+The following API calls assume that the Netlink socket descriptor is already
+opened by the user space application and discusses only the kernel crypto API
+specific invocations.
+
+Message digest API
+------------------
+
+The message digest type to be used for the cipher operation is selected when
+invoking the bind syscall. bind requires the caller to provide a filled
+struct sockaddr data structure. This data structure must be filled as follows:
+
+struct sockaddr_alg sa = {
+	.salg_family = AF_ALG,
+	.salg_type = "hash", /* this selects the hash logic in the kernel */
+	.salg_nmae = "sha1" /* this is the cipher name */
+};
+
+Using the send() system call, the application provides the data that should be
+processed with the message digest. The send system call allows the following
+flags to be specified:
+
+	* MSG_MORE: If this flag is set, the send system call acts like a
+		    message digest update function where the final hash is not
+		    yet calculated. If the flag is not set, the send system call
+		    calculates the final message digest immediately.
+
+With the read() system call, the application can read the message digest from
+the kernel crypto API. If the buffer is too small for the message digest, the
+flag MSG_TRUNC is set by the kernel.
+
+In order to set a message digest key, the calling application must use the
+setsockopt() option of ALG_SET_KEY.
+
+
+Symmetric cipher API
+--------------------
+
+The operation is very similar to the message digest discussion. During
+initialization, the struct sockaddr data structure must be filled as follows:
+
+struct sockaddr_alg sa = {
+	.salg_family = AF_ALG,
+	.salg_type = "skcipher", /* this selects the symmetric cipher */
+	.salg_name = "cbc(aes)" /* this is the cipher name */
+};
+
+Using the sendmsg() system call, the application provides the data that should
+be processed for encryption or decryption. In addition, the IV is specified
+with the data structure provided by the sendmsg() system call.
+
+The sendmsg system call parameter of struct msghdr is embedded into the
+struct cmsghdr data structure. See recv(2) and cmsg(3) for more information
+on how the cmsghdr data structure is used together with the send/recv system
+call family. That cmsghdr data structure holds the following information
+specified with a separate header instances:
+
+	* specification of the cipher operation type with one of these flags:
+		ALG_OP_ENCRYPT - encryption of data
+		ALG_OP_DECRYPT - decryption of data
+
+	* specification of the IV information marked with the flag ALG_SET_IV
+
+The send system call family allows the following flag to be specified:
+
+	* MSG_MORE: If this flag is set, the send system call acts like a
+		    cipher update function where more input data is expected
+		    with a subsequent invocation of the send system call.
+
+Note: The kernel reports -EINVAL for any unexpected data. The caller must
+make sure that all data matches the constraints given in /proc/crypto for the
+selected cipher.
+
+With the read() system call, the application can read the result of the
+cipher operation from the kernel crypto API. The output buffer must be at least
+as large as to hold all blocks of the encrypted or decrypted data. If the output
+data size is smaller, only the as many blocks are returned that fit into that
+output buffer size.
+
+User space API example
+----------------------
+
+Compile the following code with the gcc flags of "-Wextra -Wall -pedantic".
+
+/*
+ * Code from cryptsetup version 1.6.4 used as a basis
+ */
+
+#include <stdio.h>
+
+#include <unistd.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <linux/if_alg.h>
+#include <stdint.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+
+#ifndef AF_ALG
+#define AF_ALG 38
+#endif
+#ifndef SOL_ALG
+#define SOL_ALG 279
+#endif
+
+/************************************************************
+ * Application interfaces
+ ************************************************************/
+
+/* Cipher handle */
+struct kcapi_handle {
+	int tfmfd;
+	int opfd;
+};
+
+/************************************************************
+ * Internal logic
+ ************************************************************/
+
+/* The in/out should be aligned to page boundary */
+static int _kcapi_cipher_crypt(struct kcapi_handle *handle,
+			       const unsigned char *in, size_t inlen,
+			       unsigned char *out, size_t outlen,
+			       const unsigned char *iv, size_t ivlen,
+			       uint32_t enc)
+{
+	int r = 0;
+	ssize_t ret;
+	struct af_alg_iv *alg_iv;
+	struct cmsghdr *header;
+	uint32_t *type;
+	struct iovec iov;
+	int iv_msg_size = iv ? CMSG_SPACE(sizeof(*alg_iv) + ivlen) : 0;
+	char *buffer = NULL;
+	unsigned int bufferlen = CMSG_SPACE(sizeof(*type)) + iv_msg_size;
+	struct msghdr msg;
+
+	if (!in || !out || !inlen || !outlen)
+		return -EINVAL;
+
+	if ((!iv && ivlen) || (iv && !ivlen))
+		return -EINVAL;
+
+	buffer = calloc(1, bufferlen);
+	if (!buffer)
+		return -ENOMEM;
+
+	iov.iov_base = (void*)(uintptr_t)in;
+	iov.iov_len = inlen;
+	msg.msg_control = buffer;
+	msg.msg_controllen = bufferlen;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	/* encrypt/decrypt operation */
+	header = CMSG_FIRSTHDR(&msg);
+	header->cmsg_level = SOL_ALG;
+	header->cmsg_type = ALG_SET_OP;
+	header->cmsg_len = CMSG_LEN(sizeof(*type));
+	type = (void*)CMSG_DATA(header);
+	*type = enc;
+
+	/* set IV */
+	if (iv) {
+		header = CMSG_NXTHDR(&msg, header);
+		header->cmsg_level = SOL_ALG;
+		header->cmsg_type = ALG_SET_IV;
+		header->cmsg_len = iv_msg_size;
+		alg_iv = (void*)CMSG_DATA(header);
+		alg_iv->ivlen = ivlen;
+		memcpy(alg_iv->iv, iv, ivlen);
+	}
+
+	ret = sendmsg(handle->opfd, &msg, 0);
+	if (ret != (ssize_t)inlen) {
+		r = -EIO;
+		goto bad;
+	}
+
+	ret = read(handle->opfd, out, outlen);
+	if (ret != (ssize_t)outlen)
+		r = -EIO;
+bad:
+	memset(buffer, 0, bufferlen);
+	free(buffer);
+	return r;
+}
+
+
+/************************************************************
+ * API to application
+ ************************************************************/
+
+/*
+ * Initialization of a cipher handle and establishing the connection to
+ * the kernel
+ *
+ * @handle cipher handle filled during the call - output
+ * @type cipher type, one of the following - input:
+ *	 "hash" for message digests (including keyed message digests)
+ *	 "skcipher" for symmetric ciphers
+ * @ciphername kernel crypto API cipher name as specified in
+ *	       /proc/crypto - input
+ *
+ * return: 0 upon success
+ *	   < 0 in case of error
+ *		ENOENT - algorithm not available
+ *		ENOTSUP - AF_ALG family not available
+ *		EINVAL - accept syscall failed
+ */
+int kcapi_cipher_init(struct kcapi_handle *handle,
+		      const char *type, const char *ciphername)
+{
+	struct sockaddr_alg sa;
+
+	memset(&sa, 0, sizeof(sa));
+	sa.salg_family = AF_ALG;
+	snprintf((char *)sa.salg_type, sizeof(sa.salg_type),"%s", type);
+	snprintf((char *)sa.salg_name, sizeof(sa.salg_name),"%s", ciphername);
+
+	handle->tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
+	if (handle->tfmfd == -1)
+		return -ENOTSUP;
+
+	if (bind(handle->tfmfd, (struct sockaddr *)&sa, sizeof(sa)) == -1) {
+		close(handle->tfmfd);
+		handle->tfmfd = -1;
+		return -ENOENT;
+	}
+
+	handle->opfd = accept(handle->tfmfd, NULL, 0);
+	if (handle->opfd == -1) {
+		close(handle->tfmfd);
+		handle->tfmfd = -1;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Close the cipher handle and release resources
+ *
+ * @handle cipher handle to release - input
+ *
+ * return: 0 upon success
+ */
+int kcapi_cipher_destory(struct kcapi_handle *handle)
+{
+	if (handle->tfmfd != -1)
+		close(handle->tfmfd);
+	if (handle->opfd != -1)
+		close(handle->opfd);
+	return 0;
+}
+
+
+/*
+ * Set the key for the cipher handle
+ *
+ * This call is applicable for keyed message digests and symmetric ciphers.
+ *
+ * @handle cipher handle - input
+ * @key key buffer - input
+ * @keylen length of key buffer - input
+ *
+ * return: 0 upon success
+ *	   < 0 in case of error
+ */
+int kcapi_cipher_setkey(struct kcapi_handle *handle,
+			const unsigned char *key, size_t keylen)
+{
+	if (setsockopt(handle->tfmfd, SOL_ALG, ALG_SET_KEY,
+		       key, keylen) == -1)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Message digest update function
+ *
+ * @handle cipher handle - input
+ * @buffer holding the data to add to the message digest - input
+ * @len buffer length - input
+ *
+ * return: 0 upon success
+ *	   < 0 in case of error
+ */
+int kcapi_md_update(struct kcapi_handle *handle,
+		    const unsigned char *buffer, size_t len)
+{
+	ssize_t r;
+
+	r = send(handle->opfd, buffer, len, MSG_MORE);
+	if (r < 0 || (size_t)r < len)
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Message digest finalization function
+ *
+ * @handle cipher handle - input
+ * @buffer filled with the message digest - output
+ * @len buffer length - input
+ *
+ * return: 0 upon success
+ *	   < 0 in case of error
+ *		EIO - data cannot be obtained
+ *		ENOMEM - buffer is too small for the complete message digest,
+ *			 the buffer is filled with the truncated message digest
+ */
+
+int kcapi_md_final(struct kcapi_handle *handle,
+		   unsigned char *buffer, size_t len)
+{
+	ssize_t r;
+	struct iovec iov;
+	struct msghdr msg;
+
+	iov.iov_base = (void*)(uintptr_t)buffer;
+	iov.iov_len = len;
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+
+	r = recvmsg(handle->opfd, &msg, 0);
+	if (r < 0)
+		return -EIO;
+	if (msg.msg_flags & MSG_TRUNC)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Encrypt data
+ *
+ * @handle cipher handle - input
+ * @in plaintext data buffer - input
+ * @inlen length of in buffer - input
+ * @out ciphertext data buffer - output
+ * @outlen length of out buffer - input
+ * @iv buffer holding the IV (may be NULL if IV is not needed) - input
+ * @ivlen length of iv (should be zero if iv is NULL) - input
+ *
+ * return: 0 upon success
+ *	   < 0 in case of error
+ */
+int kcapi_cipher_encrypt(struct kcapi_handle *handle,
+			 const unsigned char *in, size_t inlen,
+			 unsigned char *out, size_t outlen,
+			 const unsigned char *iv, size_t ivlen)
+{
+	return _kcapi_cipher_crypt(handle, in, inlen, out, outlen,
+				   iv, ivlen, ALG_OP_ENCRYPT);
+}
+
+/*
+ * Decrypt data
+ *
+ * @handle cipher handle - input
+ * @in ciphertext data buffer - input
+ * @inlen length of in buffer - input
+ * @out plaintext data buffer - output
+ * @outlen length of out buffer - input
+ * @iv buffer holding the IV (may be NULL if IV is not needed) - input
+ * @ivlen length of iv (should be zero if iv is NULL) - input
+ *
+ * return: 0 upon success
+ *	   < 0 in case of error
+ */
+int kcapi_cipher_decrypt(struct kcapi_handle *handle,
+			 const unsigned char *in, size_t inlen,
+			 unsigned char *out, size_t outlen,
+			 const unsigned char *iv, size_t ivlen)
+{
+	return _kcapi_cipher_crypt(handle, in, inlen, out, outlen,
+				   iv, ivlen, ALG_OP_DECRYPT);
+}
+
+/************************************************************
+ * Application requiring cryptographic services
+ ************************************************************/
+
+static char hex_char_map_l[] = { '0', '1', '2', '3', '4', '5', '6', '7',
+				 '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
+static char hex_char_map_u[] = { '0', '1', '2', '3', '4', '5', '6', '7',
+				 '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
+static char hex_char(unsigned int bin, int u)
+{
+	if (bin < sizeof(hex_char_map_l))
+		return (u) ? hex_char_map_u[bin] : hex_char_map_l[bin];
+	return 'X';
+}
+
+/*
+ * Convert binary string into hex representation
+ * @bin input buffer with binary data
+ * @binlen length of bin
+ * @hex output buffer to store hex data
+ * @hexlen length of already allocated hex buffer (should be at least
+ *	   twice binlen -- if not, only a fraction of binlen is converted)
+ * @u case of hex characters (0=>lower case, 1=>upper case)
+ */
+static void bin2hex(const unsigned char *bin, size_t binlen,
+		    char *hex, size_t hexlen, int u)
+{
+	size_t i = 0;
+	size_t chars = (binlen > (hexlen / 2)) ? (hexlen / 2) : binlen;
+
+	for (i = 0; i < chars; i++) {
+		hex[(i*2)] = hex_char((bin[i] >> 4), u);
+		hex[((i*2)+1)] = hex_char((bin[i] & 0x0f), u);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kcapi_handle handle;
+#define BUFLEN 32
+	unsigned char inbuf[BUFLEN];
+#define IVLEN 16
+	unsigned char ivbuf[IVLEN];
+	unsigned char outbuf[BUFLEN];
+	unsigned char outbuf2[BUFLEN];
+	char hexbuf[BUFLEN * 2 + 1];
+
+	(void)argc;
+	(void)argv;
+
+	/*
+	 * Calculate a message digest
+	 */
+	if (kcapi_cipher_init(&handle, "hash", "sha256")) {
+		printf("Allocation of hash failed\n");
+		return(1);
+	}
+	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+		      "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
+	if (kcapi_md_update(&handle, inbuf, BUFLEN)) {
+		printf("Hash update of buffer failed\n");
+		return(1);
+	}
+	if (kcapi_md_final(&handle, outbuf, BUFLEN)) {
+		printf("Hash final failed\n");
+		return(1);
+	}
+	kcapi_cipher_destory(&handle);
+	memset(hexbuf, 0, BUFLEN * 2 + 1);
+	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
+	printf("Calculated hash %s\n", hexbuf);
+
+	/*
+	 * Calculate a keyed message digest
+	 */
+	if (kcapi_cipher_init(&handle, "hash", "hmac(sha256)")) {
+		printf("Allocation of HMAC failed\n");
+		return(1);
+	}
+	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+		      "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
+	if (kcapi_cipher_setkey(&handle, inbuf, BUFLEN)) {
+		printf("HMAC setkey failed\n");
+		return(1);
+	}
+	if (kcapi_md_update(&handle, inbuf, BUFLEN)) {
+		printf("HMAC update of buffer failed\n");
+		return(1);
+	}
+	if (kcapi_md_final(&handle, outbuf, BUFLEN)) {
+		printf("HMAC final failed\n");
+		return(1);
+	}
+	kcapi_cipher_destory(&handle);
+	memset(hexbuf, 0, BUFLEN * 2 + 1);
+	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
+	printf("Calculated hmac %s\n", hexbuf);
+
+	/*
+	 * Encrypt data
+	 */
+	if (kcapi_cipher_init(&handle, "skcipher", "cbc(aes)")) {
+		printf("Allocation of cipher failed\n");
+		return(1);
+	}
+	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+		      "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
+	if (kcapi_cipher_setkey(&handle, inbuf, BUFLEN)) {
+		printf("AES setkey failed\n");
+		return(1);
+	}
+	memcpy(ivbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
+		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", IVLEN);
+	if (kcapi_cipher_encrypt(&handle, inbuf, BUFLEN,
+				 outbuf, BUFLEN, ivbuf, IVLEN)) {
+		printf("Encryption buffer failed\n");
+		return(1);
+	}
+	memset(hexbuf, 0, BUFLEN * 2 + 1);
+	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
+	printf("Encrypted data %s\n", hexbuf);
+
+	/*
+	 * Decrypt previously encrypted data
+	 */
+	if (kcapi_cipher_decrypt(&handle, outbuf, BUFLEN,
+				 outbuf2, BUFLEN, ivbuf, IVLEN)) {
+		printf("Decryption buffer failed\n");
+		return(1);
+	}
+	kcapi_cipher_destory(&handle);
+	memset(hexbuf, 0, BUFLEN * 2 + 1);
+	bin2hex(outbuf2, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
+	printf("Decrypted data %s\n", hexbuf);
+	if (!memcmp(inbuf, outbuf2, BUFLEN))
+		printf("Decrypted data match original plaintext as expected\n");
+	else
+		printf("FAILURE: Decrypted data does not match original plaintext\n");
+
+	return 0;
+}
+
+License of code
+===============
+/*
+ * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, and the entire permission notice in its entirety,
+ *    including the disclaimer of warranties.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * ALTERNATIVELY, this product may be distributed under the terms of
+ * the GNU General Public License, in which case the provisions of the GPL2 are
+ * required INSTEAD OF the above restrictions.  (This clause is
+ * necessary due to a potential bad interaction between the GPL and
+ * the restrictions contained in a BSD-style copyright.)
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+ * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+ * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ */
-- 
1.9.3


