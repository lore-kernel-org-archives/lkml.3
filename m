Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaG2JeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:34:00 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:29326
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752168AbaG2Jd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:33:57 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 2/2] crypto: add TLS 1.0 test vectors for AES-CBC-HMAC-SHA1
Date: Tue, 29 Jul 2014 12:32:33 +0300
Message-ID: <1406626353-23309-3-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(77156001)(62966002)(47776003)(48376002)(85306003)(36756003)(104016003)(77982001)(20776003)(107046002)(229853001)(95666004)(76482001)(64706001)(106466001)(80022001)(97736001)(74502001)(6806004)(79102001)(50466002)(92566001)(89996001)(105606002)(85852003)(21056001)(83072002)(102836001)(33646002)(31966008)(74662001)(76176999)(46102001)(26826002)(81342001)(92726001)(81542001)(87286001)(86362001)(87936001)(50986999)(104166001)(93916002)(83322001)(50226001)(4396001)(88136002)(99396002)(44976005)(19580395003)(84676001)(575784001)(19580405001)(68736004);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0618;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/tcrypt.c  |   5 ++
 crypto/testmgr.c |  41 ++++++++---
 crypto/testmgr.h | 217 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 253 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index c48d078..be92fe1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1528,6 +1528,11 @@ static int do_test(int m)
 	case 157:
 		ret += tcrypt_test("authenc(hmac(sha1),ecb(cipher_null))");
 		break;
+
+	case 160:
+		ret += tcrypt_test("tls10(hmac(sha1),cbc(aes))");
+		break;
+
 	case 181:
 		ret += tcrypt_test("authenc(hmac(sha1),cbc(des))");
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f3883d..ef2aac7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -430,7 +430,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		       const bool diff_dst, const int align_offset)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
-	unsigned int i, j, k, n, temp;
+	unsigned int i, j, k, n, temp, ilen, rlen;
 	int ret = -ENOMEM;
 	char *q;
 	char *key;
@@ -537,22 +537,28 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		} else if (ret)
 			continue;
 
-		authsize = abs(template[i].rlen - template[i].ilen);
-		ret = crypto_aead_setauthsize(tfm, authsize);
-		if (ret) {
-			pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
-			       d, authsize, j, algo);
-			goto out;
+		if (strncmp(algo, "tls", 3) == 0) {
+			rlen = max(template[i].ilen, template[i].rlen);
+			ilen = rlen;
+		} else {
+			authsize = abs(template[i].rlen - template[i].ilen);
+			ret = crypto_aead_setauthsize(tfm, authsize);
+			if (ret) {
+				pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
+				       d, authsize, j, algo);
+				goto out;
+			}
+			rlen = template[i].rlen;
+			ilen = template[i].ilen + (enc ? authsize : 0);
 		}
 
 		if (diff_dst) {
 			output = xoutbuf[0];
 			output += align_offset;
 			sg_init_one(&sg[0], input, template[i].ilen);
-			sg_init_one(&sgout[0], output, template[i].rlen);
+			sg_init_one(&sgout[0], output, rlen);
 		} else {
-			sg_init_one(&sg[0], input,
-				    template[i].ilen + (enc ? authsize : 0));
+			sg_init_one(&sg[0], input, ilen);
 			output = input;
 		}
 
@@ -3459,6 +3465,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "tls10(hmac(sha1),cbc(aes))",
+		.test = alg_test_aead,
+		.suite = {
+			.aead = {
+				.enc = {
+					.vecs = tls10_hmac_sha1_cbc_aes_enc_tv_template,
+					.count = TLS10_HMAC_SHA1_CBC_AES_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = tls10_hmac_sha1_cbc_aes_dec_tv_template,
+					.count = TLS10_HMAC_SHA1_CBC_AES_DEC_TEST_VECTORS,
+				}
+			}
+		}
+	}, {
 		.alg = "vmac(aes)",
 		.test = alg_test_hash,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 46df9e8..63b4b75 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -110,6 +110,223 @@ struct drbg_testvec {
 static char zeroed_string[48];
 
 /*
+ * TLS1.0 synthetic test vectors
+ */
+#define TLS10_HMAC_SHA1_CBC_AES_ENC_TEST_VECTORS 3
+#define TLS10_HMAC_SHA1_CBC_AES_DEC_TEST_VECTORS 3
+
+static struct aead_testvec tls10_hmac_sha1_cbc_aes_enc_tv_template[] = {
+	{
+#ifdef __LITTLE_ENDIAN
+		.key	= "\x08\x00"		/* rta length */
+			"\x01\x00"		/* rta type */
+#else
+		.key	= "\x00\x08"		/* rta length */
+			"\x00\x01"		/* rta type */
+#endif
+			"\x00\x00\x00\x10"	/* enc key length */
+			"authenticationkey20b"
+			"enckeyis16_bytes",
+		.klen	= 8 + 20 + 16,
+		.iv	= "iv0123456789abcd",
+		.input	= "Single block msg",
+		.ilen	= 16,
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x00\x03\x01\x00\x10",
+		.alen	= 13,
+		.result	= "\xd5\xac\xb\xd2\xac\xad\x3f\xb1"
+			"\x59\x79\x1e\x91\x5f\x52\x14\x9c"
+			"\xc0\x75\xd8\x4c\x97\x0f\x07\x73"
+			"\xdc\x89\x47\x49\x49\xcb\x30\x6b"
+			"\x1b\x45\x23\xa1\xd0\x51\xcf\x02"
+			"\x2e\xa8\x5d\xa0\xfe\xca\x82\x61",
+		.rlen	= 16 + 20 + 12,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key	= "\x08\x00"		/* rta length */
+			"\x01\x00"		/* rta type */
+#else
+		.key	= "\x00\x08"		/* rta length */
+			"\x00\x01"		/* rta type */
+#endif
+			"\x00\x00\x00\x10"	/* enc key length */
+			"authenticationkey20b"
+			"enckeyis16_bytes",
+		.klen	= 8 + 20 + 16,
+		.iv	= "iv0123456789abcd",
+		.input	= "",
+		.ilen	= 0,
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x00\x03\x01\x00\x00",
+		.alen	= 13,
+		.result = "\x58\x2a\x11\xc\x86\x8e\x4b\x67"
+			"\x2d\x16\x26\x1a\xac\x4b\xe2\x1a"
+			"\xe9\x6a\xcc\x4d\x6f\x79\x8a\x45"
+			"\x1f\x4e\x27\xf2\xa7\x59\xb4\x5a",
+		.rlen	= 20 + 12,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key	= "\x08\x00"		/* rta length */
+			"\x01\x00"		/* rta type */
+#else
+		.key	= "\x00\x08"		/* rta length */
+			"\x00\x01"		/* rta type */
+#endif
+			"\x00\x00\x00\x10"	/* enc key length */
+			"authenticationkey20b"
+			"enckeyis16_bytes",
+		.klen	= 8 + 20 + 16,
+		.iv	= "iv0123456789abcd",
+		.input	= "285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext",
+		.ilen	= 285,
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x00\x03\x01\x01\x1d",
+		.alen	= 13,
+		.result = "\x80\x23\x82\x44\x14\x2a\x1d\x94\xc\xc2\x1d\xd"
+			"\x3a\x32\x89\x4c\x57\x30\xa8\x89\x76\x46\xcc\x90"
+			"\x1d\x88\xb8\xa6\x1a\x58\xe\x2d\xeb\x2c\xc7\x3a"
+			"\x52\x4e\xdb\xb3\x1e\x83\x11\xf5\x3c\xce\x6e\x94"
+			"\xd3\x26\x6a\x9a\xd\xbd\xc7\x98\xb9\xb3\x3a\x51"
+			"\x1e\x4\x84\x8a\x8f\x54\x9a\x51\x69\x9c\xce\x31"
+			"\x8d\x5d\x8b\xee\x5f\x70\xc\xc9\xb8\x50\x54\xf8"
+			"\xb2\x4a\x7a\xcd\xeb\x7a\x82\x81\xc6\x41\xc8\x50"
+			"\x91\x8d\xc8\xed\xcd\x40\x8f\x55\xd1\xec\xc9\xac"
+			"\x15\x18\xf9\x20\xa0\xed\x18\xa1\xe3\x56\xe3\x14"
+			"\xe5\xe8\x66\x63\x20\xed\xe4\x62\x9d\xa3\xa4\x1d"
+			"\x81\x89\x18\xf2\x36\xae\xc8\x8a\x2b\xbc\xc3\xb8"
+			"\x80\xf\x97\x21\x36\x39\x8\x84\x23\x18\x9e\x9c"
+			"\x72\x32\x75\x2d\x2e\xf9\x60\xb\xe8\xcc\xd9\x74"
+			"\x4\x1b\x8e\x99\xc1\x94\xee\xd0\xac\x4e\xfc\x7e"
+			"\xf1\x96\xb3\xe7\x14\xb8\xf2\xc\x25\x97\x82\x6b"
+			"\xbd\x0\x65\xab\x5c\xe3\x16\xfb\x68\xef\xea\x9d"
+			"\xff\x44\x1d\x2a\x44\xf5\xc8\x56\x77\xb7\xbf\x13"
+			"\xc8\x54\xdb\x92\xfe\x16\x4c\xbe\x18\xe9\xb\x8d"
+			"\xb\xd4\x43\x58\x43\xaa\xf4\x3\x80\x97\x62\xd5"
+			"\xdf\x3c\x28\xaa\xee\x48\x4b\x55\x41\x1b\x31\x2"
+			"\xbe\xa0\x1c\xbd\xb7\x22\x2a\xe5\x53\x72\x73\x20"
+			"\x44\x4f\xe6\x1\x2b\x34\x33\x11\x7d\xfb\x10\xc1"
+			"\x66\x7c\xa6\xf4\x48\x36\x5e\x2\xda\x41\x4b\x3e"
+			"\xe7\x80\x17\x17\xce\xf1\x3e\x6a\x8e\x26\xf3\xb7"
+			"\x2b\x85\xd\x31\x8d\xba\x6c\x22\xb4\x28\x55\x7e"
+			"\x2a\x9e\x26\xf1\x3d\x21\xac\x65",
+		.rlen	= 285 + 20 + 15,
+	}
+};
+
+static struct aead_testvec tls10_hmac_sha1_cbc_aes_dec_tv_template[] = {
+	{
+#ifdef __LITTLE_ENDIAN
+		.key	= "\x08\x00"		/* rta length */
+			"\x01\x00"		/* rta type */
+#else
+		.key	= "\x00\x08"		/* rta length */
+			"\x00\x01"		/* rta type */
+#endif
+			"\x00\x00\x00\x10"	/* enc key length */
+			"authenticationkey20b"
+			"enckeyis16_bytes",
+		.klen	= 8 + 20 + 16,
+		.iv	= "iv0123456789abcd",
+		.input	= "\xd5\xac\xb\xd2\xac\xad\x3f\xb1"
+			"\x59\x79\x1e\x91\x5f\x52\x14\x9c"
+			"\xc0\x75\xd8\x4c\x97\x0f\x07\x73"
+			"\xdc\x89\x47\x49\x49\xcb\x30\x6b"
+			"\x1b\x45\x23\xa1\xd0\x51\xcf\x02"
+			"\x2e\xa8\x5d\xa0\xfe\xca\x82\x61",
+		.ilen	= 16 + 20 + 12,
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x00\x03\x01\x00\x30",
+		.alen	= 13,
+		.result	= "Single block msg",
+		.rlen	= 16,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key	= "\x08\x00"		/* rta length */
+			"\x01\x00"		/* rta type */
+#else
+		.key	= "\x00\x08"		/* rta length */
+			"\x00\x01"		/* rta type */
+#endif
+			"\x00\x00\x00\x10"	/* enc key length */
+			"authenticationkey20b"
+			"enckeyis16_bytes",
+		.klen	= 8 + 20 + 16,
+		.iv	= "iv0123456789abcd",
+		.input = "\x58\x2a\x11\xc\x86\x8e\x4b\x67"
+			"\x2d\x16\x26\x1a\xac\x4b\xe2\x1a"
+			"\xe9\x6a\xcc\x4d\x6f\x79\x8a\x45"
+			"\x1f\x4e\x27\xf2\xa7\x59\xb4\x5a",
+		.ilen	= 20 + 12,
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x00\x03\x01\x00\x20",
+		.alen	= 13,
+		.result	= "",
+		.rlen	= 0,
+	}, {
+#ifdef __LITTLE_ENDIAN
+		.key	= "\x08\x00"		/* rta length */
+			"\x01\x00"		/* rta type */
+#else
+		.key	= "\x00\x08"		/* rta length */
+			"\x00\x01"		/* rta type */
+#endif
+			"\x00\x00\x00\x10"	/* enc key length */
+			"authenticationkey20b"
+			"enckeyis16_bytes",
+		.klen	= 8 + 20 + 16,
+		.iv	= "iv0123456789abcd",
+		.input = "\x80\x23\x82\x44\x14\x2a\x1d\x94\xc\xc2\x1d\xd"
+			"\x3a\x32\x89\x4c\x57\x30\xa8\x89\x76\x46\xcc\x90"
+			"\x1d\x88\xb8\xa6\x1a\x58\xe\x2d\xeb\x2c\xc7\x3a"
+			"\x52\x4e\xdb\xb3\x1e\x83\x11\xf5\x3c\xce\x6e\x94"
+			"\xd3\x26\x6a\x9a\xd\xbd\xc7\x98\xb9\xb3\x3a\x51"
+			"\x1e\x4\x84\x8a\x8f\x54\x9a\x51\x69\x9c\xce\x31"
+			"\x8d\x5d\x8b\xee\x5f\x70\xc\xc9\xb8\x50\x54\xf8"
+			"\xb2\x4a\x7a\xcd\xeb\x7a\x82\x81\xc6\x41\xc8\x50"
+			"\x91\x8d\xc8\xed\xcd\x40\x8f\x55\xd1\xec\xc9\xac"
+			"\x15\x18\xf9\x20\xa0\xed\x18\xa1\xe3\x56\xe3\x14"
+			"\xe5\xe8\x66\x63\x20\xed\xe4\x62\x9d\xa3\xa4\x1d"
+			"\x81\x89\x18\xf2\x36\xae\xc8\x8a\x2b\xbc\xc3\xb8"
+			"\x80\xf\x97\x21\x36\x39\x8\x84\x23\x18\x9e\x9c"
+			"\x72\x32\x75\x2d\x2e\xf9\x60\xb\xe8\xcc\xd9\x74"
+			"\x4\x1b\x8e\x99\xc1\x94\xee\xd0\xac\x4e\xfc\x7e"
+			"\xf1\x96\xb3\xe7\x14\xb8\xf2\xc\x25\x97\x82\x6b"
+			"\xbd\x0\x65\xab\x5c\xe3\x16\xfb\x68\xef\xea\x9d"
+			"\xff\x44\x1d\x2a\x44\xf5\xc8\x56\x77\xb7\xbf\x13"
+			"\xc8\x54\xdb\x92\xfe\x16\x4c\xbe\x18\xe9\xb\x8d"
+			"\xb\xd4\x43\x58\x43\xaa\xf4\x3\x80\x97\x62\xd5"
+			"\xdf\x3c\x28\xaa\xee\x48\x4b\x55\x41\x1b\x31\x2"
+			"\xbe\xa0\x1c\xbd\xb7\x22\x2a\xe5\x53\x72\x73\x20"
+			"\x44\x4f\xe6\x1\x2b\x34\x33\x11\x7d\xfb\x10\xc1"
+			"\x66\x7c\xa6\xf4\x48\x36\x5e\x2\xda\x41\x4b\x3e"
+			"\xe7\x80\x17\x17\xce\xf1\x3e\x6a\x8e\x26\xf3\xb7"
+			"\x2b\x85\xd\x31\x8d\xba\x6c\x22\xb4\x28\x55\x7e"
+			"\x2a\x9e\x26\xf1\x3d\x21\xac\x65",
+
+		.ilen	= 285 + 20 + 15,
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x00\x03\x01\x01\x40",
+		.alen	= 13,
+		.result	= "285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext285 bytes plaintext"
+			"285 bytes plaintext",
+		.rlen	= 285,
+	}
+};
+
+/*
  * MD4 test vectors from RFC1320
  */
 #define MD4_TEST_VECTORS	7
-- 
1.8.3.1

