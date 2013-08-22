Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab3HVLEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:04:34 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44584 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3HVLEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:04:31 -0400
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
Subject: [PATCH 07/18] asymmetric keys: explicitly add the leading zero byte to encoded message
Date: Thu, 22 Aug 2013 19:01:46 +0800
Message-Id: <1377169317-5959-8-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
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

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/rsa.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index e60defe..1fadc7f 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -401,6 +401,7 @@ static int RSA_verify_signature(const struct public_key *key,
 	/* Variables as per RFC3447 sec 8.2.2 */
 	const u8 *H = sig->digest;
 	u8 *EM = NULL;
+	u8 *_EM = NULL;
 	MPI m = NULL;
 	size_t k;
 
@@ -435,14 +436,19 @@ static int RSA_verify_signature(const struct public_key *key,
 	/* (2c) Convert the message representative (m) to an encoded message
 	 *      (EM) of length k octets.
 	 *
-	 *      NOTE!  The leading zero byte is suppressed by MPI, so we pass a
-	 *      pointer to the _preceding_ byte to RSA_verify()!
+	 *      NOTE!  The leading zero byte is suppressed by MPI, so we add it
+	 *      back to EM before input to RSA_verify()!
 	 */
-	ret = RSA_I2OSP(m, k, &EM);
+	ret = RSA_I2OSP(m, k, &_EM);
 	if (ret < 0)
 		goto error;
 
-	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
+	EM = kmalloc(k, GFP_KERNEL);
+	memset(EM, 0, 1);
+	memcpy(EM + 1, _EM, k-1);
+	kfree(_EM);
+
+	ret = RSA_verify(H, EM, k, sig->digest_size,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
 
-- 
1.6.4.2

