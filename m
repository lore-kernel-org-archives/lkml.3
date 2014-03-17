Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaCQHla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:41:30 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:35662 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbaCQHlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:41:01 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: [PATCH v2 2/6] header file for DRBG
Date: Mon, 17 Mar 2014 08:35:10 +0100
Message-ID: <2831049.lrfGvkkTou@myon.chronox.de>
User-Agent: KMail/4.12.3 (Linux/3.13.6-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <3662681.npTzbSq3ye@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <5770301.bQ9lKffXf3@myon.chronox.de> <3662681.npTzbSq3ye@myon.chronox.de>
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
        - struct drbg_string defining a linked list for input data
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

Changes to v1:

  * Changes due to modification of drbg.c as documented in PATCH 1
  * Fix coding style and apply scripts/checkpatch.pl

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
create mode 100644 include/crypto/drbg.h

diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
new file mode 100644
index 0000000..f52e7ca
--- /dev/null
+++ b/include/crypto/drbg.h
@@ -0,0 +1,292 @@
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
+ * Concatenation Helper and string operation helper
+ *
+ * SP800-90A requires the concatenation of different data. To avoid copying
+ * buffers around or allocate additional memory, the following data structure
+ * is used to point to the original memory with its size. In addition, it
+ * is used to build a linked list. The linked list defines the concatenation
+ * of individual buffers. The order of memory block referenced in that
+ * linked list determines the order of concatenation.
+ */
+
+struct drbg_string {
+	const unsigned char *buf;
+	size_t len;
+	struct drbg_string *next;
+};
+
+static inline void drbg_string_fill(struct drbg_string *string,
+				    const unsigned char *buf, size_t len)
+{
+	string->buf = buf;
+	string->len = len;
+	string->next = NULL;
+}
+
+struct drbg_state;
+typedef uint32_t drbg_flag_t;
+
+struct drbg_core {
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
+};
+
+struct drbg_state_ops {
+	int (*update)(struct drbg_state *drbg, struct drbg_string *seed,
+		       int reseed);
+	unsigned int (*generate)(struct drbg_state *drbg,
+				 unsigned char *buf, unsigned int buflen,
+				 struct drbg_string *addtl);
+	int (*crypto_init)(struct drbg_state *drbg);
+	int (*crypto_fini)(struct drbg_state *drbg);
+
+};
+
+struct drbg_test_data {
+	struct drbg_string *testentropy; /* TEST PARAMETER: test entropy */
+};
+
+struct drbg_state {
+	spinlock_t drbg_lock;	/* lock around DRBG */
+	unsigned char *V;	/* internal state 10.1.1.1 1a) */
+	unsigned char *C;	/* hash: static value 10.1.1.1 1b)
+				 * hmac / ctr: key */
+	size_t reseed_ctr;	/* Number of RNG requests since last reseed --
+				 * 10.1.1.1 1c) */
+	unsigned char *scratchpad; /* some memory the DRBG can use for its
+				    * operation -- allocated during init */
+	void *priv_data;	/* Data needed for specific cipher
+				 * implementation */
+	bool seeded;		/* DRBG fully seeded? */
+	bool pr;		/* Prediction resistance enabled? */
+#ifdef CONFIG_CRYPTO_FIPS
+	bool fips_primed;	/* Continuous test primed? */
+	unsigned char *prev;	/* previous output value of DRBG_BLOCKLEN for
+				 * FIPS 140-2 continuous test */
+#endif
+	const struct drbg_state_ops *d_ops;
+	const struct drbg_core *core;
+	struct drbg_test_data *test_data;
+};
+
+/* helper functions */
+static inline __u8 drbg_statelen(struct drbg_state *drbg)
+{
+	if (drbg && drbg->core)
+		return drbg->core->statelen;
+	return 0;
+}
+
+static inline __u8 drbg_blocklen(struct drbg_state *drbg)
+{
+	if (drbg && drbg->core)
+		return drbg->core->blocklen_bytes;
+	return 0;
+}
+
+static inline __u8 drbg_keylen(struct drbg_state *drbg)
+{
+	if (drbg && drbg->core)
+		return (drbg->core->statelen - drbg->core->blocklen_bytes);
+	return 0;
+}
+
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
+/* kernel crypto API input data structure for DRBG generate in case dlen
+ * is set to 0 */
+struct drbg_gen {
+	unsigned char *outbuf;	/* output buffer for random numbers */
+	unsigned int outlen;	/* size of output buffer */
+	struct drbg_string *addtl;	/* input buffer for
+					 * additional information string */
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
+ *	see crypto_rng_get_bytes
+ */
+static inline int crypto_drbg_get_bytes_addtl(struct crypto_rng *drng,
+			unsigned char *outbuf, unsigned int outlen,
+			struct drbg_string *addtl)
+{
+	int ret;
+	struct drbg_gen genbuf;
+	genbuf.outbuf = outbuf;
+	genbuf.outlen = outlen;
+	genbuf.addtl = addtl;
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
+ *	see crypto_rng_get_bytes
+ */
+static inline int crypto_drbg_get_bytes_addtl_test(struct crypto_rng *drng,
+			unsigned char *outbuf, unsigned int outlen,
+			struct drbg_string *addtl,
+			struct drbg_test_data *test_data)
+{
+	int ret;
+	struct drbg_gen genbuf;
+	genbuf.outbuf = outbuf;
+	genbuf.outlen = outlen;
+	genbuf.addtl = addtl;
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
+ *	see crypto_rng_reset
+ */
+static inline int crypto_drbg_reset_test(struct crypto_rng *drng,
+					 struct drbg_string *pers,
+					 struct drbg_test_data *test_data)
+{
+	int ret;
+	struct drbg_gen genbuf;
+	genbuf.outbuf = NULL;
+	genbuf.outlen = 0;
+	genbuf.addtl = pers;
+	genbuf.test_data = test_data;
+	ret = crypto_rng_reset(drng, (u8 *)&genbuf, 0);
+	return ret;
+}
+
+/* DRBG type flags */
+#define DRBG_CTR	((drbg_flag_t)1<<0)
+#define DRBG_HMAC	((drbg_flag_t)1<<1)
+#define DRBG_HASH	((drbg_flag_t)1<<2)
+#define DRBG_TYPE_MASK	(DRBG_CTR | DRBG_HMAC | DRBG_HASH)
+/* DRBG strength flags */
+#define DRBG_STRENGTH128	((drbg_flag_t)1<<3)
+#define DRBG_STRENGTH192	((drbg_flag_t)1<<4)
+#define DRBG_STRENGTH256	((drbg_flag_t)1<<5)
+#define DRBG_STRENGTH_MASK	(DRBG_STRENGTH128 | DRBG_STRENGTH192 | \
+				 DRBG_STRENGTH256)
+
+enum drbg_prefixes {
+	DRBG_PREFIX0 = 0x00,
+	DRBG_PREFIX1,
+	DRBG_PREFIX2,
+	DRBG_PREFIX3
+};
+
+#endif /* _DRBG_H */

