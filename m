Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaFQI6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:58:20 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32433 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbaFQI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:57:47 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-1b-53a00309c64a
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 2/3] KEYS: validate certificate trust only with selected
 owner key
Date: Tue, 17 Jun 2014 11:56:58 +0300
Message-id: <a8b80185ea01d31e5a8999cb4107b69d6c3bbef3.1402994752.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1402994752.git.d.kasatkin@samsung.com>
References: <cover.1402994752.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1402994752.git.d.kasatkin@samsung.com>
References: <cover.1402994752.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4ZV1O5gXBBi9P8lrc+ruX2eJd028W
	iwPvnrBYzN71kMXi8q45bBYfeh6xWXxaMYnZgd1j2ollLB4PDm1m8Xi/7yqbR9+WVYwenzfJ
	BbBGcdmkpOZklqUW6dslcGXsWHeOqWC+cMX3CedYGxif8HcxcnJICJhILJxyiQXCFpO4cG89
	WxcjF4eQwFJGiS+tO5ggnE4miYZnp9lBqtgE9CQ2NP9gB0mICLQxSrRtfcYGkmAW8JI4+fcb
	WJGwQLjEhsvLGLsYOThYBFQl1p41BQnzCsRJzPlwnB1im5zEyWOTWUFKOAWsJE4vkgIJCwlY
	SpxcOoEZh/AERv4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJC8OsOxqXHrA4xCnAw
	KvHwKvybEyzEmlhWXJl7iFGCg1lJhFfo1fxgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyKF85c
	f/dFWEnSUaNw1yvbyQ//F7pbPG7bdebBGmuTQ2Y7Ju68z6Z9m71sY1Ovb0lAnU3jvDop57nV
	6vEvI7tr/01cEJ56Q8xXdP2VeW/f7WM2ZW3e78p1+sDlYMkrK+dG/7z0VlNIPDTHfMnjmrju
	Oy6XmM5PNf71c1nnrG8XzZzF/21fKrJOiaU4I9FQi7moOBEAHtvJmR8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allowing public keys, with certificates signed by any
key on the system trusted keyring, to be added to a trusted keyring,
this patch further restricts the certificates to those signed by a
particular key on the system keyring.

This patch defines a new kernel parameter 'keys_ownerid' to identify
the owner's key which must be used for trust validation of certificates.

Based on Mimi's "KEYS: define an owner trusted keyring" patch.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt      |  5 +++++
 crypto/asymmetric_keys/x509_public_key.c | 17 +++++++++++++++++
 2 files changed, 22 insertions(+)

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
index 7a9b386..8482d23 100644
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
@@ -169,6 +182,10 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 
+	if (owner_keyid &&
+		   !asymmetric_keyid_match(cert->authority, owner_keyid))
+			return -EPERM;
+
 	key = x509_request_asymmetric_key(trust_keyring,
 					  cert->issuer, strlen(cert->issuer),
 					  cert->authority,
-- 
1.9.1

