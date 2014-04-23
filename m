Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaDWNfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:35:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56763 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaDWNaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:30:01 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-b2-5357c0578bd3
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 20/20] evm: read EVM key from the kernel
Date: Wed, 23 Apr 2014 16:30:38 +0300
Message-id: <d7c005ef499c8824eda2bb2480cc870a3f328b84.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7rhB8KDDXZMMra49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MrY0NnCWLBcvWLZ1QtMDYxH5bsYOTkkBEwkmm7uZoWwxSQu
	3FvP1sXIxSEksJRRYur7BrCEkEAnk8Tab2IgNpuAnsSG5h/sILaIgIvE7jl9TCANzAI9jBK7
	/yxmBkkIC1hI9FxZAmazCKhKXPjyBWwQr0CcxJETi9khtilILPuyFqyGU8BK4k/zdHaIZZYS
	3ydNxik+gZF/ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQYPy6g3HpMatDjAIcjEo8
	vBLLw4KFWBPLiitzDzFKcDArifAuWRQeLMSbklhZlVqUH19UmpNafIiRiYNTqoHxytp/aze0
	JbMZv2X+9NNjuY24m5VchYpZm76t9p1bYb6pVevY/Pcdn23e2se1Q3F9m5Wm0kPVv4er1jvV
	MP9wOFJ1Jjtj/gzuC3sr3O+waL22OdcTIbS5a6fj5btrlY35FteltgoYzGO6tEO2qfHHyn0l
	lw0aWz8pnuHn+HjhltyDxG8dkieUWIozEg21mIuKEwFSulisJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently EVM key needs to be added from the user space
and it has to be done before mounting filesystems.
It requires initramfs.
Many systems often does not want to use initramfs.

This patch provide support for loading EVM key from the kernel.

It supports both 'trusted' and 'user' master keys.
However, it is recommended to use 'trusted' master key,
because 'user' master key is in non-encrypted form.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/Kconfig      |  8 ++++
 security/integrity/evm/evm.h        |  9 ++++
 security/integrity/evm/evm_crypto.c | 96 +++++++++++++++++++++++++++++++++++++
 security/integrity/evm/evm_main.c   |  1 +
 4 files changed, 114 insertions(+)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index 70d12f7..953ef05 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -60,3 +60,11 @@ config EVM_LOAD_X509
 	help
 	   This option enables X509 certificate loading from the kernel
 	   to the '_evm' trusted keyring.
+
+config EVM_LOAD_KEY
+	bool "Load EVM HMAC key from the kernel"
+	depends on EVM
+	default n
+	help
+	   This option enables EVM HMAC key loading from the kernel.
+	   It enables EVM.
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 1db78b8..1890eac 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -40,6 +40,15 @@ extern struct crypto_shash *hash_tfm;
 /* List of EVM protected security xattrs */
 extern char *evm_config_xattrnames[];
 
+#ifdef CONFIG_EVM_LOAD_KEY
+int evm_load_key(const char *key, const char *kmk);
+#else
+static inline int evm_load_key(const char *key, const char *kmk)
+{
+	return 0;
+}
+#endif
+
 int evm_init_key(void);
 int evm_update_evmxattr(struct dentry *dentry,
 			const char *req_xattr_name,
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index f79ebf5..c45b71b 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -18,6 +18,8 @@
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/xattr.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
 #include <keys/encrypted-type.h>
 #include <crypto/hash.h>
 #include "evm.h"
@@ -265,3 +267,97 @@ out:
 		pr_err("initialization failed\n");
 	return rc;
 }
+
+#ifdef CONFIG_EVM_LOAD_KEY
+int evm_load_key(const char *key, const char *kmk)
+{
+	key_ref_t key_ref, keyring_ref;
+	char *data, *tdata = NULL, *cmd, *type, ch = '\0';
+	int rc, len;
+	bool trusted = false;
+
+	keyring_ref = make_key_ref(current_cred()->user->uid_keyring, 1);
+
+	len = integrity_read_file(key, &data);
+	if (len < 0)
+		return len;
+
+	swap(data[len - 1], ch);
+	if (strstr(data, "trusted"))
+		trusted = true;
+	swap(data[len - 1], ch);
+
+	rc = integrity_read_file(kmk, &tdata);
+	if (rc < 0)
+		goto out;
+
+	/* padd does not like \n - remove it*/
+	if (strchr(tdata, '\n'))
+		rc--;
+
+	if (trusted) {
+		/* we need 'load' keyword */
+		cmd = kmalloc(rc + 5, GFP_KERNEL);
+		if (!cmd)
+			goto out;
+
+		memcpy(cmd, "load ", 5);
+		memcpy(cmd + 5, tdata, rc);
+		rc += 5;
+	} else {
+		cmd = tdata;
+	}
+
+	key_ref = key_create_or_update(keyring_ref,
+					trusted ? "trusted" : "user", "kmk",
+					cmd, rc,
+					((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					KEY_USR_VIEW | KEY_USR_READ),
+					KEY_ALLOC_NOT_IN_QUOTA);
+	if (trusted)
+		kfree(cmd);
+	type = trusted ? "trusted" : "user";
+	if (IS_ERR(key_ref)) {
+		rc = PTR_ERR(key_ref);
+		pr_err("problem loading EVM kmk (%s) (%d): %s\n",
+		       type, rc, kmk);
+		goto out;
+	} else {
+		pr_notice("loaded EVM kmk (%s) %d': %s\n",
+			  type, key_ref_to_ptr(key_ref)->serial, kmk);
+		key_ref_put(key_ref);
+	}
+
+	/* padd does not like \n - remove it*/
+	if (strchr(data, '\n'))
+		len--;
+
+	/* we need 'load' keyword */
+	cmd = kmalloc(len + 5, GFP_KERNEL);
+	if (!cmd)
+		goto out;
+
+	memcpy(cmd, "load ", 5);
+	memcpy(cmd + 5, data, len);
+
+	key_ref = key_create_or_update(keyring_ref,
+					"encrypted", EVMKEY, cmd, len + 5,
+					((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					KEY_USR_VIEW | KEY_USR_READ),
+					KEY_ALLOC_NOT_IN_QUOTA);
+	kfree(cmd);
+	if (IS_ERR(key_ref)) {
+		rc = PTR_ERR(key_ref);
+		pr_err("problem loading EVM key (%d): %s\n", rc, key);
+	} else {
+		pr_notice("loaded EVM key %d': %s\n",
+			  key_ref_to_ptr(key_ref)->serial, key);
+		key_ref_put(key_ref);
+	}
+
+out:
+	kfree(tdata);
+	kfree(data);
+	return rc;
+}
+#endif
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index d2c06d3..4808596 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -463,6 +463,7 @@ static int __init init_evm(void)
 		goto err;
 	}
 
+	evm_load_key("/etc/keys/evm-key", "/etc/keys/kmk");
 	evm_init_key();
 
 	return 0;
-- 
1.8.3.2

