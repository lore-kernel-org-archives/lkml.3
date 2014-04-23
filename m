Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbaDWNmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:42:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8284 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbaDWN35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:57 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-8e-5357c053c24b
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 15/20] ima: path based policy loading interface
Date: Wed, 23 Apr 2014 16:30:33 +0300
Message-id: <0f525fc369d224f149dec6606467109c9cd7e735.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7rBB8KDDQ4+07C49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MpoOPqcseCzcsWy23/YGxh3yXYxcnJICJhIrJ2/iAnCFpO4
	cG89WxcjF4eQwFJGibXHlrNAOJ1MEjt/32IFqWIT0JPY0PyDHcQWEXCR2D2njwmkiFmgh1Fi
	95/FzCAJYQF7ie3b9oKNZRFQlfi2aR4LiM0rECexd+pFdoh1ChLLvqwFq+cUsJL40zwdLC4k
	YCnxfdJknOITGPkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJxy87GBcfszrEKMDB
	qMTDK7E8LFiINbGsuDL3EKMEB7OSCO+SReHBQrwpiZVVqUX58UWlOanFhxiZODilGhhN53OI
	vBdKsfi3yEj1jefLe7r/EoWmTLljdT+dO+nf9GiTJv9HJee1ypkmG+kF/ryVFVRiKjHfTLFz
	88Ibeh5tdbduSCadeK3xKWfhFcOb09wiU1r0jHvOrBNfl7ihMnuvzD/9jRalQvMlfyedV1Rd
	9KrHuekW99kvgdq8LpWqKaaWZmftTZRYijMSDbWYi4oTAYET2kYlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently policy is loaded by writing policy content to
'<securityfs>/ima/policy' file.

This patch extends policy loading meachanism with possibility
to load signed policy using a path to the policy.
Policy signature must be available in the <policy>.sig file.

Policy can be loaded like:
echo /etc/ima/ima_policy > /sys/kernel/security/ima/policy

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig      | 13 +++++++
 security/integrity/ima/ima.h        |  9 +++++
 security/integrity/ima/ima_fs.c     |  2 +-
 security/integrity/ima/ima_policy.c | 74 +++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 5474c47..465cef4 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -140,3 +140,16 @@ config IMA_LOAD_X509
 	help
 	   This option enables X509 certificate loading from the kernel
 	   to the '_ima' trusted keyring.
+
+config IMA_POLICY_LOADER
+	bool "Path based policy loading interface"
+	depends on IMA_TRUSTED_KEYRING
+	default n
+	help
+	  This option enables path based signed policy loading interface.
+	  Policy signature must be provided in the <policy>.sig file
+	  along with the policy. When this option is enabled, kernel
+	  tries to load default policy from /etc/ima_policy.
+
+	  Loading policy is like:
+	  echo /etc/ima/ima_policy > /sys/kernel/security/ima/policy
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 3b90b60..f2722bb 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -170,6 +170,15 @@ bool ima_default_policy(void);
 ssize_t ima_parse_add_rule(char *);
 void ima_delete_rules(void);
 
+#ifdef CONFIG_IMA_POLICY_LOADER
+ssize_t ima_read_policy(char *path);
+#else
+static inline ssize_t ima_read_policy(char *data)
+{
+	return ima_parse_add_rule(data);
+}
+#endif
+
 /* Appraise integrity measurements */
 #define IMA_APPRAISE_ENFORCE	0x01
 #define IMA_APPRAISE_FIX	0x02
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 34ae5f2..bde7a0e 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -273,7 +273,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
 	if (copy_from_user(data, buf, datalen))
 		goto out;
 
-	result = ima_parse_add_rule(data);
+	result = ima_read_policy(data);
 out:
 	if (result < 0)
 		valid_policy = 0;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index b24e7d1..c6da801 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -17,6 +17,9 @@
 #include <linux/parser.h>
 #include <linux/slab.h>
 #include <linux/genhd.h>
+#ifdef CONFIG_IMA_POLICY_LOADER
+#include <linux/file.h>
+#endif
 
 #include "ima.h"
 
@@ -747,3 +750,74 @@ void ima_delete_rules(void)
 	}
 	mutex_unlock(&ima_rules_mutex);
 }
+
+#ifdef CONFIG_IMA_POLICY_LOADER
+
+ssize_t ima_read_policy(char *path)
+{
+	char *data, *datap, *sig;
+	int rc, psize, pathlen = strlen(path);
+	char *p, *sigpath;
+	struct {
+		struct ima_digest_data hdr;
+		char digest[IMA_MAX_DIGEST_SIZE];
+	} hash;
+
+	if (path[0] != '/')
+		return ima_parse_add_rule(path);
+
+	/* remove \n */
+	datap = path;
+	strsep(&datap, "\n");
+
+	/* we always want signature? */
+	sigpath = __getname();
+	if (!sigpath)
+		return -ENOMEM;
+
+	rc = integrity_read_file(path, &data);
+	if (rc < 0)
+		goto free_path;
+
+	psize = rc;
+	datap = data;
+
+	sprintf(sigpath, "%s.sig", path);
+	/* we always want signature? */
+	rc = integrity_read_file(sigpath, &sig);
+	if (rc < 0)
+		goto free_data;
+
+	hash.hdr.algo = ima_hash_algo;
+	ima_get_hash_algo((void *)sig, rc, &hash.hdr);
+	ima_calc_buffer_hash(data, psize, &hash.hdr);
+	rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+				     (const char *)sig, rc,
+				     hash.hdr.digest, hash.hdr.length);
+	if (rc) {
+		pr_err("integrity_digsig_verify() = %d\n", rc);
+		goto free_sig;
+	}
+
+	while (psize > 0 && (p = strsep(&datap, "\n"))) {
+		pr_debug("rule: %s\n", p);
+		rc = ima_parse_add_rule(p);
+		if (rc < 0)
+			break;
+		psize -= rc;
+	}
+free_sig:
+	kfree(sig);
+free_data:
+	kfree(data);
+free_path:
+	__putname(sigpath);
+	if (rc < 0)
+		return rc;
+	else if (psize)
+		return -EINVAL;
+	else
+		return pathlen;
+}
+
+#endif
-- 
1.8.3.2

