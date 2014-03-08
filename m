Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaCHXvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:51:33 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:46780 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaCHXuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:50:55 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: [PATCH 1/6] SP800-90A Deterministic Random Bit Generator
Date: Sun, 09 Mar 2014 00:46 +0100
Message-ID: <5770301.bQ9lKffXf3@myon.chronox.de>
User-Agent: KMail/4.12.2 (Linux/3.13.5-200.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <2396177.vxvG2ljJL8@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a clean-room implementation of the DRBG defined in SP800-90A.
All three viable DRBGs defined in the standard are implemented:

	* HMAC
	* Hash
	* CTR

Signed-off-by: Stephan Mueller <smueller@chronox.de>

 create mode 100644 crypto/drbg.c

diff --git a/crypto/drbg.c b/crypto/drbg.c
new file mode 100644
index 0000000..5308cce
--- /dev/null
+++ b/crypto/drbg.c
@@ -0,0 +1,1941 @@
+/*
+ * DRBG: Deterministic Random Bits Generator
+ *       Based on NIST Recommended DRBG from NIST SP800-90A with the following
+ *       properties:
+ *		* CTR DRBG with DF with AES-128, AES-192, AES-256 cores
+ * 		* Hash DRBG with DF with SHA-1, SHA-256, SHA-384, SHA-512 cores
+ * 		* HMAC DRBG with DF with SHA-1, SHA-256, SHA-384, SHA-512 cores
+ * 		* with and without prediction resistance
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
+ * 
+ * DRBG Usage
+ * ==========
+ * The SP 800-90A DRBG allows the user to specify a personalization string
+ * for initialization as well as an additional information string for each
+ * random number request. The following code fragments show how a caller
+ * uses the kernel crypto API to use the full functionality of the DRBG.
+ * 
+ * Usage without any additional data
+ * ---------------------------------
+ * struct crypto_rng *drng;
+ * int err;
+ * char data[DATALEN];
+ * 
+ * drng = crypto_alloc_rng(drng_name, 0, 0);
+ * err = crypto_rng_get_bytes(drng, &data, DATALEN);
+ * crypto_free_rng(drng);
+ * 
+ * 
+ * Usage with personalization string during initialization
+ * -------------------------------------------------------
+ * struct crypto_rng *drng;
+ * int err;
+ * char data[DATALEN];
+ * char personalization = "some-string";
+ * 
+ * drng = crypto_alloc_rng(drng_name, 0, 0);
+ * // The reset completely re-initializes the DRBG with the provided
+ * // personalization string
+ * err = crypto_rng_reset(drng, &personalization, strlen(personalization));
+ * err = crypto_rng_get_bytes(drng, &data, DATALEN);
+ * crypto_free_rng(drng);
+ * 
+ * 
+ * Usage with additional information string during random number request
+ * ---------------------------------------------------------------------
+ * struct crypto_rng *drng;
+ * int err;
+ * char data[DATALEN];
+ * char addtl = "some-string";
+ * 
+ * drng = crypto_alloc_rng(drng_name, 0, 0);
+ * // The following call is a wrapper to crypto_rng_get_bytes() and returns
+ * // the same error codes.
+ * err = crypto_drbg_get_bytes_addtl(drng,
+ *				     &data, DATALEN,
+ *				     &addtl, strlen(addtl));
+ * crypto_free_rng(drng);
+ * 
+ * 
+ * Usage with personalization and additional information strings
+ * -------------------------------------------------------------
+ * Just mix both scenarios above.
+ */
+
+#include <crypto/drbg.h>
+
+#if !defined(CONFIG_CRYPTO_DRBG_HASH) && \
+	!defined(CONFIG_CRYPTO_DRBG_HMAC) && \
+	!defined(CONFIG_CRYPTO_DRBG_CTR)
+#warning "The DRBG code is useless without compiling at least one DRBG type"
+#endif
+
+/***************************************************************
+ * Backend cipher definitions available to DRBG
+ ***************************************************************/
+
+#ifdef CONFIG_CRYPTO_DRBG_HMAC
+static int drbg_kcapi_hmac(struct drbg_state *drbg, unsigned char *key,
+			   unsigned char *outval, struct drbg_conc *in);
+#endif /* CONFIG_CRYPTO_DRBG_HASH */
+#if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
+static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *key,
+			   unsigned char *outval, struct drbg_conc *in);
+static int drbg_init_hash_kernel(struct drbg_state *drbg);
+static int drbg_fini_hash_kernel(struct drbg_state *drbg);
+#endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *key,
+			  unsigned char *outval, struct drbg_conc *in);
+static int drbg_init_sym_kernel(struct drbg_state *drbg);
+static int drbg_fini_sym_kernel(struct drbg_state *drbg);
+#endif /* CONFIG_CRYPTO_DRBG_CTR */
+
+const struct drbg_core cores[] =
+{
+		/* Hash DRBGs */
+#ifdef CONFIG_CRYPTO_DRBG_HASH
+	{
+		.flags = DRBG_HASHSHA1,
+		.statelen = 55, /* 440 bits */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 20,
+		.cipher_fn = drbg_kcapi_hash,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "sha1",
+		.cra_driver_name = "sha1",
+		.backend_cra_name = "sha1",
+	}, {
+		.flags = DRBG_HASHSHA256,
+		.statelen = 55, /* 440 bits */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 32,
+		.cipher_fn = drbg_kcapi_hash,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "sha256",
+		.cra_driver_name = "sha256",
+		.backend_cra_name = "sha256",
+	}, {
+		.flags = DRBG_HASHSHA384,
+		.statelen = 111, /* 888 bits */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 48,
+		.cipher_fn = drbg_kcapi_hash,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "sha384",
+		.cra_driver_name = "sha384",
+		.backend_cra_name = "sha384",
+	}, {
+		.flags = DRBG_HASHSHA512,
+		.statelen = 111, /* 888 bits */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 64,
+		.cipher_fn = drbg_kcapi_hash,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "sha512",
+		.cra_driver_name = "sha512",
+		.backend_cra_name = "sha512",
+	},
+#endif /* CONFIG_CRYPTO_DRBG_HASH */
+#ifdef CONFIG_CRYPTO_DRBG_HMAC
+	{
+		/* HMAC DRBGs */
+		.flags = DRBG_HMACSHA1,
+		.statelen = 20, /* block length of cipher */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 20,
+		.cipher_fn = drbg_kcapi_hmac,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "hmac(sha1)",
+		.cra_driver_name = "hmac_sha1",
+		.backend_cra_name = "hmac(sha1)",
+	}, {
+		.flags = DRBG_HMACSHA256,
+		.statelen = 32, /* block length of cipher */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 32,
+		.cipher_fn = drbg_kcapi_hmac,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "hmac(sha256)",
+		.cra_driver_name = "hmac_sha256",
+		.backend_cra_name = "hmac(sha256)",
+	}, {
+		.flags = DRBG_HMACSHA384,
+		.statelen = 48, /* block length of cipher */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 48,
+		.cipher_fn = drbg_kcapi_hmac,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "hmac(sha384)",
+		.cra_driver_name = "hmac_sha384",
+		.backend_cra_name = "hmac(sha384)",
+	}, {
+		.flags = DRBG_HMACSHA512,
+		.statelen = 64, /* block length of cipher */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 64,
+		.cipher_fn = drbg_kcapi_hmac,
+		.init_lib = drbg_init_hash_kernel,
+		.fini_lib = drbg_fini_hash_kernel,
+		.cra_name = "hmac(sha512)",
+		.cra_driver_name = "hmac_sha512",
+		.backend_cra_name = "hmac(sha512)",
+	},
+#endif /* CONFIG_CRYPTO_DRBG_HMAC */
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+	{
+		/* block ciphers */
+		.flags = DRBG_CTRAES128,
+		.statelen = 32, /* 256 bits as defined in 10.2.1 */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 16,
+		.cipher_fn = drbg_kcapi_sym,
+		.init_lib = drbg_init_sym_kernel,
+		.fini_lib = drbg_fini_sym_kernel,
+		.cra_name = "ctr(aes128)",
+		.cra_driver_name = "ctr_aes128",
+		.backend_cra_name = "ecb(aes)",
+		
+	}, {
+		/* block ciphers */
+		.flags = DRBG_CTRAES192,
+		.statelen = 40, /* 320 bits as defined in 10.2.1 */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 16,
+		.cipher_fn = drbg_kcapi_sym,
+		.init_lib = drbg_init_sym_kernel,
+		.fini_lib = drbg_fini_sym_kernel,
+		.cra_name = "ctr(aes192)",
+		.cra_driver_name = "ctr_aes192",
+		.backend_cra_name = "ecb(aes)",
+	}, {
+		/* block ciphers */
+		.flags = DRBG_CTRAES256,
+		.statelen = 48, /* 384 bits as defined in 10.2.1 */
+		.max_addtllen = 35,
+		.max_bits = 19,
+		.max_req = 48,
+		.blocklen_bytes = 16,
+		.cipher_fn = drbg_kcapi_sym,
+		.init_lib = drbg_init_sym_kernel,
+		.fini_lib = drbg_fini_sym_kernel,
+		.cra_name = "ctr(aes256)",
+		.cra_driver_name = "ctr_aes256",
+		.backend_cra_name = "ecb(aes)",
+	},
+#endif /* CONFIG_CRYPTO_DRBG_CTR */
+};
+
+/******************************************************************
+ * Generic helper functions
+ ******************************************************************/
+
+/*
+ * Return strength of DRBG according to SP800-90A section 8.4
+ *
+ * flags: DRBG flags reference
+ *
+ * Return: normalized strength value or 0 on error
+ */
+static unsigned short drbg_sec_strength(drbg_flag_t flags)
+{
+	switch(flags & DRBG_CIPHER_MASK) {
+		case DRBG_CTRAES128:
+		case DRBG_CTRSERPENT128:
+		case DRBG_CTRTWOFISH128:
+		case DRBG_HASHSHA1:
+		case DRBG_HMACSHA1:
+			return 128;
+		case DRBG_CTRAES192:
+		case DRBG_CTRSERPENT192:
+		case DRBG_CTRTWOFISH192:
+			return 192;
+		case DRBG_CTRAES256:
+		case DRBG_CTRSERPENT256:
+		case DRBG_CTRTWOFISH256:
+		case DRBG_HASHSHA256:
+		case DRBG_HASHSHA384:
+		case DRBG_HASHSHA512:
+		case DRBG_HMACSHA256:
+		case DRBG_HMACSHA384:
+		case DRBG_HMACSHA512:
+			return 256;
+		default:
+			return 0;
+	}
+}
+
+#if (defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_CTR))
+static inline void drbg_int2byte(unsigned char *buf, uint64_t val, size_t buflen)
+{
+	unsigned char *byte;
+	uint64_t i;
+
+	byte = buf + (buflen - 1);
+	for (i = 0; i < buflen; i++)
+		*(byte--) = val >> (i * 8) & 0xff;
+}
+
+static inline void drbg_add_buf(unsigned char *dst, size_t dstlen,
+				unsigned char *add, size_t addlen)
+{
+	/* implied: dstlen > addlen */
+	unsigned char *dstptr, *addptr;
+	unsigned int remainder = 0;
+	size_t len = addlen;
+
+	dstptr = dst + (dstlen-1);
+	addptr = add + (addlen-1);
+	while(len) {
+		remainder += *dstptr + *addptr;
+		*dstptr = remainder & 0xff;
+		remainder >>= 8;
+		len--; dstptr--; addptr--;
+	}
+	len = dstlen - addlen;
+	while(len && remainder > 0) {
+		remainder = *dstptr + 1;
+		*dstptr = remainder & 0xff;
+		remainder >>= 8;
+		len--; dstptr--;
+	}
+}
+#endif /* defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_CTR) */
+
+/******************************************************************
+ * CTR DRBG callback functions
+ ******************************************************************/
+
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+static int drbg_ctr_bcc(struct drbg_state *drbg,
+			unsigned char *out, unsigned char *key,
+			struct drbg_conc *in)
+{
+	int ret = -EFAULT;
+	struct drbg_conc *curr = in;
+	size_t inpos = curr->len;
+	unsigned char *pos = curr->in;
+	struct drbg_conc data;
+
+	DRBG_CLEAR_CONC(data);
+	data.in = out;
+	data.len = DRBG_BLOCKLEN(drbg);
+
+	/* 10.4.3 step 1 */
+	memset(out, 0, DRBG_BLOCKLEN(drbg));
+
+	/* 10.4.3 step 2 / 4 */
+	while(inpos) {
+		short cnt = 0;
+		/* 10.4.3 step 4.1 */
+		for(cnt = 0; cnt < DRBG_BLOCKLEN(drbg); cnt++) {
+			out[cnt] ^= *pos;
+			pos++; inpos--;
+			/* the following branch implements the linked list
+			 * iteration. If we are at the end of the current data
+			 * set, we have to start using the next data set if
+			 * available -- the inpos value always points to the
+			 * current byte and will be zero if we have processed
+			 * the last byte of the last linked list member */
+			if(0 == inpos) {
+				curr = curr->next;
+				if(NULL != curr) {
+					pos = curr->in;
+					inpos = curr->len;
+				} else {
+					inpos = 0;
+					break;
+				}
+			}
+		}
+		/* 10.4.3 step 4.2 */
+		ret = drbg->core->cipher_fn(drbg, key, out, &data);
+		if(ret)
+			return ret;
+		/* 10.4.3 step 2 */
+	}
+	return 0;
+}
+
+static int drbg_ctr_df(struct drbg_state *drbg,
+		       unsigned char *out, size_t bytes_to_return,
+		       struct drbg_conc *input)
+{
+	int ret = -EFAULT;
+	unsigned char L_N[8];
+	/* S3 is input */
+	struct drbg_conc S1, S2, S4;
+	unsigned char temp[DRBG_CTR_BLK], pad[DRBG_CTR_BLK], IV[DRBG_CTR_BLK];
+	size_t padlen = 1; /* already reserve space for 0x80 */
+	int templen = 0;
+	/* 10.4.2 step 7 */
+	unsigned int i = 0;
+	/* 10.4.2 step 8 - truncation happens in ->cipher_fn which uses only
+	 * DRBG_BLOCKLEN bits of key */
+	unsigned char *K = (unsigned char *)
+			   "\x00\x01\x02\x03\x04\x05\x06\x07"
+			   "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			   "\x10\x11\x12\x13\x14\x15\x16\x17"
+			   "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";
+	unsigned char *X;
+	struct drbg_conc cipherin;
+	size_t generated_len = 0;
+	size_t inputlen = 0;
+	struct drbg_conc *tempconc = input;
+
+	DRBG_CLEAR_CTR_BLK(pad);
+	DRBG_CLEAR_CTR_BLK(temp);
+	DRBG_CLEAR_CTR_BLK(IV);
+	DRBG_CLEAR_CONC(S1);
+	DRBG_CLEAR_CONC(S2);
+	DRBG_CLEAR_CONC(S4);
+
+	/* 10.4.2 step 1 is implicit as we work byte-wise*/
+
+	/* 10.4.2 step 2 */
+	if((512/8) < bytes_to_return)
+		return -EINVAL;
+
+	/* 10.4.2 step 2 -- calculate the entire length of all input data*/
+	for(; NULL != tempconc; tempconc = tempconc->next)
+		inputlen += tempconc->len;
+
+	drbg_int2byte(&L_N[0], inputlen, 4);
+	/* 10.4.2 step 3 */
+	drbg_int2byte(&L_N[4], bytes_to_return, 4);
+
+	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
+	while(0 != ((8 + inputlen + padlen) % (DRBG_BLOCKLEN(drbg))))
+		padlen++;
+	pad[0] = 0x80;
+
+	/* 10.4.2 step 4 -- first arrange the linked list and then fill it */
+	S1.next = &S2;
+	S2.next = input;
+	/* splice in input between S2 and S4 -- we place S4 at the end of the
+	 * input data chain */
+	tempconc = input;
+	for(; NULL != tempconc; tempconc = tempconc->next)
+		if(NULL == tempconc->next)
+			break;
+	tempconc->next = &S4;
+
+	S1.in = IV;
+	S1.len = DRBG_BLOCKLEN(drbg);
+	S2.in = L_N;
+	S2.len = 8;
+	S4.in = pad;
+	S4.len = padlen;
+
+	/* 10.4.2 step 9 */
+	while(templen < (DRBG_KEYLEN(drbg) + (DRBG_BLOCKLEN(drbg)))) {
+		/* 10.4.2 step 9.1 - the padding is implicit as the buffer
+		 * holds zeros after allocation -- even the increment of i
+		 * is irrelevant as the increment remains within length of i */
+		drbg_int2byte(IV, i, 4);
+		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
+		ret = drbg_ctr_bcc(drbg, temp + templen, K, &S1);
+		if(ret)
+			goto out;
+		/* 10.4.2 step 9.3 */
+		i++;
+		templen += DRBG_BLOCKLEN(drbg);
+	}
+
+	/* 10.4.2 step 11 */
+	/* implicit key len with seedlen - blocklen according to table 3 */
+	X = temp + (DRBG_KEYLEN(drbg));
+	cipherin.in = X; cipherin.len = DRBG_BLOCKLEN(drbg);
+
+	/* 10.4.2 step 12: overwriting of outval */
+
+	/* 10.4.2 step 13 */
+	while(generated_len < bytes_to_return) {
+		short blocklen = 0;
+		/* 10.4.2 step 13.1 */
+		/* the truncation of the key length is implicit as the key
+		 * is only DRBG_BLOCKLEN in size -- check for the implementation
+		 * of the cipher function callback */
+		ret = drbg->core->cipher_fn(drbg, temp, X, &cipherin);
+		if(ret)
+			goto out;
+		blocklen = (DRBG_BLOCKLEN(drbg) <
+				(bytes_to_return - generated_len)) ?
+			    DRBG_BLOCKLEN(drbg) :
+				(bytes_to_return - generated_len);
+		/* 10.4.2 step 13.2 and 14 */
+		memcpy(out + generated_len, X, blocklen);
+		generated_len += blocklen;
+	}
+
+	ret = 0;
+
+out:
+	DRBG_CLEAR_CTR_BLK(IV);
+	DRBG_CLEAR_CTR_BLK(temp);
+	DRBG_CLEAR_CTR_BLK(pad);
+	return ret;
+}
+
+static int drbg_ctr_update_state(struct drbg_state *drbg,
+				 struct drbg_conc *prov_data,
+				 int reseed)
+{
+	int ret = -EFAULT;
+	/* 10.2.1.2 step 1 */
+	unsigned char temp[DRBG_CTR_BLK], df_data[DRBG_CTR_BLK];
+	unsigned char *temp_p, *df_data_p; /* not malloced */
+	int len = 0;
+	struct drbg_conc cipherin;
+
+	DRBG_CLEAR_CTR_BLK(temp);
+	DRBG_CLEAR_CTR_BLK(df_data);
+	DRBG_CLEAR_CONC(cipherin);
+
+	/* 10.2.1.3.2 step 2 and 10.2.1.4.2 step 2 */
+	if(0 < prov_data->len) {
+		ret = drbg_ctr_df(drbg, df_data, DRBG_STATELEN(drbg),
+				  prov_data);
+		if(ret)
+			goto out;
+	}
+
+	cipherin.in = drbg->V; cipherin.len = DRBG_BLOCKLEN(drbg);
+	/* 10.2.1.3.2 step 2 and 3 -- are already covered as we memset(0)
+	 * all memory during initialization */
+	while(len < (DRBG_STATELEN(drbg))) {
+		/* 10.2.1.2 step 2.1 */
+		drbg_add_buf(drbg->V, DRBG_BLOCKLEN(drbg),
+			     (unsigned char *) "\1", 1);
+		/* 10.2.1.2 step 2.2 */
+		/* using target of temp + len: 10.2.1.2 step 2.3 and 3 */
+		ret = drbg->core->cipher_fn(drbg, drbg->C, temp + len,
+					    &cipherin);
+		if(ret)
+			goto out;
+		/* 10.2.1.2 step 2.3 and 3 */
+		len += DRBG_BLOCKLEN(drbg);
+	}
+
+	/* 10.2.1.2 step 4 */
+	temp_p = temp;
+	df_data_p = df_data;
+	for(len = 0; len < DRBG_STATELEN(drbg); len++) {
+		*temp_p ^= *df_data_p;
+		df_data_p++; temp_p++;
+	}
+
+	/* 10.2.1.2 step 5 */
+	memcpy(drbg->C, temp, DRBG_KEYLEN(drbg));
+	/* 10.2.1.2 step 6 */
+	memcpy(drbg->V, temp + DRBG_KEYLEN(drbg), DRBG_BLOCKLEN(drbg));
+	ret = 0;
+
+out:
+	DRBG_CLEAR_CTR_BLK(df_data);
+	DRBG_CLEAR_CTR_BLK(temp);
+	return ret;
+}
+
+static int drbg_ctr_process_addtl(struct drbg_state *drbg,
+				  unsigned char *addtl_input, size_t addtllen)
+{
+	struct drbg_conc addtl;
+	DRBG_CLEAR_CONC(addtl);
+	if(0 == addtllen)
+		return 0;
+	/* 10.2.1.5.2 step 2 */
+	addtl.in = addtl_input;
+	addtl.len = addtllen;
+	return drbg_ctr_update_state(drbg, &addtl, 1);
+}
+
+static int drbg_ctr_preprocess_extract(struct drbg_state *drbg,
+				       unsigned char **src,
+				       unsigned char **dst,
+				       short *length)
+{
+	memset(drbg->scratchpad, 0, DRBG_BLOCKLEN(drbg));
+	*src = drbg->V;
+	*dst = (unsigned char *)drbg->scratchpad;
+	*length = DRBG_BLOCKLEN(drbg);
+
+	drbg_add_buf(*src, DRBG_BLOCKLEN(drbg),
+		     (unsigned char *) "\1", 1);
+
+	return 0;
+}
+
+static void drbg_ctr_postprocess_extract(struct drbg_state *drbg,
+					 unsigned char *src,
+					 unsigned char *dst, int notlast)
+{
+	/* 10.2.1.5.2 step 4.1 */
+	if(notlast)
+		drbg_add_buf(src, DRBG_BLOCKLEN(drbg),
+			     (unsigned char *) "\1", 1);
+}
+
+static void drbg_ctr_cleanup_extract(struct drbg_state *drbg,
+				     unsigned char **src,
+				     unsigned char **dst)
+{
+	memset(drbg->scratchpad, 0, DRBG_BLOCKLEN(drbg));
+}
+
+static int drbg_ctr_newstate_postgen(struct drbg_state *drbg,
+				     unsigned char *addtl_input,
+				     size_t addtllen)
+{
+	struct drbg_conc addtl;
+	DRBG_CLEAR_CONC(addtl);
+	addtl.in = addtl_input;
+	addtl.len = addtllen;
+	/* 10.1.2.5 step 6 */
+	/*TODO the DF function is called again since according to step
+	 * 2, the "additional_input" after step 2 is the output of the DF
+	 * function -- when we save the DF output as a replacement
+	 * for the addtl_input data, we do not need to call the DF again here*/
+	return drbg_ctr_update_state(drbg, &addtl, 1);
+}
+
+static struct drbg_state_ops drbg_ctr_ops = {
+	.process_addtl       = drbg_ctr_process_addtl,
+	.preprocess_extract  = drbg_ctr_preprocess_extract,
+	.postprocess_extract = drbg_ctr_postprocess_extract,
+	.cleanup_extract     = drbg_ctr_cleanup_extract,
+	.newstate_postgen    = drbg_ctr_newstate_postgen,
+	.update_state        = drbg_ctr_update_state,
+};
+#endif /* CONFIG_CRYPTO_DRBG_CTR */
+
+/******************************************************************
+ * HMAC DRBG callback functions
+ ******************************************************************/
+
+#ifdef CONFIG_CRYPTO_DRBG_HMAC
+static int drbg_hmac_update_state(struct drbg_state *drbg,
+				  struct drbg_conc *seed,
+				  int reseed)
+{
+	int ret = -EFAULT;
+	int i = 0;
+	struct drbg_conc seed1, seed2, cipherin;
+
+	DRBG_CLEAR_CONC(seed1);
+	DRBG_CLEAR_CONC(seed2);
+	DRBG_CLEAR_CONC(cipherin);
+
+	if(!reseed) {
+		/* 10.1.2.3 step 2 already implicitly covered with
+		 * the initial memset(0) of drbg->C */
+		memset(drbg->C, 0, DRBG_STATELEN(drbg));
+		memset(drbg->V, 1, DRBG_STATELEN(drbg));
+	}
+
+	/* build linked list which implements the concatenation and fill
+	 * first part*/
+	seed1.next = &seed2;
+	seed2.next = seed;
+	seed1.in = drbg->V;
+	seed1.len = DRBG_STATELEN(drbg);
+
+	cipherin.in = drbg->V;
+	cipherin.len = DRBG_STATELEN(drbg);
+	/* we execute two rounds of V/K massaging */
+	for(i = 2; 0 < i; i--) {
+		/* first round uses 0x0, second 0x1 */
+		unsigned char prefix = '\0';
+		if(1 == i)
+			prefix = '\1';
+
+		/* 10.1.2.2 step 1 and 4 -- concatenation and HMAC for key */
+		seed2.in = &prefix;
+		seed2.len = 1;
+		ret = drbg->core->cipher_fn(drbg, drbg->C, drbg->C, &seed1);
+		if(ret)
+			return ret;
+
+		/* 10.1.2.2 step 2 and 5 -- HMAC for V */
+		ret = drbg->core->cipher_fn(drbg, drbg->C, drbg->V, &cipherin);
+		if(ret)
+			return ret;
+
+		/* 10.1.2.2 step 3 */
+		if(0 == seed->len)
+			return ret;
+	}
+	ret = 0;
+
+	return ret;
+}
+
+static int drbg_hmac_process_addtl(struct drbg_state *drbg,
+				   unsigned char *addtl_input, size_t addtllen)
+{
+	struct drbg_conc addtl;
+	DRBG_CLEAR_CONC(addtl);
+	if(0 == addtllen)
+		return 0;
+	addtl.in = addtl_input;
+	addtl.len = addtllen;
+	/* 10.1.2.5 step 2 */
+	return drbg_hmac_update_state(drbg, &addtl, 1);
+}
+
+static int drbg_hmac_preprocess_extract(struct drbg_state *drbg,
+					unsigned char **src,
+					unsigned char **dst,
+					short *length)
+{
+	*src = drbg->V;
+	*dst = drbg->V;
+	*length = DRBG_STATELEN(drbg);
+	return 0;
+}
+static void drbg_hmac_postprocess_extract(struct drbg_state *drbg,
+					  unsigned char *src,
+					  unsigned char *dst, int notlast)
+{
+	/* nothing needed */
+}
+
+static void drbg_hmac_cleanup_extract(struct drbg_state *drbg,
+				      unsigned char **src,
+				      unsigned char **dst)
+{
+	/* nothing needed */
+}
+
+static int drbg_hmac_newstate_postgen(struct drbg_state *drbg,
+				      unsigned char *addtl_input,
+				      size_t addtllen)
+{
+	struct drbg_conc addtl;
+	DRBG_CLEAR_CONC(addtl);
+	addtl.in = addtl_input;
+	addtl.len = addtllen;
+	/* 10.1.2.5 step 6 */
+	return drbg_hmac_update_state(drbg, &addtl, 1);
+}
+
+static struct drbg_state_ops drbg_hmac_ops = {
+	.process_addtl       = drbg_hmac_process_addtl,
+	.preprocess_extract  = drbg_hmac_preprocess_extract,
+	.postprocess_extract = drbg_hmac_postprocess_extract,
+	.cleanup_extract     = drbg_hmac_cleanup_extract,
+	.newstate_postgen    = drbg_hmac_newstate_postgen,
+	.update_state        = drbg_hmac_update_state,
+};
+#endif /* CONFIG_CRYPTO_DRBG_HMAC */
+
+/******************************************************************
+ * Hash DRBG callback functions
+ ******************************************************************/
+
+#ifdef CONFIG_CRYPTO_DRBG_HASH
+static int drbg_hash_df(struct drbg_state *drbg,
+			unsigned char *outval, size_t outlen,
+			struct drbg_conc *entropy)
+{
+	int ret = 0;
+	/* 10.1.1.4 step 1 */
+	size_t len = 0;
+	unsigned char tmp[DRBG_HASH_BLK], input[5];
+	struct drbg_conc data1;
+
+	DRBG_CLEAR_HASH_BLK(tmp);
+	DRBG_CLEAR_CONC(data1);
+
+	/* 10.4.1 step 3 */
+	input[0] = 1;
+	drbg_int2byte(&input[1], (outlen * 8), 4);
+
+	/* 10.4.1 step 4.1 -- concatenation of data for input into hash */
+	data1.next = entropy;
+	data1.in = input;
+	data1.len = 5;
+
+	/* 10.4.1 step 4 */
+	while(len < outlen) {
+		short blocklen = 0;
+		/* 10.4.1 step 4.1 */
+		ret = drbg->core->cipher_fn(drbg, NULL, tmp, &data1);
+		if(ret) {
+			memset(outval, 0, outlen);
+			goto out;
+		}
+		/* 10.4.1 step 4.2 */
+		input[0]++;
+		blocklen = (DRBG_BLOCKLEN(drbg) < (outlen - len)) ?
+			    DRBG_BLOCKLEN(drbg) : (outlen - len);
+		memcpy(outval + len, tmp, blocklen);
+		len += blocklen;
+	}
+
+out:
+	DRBG_CLEAR_HASH_BLK(tmp);
+	return ret;
+}
+
+static int drbg_hash_update_state(struct drbg_state *drbg,
+				  struct drbg_conc *seed,
+				  int reseed)
+{
+	int ret = 0;
+	struct drbg_conc data1, data2;
+	unsigned char V[DRBG_HASH_BLK];
+
+	DRBG_CLEAR_HASH_BLK(V);
+	DRBG_CLEAR_CONC(data1);
+	DRBG_CLEAR_CONC(data2);
+
+	if(reseed) {
+		/* 10.1.1.3 step 1: string length is concatenation of
+		 * 1 byte, V and seed (which is concatenated entropy/addtl
+		 * input)
+		 */
+		memcpy(V, drbg->V, DRBG_STATELEN(drbg));
+		data1.next = &data2;
+		data2.next = seed;
+		data1.in = (unsigned char *)"\1";
+		data1.len = 1;
+		data2.in = V;
+		data2.len = DRBG_STATELEN(drbg);
+	} else {
+		data1.in = seed->in;
+		data1.len = seed->len;
+		data1.next = seed->next;
+	}
+
+	/* 10.1.1.2 / 10.1.1.3 step 2 and 3 */
+	ret = drbg_hash_df(drbg, drbg->V, DRBG_STATELEN(drbg), &data1);
+	if(ret)
+		goto out;
+
+	/* 10.1.1.2 / 10.1.1.3 step 4 -- concatenation  */
+	data1.next = &data2;
+	data2.next = NULL;
+	data1.in = (unsigned char *)"\0";
+	data1.len = 1;
+	data2.in = drbg->V;
+	data2.len = DRBG_STATELEN(drbg);
+	/* 10.1.1.2 / 10.1.1.3 step 4 -- df operation */
+	ret = drbg_hash_df(drbg, drbg->C, DRBG_STATELEN(drbg), &data1);
+
+out:
+	DRBG_CLEAR_HASH_BLK(V);
+	return ret;
+}
+
+static int drbg_hash_process_addtl(struct drbg_state *drbg,
+			      unsigned char *addtl_input, size_t addtllen)
+{
+	int ret = 0;
+	unsigned char w[DRBG_HASH_BLK];
+	struct drbg_conc data1, data2, data3;
+
+	DRBG_CLEAR_HASH_BLK(w);
+	DRBG_CLEAR_CONC(data1);
+	DRBG_CLEAR_CONC(data2);
+	DRBG_CLEAR_CONC(data3);
+
+	/* 10.1.1.4 step 2 */
+	if(0 == addtllen)
+		return 0;
+
+	/* 10.1.1.4 step 2a -- concatenation */
+	data1.next = &data2;
+	data2.next = &data3;
+	data1.in = (unsigned char *) "\2";
+	data1.len = 1;
+	data2.in = drbg->V;
+	data2.len = DRBG_STATELEN(drbg);
+	data3.in = addtl_input;
+	data3.len = addtllen;
+	/* 10.1.1.4 step 2a -- cipher invocation */
+	ret = drbg->core->cipher_fn(drbg, NULL, w, &data1);
+	if(ret)
+		goto out;
+
+	/* 10.1.1.4 step 2b */
+	drbg_add_buf(drbg->V, DRBG_STATELEN(drbg), w, DRBG_BLOCKLEN(drbg));
+
+out:
+	DRBG_CLEAR_HASH_BLK(w);
+	return ret;
+}
+
+static int drbg_hash_preprocess_extract(struct drbg_state *drbg,
+					unsigned char **src,
+					unsigned char **dst,
+					short *length)
+{
+	memset(drbg->scratchpad, 0,
+	       (DRBG_STATELEN(drbg) + DRBG_BLOCKLEN(drbg)));
+	memcpy(drbg->scratchpad, drbg->V, DRBG_STATELEN(drbg));
+
+	*src = (unsigned char *)drbg->scratchpad;
+	*dst = (unsigned char *)drbg->scratchpad + DRBG_STATELEN(drbg);
+	*length = DRBG_STATELEN(drbg);
+
+	return 0;
+}
+
+static void drbg_hash_postprocess_extract(struct drbg_state *drbg,
+					  unsigned char *src,
+					  unsigned char *dst, int notlast)
+{
+	/* 10.1.1.4 hashgen step 4.3 */
+	if(notlast)
+		drbg_add_buf(src, DRBG_STATELEN(drbg),
+			     (unsigned char *) "\1", 1);
+}
+
+static void drbg_hash_cleanup_extract(struct drbg_state *drbg,
+				      unsigned char **src,
+				      unsigned char **dst)
+{
+	memset(drbg->scratchpad, 0,
+	       (DRBG_STATELEN(drbg) + DRBG_BLOCKLEN(drbg)));
+}
+
+static int drbg_hash_newstate_postgen(struct drbg_state *drbg,
+				      unsigned char *addtl_input,
+				      size_t addtllen)
+{
+	int ret = 0;
+	unsigned char req[8], H[DRBG_HASH_BLK];
+	struct drbg_conc data1, data2;
+
+	DRBG_CLEAR_HASH_BLK(H);
+	DRBG_CLEAR_CONC(data1);
+	DRBG_CLEAR_CONC(data2);
+
+	/* 10.1.1.4 step 4 */
+	data1.next = &data2;
+	data1.in = (unsigned char *) "\3";
+	data1.len = 1;
+	data2.in = drbg->V;
+	data2.len = DRBG_STATELEN(drbg);
+	ret = drbg->core->cipher_fn(drbg, NULL, H, &data1);
+	if(ret)
+		goto out;
+
+	/* 10.1.1.4 step 5 */
+	drbg_add_buf(drbg->V, DRBG_STATELEN(drbg),
+		     H, DRBG_BLOCKLEN(drbg));
+	drbg_add_buf(drbg->V, DRBG_STATELEN(drbg),
+		     drbg->C, DRBG_STATELEN(drbg));
+	drbg_int2byte(req, drbg->reseed_ctr, sizeof(req));
+	drbg_add_buf(drbg->V, DRBG_STATELEN(drbg), req, 8);
+
+out:
+	DRBG_CLEAR_HASH_BLK(H);
+	return ret;
+}
+
+static struct drbg_state_ops drbg_hash_ops = {
+	.process_addtl       = drbg_hash_process_addtl,
+	.preprocess_extract  = drbg_hash_preprocess_extract,
+	.postprocess_extract = drbg_hash_postprocess_extract,
+	.cleanup_extract     = drbg_hash_cleanup_extract,
+	.newstate_postgen    = drbg_hash_newstate_postgen,
+	.update_state        = drbg_hash_update_state,
+};
+#endif /* CONFIG_CRYPTO_DRBG_HASH */
+
+/******************************************************************
+ * Functions common for DRBG implementations
+ ******************************************************************/
+
+/*
+ * Set up the pointers to the right DRBG type implementations
+ *
+ * @drbg DRBG handle
+ *
+ * return:
+ * 	0 on success
+ * 	error value otherwise
+ */
+static inline int drbg_add_callbacks(struct drbg_state *drbg)
+{
+#ifdef CONFIG_CRYPTO_DRBG_HMAC
+	if(drbg->flags & DRBG_HMAC_MASK) {
+		drbg->d_ops = &drbg_hmac_ops;
+		return 0;
+	}
+#endif /* CONFIG_CRYPTO_DRBG_HMAC */
+#ifdef CONFIG_CRYPTO_DRBG_HASH
+	if(drbg->flags & DRBG_HASH_MASK) {
+		drbg->d_ops = &drbg_hash_ops;
+		return 0;
+	}
+#endif /* CONFIG_CRYPTO_DRBG_HASH */
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+	if(drbg->flags & DRBG_CTR_MASK) {
+		drbg->d_ops = &drbg_ctr_ops;
+		return 0;
+	}
+#endif /* CONFIG_CRYPTO_DRBG_CTR */
+	return -EOPNOTSUPP;
+}
+
+/*
+ * Seeding or reseeding of the DRBG
+ *
+ * @drbg: DRBG state struct
+ * @pers: personalization / additional information buffer
+ * @perslen: size of personalization / additional information buffer
+ * @reseed: 0 for initial seed process, 1 for reseeding
+ *
+ * return:
+ *	0 on success
+ *	error value otherwise
+ */
+static int drbg_seed(struct drbg_state *drbg, unsigned char *pers,
+		     size_t perslen, int reseed)
+{
+	int ret = 0;
+	unsigned char *entropy = NULL;
+	size_t entropylen = 0;
+	struct drbg_conc data1, data2;
+
+	DRBG_CLEAR_CONC(data1);
+	DRBG_CLEAR_CONC(data2);
+
+	/* 9.1 / 9.2 / 9.3.1 step 3 */
+	if(perslen > (drbg_max_addtl(drbg)))
+		return -EINVAL;
+
+	/* section 8.6.1 together with section 8.6.3 and 8.6.7 -- consider DRBG
+	 * seeded only when sufficient seed is provided */
+	/* Sufficient seed is provided: when we have no derivation function,
+	 * a nonce is not necessary, if we have a derivation function, a nonce
+	 * is necessary. A nonce must be at least 1/2 of the security strength
+	 * of the DRBG in size. Thus, entropy * nonce is 3/2 of the strength.
+	 *
+	 * The consideration of a nonce is only applicable during initial
+	 * seeding.
+	 */
+
+	/* chapter 9: No seed is provided, the DRBG shall get its own seed */
+	if(drbg->test_data) {
+		data1.in = drbg->test_data->testentropy;
+		data1.len = drbg->test_data->testentropylen;
+	} else {
+		entropylen = (drbg_sec_strength(drbg->flags) / 8);
+		if(0 == reseed)
+		/* make sure we round up strength/2 in
+		 * case it is not divisible by 2 */
+			entropylen = ((entropylen + 1) / 2) * 3;
+
+		entropy = kzalloc(entropylen, GFP_KERNEL);
+		if(!entropy)
+			return -ENOMEM;
+		get_random_bytes(entropy, entropylen);
+		data1.in = entropy;
+		data1.len = entropylen;
+	}
+
+	/* 10.1.1.2 step 1 and 10.1.1.3 step 1 (concatenation of entropy /
+	 * addtl input) */
+	if(0 < perslen) {
+		data1.next = &data2;
+		data2.in = pers;
+		data2.len = perslen;
+	}
+
+	ret = drbg->d_ops->update_state(drbg, &data1, reseed);
+	if(ret)
+		goto out;
+
+	drbg->flags &= ~(DRBG_UNSEEDED);
+	/* 10.1.1.2 / 10.1.1.3 step 5 */
+	drbg->reseed_ctr = 1;
+
+out:
+	if (entropy)
+		kzfree(entropy);
+	return ret;
+}
+
+/*
+ * Check for reseeding of the DRBG and invoke reseeding if necessary.
+ * This includes the enforcement of the prediction resistance as well
+ * as the reseeding constraint set by the SP800-90A requirement.
+ * 
+ * @drbg: DRBG state struct
+ * @addtl_input: addition input for reseeding
+ * @addtllen: length of additional input
+ *
+ * return:
+ *	0 on success -- implies a successful reseeding of the DRBG handle
+ *	error value otherwise
+ */
+static int drbg_check_reseed(struct drbg_state *drbg,
+			     unsigned char **addtl_input, size_t *addtllen)
+{
+	int ret = 0;
+
+	if((drbg_max_requests(drbg)) < drbg->reseed_ctr)
+		drbg->flags |= DRBG_UNSEEDED;
+
+	/* section 9.3.1 step 6 and 7 */
+	if(!(drbg->flags & DRBG_PREDICTION_RESIST) &&
+	   !(drbg->flags & DRBG_UNSEEDED))
+		return 0;
+	ret = drbg_seed(drbg, *addtl_input, *addtllen, 1);
+
+	/* This is NOT documented, but needed! */
+	*addtl_input = NULL;
+	*addtllen = 0;
+
+	return ret;
+}
+
+/*
+ * Sanity check of state during drbg_generate() -- we check for:
+ * 	reseeding requirement
+ * 	maximum number of requested bits
+ *
+ * @drbg: DRBG state struct
+ * @strength: requested minimum strength of DRBG
+ * @buflen: size of requested random number
+ *
+ * return:
+ *	0 on success
+ * 	error value otherwise
+ */
+static inline int drbg_generate_sanity(struct drbg_state *drbg, size_t buflen,
+				       unsigned char *pers, size_t perslen)
+{
+	if(NULL == drbg)
+		return -EINVAL;
+	if(NULL == drbg->core)
+		return -EINVAL;
+	if(NULL == drbg->V)
+		return -EINVAL;
+	if(NULL == drbg->C)
+		return -EINVAL;
+	if(NULL == drbg->scratchpad)
+		return -EINVAL;
+
+	/* 9.1 / 9.2 / 9.3.1 step 3 */
+	if(perslen > (drbg_max_addtl(drbg)))
+		return -EINVAL;
+	if(NULL == pers && 0 < perslen)
+		return -EINVAL;
+
+	/* 9.3.1 step 2 -- max_bits is in bits, but buflen is in bytes */
+	if(buflen > (drbg_max_request_bytes(drbg)))
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * FIPS 140-2 continuous self test
+ * The test is performed on the result of one round of the output
+ * function. Thus, the function implicitly knows the size of the
+ * buffer.
+ *
+ * @drbg DRBG handle
+ * @buf output buffer of random data to be checked
+ *
+ * return:
+ *	true on success
+ * 	false on error
+ */
+static bool drbg_fips_continuous_test(struct drbg_state *drbg,
+				     unsigned char *buf)
+{
+#ifdef CONFIG_CRYPTO_FIPS
+	int ret = 0;
+	/* skip test if we test the overall system */
+	if(drbg->test_data)
+		return true;
+	/* only perform test in FIPS mode */
+	if(0 == fips_enabled)
+		return true;
+	if(!drbg->prev) {
+		drbg->prev = kzalloc(DRBG_BLOCKLEN(drbg), GFP_KERNEL);
+		if(!drbg->prev)
+			return -ENOMEM;
+		/* Priming of FIPS test */
+		memcpy(drbg->prev, buf, DRBG_BLOCKLEN(drbg));
+		/* return false due to priming, i.e. another round is needed */
+		return false;
+	}
+	ret = memcmp(drbg->prev, buf, DRBG_BLOCKLEN(drbg));
+	memcpy(drbg->prev, buf, DRBG_BLOCKLEN(drbg));
+	/* invert the memcmp result, because the test shall pass when the
+	 * two compared values do not match */
+	if(ret)
+		return true;
+	else
+		return false;
+#else
+	return true;
+#endif /* CONFIG_CRYPTO_FIPS */
+}
+
+/*
+ * Heavy lifting function of generating random numbers by generating
+ * blockwise output via cipher and ensuring that the last block is truncated
+ * to the proper length.
+ *
+ * @drbg DRBG handle
+ * @buf output buffer of random data
+ * @buflen length of output buffer
+ *
+ * return: generated bytes
+ */
+static unsigned int drbg_extract_bytes(struct drbg_state *drbg,
+				       unsigned char *buf,
+				       unsigned int buflen)
+{
+	int ret = 0;
+	/* 10.1.1.4 step 1 */
+	unsigned int len = 0;
+	unsigned char *src = NULL;
+	unsigned char *dst = NULL;
+	short length = 0;
+	struct drbg_conc data;
+
+	DRBG_CLEAR_CONC(data);
+
+	/* set up the source buffers and destination buffers as needed for
+	 * the DRBG type -- the source buffer is fed into the cipher operation
+	 * and the destination buffer will hold the result of the cipher
+	 * operation */
+	ret = drbg->d_ops->preprocess_extract(drbg, &src, &dst, &length);
+	if(ret)
+		return 0;
+	data.in = src;
+	data.len = length;
+
+	/* potential integer overflow is covered by drbg_generate_sanity which
+	 * ensures that buflen cannot overflow a signed int */
+	while(len < buflen) {
+		unsigned int outlen = 0;
+		/* 10.1.1.4 step hashgen 4.1, 10.1.2.5 step 4.1,
+		 * 10.2.1.5.2 step 4.2 */
+		ret = drbg->core->cipher_fn(drbg, drbg->C, dst, &data);
+		if(ret)
+			goto out;
+		outlen = (DRBG_BLOCKLEN(drbg) < (buflen - len)) ?
+			  DRBG_BLOCKLEN(drbg) : (buflen - len);
+		if(!drbg_fips_continuous_test(drbg, dst)) {
+			/* Continuous test failed or is just primed -- generate
+			 * next round without copying the generated value out
+			 * to the caller -- potential for a deadlock, but
+			 * this error cannot mathematically occur. If it
+			 * occurs, the integrity of the entire kernel is
+			 * lost. */
+			drbg->d_ops->postprocess_extract(drbg, src, dst,
+							 (len < buflen));
+			continue;
+		}
+		/* 10.1.1.4 step hashgen 4.2, 10.1.2.5 step 4.2,
+		 * 10.2.1.5.2 step 4.3 */
+		memcpy(buf + len, dst, outlen);
+		len += outlen;
+		/* Advance the buffers, if needed by the DRBG type */
+		drbg->d_ops->postprocess_extract(drbg, src, dst,
+						 (len < buflen));
+	}
+
+out:
+	/* Allow DRBG type implementations to cleanup any temporary buffers
+	 * set up when defining source and destination buffers
+	 */
+	drbg->d_ops->cleanup_extract(drbg, &src, &dst);
+	return len;
+}
+
+/*
+ * Process request to generate random numbers. This function ensures
+ * that the additional information / personalization string is processed
+ * before bytes are generated. Also, this function ensures that the DRBG
+ * state is updated after random number generation.
+ *
+ * @drbg DRBG handle
+ * @buf output buffer of random data
+ * @buflen length of output buffer
+ * @addtl_input Additional input / personalization string buffer
+ * @addtllen Length of additional input buffer
+ *
+ * return: generated bytes
+ */
+static unsigned int drbg_generate_bytes(struct drbg_state *drbg,
+					unsigned char *buf, unsigned int buflen,
+					unsigned char *addtl_input,
+					size_t addtllen)
+{
+	unsigned int len = 0;
+
+	/* 10.1.1.4 step 2, 10.1.2.5 step 2, 10.2.1.5.2 step 2 */
+	if(drbg->d_ops->process_addtl(drbg, addtl_input, addtllen))
+		return 0;
+	/* 10.1.1.4 step 3, 10.1.2.5 step 3, 10.2.1.5.2 step 3 */
+	len = drbg_extract_bytes(drbg, buf, buflen);
+	
+	/* 10.1.1.4 step 4 and following, 10.1.2.5 step 6, 10.2.1.5.2 step 6 */
+	if(drbg->d_ops->newstate_postgen(drbg, addtl_input, addtllen))
+		return 0;
+	return len;
+}
+
+/*
+ * Check for programming errors: ensure that stack variable size is
+ * sufficient for ciphers.
+ *
+ * @flags flags specifying the core cipher type
+ * @core selected core
+ *
+ * return:
+ * 	true if sanity check passed
+ * 	false if sanity check failed
+ */
+static inline bool drbg_check_progamming_sanity(drbg_flag_t flags,
+					 const struct drbg_core *core)
+{
+	size_t size = 0;
+	if(flags & DRBG_CTR_MASK)
+		size = DRBG_CTR_BLK;
+	else if (flags & DRBG_HASH_MASK)
+		size = DRBG_HASH_BLK;
+	else if (flags & DRBG_HMAC_MASK)
+		size = DRBG_HMAC_BLK;
+	return (size >= core->statelen);
+}
+
+/*
+ * Find the right cipher callback data structure that matches the
+ * the requested cipher type. The code returns the first match in case caller
+ * made the error to request multiple ciphers
+ *
+ * @flags Flags handed in by caller during instantiation request
+ *
+ * return:
+ * 	pointer to core on success
+ * 	NULL on error
+ */
+static const inline struct drbg_core *drbg_find_core(drbg_flag_t flags)
+{
+	drbg_flag_t req_cipher = (flags & DRBG_CIPHER_MASK);
+	int i = 0;
+
+	for(i = 0; ARRAY_SIZE(cores) > i; i++) {
+		if(req_cipher & cores[i].flags) {
+			if(drbg_check_progamming_sanity(req_cipher, &cores[i]))
+				return &cores[i];
+			return NULL;
+		}
+	}
+	return NULL;
+}
+
+/*************************************************************************
+ * DRBG interface functions
+ *************************************************************************/
+
+/*
+ * DRBG instantiation function as required by SP800-90A - this function
+ * sets up the DRBG handle, performs the initial seeding and all sanity
+ * checks required by SP800-90A
+ *
+ * @drbg memory of state -- if NULL, new memory is allocated
+ * @pers Personalization string that is mixed into state, may be NULL -- note
+ * 	 the entropy is pulled by the DRBG internally unconditionally
+ * 	 as defined in SP800-90A. The additional input is mixed into
+ * 	 the state in addition to the pulled entropy.
+ * @perslen Length of personalization string buffer, shall be 0 when buffer
+ *	    is NULL
+ * @flags Flags defining the requested DRBG type and cipher type. The flags
+ * 	  are defined in drbg.h and may be XORed. Beware, if you XOR multiple
+ * 	  cipher types together, the code picks the core on a first come first
+ * 	  serve basis as it iterates through the available cipher cores and
+ * 	  uses the one with the first match. The minimum required flags are:
+ * 		cipher type flag
+ *
+ * return
+ * 	0 on success
+ * 	error value otherwise
+ */
+
+static int drbg_instantiate(struct drbg_state *drbg,
+			    unsigned char *pers, size_t perslen,
+			    drbg_flag_t flags)
+{
+	int ret = -ENOMEM;
+	const struct drbg_core *core = NULL;
+
+	core = drbg_find_core(flags);
+	if(NULL == core)
+		return -EINVAL;
+
+	/* 9.1 step 1 is implicit with the selected DRBG type -- see
+	 * drbg_sec_strength() */
+
+	/* 9.1 step 2 is implicit as caller can select prediction resistance
+	 * and the flag is copied into drbg->flags --
+	 * all DRBG types support prediction resistance */
+
+	/* 9.1 step 4 is implicit in  drbg_sec_strength */
+
+	/* no allocation of drbg as this is done by the kernel crypto API */
+	drbg->V = kzalloc(core->statelen, GFP_KERNEL);
+	if(!drbg->V)
+		goto err;
+	drbg->C = kzalloc(core->statelen, GFP_KERNEL);
+	if(!drbg->C)
+		goto err;
+
+	/* the Hash DRBG needs full buffer, CTR needs only blocklen_bytes and
+	 * HMAC does not need buffer at all */
+	drbg->scratchpad = kzalloc(core->statelen + core->blocklen_bytes,
+				   GFP_KERNEL);
+	if(!drbg->scratchpad)
+		goto err;
+
+	spin_lock_init(&drbg->drbg_lock);
+
+	drbg->flags = flags;
+	drbg->flags |= DRBG_UNSEEDED;
+	drbg->core = core;
+
+	if(core->init_lib)
+		if(core->init_lib(drbg))
+			return -EFAULT;
+
+	ret = drbg_add_callbacks(drbg);
+	if(ret)
+		goto err;
+
+	/* 9.1 step 6 through 11 */
+	ret = drbg_seed(drbg, pers, perslen, 0);
+	if(ret)
+		goto err;
+
+	return 0;
+
+err:
+	if(drbg->C)
+		kzfree(drbg->C);
+	drbg->C = NULL;
+	if(drbg->V)
+		kzfree(drbg->V);
+	drbg->V = NULL;
+	if(drbg->scratchpad)
+		kzfree(drbg->scratchpad);
+	drbg->scratchpad = NULL;
+	return ret;
+}
+
+/*
+ * DRBG uninstantiate function as required by SP800-90A - this function
+ * frees all buffers and the DRBG handle
+ *
+ * @drbg DRBG state handle
+ * @free_state free the DRBG state handle in addition to zeroization
+ *
+ * return
+ * 	0 on success
+ */
+static int drbg_uninstantiate(struct drbg_state *drbg)
+{
+	/* ensure that other threads have their chance to complete their work */
+	spin_lock_bh(&drbg->drbg_lock);
+	if(drbg->core->fini_lib)
+		drbg->core->fini_lib(drbg);
+	if(drbg->V)
+		kzfree(drbg->V);
+	drbg->V = NULL;
+	if(drbg->C)
+		kzfree(drbg->C);
+	drbg->C = NULL;
+	if(drbg->scratchpad)
+		kzfree(drbg->scratchpad);
+	drbg->scratchpad = NULL;
+#ifdef CONFIG_CRYPTO_FIPS
+	if(drbg->prev)
+		kzfree(drbg->prev);
+	drbg->prev = NULL;
+#endif
+	/* no scrubbing of test_data -- this shall survive an uninstantiate */
+	spin_unlock_bh(&drbg->drbg_lock);
+	/* no freeing of drbg as this is done by the kernel crypto API */
+	return 0;
+}
+
+/*
+ * DRBG generate function as required by SP800-90A - this function
+ * generates random numbers
+ *
+ * @drbg DRBG state handle
+ * @buf Buffer where to store the random numbers -- the buffer must already
+ *      be pre-allocated by caller
+ * @buflen Length of output buffer - this value defines the number of random
+ * 	   bytes pulled from DRBG
+ * @addtl_input Additional input that is mixed into state, may be NULL -- note
+ * 		the entropy is pulled by the DRBG internally unconditionally
+ * 		as defined in SP800-90A. The additional input is mixed into
+ * 		the state in addition to the pulled entropy.
+ * @addtllen Length of additional input buffer, shall be 0 when buffer is NULL
+ *
+ * return: generated number of bytes
+ */
+static unsigned int drbg_generate(struct drbg_state *drbg,
+				  unsigned char *buf, unsigned int buflen,
+				  unsigned char *addtl_input, size_t addtllen)
+{
+	unsigned int len = 0;
+
+	if(0 == buflen)
+		return 0;
+
+	spin_lock_bh(&drbg->drbg_lock);
+	if(drbg_generate_sanity(drbg, buflen, addtl_input, addtllen))
+		goto out;
+
+	if(drbg_check_reseed(drbg, &addtl_input, &addtllen))
+		goto out;
+
+	len = drbg_generate_bytes(drbg, buf, buflen, addtl_input, addtllen);
+
+	/* 10.1.1.4 step 6, 10.1.2.5 step 7, 10.2.1.5.2 step 7 */
+	drbg->reseed_ctr++;
+
+out:
+	spin_unlock_bh(&drbg->drbg_lock);
+	return len;
+}
+
+/*
+ * DRBG reseed function as required by SP800-90A
+ *
+ * @drbg DRBG state handle
+ * @addtl_input Additional input that is mixed into state, may be NULL -- note
+ * 		the entropy is pulled by the DRBG internally unconditionally
+ * 		as defined in SP800-90A. The additional input is mixed into
+ * 		the state in addition to the pulled entropy.
+ * @addtllen Length of additional input buffer, shall be 0 when buffer is NULL
+ *
+ * return
+ * 	0 on success
+ * 	error value otherwise
+ */
+/* The kernel crypto API does not implement a reseeding function API call.
+ * This function should be enabled once a reseeding API call is implemented.
+ */
+#if 0
+static int drbg_reseed(struct drbg_state *drbg, unsigned char *addtl_input,
+		       size_t addtllen)
+{
+	int ret = 0;
+	spin_lock_bh(&drbg->drbg_lock);
+	ret = drbg_seed(drbg, addtl_input, addtllen, 1);
+	spin_unlock_bh(&drbg->drbg_lock);
+	return ret;
+}
+#endif
+
+/*
+ * Helper function for setting the test data in the DRBG
+ *
+ * @drbg DRBG state handle
+ * @test_data test data to sets
+ */
+static inline void drbg_set_testdata(struct drbg_state *drbg,
+			      struct drbg_test_data *test_data)
+{
+	if(!test_data)
+		return;
+	spin_lock_bh(&drbg->drbg_lock);
+	drbg->test_data = test_data;
+	spin_unlock_bh(&drbg->drbg_lock);
+}
+
+/***************************************************************
+ * Kernel crypto APi cipher invocations requested by DRBG
+ ***************************************************************/
+
+#if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
+static int drbg_init_hash_kernel(struct drbg_state *drbg)
+{
+	int ret = 0;
+	struct shash_desc *shash;
+	int size;
+	struct crypto_shash *tfm;
+
+	/* allocate synchronous hash */
+	tfm = crypto_alloc_shash(drbg->core->backend_cra_name, 0, 0);
+	if (IS_ERR(tfm)) {
+		printk("drbg: could not allocate digest TFM handle\n");
+		return -EFAULT;
+	}
+
+	size = sizeof(struct shash_desc);
+	shash = kzalloc(size, GFP_KERNEL);
+	if (!shash) {
+		crypto_free_shash(tfm);
+		return -ENOMEM;
+	}
+	shash->tfm = tfm;
+	shash->flags = 0x0;
+	drbg->priv_data = shash;
+
+	return ret;
+}
+
+static int drbg_fini_hash_kernel(struct drbg_state *drbg)
+{
+	struct shash_desc *shash = (struct shash_desc *)drbg->priv_data;
+	if(shash) {
+		crypto_free_shash(shash->tfm);
+		kzfree(shash);
+	}
+	drbg->priv_data = NULL;
+	return 0;
+}
+
+static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *key,
+			   unsigned char *outval, struct drbg_conc *in)
+{
+	struct shash_desc *shash = (struct shash_desc *)drbg->priv_data;
+	crypto_shash_init(shash);
+	for(; NULL != in; in = in->next)
+		crypto_shash_update(shash, in->in, in->len);
+	return crypto_shash_final(shash, outval);
+}
+#endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
+
+#ifdef CONFIG_CRYPTO_DRBG_HMAC
+static int drbg_kcapi_hmac(struct drbg_state *drbg, unsigned char *key,
+			   unsigned char *outval, struct drbg_conc *in)
+{
+	int ret = 0;
+	struct shash_desc *shash = (struct shash_desc *)drbg->priv_data;
+	ret = crypto_shash_setkey(shash->tfm, key, DRBG_STATELEN(drbg));
+	if(ret)
+		return ret;
+	return drbg_kcapi_hash(drbg, key, outval, in);
+}
+#endif /* CONFIG_CRYPTO_DRBG_HMAC */
+
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+static int drbg_init_sym_kernel(struct drbg_state *drbg)
+{
+	int ret = 0;
+	struct blkcipher_desc *desc;
+	struct crypto_blkcipher *blkcipher;
+
+	/* allocate synchronous cipher */
+	blkcipher = crypto_alloc_blkcipher(drbg->core->backend_cra_name, 0, 0);
+	if(IS_ERR(blkcipher)) {
+		printk("drbg: could not allocate cipher TFM handle\n");
+		return -EFAULT;
+	}
+
+	desc = kzalloc(sizeof(struct blkcipher_desc), GFP_KERNEL);
+	if (!desc) {
+		crypto_free_blkcipher(blkcipher);
+		return -ENOMEM;
+	}
+	desc->tfm = blkcipher;
+        desc->flags = 0;
+	drbg->priv_data = desc;
+
+	return ret;
+}
+
+static int drbg_fini_sym_kernel(struct drbg_state *drbg)
+{
+	struct blkcipher_desc *desc =
+		(struct blkcipher_desc *)drbg->priv_data;
+	if(desc) {
+		crypto_free_blkcipher(desc->tfm);
+		kzfree(desc);
+	}
+	drbg->priv_data = NULL;
+	return 0;
+}
+
+static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *key,
+			  unsigned char *outval, struct drbg_conc *in)
+{
+	int ret = 0;
+	struct scatterlist sg_in, sg_out;
+	struct blkcipher_desc *desc =
+		(struct blkcipher_desc *)drbg->priv_data;
+
+	if(crypto_blkcipher_setkey(desc->tfm, key, (DRBG_KEYLEN(drbg))))
+		return -EFAULT;
+	/* in is only component */
+	sg_init_one(&sg_in, in->in, in->len);
+	sg_init_one(&sg_out, outval, DRBG_BLOCKLEN(drbg));
+	ret = crypto_blkcipher_encrypt(desc, &sg_out, &sg_in, in->len);
+
+	return ret;
+}
+#endif /* CONFIG_CRYPTO_DRBG_CTR */
+
+/***************************************************************
+ * Kernel crypto API interface to register DRBG
+ ***************************************************************/
+
+/*
+ * Look up the DRBG flags by given kernel crypto API cra_name
+ * The code uses the cores definition to do this
+ * 
+ * @cra_name kernel crypto API cra_name
+ * 
+ * return: flags
+ */
+static drbg_flag_t drbg_convert_tfm_flags(const char *cra_name)
+{
+	int i = 0;
+	size_t start = 0;
+	int len = 0;
+	drbg_flag_t pr_flag = DRBG_PREDICTION_RESIST;
+	
+	/* disassemble the names */
+	if(0 == memcmp(cra_name, "drbg(nopr(", 10)) {
+		start = 10;
+		pr_flag = 0;
+	} else if (0 == memcmp(cra_name, "drbg(pr(", 8)) {
+		start = 8;
+	} else
+		return 0;
+	
+	/* remove the first part and the closing parenthesis */
+	len = strlen(cra_name) - start - 2;
+	
+	for(i = 0; ARRAY_SIZE(cores) > i; i++) {
+		if(0 == memcmp(cra_name + start, cores[i].cra_name, len))
+			/* add the prediction resistance flag, if drbg(pr(()))
+			 * is selected */
+			return (cores[i].flags | pr_flag);
+	}
+	return 0;
+}
+
+/*
+ * Initialize one DRBG invoked by the kernel crypto API
+ * 
+ * Function uses the kernel crypto API cra_name to look up
+ * the flags to instantiate the DRBG
+ */
+static int drbg_kcapi_init(struct crypto_tfm *tfm)
+{
+	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
+	drbg_flag_t flags = 0;
+	
+	flags = drbg_convert_tfm_flags(crypto_tfm_alg_name(tfm));
+	/* when personalization string is needed, the caller must call reset
+	 * and provide the personalization string as seed information */
+	return drbg_instantiate(drbg, NULL, 0, flags);
+}
+
+static void drbg_kcapi_cleanup(struct crypto_tfm *tfm)
+{
+	drbg_uninstantiate(crypto_tfm_ctx(tfm));
+}
+
+/*
+ * Generate random numbers:
+ * The API of the kernel crypto API is extended as follows:
+ * 
+ * If dlen is larger than zero, rdata is interpreted as the output buffer
+ * where random data is to be stored.
+ * 
+ * If dlen is zero, rdata is interpreted as a pointer to a struct drbg_gen
+ * which holds the additional information string that is used for the
+ * DRBG generation process. The output buffer that is to be used to store
+ * data is also pointed to by struct drbg_gen.
+ * 
+ */
+static int drbg_kcapi_random(struct crypto_rng *tfm, u8 *rdata,
+			     unsigned int dlen)
+{
+	struct drbg_state *drbg = crypto_rng_ctx(tfm);
+	if(0 < dlen) {
+		return drbg_generate(drbg, rdata, dlen,
+				     NULL, 0);
+	} else {
+		struct drbg_gen *data = (struct drbg_gen *)rdata;
+		drbg_set_testdata(drbg, data->test_data);
+		return drbg_generate(drbg, data->outbuf, data->outlen,
+				     data->addtl_input, data->addtllen);
+	}
+}
+
+static int drbg_kcapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	struct drbg_state *drbg = crypto_rng_ctx(tfm);
+	struct crypto_tfm *tfm_base = crypto_rng_tfm(tfm);
+	drbg_flag_t flags = 0;
+
+	drbg_uninstantiate(drbg);
+	flags = drbg_convert_tfm_flags(crypto_tfm_alg_name(tfm_base));
+	if(0 < slen) {
+		return drbg_instantiate(drbg, seed, slen, flags);
+	} else {
+		struct drbg_gen *data = (struct drbg_gen *)seed;
+		drbg_set_testdata(drbg, data->test_data);
+		return drbg_instantiate(drbg, data->addtl_input, data->addtllen,
+					flags);
+	}
+}
+
+/***************************************************************
+ * Kernel module: code to load the module
+ ***************************************************************/
+
+static struct crypto_alg drbg_algs[22];
+
+/* 
+ * Fill the array drbg_algs used to register the different DRBGs
+ * with the kernel crypto API. To fill the array, the information
+ * from cores[] is used.
+ */
+static void __init drbg_fill_array(unsigned long i, unsigned long j, int pr)
+{
+	int pos = 0;
+
+	memset(&drbg_algs[i], 0, sizeof(struct crypto_alg));
+	if(pr) {
+		memcpy(drbg_algs[i].cra_name, "drbg(pr(", 8);
+		memcpy(drbg_algs[i].cra_driver_name, "drbg_pr_", 8);
+		pos = 8;
+	} else {
+		memcpy(drbg_algs[i].cra_name, "drbg(nopr(", 10);
+		memcpy(drbg_algs[i].cra_driver_name, "drbg_nopr_", 10);
+		pos = 10;
+	}
+	memcpy(drbg_algs[i].cra_name + pos, cores[j].cra_name,
+	       strlen(cores[j].cra_name));
+	memcpy(drbg_algs[i].cra_name + pos + strlen(cores[j].cra_name), "))", 2);
+	memcpy(drbg_algs[i].cra_driver_name + pos,
+	       cores[j].cra_driver_name, strlen(cores[j].cra_driver_name));
+	drbg_algs[i].cra_priority	= 100;
+	drbg_algs[i].cra_flags	= CRYPTO_ALG_TYPE_RNG;
+	drbg_algs[i].cra_ctxsize= sizeof(struct drbg_state);
+	drbg_algs[i].cra_type	= &crypto_rng_type;
+	drbg_algs[i].cra_module	= THIS_MODULE;
+	drbg_algs[i].cra_init	= drbg_kcapi_init;
+	drbg_algs[i].cra_exit	= drbg_kcapi_cleanup;
+	drbg_algs[i].cra_u.rng.rng_make_random	= drbg_kcapi_random;
+	drbg_algs[i].cra_u.rng.rng_reset	= drbg_kcapi_reset;
+	drbg_algs[i].cra_u.rng.seedsize		= 0;
+}
+
+static void __init drbg_create_algs(void)
+{
+	unsigned int i = 0; /* pointer to drbg_algs */
+	unsigned int j = 0; /* pointer to cores */
+	
+	if(ARRAY_SIZE(cores) * 2 > ARRAY_SIZE(drbg_algs))
+		printk("drbg: Not all available DRBGs registered (slots needed:"
+		       "%lu, slots available: %lu)\n",
+		       ARRAY_SIZE(cores) * 2, ARRAY_SIZE(drbg_algs));
+
+	/* each DRBG definition can be used with PR and without PR, thus
+	 * we instantiate each DRBG in cores[] twice */
+	for(j = 0; ARRAY_SIZE(cores) > j; j++) {
+		drbg_fill_array(i, j, 1);
+		i++;
+		drbg_fill_array(i, j, 0);
+		i++;
+	}
+}
+
+static int __init drbg_init(void)
+{
+	drbg_create_algs();
+	return crypto_register_algs(drbg_algs, (ARRAY_SIZE(cores) * 2));
+}
+
+void __exit drbg_exit(void)
+{
+        crypto_unregister_algs(drbg_algs, (ARRAY_SIZE(cores) * 2));
+}
+
+module_init(drbg_init);
+module_exit(drbg_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("NIST SP800-90A Determinist Random Bit Generator (DRBG) using following cores:"
+#ifdef CONFIG_CRYPTO_DRBG_HMAC
+"HMAC "
+#endif
+#ifdef CONFIG_CRYPTO_DRBG_HASH
+"Hash "
+#endif
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+"CTR"
+#endif
+);
+
-- 
1.8.5.3


