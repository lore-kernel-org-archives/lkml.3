Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaDWNmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:42:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56757 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaDWN35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:57 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-91-5357c05406f7
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 16/20] ima: load policy from the kernel
Date: Wed, 23 Apr 2014 16:30:34 +0300
Message-id: <558a8e9da9e9ca542a484cd14de82896028a6f6e.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xq7ohB8KDDR7/lba49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mo48U2j4LdkxZXnb5gaGL+KdjFycEgImEjMaqzpYuQEMsUk
	Ltxbz9bFyMUhJLCUUeLS9xusEE4nk8SFmWvZQKrYBPQkNjT/YAexRQRcJHbP6WMCKWIW6GGU
	2P1nMTNIQljAXGL6yjdgRSwCqhJfbq0Fi/MKxEnsbO1nglinILHsC0ScU8BK4k/zdLB6IQFL
	ie+TJuMUn8DIv4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSCh+2cG4+JjVIUYBDkYl
	Hl6J5WHBQqyJZcWVuYcYJTiYlUR4lywKDxbiTUmsrEotyo8vKs1JLT7EyMTBKdXAqPL7sC6P
	s+6mG//emLN61y+fNP+qcpFndFNSK1NU+JpyhyWH19Sceu0dd7pjpbqaofD6QNafstqK/zv3
	LF2ynNvg6uctMgcZy1Lm3E8JKjrWdMd1q76Oa2fww8DW8vcfrFYpquXJijav2P7CYZ1y8c3z
	P8TDzi7yLMuXPb1lwpHNoun517n2K7EUZyQaajEXFScCAGlv3uojAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provide IMA policy loading from the kernel.
When CONFIG_IMA_KERNEL_POLICY is enabled, kernel tries
to load default /etc/ima_policy. Policy signature must
be located in /etc/ima_policy.sig.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig    |  7 +++++++
 security/integrity/ima/ima.h      |  8 ++++++++
 security/integrity/ima/ima_fs.c   | 18 +++++++++++++++++-
 security/integrity/ima/ima_init.c |  1 +
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 465cef4..b00044f 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -153,3 +153,10 @@ config IMA_POLICY_LOADER
 
 	  Loading policy is like:
 	  echo /etc/ima/ima_policy > /sys/kernel/security/ima/policy
+
+config IMA_KERNEL_POLICY
+	bool "Load IMA policy from the kernel"
+	depends on IMA_POLICY_LOADER
+	default n
+	help
+	  This option enables IMA policy loading from the kernel.
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index f2722bb..3727cf7 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -179,6 +179,14 @@ static inline ssize_t ima_read_policy(char *data)
 }
 #endif
 
+#ifdef CONFIG_IMA_KERNEL_POLICY
+void ima_load_policy(char *path);
+#else
+static inline void ima_load_policy(char *path)
+{
+}
+#endif
+
 /* Appraise integrity measurements */
 #define IMA_APPRAISE_ENFORCE	0x01
 #define IMA_APPRAISE_FIX	0x02
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index bde7a0e..d050a5c 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -319,7 +319,7 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
  * point to the new policy rules, and remove the securityfs policy file,
  * assuming a valid policy.
  */
-static int ima_release_policy(struct inode *inode, struct file *file)
+static void ima_check_policy(void)
 {
 	if (!valid_policy) {
 		ima_delete_rules();
@@ -328,6 +328,11 @@ static int ima_release_policy(struct inode *inode, struct file *file)
 		ima_update_policy();
 	}
 	clear_bit(IMA_FS_BUSY, &ima_fs_flags);
+}
+
+static int ima_release_policy(struct inode *inode, struct file *file)
+{
+	ima_check_policy();
 	return 0;
 }
 
@@ -338,6 +343,17 @@ static const struct file_operations ima_measure_policy_ops = {
 	.llseek = generic_file_llseek,
 };
 
+#ifdef CONFIG_IMA_KERNEL_POLICY
+void __init ima_load_policy(char *path)
+{
+	if (test_and_set_bit(IMA_FS_BUSY, &ima_fs_flags))
+		return;
+	if (ima_read_policy(path) < 0)
+		valid_policy = 0;
+	ima_check_policy();
+}
+#endif
+
 int __init ima_fs_init(void)
 {
 	ima_dir = securityfs_create_dir("ima", NULL);
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index c13d6a8..d1a6483 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -109,6 +109,7 @@ int __init ima_init(void)
 	ima_init_policy();
 	integrity_init_keyring(INTEGRITY_KEYRING_IMA);
 	integrity_load_x509(INTEGRITY_KEYRING_IMA, "/etc/keys/x509_ima.der");
+	ima_load_policy("/etc/ima_policy");
 
 	return ima_fs_init();
 }
-- 
1.8.3.2

