Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaJJOMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:12:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26329 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaJJOJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:09:59 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-3f-5437e8b2ebde
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 2/6] integrity: provide x509 certificate loading from the
 kernel
Date: Fri, 10 Oct 2014 17:09:29 +0300
Message-id: <18b795d742e81d3b820584e22803c907dac301e1.1412950047.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xy7qbX5iHGPzpZLSYs34Nm8Wtv3uZ
	Lb4srbN4OWMeu8XlXXPYLD70PGKzOP/3OKvFpxWTmB04PHbOusvucWLGbxaPB4c2s3jsXvCZ
	yaNvyypGj8+b5Dw2PXnLFMAexWWTkpqTWZZapG+XwJXx4NtXpoKZwhXX1sxlaWDcx9/FyMkh
	IWAi8WH3JmYIW0ziwr31bF2MXBxCAksZJaadOgrldDJJtE1sYQepYhPQk9jQ/IMdJCEisIhR
	4vGyi6wgCWaBdIlPk3rBioQFQiX6uy6wgNgsAqoSr+/MBavhFYiTOH30KxvEOjmJk8cmg8U5
	Bawkvr36xQRiCwlYSnx/38KCS3wCI/8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFB
	+nUH49JjVocYBTgYlXh4L8iYhwixJpYVV+YeYpTgYFYS4f32HCjEm5JYWZValB9fVJqTWnyI
	kYmDU6qB8S7Dz+UTvLUNvHq37BJKc5rxo8/8xJ3jEQG1v0LiD3wpcLv79tPPC5tvdE5/J2DB
	d0wl7OnGvJ3P1KKenSw4GcJwXKJKY99s24tKmjzWcUFVoukGj6Pj1b69ObD/pPVWhge+9mfD
	WlSulfT1FNw+K1YncjaebZ58hLVR2RHumJtcL+ZfWMpZpcRSnJFoqMVcVJwIABy7UrUwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide function to load x509 certificates from the kernel into the
integrity kernel keyrings.

Changes in v2:
* configuration option removed
* function declared as '__init'

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/digsig.c    | 37 ++++++++++++++++++++++++++++++++++++-
 security/integrity/integrity.h |  2 ++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 4f643d1..fa383fd 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -14,7 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/sched.h>
-#include <linux/rbtree.h>
+#include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
@@ -84,3 +84,38 @@ int __init integrity_init_keyring(const unsigned int id)
 	}
 	return err;
 }
+
+int __init integrity_load_x509(const unsigned int id, char *path)
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
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 20d2204..1057abb 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -134,6 +134,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
 int __init integrity_init_keyring(const unsigned int id);
+int __init integrity_load_x509(const unsigned int id, char *path);
 #else
 
 static inline int integrity_digsig_verify(const unsigned int id,
@@ -147,6 +148,7 @@ static inline int integrity_init_keyring(const unsigned int id)
 {
 	return 0;
 }
+
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
-- 
1.9.1

