Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab3IOA5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 20:57:47 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:52640 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3IOA5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 20:57:43 -0400
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
Subject: [PATCH V4 07/15] asymmetric keys: explicitly add the leading zero byte to encoded message
Date: Sun, 15 Sep 2013 08:56:53 +0800
Message-Id: <1379206621-18639-8-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per PKCS1 spec, the EMSA-PKCS1-v1_5 encoded message is leading by 0x00 0x01 in
its first 2 bytes. The leading zero byte is suppressed by MPI so we pass a
pointer to the _preceding_ byte to RSA_verify() in original code, but it has
risk for the byte is not zero because it's not in EM buffer's scope, neither
RSA_verify() nor mpi_get_buffer() didn't take care the leading byte.

To avoid the risk, that's better we explicitly add the leading zero byte to EM
for pass to RSA_verify(). This patch allocate a _EM buffer to capture the
result from RSA_I2OSP(), then set the first byte to zero in EM and copy the
remaining bytes from _EM.

V2:
- Check the memory allocate result of EM to avoid use it when allocate fail.

Cc: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/rsa.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 0ede317..9763df7 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -408,6 +408,7 @@ static int RSA_verify_signature(const struct public_key *key,
 	/* Variables as per RFC3447 sec 8.2.2 */
 	const u8 *H = sig->digest;
 	u8 *EM = NULL;
+	u8 *EM_tmp = NULL;
 	MPI m = NULL;
 	size_t k;
 
@@ -442,19 +443,28 @@ static int RSA_verify_signature(const struct public_key *key,
 	/* (2c) Convert the message representative (m) to an encoded message
 	 *      (EM) of length k octets.
 	 *
-	 *      NOTE!  The leading zero byte is suppressed by MPI, so we pass a
-	 *      pointer to the _preceding_ byte to RSA_verify()!
+	 *      NOTE!  The leading zero byte is suppressed by MPI, so we add it
+	 *      back to EM before input to RSA_verify()!
 	 */
-	ret = RSA_I2OSP(m, k, &EM);
+	ret = RSA_I2OSP(m, k, &EM_tmp);
 	if (ret < 0)
 		goto error;
 
-	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
+	EM = kmalloc(k, GFP_KERNEL);
+	if (!EM) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	memset(EM, 0, 1);
+	memcpy(EM + 1, EM_tmp, k-1);
+
+	ret = RSA_verify(H, EM, k, sig->digest_size,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
 
-error:
 	kfree(EM);
+error:
+	kfree(EM_tmp);
 	mpi_free(m);
 	kleave(" = %d", ret);
 	return ret;
-- 
1.6.0.2

