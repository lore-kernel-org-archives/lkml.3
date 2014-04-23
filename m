Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaDWN3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:29:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55980 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaDWN3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:51 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-66-5357c04dd90f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 07/20] integrity: provide x509 certificate loading from the
 kernel
Date: Wed, 23 Apr 2014 16:30:25 +0300
Message-id: <b2706d6bb3a8e94277d7136bd15c1ef481fd124f.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7q+B8KDDW5/5LK49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mp4fWIiY8FR6YqVV64wNjAuEuti5OSQEDCR6N6+iB3CFpO4
	cG89WxcjF4eQwFJGiY9vJrJAOJ1MEvcv7GcDqWIT0JPY0PwDrENEwEVi95w+JpAiZoEeRond
	fxYzgySEBUIkvj3azApiswioSpx+0sACYvMKxEk8+XWcBWKdgsSyL2vB6jkFrCT+NE8HGyok
	YCnxfdJknOITGPkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJxy87GBcfszrEKMDB
	qMTDK7E8LFiINbGsuDL3EKMEB7OSCO+SReHBQrwpiZVVqUX58UWlOanFhxiZODilGhjNnNtO
	1RYeEtz+a77uh4Cpa1QeX6o0XLEm+KmexP/TF1p+rlh4z+DlO/9y3bVLNgtusd4efUavlXut
	36ql//zMe1bIaRT+XlF7dtfGyYeyrtVt15J8X3qB99uxDofbr7b32xa99po6j+dF0dI6x3v9
	JQpPbnqot0/XvhWrNO3+6TX/XcMqJtb6KLEUZyQaajEXFScCAI0Ihq4lAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide API to load x509 certificates from the kernel into the
integrity kernel keyrings.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Kconfig     |  4 +++
 security/integrity/digsig.c    | 72 ++++++++++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h | 10 ++++++
 3 files changed, 86 insertions(+)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 89f226a..8f34b28 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -51,6 +51,10 @@ config INTEGRITY_TRUSTED_KEYRING
 	def_bool n
 	depends on IMA_TRUSTED_KEYRING || EVM_TRUSTED_KEYRING
 
+config INTEGRITY_LOAD_X509
+	def_bool n
+	depends on IMA_LOAD_X509 || EVM_LOAD_X509
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
 
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 45adc07..cba38e3 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -18,6 +18,8 @@
 #include <linux/cred.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
+#include <linux/slab.h>
+#include <linux/file.h>
 
 #include "integrity.h"
 
@@ -59,6 +61,76 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 	return -EOPNOTSUPP;
 }
 
+#ifdef CONFIG_INTEGRITY_LOAD_X509
+int integrity_read_file(const char *path, char **data)
+{
+	struct file *file;
+	loff_t size;
+	char *buf;
+	int rc =  -EINVAL;
+
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	size = i_size_read(file_inode(file));
+	if (size <= 0)
+		goto out;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = kernel_read(file, 0, buf, size);
+	if (rc < 0)
+		kfree(buf);
+	else if (rc != size)
+		rc = -EIO;
+	else
+		*data = buf;
+out:
+	fput(file);
+	return rc;
+}
+
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
 #ifdef CONFIG_INTEGRITY_TRUSTED_KEYRING
 int integrity_init_keyring(const unsigned int id)
 {
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index dd26ad0..96960fb 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -146,6 +146,16 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
 }
 #endif
 
+#ifdef CONFIG_INTEGRITY_LOAD_X509
+int integrity_read_file(const char *path, char **data);
+int integrity_load_x509(const unsigned int id, char *path);
+#else
+static inline int integrity_load_x509(const unsigned int id, char *path)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_INTEGRITY_TRUSTED_KEYRING
 int integrity_init_keyring(const unsigned int id);
 #else
-- 
1.8.3.2

