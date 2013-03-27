Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3C0Sm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:42:29 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43627 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3C0Sm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:42:27 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Holler <holler@ahsoftware.de>, stable@vger.kernel.org
Subject: [PATCH] crypto: Ignore validity dates of X.509 certificates at loading/parsing time
Date: Wed, 27 Mar 2013 19:41:50 +0100
Message-Id: <1364409710-6458-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any real use case where checking the validity dates of X.509
certificates at parsing time adds any security gain. In contrast, doing so
makes MODSIGN unusable on systems without a RTC (or systems with a possible
wrong date in a existing RTC, or systems where the RTC is read after the keys
got loaded).

If something really cares about the dates, it should check them at the time
when the certificates are used, not when they are loaded and parsed.

So just remove the validity check of the dates in the parser.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: stable@vger.kernel.org

Sidenote (not for necessarily for inclusion into the patch):
There were already 3 variations of this patch.
The first removed the check by adding a config option:
  https://lkml.org/lkml/2013/2/25/171
The second just removed the return of errors:
  https://lkml.org/lkml/2013/3/14/247
And the third wich removed parsing of the dates too:
  https://lkml.org/lkml/2013/3/14/257
Maybe this one will find the approval of a maintainer.
Here is a thread which explains the motivation for this patch a bit further:
  https://lkml.org/lkml/2013/2/13/90
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
1.8.1.4

