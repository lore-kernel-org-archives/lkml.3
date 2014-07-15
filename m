Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbaGOM4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:56:44 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14500 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036AbaGOM4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:36 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-ab-53c524ecf4f0
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 3/4] integrity: provide x509 certificate loading from the
 kernel
Date: Tue, 15 Jul 2014 15:54:22 +0300
Message-id: <c383891a8ee03df2164de41e1c582ecf4bca87d4.1405428802.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xK7pvVI4GG7w7yGcxZ/0aNotbf/cy
	W7xr+s1i8WVpncXLGfPYLS7vmsNm8aHnEZvFpxWTmB04PHbOusvucWLGbxaPB4c2s3jsXvCZ
	yeP9vqtsHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJXRuYe9YJpIRV/vbuYGxu0CXYycHBIC
	JhKT/71mgrDFJC7cW8/WxcjFISSwlFHiyN+PTBBOJ5PE5qb9LCBVbAJ6Ehuaf7CDJEQE2hkl
	Dlw/zQ6SYBaokXjYswisSFggVGLWya2sIDaLgKpE/59JYDW8AnES3x7PY4NYJydx8thksBpO
	ASuJy0sPAdVwAG2zlLh2IQCH8ARG/gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsLz
	6w7GpcesDjEKcDAq8fDemHYkWIg1say4MvcQowQHs5IIb6HS0WAh3pTEyqrUovz4otKc1OJD
	jEwcnFINjNVMt2oD5fcJ9S2d/3vqwo6v/nv7FnJvmPdfdu/a0FyuC/HpFd4mfmVznh3L+6mV
	qb7m3qcVOpJLg6I7q/+4mJc99Xx3dttXY4lHO7Zb3Py1WpG3zfHaRVbHORoXvFUi785ew//7
	dJLLn553N1qfSt3vVxU5Ms3izKvf6pr/fFhvTl0oKttnf06JpTgj0VCLuag4EQAFZhscLQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide API to load x509 certificates from the kernel into the
integrity kernel keyrings.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Kconfig     |  4 ++++
 security/integrity/digsig.c    | 37 +++++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h |  9 +++++++++
 3 files changed, 50 insertions(+)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 1f000c4..63766fb 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -53,6 +53,10 @@ config INTEGRITY_AUDIT
 config INTEGRITY_FILE_READ
 	def_bool n
 
+config INTEGRITY_LOAD_X509
+	select INTEGRITY_FILE_READ
+	def_bool n
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
 
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 85d6662..63f66cc 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -104,6 +104,43 @@ out:
 }
 #endif
 
+#ifdef CONFIG_INTEGRITY_LOAD_X509
+int integrity_load_x509(const unsigned int id, char *path)
+{
+	key_ref_t key;
+	char *data;
+	int rc;
+
+	if (!keyring[id])
+		return -EINVAL;
+
+	rc = integrity_read_file(path, &data);
+	if (rc < 0)
+		return rc;
+
+	key = key_create_or_update(make_key_ref(keyring[id], 1),
+				   "asymmetric",
+				   NULL,
+				   data,
+				   rc,
+				   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				   KEY_USR_VIEW | KEY_USR_READ),
+				   KEY_ALLOC_NOT_IN_QUOTA |
+				   KEY_ALLOC_TRUSTED);
+	if (IS_ERR(key)) {
+		rc = PTR_ERR(key);
+		pr_err("Problem loading X.509 certificate (%d): %s\n",
+		       rc, path);
+	} else {
+		pr_notice("Loaded X.509 cert '%s': %s\n",
+			  key_ref_to_ptr(key)->description, path);
+		key_ref_put(key);
+	}
+	kfree(data);
+	return 0;
+}
+#endif
+
 int integrity_init_keyring(const unsigned int id)
 {
 	const struct cred *cred = current_cred();
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index f77de68..a4de3e3 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -158,6 +158,15 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
 }
 #endif
 
+#ifdef CONFIG_INTEGRITY_LOAD_X509
+int integrity_load_x509(const unsigned int id, char *path);
+#else
+static inline int integrity_load_x509(const unsigned int id, char *path)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_INTEGRITY_AUDIT
 /* declarations */
 void integrity_audit_msg(int audit_msgno, struct inode *inode,
-- 
1.9.1

