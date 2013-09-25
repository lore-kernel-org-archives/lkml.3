Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab3IYGk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 02:40:57 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43791 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3IYGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 02:40:56 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Josh Boyer <jwboyer@redhat.com>,
        Alexander Holler <holler@ahsoftware.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Peter Jones <pjones@redhat.com>
Subject: [PATCH] X.509: Remove validity check of certificate date
Date: Wed, 25 Sep 2013 14:41:12 +0800
Message-Id: <1380091272-20040-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check of valid_from and valid_to fields on X.509 certificate is a
time bomb to MODSIGN function, It causes kernel module could not be
load because the RTC on system may messed by user action (e.g. refresh
BIOS) that should not be trusted.

Base on the discussion of David Howells's "[PATCH] X.509: Remove
certificate date checks":
  https://lkml.org/lkml/2013/3/14/257

This patch removed the validity check of certificate date but still keep
the valid_from and valid_to fields for future usage.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
cc: David Howells <dhowells@redhat.com>
cc: David Woodhouse <dwmw2@infradead.org>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Josh Boyer <jwboyer@redhat.com>
cc: Alexander Holler <holler@ahsoftware.de>
cc: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Peter Jones <pjones@redhat.com>
---
 crypto/asymmetric_keys/x509_public_key.c |   38 ------------------------------
 1 files changed, 0 insertions(+), 38 deletions(-)

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
1.6.4.2

