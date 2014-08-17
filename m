Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaHQPpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:45:46 -0400
Received: from mail.eperm.de ([89.247.134.16]:53656 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaHQPpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:45:43 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 1/8] DRBG: replace int2byte with cpu_to_be
Date: Sun, 17 Aug 2014 17:37:34 +0200
Message-ID: <3515024.zAGKoTUedE@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DRBG requires the conversion of an integer into a string
representation of that integer. The previous implementation converted
the given integer byte-wise. However, the kernel offers the cpu_to_be
function which already re-arranges the memory representation of an
integer such that it applies when interpreting the same memory as
character string.

The change therefore uses an integer-cast / union of the target
character array together with the cpu_to_be function to convert an
integer into its string representation.

Tests show that the Hash and CTR DRBG implementations (the HMAC DRBG
does not require such conversion) is about 10% faster (or requires less
computing power, respectively).

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ff975d9..73d21e5 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -302,20 +302,19 @@ static bool drbg_fips_continuous_test(struct drbg_state *drbg,
  * Convert an integer into a byte representation of this integer.
  * The byte representation is big-endian
  *
- * @buf buffer holding the converted integer
  * @val value to be converted
- * @buflen length of buffer
+ * @buf buffer holding the converted integer -- caller must ensure that
+ *      buffer size is at least 32 bit
  */
 #if (defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_CTR))
-static inline void drbg_int2byte(unsigned char *buf, uint64_t val,
-				 size_t buflen)
+static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
 {
-	unsigned char *byte;
-	uint64_t i;
+	struct s {
+		__u32 conv;
+	};
+	struct s *conversion = (struct s *) buf;
 
-	byte = buf + (buflen - 1);
-	for (i = 0; i < buflen; i++)
-		*(byte--) = val >> (i * 8) & 0xff;
+	conversion->conv = cpu_to_be32(val);
 }
 
 /*
@@ -483,10 +482,10 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	/* 10.4.2 step 2 -- calculate the entire length of all input data */
 	list_for_each_entry(seed, seedlist, list)
 		inputlen += seed->len;
-	drbg_int2byte(&L_N[0], inputlen, 4);
+	drbg_cpu_to_be32(inputlen, &L_N[0]);
 
 	/* 10.4.2 step 3 */
-	drbg_int2byte(&L_N[4], bytes_to_return, 4);
+	drbg_cpu_to_be32(bytes_to_return, &L_N[4]);
 
 	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
 	padlen = (inputlen + sizeof(L_N) + 1) % (drbg_blocklen(drbg));
@@ -517,7 +516,7 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 		 * holds zeros after allocation -- even the increment of i
 		 * is irrelevant as the increment remains within length of i
 		 */
-		drbg_int2byte(iv, i, 4);
+		drbg_cpu_to_be32(i, iv);
 		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
 		ret = drbg_ctr_bcc(drbg, temp + templen, K, &bcc_list);
 		if (ret)
@@ -862,7 +861,7 @@ static int drbg_hash_df(struct drbg_state *drbg,
 
 	/* 10.4.1 step 3 */
 	input[0] = 1;
-	drbg_int2byte(&input[1], (outlen * 8), 4);
+	drbg_cpu_to_be32((outlen * 8), &input[1]);
 
 	/* 10.4.1 step 4.1 -- concatenation of data for input into hash */
 	drbg_string_fill(&data, input, 5);
@@ -1023,7 +1022,10 @@ static int drbg_hash_generate(struct drbg_state *drbg,
 {
 	int len = 0;
 	int ret = 0;
-	unsigned char req[8];
+	union {
+		unsigned char req[8];
+		__u64 req_int;
+	} u;
 	unsigned char prefix = DRBG_PREFIX3;
 	struct drbg_string data1, data2;
 	LIST_HEAD(datalist);
@@ -1053,8 +1055,8 @@ static int drbg_hash_generate(struct drbg_state *drbg,
 		     drbg->scratchpad, drbg_blocklen(drbg));
 	drbg_add_buf(drbg->V, drbg_statelen(drbg),
 		     drbg->C, drbg_statelen(drbg));
-	drbg_int2byte(req, drbg->reseed_ctr, sizeof(req));
-	drbg_add_buf(drbg->V, drbg_statelen(drbg), req, 8);
+	u.req_int = cpu_to_be64(drbg->reseed_ctr);
+	drbg_add_buf(drbg->V, drbg_statelen(drbg), u.req, 8);
 
 out:
 	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
-- 
1.9.3


