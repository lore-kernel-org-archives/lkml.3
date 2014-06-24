Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaFXOlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:41:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55097 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaFXOlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:41:20 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v6 4/6] KEYS: validate certificate trust only with selected owner key
Date: Tue, 24 Jun 2014 10:40:50 -0400
Message-Id: <1403620852-16476-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062414-9332-0000-0000-0000012EE6A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

Instead of allowing public keys, with certificates signed by any
key on the system trusted keyring, to be added to a trusted keyring,
this patch further restricts the certificates to those signed by a
particular key on the system keyring.

This patch defines a new kernel parameter 'keys_ownerid' to identify
the owner's key which must be used for trust validation of certificates.

Simplified Mimi's "KEYS: define an owner trusted keyring" patch.

Changelog:
- support for builtin x509 public keys only
- export "asymmetric_keyid_match"
- remove ifndefs MODULE

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt      |  5 +++++
 crypto/asymmetric_keys/asymmetric_type.c |  1 +
 crypto/asymmetric_keys/x509_public_key.c | 20 ++++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6eaa9cd..b0cc47d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1492,6 +1492,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
+	keys_ownerid=[KEYS] This parameter identifies a specific key(s) on
+			the system trusted keyring to be used for certificate
+			trust validation.
+			format: id:<keyid>
+
 	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
 			The controller # is the number of the ehci usb debug
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 1fd1d30..c948df5 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -49,6 +49,7 @@ int asymmetric_keyid_match(const char *kid, const char *id)
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(asymmetric_keyid_match);
 
 /*
  * Match asymmetric keys on (part of) their name
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 436fbd8..44850f2 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -24,6 +24,22 @@
 #include "public_key.h"
 #include "x509_parser.h"
 
+static char *owner_keyid;
+
+#ifndef MODULE
+static int __init default_owner_keyid_set(char *str)
+{
+	if (!str)		/* default system keyring */
+		return 1;
+
+	if (strncmp(str, "id:", 3) == 0)
+		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
+
+	return 1;
+}
+__setup("keys_ownerid=", default_owner_keyid_set);
+#endif
+
 /*
  * Find a key in the given keyring by issuer and authority.
  */
@@ -171,6 +187,10 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 
+	if (owner_keyid &&
+	    !asymmetric_keyid_match(cert->authority, owner_keyid))
+		return -EPERM;
+
 	key = x509_request_asymmetric_key(trust_keyring,
 					  cert->issuer, strlen(cert->issuer),
 					  cert->authority,
-- 
1.8.1.4

