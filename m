Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3HVLDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:03:46 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56793 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3HVLDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:03:42 -0400
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
Subject: [PATCH 03/18] asymmetric keys: separate the length checking of octet string from RSA_I2OSP
Date: Thu, 22 Aug 2013 19:01:42 +0800
Message-Id: <1377169317-5959-4-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to RSA_I2OSP is not only used by signature verification path but also used
in signature generation path. So, separate the length checking of octet string
because it's not for generate 0x00 0x01 leading string when used in signature
generation.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/rsa.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 6996ff7..c26ae77 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -121,12 +121,30 @@ static int RSAVP1(const struct public_key *key, MPI s, MPI *_m)
 /*
  * Integer to Octet String conversion [RFC3447 sec 4.1]
  */
-static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+static int _RSA_I2OSP(MPI x, unsigned *X_size, u8 **_X)
 {
-	unsigned X_size, x_size;
 	int X_sign;
 	u8 *X;
 
+	X = mpi_get_buffer(x, X_size, &X_sign);
+	if (!X)
+		return -ENOMEM;
+	if (X_sign < 0) {
+		kfree(X);
+		return -EBADMSG;
+	}
+
+	*_X = X;
+	return 0;
+}
+
+static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+{
+	unsigned x_size;
+	unsigned X_size;
+	u8 *X = NULL;
+	int ret;
+
 	/* Make sure the string is the right length.  The number should begin
 	 * with { 0x00, 0x01, ... } so we have to account for 15 leading zero
 	 * bits not being reported by MPI.
@@ -136,13 +154,10 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 	if (x_size != xLen * 8 - 15)
 		return -ERANGE;
 
-	X = mpi_get_buffer(x, &X_size, &X_sign);
-	if (!X)
-		return -ENOMEM;
-	if (X_sign < 0) {
-		kfree(X);
-		return -EBADMSG;
-	}
+	ret = _RSA_I2OSP(x, &X_size, &X);
+	if (ret < 0)
+		return ret;
+
 	if (X_size != xLen - 1) {
 		kfree(X);
 		return -EBADMSG;
-- 
1.6.4.2

