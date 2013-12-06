Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162748Ab3LFXwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:52:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48386 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161297Ab3LFXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Howells <dhowells@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Josh Boyer <jwboyer@redhat.com>,
        Alexander Holler <holler@ahsoftware.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 007/152] X.509: Remove certificate date checks
Date: Fri,  6 Dec 2013 15:08:51 -0800
Message-Id: <1386371476-2477-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 124df926090b32a998483f6e43ebeccdbe5b5302 upstream.

Remove the certificate date checks that are performed when a certificate is
parsed.  There are two checks: a valid from and a valid to.  The first check is
causing a lot of problems with system clocks that don't keep good time and the
second places an implicit expiry date upon the kernel when used for module
signing, so do we really need them?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: David Woodhouse <dwmw2@infradead.org>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Josh Boyer <jwboyer@redhat.com>
cc: Alexander Holler <holler@ahsoftware.de>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 38 --------------------------------
 1 file changed, 38 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 06007f0..52222a2 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -106,7 +106,6 @@ error_no_sig:
 static int x509_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct x509_certificate *cert;
-	struct tm now;
 	size_t srlen, sulen;
 	char *desc = NULL;
 	int ret;
@@ -137,43 +136,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		goto error_free_cert;
 	}
 
-	time_to_tm(CURRENT_TIME.tv_sec, 0, &now);
-	pr_devel("Now: %04ld-%02d-%02d %02d:%02d:%02d\n",
-		 now.tm_year + 1900, now.tm_mon + 1, now.tm_mday,
-		 now.tm_hour, now.tm_min,  now.tm_sec);
-	if (now.tm_year < cert->valid_from.tm_year ||
-	    (now.tm_year == cert->valid_from.tm_year &&
-	     (now.tm_mon < cert->valid_from.tm_mon ||
-	      (now.tm_mon == cert->valid_from.tm_mon &&
-	       (now.tm_mday < cert->valid_from.tm_mday ||
-		(now.tm_mday == cert->valid_from.tm_mday &&
-		 (now.tm_hour < cert->valid_from.tm_hour ||
-		  (now.tm_hour == cert->valid_from.tm_hour &&
-		   (now.tm_min < cert->valid_from.tm_min ||
-		    (now.tm_min == cert->valid_from.tm_min &&
-		     (now.tm_sec < cert->valid_from.tm_sec
-		      ))))))))))) {
-		pr_warn("Cert %s is not yet valid\n", cert->fingerprint);
-		ret = -EKEYREJECTED;
-		goto error_free_cert;
-	}
-	if (now.tm_year > cert->valid_to.tm_year ||
-	    (now.tm_year == cert->valid_to.tm_year &&
-	     (now.tm_mon > cert->valid_to.tm_mon ||
-	      (now.tm_mon == cert->valid_to.tm_mon &&
-	       (now.tm_mday > cert->valid_to.tm_mday ||
-		(now.tm_mday == cert->valid_to.tm_mday &&
-		 (now.tm_hour > cert->valid_to.tm_hour ||
-		  (now.tm_hour == cert->valid_to.tm_hour &&
-		   (now.tm_min > cert->valid_to.tm_min ||
-		    (now.tm_min == cert->valid_to.tm_min &&
-		     (now.tm_sec > cert->valid_to.tm_sec
-		      ))))))))))) {
-		pr_warn("Cert %s has expired\n", cert->fingerprint);
-		ret = -EKEYEXPIRED;
-		goto error_free_cert;
-	}
-
 	cert->pub->algo = x509_public_key_algorithms[cert->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
-- 
1.8.3.2

