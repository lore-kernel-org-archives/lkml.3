Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3A1Q6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:58:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56031 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3A1Q6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:58:37 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Dave Howells <dhowells@redhat.com>
Subject: [PATCH 12/15] Add an EFI signature blob parser and key loader.
Date: Mon, 28 Jan 2013 11:42:36 -0500
Message-Id: <1359391359-25783-13-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Howells <dhowells@redhat.com>

X.509 certificates are loaded into the specified keyring as asymmetric type
keys.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 crypto/asymmetric_keys/Kconfig      |   8 +++
 crypto/asymmetric_keys/Makefile     |   1 +
 crypto/asymmetric_keys/efi_parser.c | 108 ++++++++++++++++++++++++++++++++++++
 include/linux/efi.h                 |   4 ++
 4 files changed, 121 insertions(+)
 create mode 100644 crypto/asymmetric_keys/efi_parser.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 6d2c2ea..ace9c30 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -35,4 +35,12 @@ config X509_CERTIFICATE_PARSER
 	  data and provides the ability to instantiate a crypto key from a
 	  public key packet found inside the certificate.
 
+config EFI_SIGNATURE_LIST_PARSER
+	bool "EFI signature list parser"
+	depends on EFI
+	select X509_CERTIFICATE_PARSER
+	help
+	  This option provides support for parsing EFI signature lists for
+	  X.509 certificates and turning them into keys.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 0727204..cd8388e 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -8,6 +8,7 @@ asymmetric_keys-y := asymmetric_type.o signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
 obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
+obj-$(CONFIG_EFI_SIGNATURE_LIST_PARSER) += efi_parser.o
 
 #
 # X.509 Certificate handling
diff --git a/crypto/asymmetric_keys/efi_parser.c b/crypto/asymmetric_keys/efi_parser.c
new file mode 100644
index 0000000..636feb1
--- /dev/null
+++ b/crypto/asymmetric_keys/efi_parser.c
@@ -0,0 +1,108 @@
+/* EFI signature/key/certificate list parser
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "EFI: "fmt
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/err.h>
+#include <linux/efi.h>
+#include <keys/asymmetric-type.h>
+
+static __initdata efi_guid_t efi_cert_x509_guid = EFI_CERT_X509_GUID;
+
+/**
+ * parse_efi_signature_list - Parse an EFI signature list for certificates
+ * @data: The data blob to parse
+ * @size: The size of the data blob
+ * @keyring: The keyring to add extracted keys to
+ */
+int __init parse_efi_signature_list(const void *data, size_t size, struct key *keyring)
+{
+	unsigned offs = 0;
+	size_t lsize, esize, hsize, elsize;
+
+	pr_devel("-->%s(,%zu)\n", __func__, size);
+
+	while (size > 0) {
+		efi_signature_list_t list;
+		const efi_signature_data_t *elem;
+		key_ref_t key;
+
+		if (size < sizeof(list))
+			return -EBADMSG;
+
+		memcpy(&list, data, sizeof(list));
+		pr_devel("LIST[%04x] guid=%pUl ls=%x hs=%x ss=%x\n",
+			 offs,
+			 list.signature_type.b, list.signature_list_size,
+			 list.signature_header_size, list.signature_size);
+
+		lsize = list.signature_list_size;
+		hsize = list.signature_header_size;
+		esize = list.signature_size;
+		elsize = lsize - sizeof(list) - hsize;
+
+		if (lsize > size) {
+			pr_devel("<--%s() = -EBADMSG [overrun @%x]\n",
+				 __func__, offs);
+			return -EBADMSG;
+		}
+		if (lsize < sizeof(list) ||
+		    lsize - sizeof(list) < hsize ||
+		    esize < sizeof(*elem) ||
+		    elsize < esize ||
+		    elsize % esize != 0) {
+			pr_devel("- bad size combo @%x\n", offs);
+			return -EBADMSG;
+		}
+
+		if (efi_guidcmp(list.signature_type, efi_cert_x509_guid) != 0) {
+			data += lsize;
+			size -= lsize;
+			offs += lsize;
+			continue;
+		}
+
+		data += sizeof(list) + hsize;
+		size -= sizeof(list) + hsize;
+		offs += sizeof(list) + hsize;
+
+		for (; elsize > 0; elsize -= esize) {
+			elem = data;
+
+			pr_devel("ELEM[%04x]\n", offs);
+
+			key = key_create_or_update(
+				make_key_ref(keyring, 1),
+				"asymmetric",
+				NULL,
+				&elem->signature_data,
+				esize - sizeof(*elem),
+				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				KEY_USR_VIEW,
+				KEY_ALLOC_NOT_IN_QUOTA);
+
+			if (IS_ERR(key))
+				pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
+				       PTR_ERR(key));
+			else
+				pr_notice("Loaded cert '%s' linked to '%s'\n",
+					  key_ref_to_ptr(key)->description,
+					  keyring->description);
+
+			data += esize;
+			size -= esize;
+			offs += esize;
+		}
+	}
+
+	return 0;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index de7021d..64b3e55 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -612,6 +612,10 @@ extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
+struct key;
+extern int __init parse_efi_signature_list(const void *data, size_t size,
+					   struct key *keyring);
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
-- 
1.8.0.2

