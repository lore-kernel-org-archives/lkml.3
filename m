Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3IOA5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 20:57:17 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:57947 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3IOA5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 20:57:14 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH V4 04/15] asymmetric keys: implement OS2IP in rsa
Date: Sun, 15 Sep 2013 08:56:50 +0800
Message-Id: <1379206621-18639-5-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement Octet String to Integer conversion [RFC3447 sec 4.2] in rsa.c. It's
the second step of signature generation operation.

This patch is temporary set non-RSASP1 message to pks->S for debugging.

The naming of RSA_OS2IP and the variables used in this function accord PKCS#1
spec but not follow kernel naming convention, it useful when look at them with
spec.

Reference: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1v2/pkcs1ietffinal.txt
Reference: http://www.emc.com/collateral/white-papers/h11300-pkcs-1v2-2-rsa-cryptography-standard-wp.pdf

Cc: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/rsa.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index aac8b77..a092aac 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -168,6 +168,20 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 }
 
 /*
+ * Octet String to Integer conversion [RFC3447 sec 4.2]
+ */
+static int RSA_OS2IP(u8 *X, size_t XLen, MPI *_x)
+{
+	MPI x;
+
+	x = mpi_alloc((XLen + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB);
+	mpi_set_buffer(x, X, XLen, 0);
+
+	*_x = x;
+	return 0;
+}
+
+/*
  * EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2]
  * @M: message to be signed, an octet string
  * @emLen: intended length in octets of the encoded message
@@ -419,6 +433,9 @@ static struct public_key_signature *RSA_generate_signature(
 {
 	struct public_key_signature *pks;
 	u8 *EM = NULL;
+	MPI m = NULL;
+	MPI s = NULL;
+	unsigned X_size;
 	size_t emLen;
 	int ret;
 
@@ -438,14 +455,16 @@ static struct public_key_signature *RSA_generate_signature(
 	if (ret < 0)
 		goto error_v1_5_encode;
 
-	/* TODO 2): m = OS2IP (EM) */
+	/* 2): m = OS2IP (EM) */
+	ret = RSA_OS2IP(EM, emLen, &m);
+	if (ret < 0)
+		goto error_v1_5_encode;
 
 	/* TODO 3): s = RSASP1 (K, m) */
+	s = m;
 
-	/* TODO 4): S = I2OSP (s, k) */
-
-	/* TODO: signature S to a u8* S or set to sig->rsa.s? */
-	pks->S = EM;            /* TODO: temporary set S to EM */
+	/* 4): S = I2OSP (s, k) */
+	_RSA_I2OSP(s, &X_size, &pks->S);
 
 	return pks;
 
-- 
1.6.0.2

