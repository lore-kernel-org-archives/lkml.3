Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaKEPEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:04:33 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62684 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaKEPCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:02:46 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-02-545a3c1489b7
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v4 2/6] integrity: provide a function to load x509 certificate
 from the kernel
Date: Wed, 05 Nov 2014 17:01:13 +0200
Message-id: <33a4fc659a45203dbf8fa9624058a36577d6b631.1415197743.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xK7oiNlEhBs+3s1jMWb+GzeLW373M
	Fl+W1lm8nDGP3eLyrjlsFh96HrFZnP97nNXi04pJzA4cHjtn3WX3ODHjN4vHg0ObWTx2L/jM
	5NG3ZRWjx+dNch6bnrxlCmCP4rJJSc3JLEst0rdL4MpofXqPvWCOcMWdu/9ZGhgP8HcxcnJI
	CJhIrHn0mQXCFpO4cG89WxcjF4eQwFJGiWn/j7NDOJ1MEpv6PrCBVLEJ6ElsaP4BlhARWMQo
	senrRbB2ZoF0iU+TetlBbGGBBIk7k/rB4iwCqhJP/88Fi/MKxEms6GphhFgnJ3Hy2GRWEJtT
	wEpiwpOLYAuEBCwlFj5qYsQlPoGRfwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkCD9
	uoNx6TGrQ4wCHIxKPLweTZEhQqyJZcWVuYcYJTiYlUR4r1lGhQjxpiRWVqUW5ccXleakFh9i
	ZOLglGpgjJFbWizzUHnHh++u/B/Upqo+nhaSbON1eMbVo9OXvU+LXjKP477Jxla9LhHBrfsP
	ysrITXxq/M372YnFi6/MELnEmBPAoLnu0DvpI6zRdomn1CVLih7PY4vp0sn8JTLt57WDZeae
	IdVZ53e8Y3FeaWlWMTVtUen7NqPY1Xc/yZSeklhWcjTptxJLcUaioRZzUXEiAGUbtBAwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the function to load x509 certificates from the kernel into the
integrity kernel keyring.

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

