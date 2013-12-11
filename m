Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3LKW2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:28:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:51752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab3LKW2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:28:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,874,1378882800"; 
   d="scan'208";a="450805831"
Subject: [PATCH 2/2] crypto: Added speed tests for AEAD crypto alogrithms
 in tcrypt test suite
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>
Cc: Erdinc Ozturk <erdinc.ozturk@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Huang Ying <ying.huang@intel.com>,
        Alessandro Salvatori <sandr8@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
In-Reply-To: <a9c60c786b1b0d32664547342550ed3ddfe92364.1386772173.git.tim.c.chen@linux.intel.com>
References: <a9c60c786b1b0d32664547342550ed3ddfe92364.1386772173.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Dec 2013 14:28:47 -0800
Message-ID: <1386800927.2624.10.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding simple speed tests for a range of block sizes for AEAD crypto
algorithms.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/tcrypt.c | 270 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.h |  10 +++
 2 files changed, 280 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 001f07c..0d9003a 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -137,7 +137,272 @@ out:
 	return ret;
 }
 
+static int test_aead_jiffies(struct aead_request *req, int enc,
+				int blen, int sec)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	for (start = jiffies, end = start + sec * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		if (enc)
+			ret = crypto_aead_encrypt(req);
+		else
+			ret = crypto_aead_decrypt(req);
+
+		if (ret)
+			return ret;
+	}
+
+	printk("%d operations in %d seconds (%ld bytes)\n",
+	       bcount, sec, (long)bcount * blen);
+	return 0;
+}
+
+static int test_aead_cycles(struct aead_request *req, int enc, int blen)
+{
+	unsigned long cycles = 0;
+	int ret = 0;
+	int i;
+
+	local_irq_disable();
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		if (enc)
+			ret = crypto_aead_encrypt(req);
+		else
+			ret = crypto_aead_decrypt(req);
+
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		if (enc)
+			ret = crypto_aead_encrypt(req);
+		else
+			ret = crypto_aead_decrypt(req);
+		end = get_cycles();
+
+		if (ret)
+			goto out;
+
+		cycles += end - start;
+	}
+
+out:
+	local_irq_enable();
+
+	if (ret == 0)
+		printk("1 operation in %lu cycles (%d bytes)\n",
+		       (cycles + 4) / 8, blen);
+
+	return ret;
+}
+
 static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
+static u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
+
+#define XBUFSIZE 8
+#define MAX_IVLEN 32
+
+static int testmgr_alloc_buf(char *buf[XBUFSIZE])
+{
+	int i;
+
+	for (i = 0; i < XBUFSIZE; i++) {
+		buf[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!buf[i])
+			goto err_free_buf;
+	}
+
+	return 0;
+
+err_free_buf:
+	while (i-- > 0)
+		free_page((unsigned long)buf[i]);
+
+	return -ENOMEM;
+}
+
+static void testmgr_free_buf(char *buf[XBUFSIZE])
+{
+	int i;
+
+	for (i = 0; i < XBUFSIZE; i++)
+		free_page((unsigned long)buf[i]);
+}
+
+static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
+			unsigned int buflen)
+{
+	int np = (buflen + PAGE_SIZE - 1)/PAGE_SIZE;
+	int k, rem;
+
+	np = (np > XBUFSIZE) ? XBUFSIZE : np;
+	rem = buflen % PAGE_SIZE;
+	if (np > XBUFSIZE) {
+		rem = PAGE_SIZE;
+		np = XBUFSIZE;
+	}
+	sg_init_table(sg, np);
+	for (k = 0; k < np; ++k) {
+		if (k == (np-1))
+			sg_set_buf(&sg[k], xbuf[k], rem);
+		else
+			sg_set_buf(&sg[k], xbuf[k], PAGE_SIZE);
+	}
+}
+
+static void test_aead_speed(const char *algo, int enc, unsigned int sec,
+			    struct aead_speed_template *template,
+			    unsigned int tcount, u8 authsize,
+			    unsigned int aad_size, u8 *keysize)
+{
+	unsigned int i, j;
+	struct crypto_aead *tfm;
+	int ret = -ENOMEM;
+	const char *key;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	struct scatterlist *asg;
+	struct scatterlist *sgout;
+	const char *e;
+	void *assoc;
+	char iv[MAX_IVLEN];
+	char *xbuf[XBUFSIZE];
+	char *xoutbuf[XBUFSIZE];
+	char *axbuf[XBUFSIZE];
+	unsigned int *b_size;
+	unsigned int iv_len;
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	if (testmgr_alloc_buf(xbuf))
+		goto out_noxbuf;
+	if (testmgr_alloc_buf(axbuf))
+		goto out_noaxbuf;
+	if (testmgr_alloc_buf(xoutbuf))
+		goto out_nooutbuf;
+
+	sg = kmalloc(sizeof(*sg) * 8 * 3, GFP_KERNEL);
+	if (!sg)
+		goto out_nosg;
+	asg = &sg[8];
+	sgout = &asg[8];
+
+
+	printk(KERN_INFO "\ntesting speed of %s %s\n", algo, e);
+
+	tfm = crypto_alloc_aead(algo, 0, 0);
+
+	if (IS_ERR(tfm)) {
+		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
+		       PTR_ERR(tfm));
+		return;
+	}
+
+	req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("alg: aead: Failed to allocate request for %s\n",
+		       algo);
+		goto out;
+	}
+
+	i = 0;
+	do {
+		b_size = aead_sizes;
+		do {
+			assoc = axbuf[0];
+
+			if (aad_size < PAGE_SIZE)
+				memset(assoc, 0xff, aad_size);
+			else {
+				pr_err("associate data length (%u) too big\n",
+					aad_size);
+				goto out_nosg;
+			}
+			sg_init_one(&asg[0], assoc, aad_size);
+
+			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
+				pr_err("template (%u) too big for tvmem (%lu)\n",
+				       *keysize + *b_size,
+					TVMEMSIZE * PAGE_SIZE);
+				goto out;
+			}
+
+			key = tvmem[0];
+			for (j = 0; j < tcount; j++) {
+				if (template[j].klen == *keysize) {
+					key = template[j].key;
+					break;
+				}
+			}
+			ret = crypto_aead_setkey(tfm, key, *keysize);
+			ret = crypto_aead_setauthsize(tfm, authsize);
+
+			iv_len = crypto_aead_ivsize(tfm);
+			if (iv_len)
+				memset(&iv, 0xff, iv_len);
+
+			crypto_aead_clear_flags(tfm, ~0);
+			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
+					i, *keysize * 8, *b_size);
+
+
+			memset(tvmem[0], 0xff, PAGE_SIZE);
+
+			if (ret) {
+				pr_err("setkey() failed flags=%x\n",
+						crypto_aead_get_flags(tfm));
+				goto out;
+			}
+
+			sg_init_aead(&sg[0], xbuf,
+				    *b_size + (enc ? authsize : 0));
+
+			sg_init_aead(&sgout[0], xoutbuf,
+				    *b_size + (enc ? authsize : 0));
+
+			aead_request_set_crypt(req, sg, sgout, *b_size, iv);
+			aead_request_set_assoc(req, asg, aad_size);
+
+			if (sec)
+				ret = test_aead_jiffies(req, enc, *b_size, sec);
+			else
+				ret = test_aead_cycles(req, enc, *b_size);
+
+			if (ret) {
+				pr_err("%s() failed return code=%d\n", e, ret);
+				break;
+			}
+			b_size++;
+			i++;
+		} while (*b_size);
+		keysize++;
+	} while (*keysize);
+
+out:
+	crypto_free_aead(tfm);
+	kfree(sg);
+out_nosg:
+	testmgr_free_buf(xoutbuf);
+out_nooutbuf:
+	testmgr_free_buf(axbuf);
+out_noaxbuf:
+	testmgr_free_buf(xbuf);
+out_noxbuf:
+	return;
+}
 
 static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 			      struct cipher_speed_template *template,
@@ -1427,6 +1692,11 @@ static int do_test(int m)
 				  speed_template_32_64);
 		break;
 
+	case 211:
+		test_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec,
+				NULL, 0, 16, 8, aead_speed_template_20);
+		break;
+
 	case 300:
 		/* fall through */
 
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index ecdeeb1..6c7e21a 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -22,6 +22,11 @@ struct cipher_speed_template {
 	unsigned int klen;
 };
 
+struct aead_speed_template {
+	const char *key;
+	unsigned int klen;
+};
+
 struct hash_speed {
 	unsigned int blen;	/* buffer length */
 	unsigned int plen;	/* per-update length */
@@ -58,6 +63,11 @@ static u8 speed_template_32_48_64[] = {32, 48, 64, 0};
 static u8 speed_template_32_64[] = {32, 64, 0};
 
 /*
+ * AEAD speed tests
+ */
+static u8 aead_speed_template_20[] = {20, 0};
+
+/*
  * Digest speed tests
  */
 static struct hash_speed generic_hash_speed_template[] = {
-- 
1.7.11.7


