Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3BFWO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:14:56 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42364 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab3BFWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:15 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        zohar@linux.vnet.ibm.com, jmorris@namei.org
Subject: [PATCH v1 1/1] ima: digital signature verification using asymmetric keys
Date: Thu,  7 Feb 2013 00:12:08 +0200
Message-Id: <23aa8ff1a02fe1a0e841aa83658f15ec401d9fc5.1360188726.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asymmetric keys were introduced in linux-3.7 to verify the signature on
signed kernel modules. The asymmetric keys infrastructure abstracts the
signature verification from the crypto details. This patch adds IMA/EVM
signature verification using asymmetric keys. Support for additional
signature verification methods can now be delegated to the asymmetric
key infrastructure.

Although the module signature header and the IMA/EVM signature header could
use the same header format, to minimize the signature length and save space
in the extended attribute, the IMA/EVM header format is different than the
module signature header.  The main difference is that the key identifier is
a sha1[12 - 19] hash of the key modulus and exponent and similar to the current
implementation. The only purpose is to identify corresponding key in the kernel
keyring. ima-evm-utils was updated to support the new signature format.

While asymmetric signature verification functionality supports many
different hash algorithims, a hash, which is used in this patch, is
calculated during IMA collection phase and depends on configured algorithm.
IMA currently uses sha1 by default or might use md5 instead. It is defined
using the 'ima_hash' kernel parameter. Due to this current limitation,
signature should be generated using sha1 hash algorithm.

Changes in this patch:
- Functionality has been moved to separate source file in order to get rid of
  in source #ifdefs.
- keyid is derived according to the RFC 3280. It does not require to assign
  IMA/EVM specific "description" when loading X509 certificate. Kernel
  asymmetric key subsystem automatically generate the description. Also
  loading a certificate does not require using of ima-evm-utils and can be
  done using keyctl only.
- keyid size is reduced to 32 bits to save xattr space.  Key search is done
  using partial match functionality of asymmetric_key_match().
- Kconfig option title was changed

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 security/integrity/Kconfig             |   12 ++++
 security/integrity/Makefile            |    1 +
 security/integrity/digsig.c            |   11 ++-
 security/integrity/digsig_asymmetric.c |  115 ++++++++++++++++++++++++++++++++
 security/integrity/integrity.h         |   12 ++++
 5 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 security/integrity/digsig_asymmetric.c

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 5bd1cc1..4bb3a77 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -17,5 +17,17 @@ config INTEGRITY_SIGNATURE
 	  This is useful for evm and module keyrings, when keys are
 	  usually only added from initramfs.
 
+config INTEGRITY_ASYMMETRIC_KEYS
+	boolean "Enable asymmetric keys support"
+	depends on INTEGRITY_SIGNATURE
+	default n
+        select ASYMMETRIC_KEY_TYPE
+        select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+        select PUBLIC_KEY_ALGO_RSA
+        select X509_CERTIFICATE_PARSER
+	help
+	  This option enables digital signature verification using
+	  asymmetric keys.
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index d43799c..ebb6409 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_INTEGRITY) += integrity.o
 obj-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
+obj-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
 
 integrity-y := iint.o
 
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 2dc167d..0b759e1 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -44,5 +44,14 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 		}
 	}
 
-	return digsig_verify(keyring[id], sig, siglen, digest, digestlen);
+	switch (sig[0]) {
+	case 1:
+		return digsig_verify(keyring[id], sig, siglen,
+				     digest, digestlen);
+	case 2:
+		return asymmetric_verify(keyring[id], sig, siglen,
+					 digest, digestlen);
+	}
+
+	return -EOPNOTSUPP;
 }
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
new file mode 100644
index 0000000..b475466
--- /dev/null
+++ b/security/integrity/digsig_asymmetric.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2013 Intel Corporation
+ *
+ * Author:
+ * Dmitry Kasatkin <dmitry.kasatkin@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/err.h>
+#include <linux/key-type.h>
+#include <crypto/public_key.h>
+#include <keys/asymmetric-type.h>
+
+#include "integrity.h"
+
+/*
+ * signature format v2 - for using with asymmetric keys
+ */
+struct signature_v2_hdr {
+	uint8_t version;	/* signature format version */
+	uint8_t	hash_algo;	/* Digest algorithm [enum pkey_hash_algo] */
+	uint32_t keyid;		/* IMA key identifier - not X509/PGP specific*/
+	uint16_t sig_size;	/* signature size */
+	uint8_t sig[0];		/* signature payload */
+} __packed;
+
+/*
+ * Request an asymmetric key.
+ */
+static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
+{
+	struct key *key;
+	char name[12];
+
+	sprintf(name, "id:%x", keyid);
+
+	pr_debug("key search: \"%s\"\n", name);
+
+	if (keyring) {
+		/* search in specific keyring */
+		key_ref_t kref;
+		kref = keyring_search(make_key_ref(keyring, 1),
+				      &key_type_asymmetric, name);
+		if (IS_ERR(kref))
+			key = ERR_CAST(kref);
+		else
+			key = key_ref_to_ptr(kref);
+	} else {
+		key = request_key(&key_type_asymmetric, name, NULL);
+	}
+
+	if (IS_ERR(key)) {
+		pr_warn("Request for unknown key '%s' err %ld\n",
+			name, PTR_ERR(key));
+		switch (PTR_ERR(key)) {
+			/* Hide some search errors */
+		case -EACCES:
+		case -ENOTDIR:
+		case -EAGAIN:
+			return ERR_PTR(-ENOKEY);
+		default:
+			return key;
+		}
+	}
+
+	pr_debug("%s() = 0 [%x]\n", __func__, key_serial(key));
+
+	return key;
+}
+
+int asymmetric_verify(struct key *keyring, const char *sig,
+		      int siglen, const char *data, int datalen)
+{
+	struct public_key_signature pks;
+	struct signature_v2_hdr *hdr = (struct signature_v2_hdr *)sig;
+	struct key *key;
+	int ret = -ENOMEM;
+
+	if (siglen <= sizeof(*hdr))
+		return -EBADMSG;
+
+	siglen -= sizeof(*hdr);
+
+	if (siglen != __be16_to_cpu(hdr->sig_size))
+		return -EBADMSG;
+
+	if (hdr->hash_algo >= PKEY_HASH__LAST)
+		return -ENOPKG;
+
+	key = request_asymmetric_key(keyring, __be32_to_cpu(hdr->keyid));
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	memset(&pks, 0, sizeof(pks));
+
+	pks.pkey_hash_algo = hdr->hash_algo;
+	pks.digest = (u8 *)data;
+	pks.digest_size = datalen;
+	pks.nr_mpi = 1;
+	pks.rsa.s = mpi_read_raw_data(hdr->sig, siglen);
+
+	if (pks.rsa.s)
+		ret = verify_signature(key, &pks);
+
+	mpi_free(pks.rsa.s);
+	key_put(key);
+	pr_debug("%s() = %d\n", __func__, ret);
+	return ret;
+}
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d80458a..f3f8a87 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/integrity.h>
 #include <crypto/sha.h>
+#include <linux/key.h>
 
 /* iint action cache flags */
 #define IMA_MEASURE		0x00000001
@@ -104,5 +105,16 @@ static inline int integrity_digsig_verify(const unsigned int id,
 
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
+#ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
+int asymmetric_verify(struct key *keyring, const char *sig,
+		      int siglen, const char *data, int datalen);
+#else
+static inline int asymmetric_verify(struct key *keyring, const char *sig,
+				    int siglen, const char *data, int datalen)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 /* set during initialization */
 extern int iint_initialized;
-- 
1.7.10.4

