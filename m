Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaCHXwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:52:12 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:36258 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaCHXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:50:50 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: [PATCH 2/6] header file for DRBG
Date: Sun, 09 Mar 2014 00:46:42 +0100
Message-ID: <2077366.gxQRUloqnc@myon.chronox.de>
User-Agent: KMail/4.12.2 (Linux/3.13.5-200.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <5770301.bQ9lKffXf3@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <5770301.bQ9lKffXf3@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file includes the definition of:

* DRBG data structures with
	- struct drbg_state as main structure
	- struct drbg_core referencing the backend ciphers
	- struct drbg_state_ops callbach handlers for specific code
	  supporting the Hash, HMAC, CTR DRBG implementations
	- struct drbg_conc defining a linked list for input data
	- struct drbg_test_data holding the test "entropy" data for CAVS
	  testing and testmgr.c
	- struct drbg_gen allowing test data, additional information
	  string and personalization string data to be funneled through
	  the kernel crypto API -- the DRBG requires additional
	  parameters when invoking the reset and random number
	  generation requests than intended by the kernel crypto API

* wrapper function to the kernel crypto API functions using struct
  drbg_gen to pass through all data needed for DRBG

* wrapper functions to kernel crypto API functions usable for testing
  code to inject test_data into the DRBG as needed by CAVS testing and
  testmgr.c.

* DRBG flags required for the operation of the DRBG and for selecting
  the particular DRBG type and backend cipher

* getter functions for data from struct drbg_core

Signed-off-by: Stephan Mueller <smueller@chronox.de>

 create mode 100644 include/crypto/drbg.h

diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
new file mode 100644
index 0000000..16515f9
--- /dev/null
+++ b/include/crypto/drbg.h
@@ -0,0 +1,340 @@
+/*
+ * DRBG based on NIST SP800-90A
+ *
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2014
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
+ * the GNU General Public License, in which case the provisions of the GPL are
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
+
+#ifndef _DRBG_H
+#define _DRBG_H
+
+
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <crypto/hash.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/slab.h> /* needed for kzalloc */
+#include <crypto/internal/rng.h>
+#include <crypto/rng.h>
+#include <linux/fips.h>
+#include <linux/spinlock.h>
+
+/*
+ * Concatenation Helper
+ *
+ * SP800-90A requires the concatenation of different data. To avoid copying
+ * buffers around or allocate additional memory, the following data structure
+ * is used to point to the original memory with its size. In addition, it
+ * is used to build a linked list. The linked list defines the concatenation
+ * of individual buffers. The order of memory block referenced in that
+ * linked list determines the order of concatenation.
+ */
+
+struct drbg_conc
+{
+	unsigned char *in;
+	size_t len;
+	struct drbg_conc *next;
+};
+
+#define DRBG_CLEAR_CONC(x)	\
+	x.in = NULL;		\
+	x.len = 0;		\
+	x.next = NULL;
+
+struct drbg_state;
+typedef uint32_t drbg_flag_t;
+
+struct drbg_core
+{
+	drbg_flag_t flags;	/* flags for the cipher */
+	__u8 statelen;		/* maximum state length */
+	__u8 max_addtllen;	/* maximum length of personalization string or
+				   additional input string -- exponent for base
+				   2 */
+	__u8 max_bits;		/* maximum bits per RNG request -- exponent for
+				   base 2*/
+	__u8 max_req;		/* maximum number of requests -- exponent for
+				   base 2 */
+	__u8 blocklen_bytes;	/* block size of output in bytes */
+	char cra_name[CRYPTO_MAX_ALG_NAME]; /* mapping to kernel crypto API */
+	char cra_driver_name[CRYPTO_MAX_ALG_NAME]; /* mapping to kernel crypto
+						    * API */
+	char backend_cra_name[CRYPTO_MAX_ALG_NAME]; /* kernel crypto API
+						     * backend cipher name */
+	int (*cipher_fn) (struct drbg_state *drbg, unsigned char *key,
+			  unsigned char *outval, struct drbg_conc *in);
+	int (*init_lib) (struct drbg_state *drbg);
+	int (*fini_lib)	(struct drbg_state *drbg);
+
+};
+
+struct drbg_state_ops
+{
+	int (*process_addtl) (struct drbg_state *drbg,
+			      unsigned char *addtl_input, size_t addtllen);
+	int (*preprocess_extract) (struct drbg_state *drbg,
+				   unsigned char **src,
+				   unsigned char **dst, short *length);
+	void (*postprocess_extract) (struct drbg_state *drbg,
+				     unsigned char *src,
+				     unsigned char *dst, int notlast);
+	void (*cleanup_extract) (struct drbg_state *drbg,
+				 unsigned char **src,
+				 unsigned char **dst);
+	int (*newstate_postgen) (struct drbg_state *drbg,
+				 unsigned char *addtl_input,
+				 size_t addtllen);
+	int (*update_state) (struct drbg_state *drbg, struct drbg_conc *seed,
+			     int reseed);
+};
+
+struct drbg_test_data
+{
+	unsigned char *testentropy; /* TEST PARAMETER: test entropy */
+	size_t testentropylen;	/* TEST PARAMETER: length of test entropy */
+};
+
+/* use stack for variables instead of heap */
+#define DRBG_CTR_BLK 48
+#define DRBG_HASH_BLK 111
+#define DRBG_HMAC_BLK 64
+#define DRBG_CLEAR_CTR_BLK(x)	memset(x, 0, DRBG_CTR_BLK);
+#define DRBG_CLEAR_HASH_BLK(x)	memset(x, 0, DRBG_HASH_BLK);
+#define DRBG_CLEAR_HMAC_BLK(x)	memset(x, 0, DRBG_HMAC_BLK);
+
+#define CLEAR_CRA_NAME(x) memset(x, 0, CRYPTO_MAX_ALG_NAME)
+
+struct drbg_state
+{
+	drbg_flag_t flags;	/* Security strength */
+	spinlock_t drbg_lock;	/* lock around DRBG */
+	unsigned char *V;	/* internal state 10.1.1.1 1a) */
+	unsigned char *C;	/* hash: static value 10.1.1.1 1b)
+				 * hmac: key */
+	size_t reseed_ctr;	/* Number of RNG requests since last reseed --
+				 * 10.1.1.1 1c) */
+	unsigned char *scratchpad; /* some memory the DRBG can use for its
+				    * operation -- allocated during init */
+	void *priv_data;	/* Data needed for specific cipher
+				 * implementation */
+#ifdef CONFIG_CRYPTO_FIPS
+	unsigned char *prev;	/* previous output value of DRBG_BLOCKLEN for
+				 * FIPS 140-2 continuous test */
+#endif
+	struct drbg_state_ops *d_ops;
+	const struct drbg_core *core;
+	struct drbg_test_data *test_data;
+};
+
+/* kernel crypto API input data structure for DRBG generate in case dlen
+ * is set to 0 */
+struct drbg_gen
+{
+	unsigned char *outbuf;	/* output buffer for random numbers */
+	unsigned int outlen;	/* size of output buffer */
+	unsigned char *addtl_input;	/* input buffer for
+					 * additional information string */
+	unsigned int addtllen;	/* length of addtl_input */
+	struct drbg_test_data *test_data;	/* test data */
+};
+
+/*
+ * This is a wrapper to the kernel crypto API function of
+ * crypto_rng_get_bytes() to allow the caller to provide additional data
+ *
+ * @drng DRBG handle -- see crypto_rng_get_bytes
+ * @outbuf output buffer -- see crypto_rng_get_bytes
+ * @outlen length of output buffer -- see crypto_rng_get_bytes
+ * @addtl_input additional information string input buffer
+ * @addtllen length of additional information string buffer
+ *
+ * return
+ * 	see crypto_rng_get_bytes
+ */
+static inline int crypto_drbg_get_bytes_addtl(struct crypto_rng *drng,
+			unsigned char *outbuf, unsigned int outlen,
+			unsigned char *addtl_input, size_t addtllen)
+{
+	int ret;
+	struct drbg_gen genbuf;
+	genbuf.outbuf = outbuf;
+	genbuf.outlen = outlen;
+	genbuf.addtl_input = addtl_input;
+	genbuf.addtllen = addtllen;
+	genbuf.test_data = NULL;
+	ret = crypto_rng_get_bytes(drng, (u8 *)&genbuf, 0);
+	return ret;
+}
+
+/*
+ * TEST code
+ *
+ * This is a wrapper to the kernel crypto API function of
+ * crypto_rng_get_bytes() to allow the caller to provide additional data and
+ * allow furnishing of test_data
+ *
+ * @drng DRBG handle -- see crypto_rng_get_bytes
+ * @outbuf output buffer -- see crypto_rng_get_bytes
+ * @outlen length of output buffer -- see crypto_rng_get_bytes
+ * @addtl_input additional information string input buffer
+ * @addtllen length of additional information string buffer
+ * @test_data filled test data
+ *
+ * return
+ * 	see crypto_rng_get_bytes
+ */
+static inline int crypto_drbg_get_bytes_addtl_test(struct crypto_rng *drng,
+			unsigned char *outbuf, unsigned int outlen,
+			unsigned char *addtl_input, size_t addtllen,
+			struct drbg_test_data *test_data)
+{
+	int ret;
+	struct drbg_gen genbuf;
+	genbuf.outbuf = outbuf;
+	genbuf.outlen = outlen;
+	genbuf.addtl_input = addtl_input;
+	genbuf.addtllen = addtllen;
+	genbuf.test_data = test_data;
+	ret = crypto_rng_get_bytes(drng, (u8 *)&genbuf, 0);
+	return ret;
+}
+
+/*
+ * TEST code
+ *
+ * This is a wrapper to the kernel crypto API function of
+ * crypto_rng_reset() to allow the caller to provide test_data
+ *
+ * @drng DRBG handle -- see crypto_rng_reset
+ * @pers personalization string input buffer
+ * @perslen length of additional information string buffer
+ * @test_data filled test data
+ *
+ * return
+ * 	see crypto_rng_reset
+ */
+static inline int crypto_drbg_reset_test(struct crypto_rng *drng,
+			unsigned char *pers, unsigned int perslen,
+			struct drbg_test_data *test_data)
+{
+	int ret;
+	struct drbg_gen genbuf;
+	genbuf.outbuf = NULL;
+	genbuf.outlen = 0;
+	genbuf.addtl_input = pers;
+	genbuf.addtllen = perslen;
+	genbuf.test_data = test_data;
+	ret = crypto_rng_reset(drng, (u8 *)&genbuf, 0);
+	return ret;
+}
+
+
+#define DRBG_STATELEN(a)	((a)->core->statelen)
+#define DRBG_BLOCKLEN(a)	((a)->core->blocklen_bytes)
+/* only needed for CTR mode -- implicit key len with seedlen - blocklen
+ * according to table 3 */
+#define DRBG_KEYLEN(drbg) (DRBG_STATELEN(drbg) - DRBG_BLOCKLEN(drbg))
+
+/*
+ * DRBG flags bitmasks
+ *
+ * 31  (B)  27    19         (A)           0
+ *  +-+-+-+-+------+---+---+---------------+
+ *  |~|~|u|p|~~~~~~| 3 | 2 |       1       |
+ *  +-+-+-+-+------+- -+---+---------------+
+ * ctl flags|      |drbg use selection flags
+ *
+ */
+
+/* internal state control flags (B) */
+#define DRBG_UNSEEDED		((drbg_flag_t)1<<27)
+#define DRBG_PREDICTION_RESIST	((drbg_flag_t)1<<28)
+
+/* CTR type modifiers (A.1)*/
+#define DRBG_CTRAES128		((drbg_flag_t)1<<0)
+#define DRBG_CTRAES192		((drbg_flag_t)1<<1)
+#define DRBG_CTRAES256		((drbg_flag_t)1<<2)
+#define DRBG_CTRSERPENT128	((drbg_flag_t)1<<3)
+#define DRBG_CTRSERPENT192	((drbg_flag_t)1<<4)
+#define DRBG_CTRSERPENT256	((drbg_flag_t)1<<5)
+#define DRBG_CTRTWOFISH128	((drbg_flag_t)1<<6)
+#define DRBG_CTRTWOFISH192	((drbg_flag_t)1<<7)
+#define DRBG_CTRTWOFISH256	((drbg_flag_t)1<<8)
+#define DRBG_CTR_MASK	(DRBG_CTRAES128 | DRBG_CTRAES192 | DRBG_CTRAES256| \
+			 DRBG_CTRSERPENT128 | DRBG_CTRSERPENT192 | \
+			 DRBG_CTRSERPENT256 | DRBG_CTRTWOFISH128 | \
+			 DRBG_CTRTWOFISH192 | DRBG_CTRTWOFISH256)
+
+/* HASH type modifiers (A.2)*/
+#define DRBG_HASHSHA1		((drbg_flag_t)1<<9)
+#define DRBG_HASHSHA224		((drbg_flag_t)1<<10)
+#define DRBG_HASHSHA256		((drbg_flag_t)1<<11)
+#define DRBG_HASHSHA384		((drbg_flag_t)1<<12)
+#define DRBG_HASHSHA512		((drbg_flag_t)1<<13)
+#define DRBG_HASH_MASK		(DRBG_HASHSHA1 | DRBG_HASHSHA224 | \
+				 DRBG_HASHSHA256 | DRBG_HASHSHA384 | \
+				 DRBG_HASHSHA512)
+
+/* HMAC type modifiers (A.2)*/
+#define DRBG_HMACSHA1		((drbg_flag_t)1<<14)
+#define DRBG_HMACSHA224		((drbg_flag_t)1<<15)
+#define DRBG_HMACSHA256		((drbg_flag_t)1<<16)
+#define DRBG_HMACSHA384		((drbg_flag_t)1<<17)
+#define DRBG_HMACSHA512		((drbg_flag_t)1<<18)
+#define DRBG_HMAC_MASK		(DRBG_HMACSHA1 | DRBG_HMACSHA224 | \
+				 DRBG_HMACSHA256 | DRBG_HMACSHA384 | \
+				 DRBG_HMACSHA512)
+
+#define DRBG_CIPHER_MASK (DRBG_CTR_MASK | DRBG_HASH_MASK | DRBG_HMAC_MASK)
+
+/* helper functions */
+static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
+{
+	/* max_bits is in bits, but buflen is in bytes */
+	return (1 << (drbg->core->max_bits - 3));
+}
+
+static inline size_t drbg_max_addtl(struct drbg_state *drbg)
+{
+	return (1UL<<(drbg->core->max_addtllen));
+}
+
+static inline size_t drbg_max_requests(struct drbg_state *drbg)
+{
+	return (1UL<<(drbg->core->max_req));
+}
+
+#endif /* _DRBG_H */
-- 
1.8.5.3


