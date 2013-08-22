Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3HVLEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:04:11 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48046 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3HVLEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:04:05 -0400
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
Subject: [PATCH 05/18] asymmetric keys: implement RSASP1
Date: Thu, 22 Aug 2013 19:01:44 +0800
Message-Id: <1377169317-5959-6-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement RSASP1 and fill-in the following data to public key signature
structure: signature length (pkcs->k), signature octet
strings (pks->S) and MPI of signature (pks->rsa.s).

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/rsa.c |   47 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 0862018..e60defe 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -86,6 +86,39 @@ static const struct {
 };
 
 /*
+ * RSASP1() function [RFC3447 sec 5.2.1]
+ */
+static int RSASP1(const struct private_key *key, MPI m, MPI *_s)
+{
+	MPI s;
+	int ret;
+
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0) {
+		kleave(" = -EBADMSG [m < 0]");
+		return -EBADMSG;
+	}
+	if (mpi_cmp(m, key->rsa.n) >= 0) {
+		kleave(" = -EBADMSG [m >= n]");
+		return -EBADMSG;
+	}
+
+	s = mpi_alloc(0);
+	if (!s)
+		return -ENOMEM;
+
+	/* (2) s = m^d mod n */
+	ret = mpi_powm(s, m, key->rsa.d, key->rsa.n);
+	if (ret < 0) {
+		mpi_free(s);
+		return ret;
+	}
+
+	*_s = s;
+	return 0;
+}
+
+/*
  * RSAVP1() function [RFC3447 sec 5.2.2]
  */
 static int RSAVP1(const struct public_key *key, MPI s, MPI *_m)
@@ -173,9 +206,12 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 static int RSA_OS2IP(u8 *X, size_t XLen, MPI *_x)
 {
 	MPI x;
+	int ret;
 
 	x = mpi_alloc((XLen + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB);
-	mpi_set_buffer(x, X, XLen, 0);
+	ret = mpi_set_buffer(x, X, XLen, 0);
+	if (ret < 0)
+		return ret;
 
 	*_x = x;
 	return 0;
@@ -453,8 +489,13 @@ static struct public_key_signature *RSA_generate_signature(
 	if (ret < 0)
 		goto error_v1_5_encode;
 
-	/* TODO 3): s = RSASP1 (K, m) */
-	s = m;
+	/* 3): s = RSASP1 (K, m) */
+	RSASP1(key, m, &s);
+
+	pks->rsa.s = s;
+	pks->nr_mpi = 1;
+	pks->k = mpi_get_nbits(s);
+	pks->k = (pks->k + 7) / 8;
 
 	/* 4): S = I2OSP (s, k) */
 	_RSA_I2OSP(s, &X_size, &pks->S);
-- 
1.6.4.2

