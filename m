Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaFLURn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:17:43 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46268 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaFLURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:17:41 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1a 1/2] KEYS: validate certificate trust only with selected owner key
Date: Thu, 12 Jun 2014 23:17:10 +0300
Message-Id: <f49ec580bebe72033a5f4aa160162f393b4ed625.1402604096.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1402604096.git.d.kasatkin@samsung.com>
References: <cover.1402604096.git.d.kasatkin@samsung.com>
In-Reply-To: <cover.1402604096.git.d.kasatkin@samsung.com>
References: <cover.1402604096.git.d.kasatkin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allowing public keys, with certificates signed by any
key on the system trusted keyring, to be added to a trusted keyring,
this patch further restricts the certificates to those signed by a
particular key on the system keyring.

This patch defines a new kernel parameter 'keys_ownerid' to specify
owner's key id which must be used for trust validation of certificates.

Idea belongs to Mimi Zohar.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt      |  5 +++++
 crypto/asymmetric_keys/x509_public_key.c | 23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..7a810d3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1434,6 +1434,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 7a9b386..d46b790 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -24,6 +24,19 @@
 #include "public_key.h"
 #include "x509_parser.h"
 
+static char *owner_keyid;
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
+
 /*
  * Find a key in the given keyring by issuer and authority.
  */
@@ -169,6 +182,16 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 
+	if (owner_keyid) {
+		/* validate trust only with the owner_keyid if specified */
+		/* partial match of keyid according to the asymmetric_type.c */
+		int idlen = strlen(owner_keyid) - 3; /* - id: */
+		int authlen = strlen(cert->authority);
+		char *auth = cert->authority + authlen - idlen;
+		if (idlen > authlen || strcasecmp(owner_keyid + 3, auth))
+			return -EPERM;
+	}
+
 	key = x509_request_asymmetric_key(trust_keyring,
 					  cert->issuer, strlen(cert->issuer),
 					  cert->authority,
-- 
1.9.1

