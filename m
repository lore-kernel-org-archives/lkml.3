Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3HVLD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:03:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60155 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3HVLDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:03:53 -0400
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
Subject: [PATCH 04/18] asymmetric keys: implement OS2IP in rsa
Date: Thu, 22 Aug 2013 19:01:43 +0800
Message-Id: <1377169317-5959-5-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement Octet String to Integer conversion [RFC3447 sec 4.2] in rsa.c. It's
the second step of signature generation operation.

This patch is temporary set non-RSASP1 message to pks->S for debugging.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/rsa.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index c26ae77..0862018 100644
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
  * @M: message to be signed, and octet string
  * @emLen: intended length in octets of the encoded message
@@ -412,6 +426,9 @@ static struct public_key_signature *RSA_generate_signature(
 {
 	struct public_key_signature *pks;
 	u8 *EM = NULL;
+	MPI m = NULL;
+	MPI s = NULL;
+	unsigned X_size;
 	size_t emLen;
 	int ret;
 
@@ -431,14 +448,16 @@ static struct public_key_signature *RSA_generate_signature(
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
-	pks->S = EM;		/* TODO: temporary set S to EM */
+	/* 4): S = I2OSP (s, k) */
+	_RSA_I2OSP(s, &X_size, &pks->S);
 
 	return pks;
 
-- 
1.6.4.2

