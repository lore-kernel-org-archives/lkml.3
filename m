Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaB1PCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:02:35 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23109 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaB1PBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:39 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-1d-5310a4d1c2bd
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 7/8] evm: introduce EVM hmac attribute list
Date: Fri, 28 Feb 2014 16:59:31 +0200
Message-id: <fa83f8d28e068d4cd1625d231302f6cad376ddc2.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xa7oXlwgEG9zfamJxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSvj14G/TAXHFCpOrVvG3MD4VqqLkZNDQsBE4vC8fYwQtpjE
	hXvr2UBsIYGljBJTzyt1MXIB2Z1MEue2z2MGSbAJ6ElsaP7BDmKLCDhLLLrVzgpSxCwwlVHi
	1a1pLCAJYQFriaddy8GKWARUJS6d7ALbwCsQJ3Hm9ws2iG0KEsu+rAUbyilgJbHl8j1WiM2W
	ElefzWXDJT6BkX8BI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJBg/LqDcekxq0OMAhyM
	Sjy8EosEgoVYE8uKK3MPMUpwMCuJ8F5aDBTiTUmsrEotyo8vKs1JLT7EyMTBKdXAuCGAZYJw
	TuH8rRp7k6d3z9VVzzhbeXyHhcTMO/fc9iw4t/lLg/Bizf7wmK4fm/5oBM07ztzeYub2u+L/
	Y5aQjIVf5zdMDvDrlH962E2H11X0F7sgW0TnhZIXf7RX73t1V+uxr5bIG++Z/M3xd01TknXm
	hIQcPzTL0mB/qP9BDdHt+m/e3W9hV2Ipzkg01GIuKk4EAHVs5oQkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces using of hmac version configuration parameter
with attribute list. It allows to build kernels which works with
previously labeled filesystems.

Currently supported attribute is 'fsuuid' which is equivalent of
former version 2.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/Kconfig      | 19 ++++++++++---------
 security/integrity/evm/evm.h        |  4 +++-
 security/integrity/evm/evm_crypto.c |  2 +-
 security/integrity/evm/evm_main.c   | 21 ++++++++++++++++++++-
 4 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index d35b491..2be51fa 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -12,15 +12,16 @@ config EVM
 
 	  If you are unsure how to answer this question, answer N.
 
-config EVM_HMAC_VERSION
-	int "EVM HMAC version"
-	depends on EVM
-	default 2
-	help
-	  This options adds EVM HMAC version support.
-	  1 - original version
-	  2 - add per filesystem unique identifier (UUID) (default)
+config EVM_HMAC_ATTRS
+	string "HMAC attributes"
+	default "fsuuid"
+ 	help
+	  This options allows to specify list of optional attributes included into HMAC
+	  calculation. It makes it possible easily upgrade to newer kernels.
+	 
+	  Default value is 'fsuuid', which is former version 2.
+	  if blank, it is equivalent of version 1
 
 	  WARNING: changing the HMAC calculation method or adding 
 	  additional info to the calculation, requires existing EVM
-	  labeled file systems to be relabeled.  
+	  labeled file systems to be relabeled.
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 37c88dd..c8fa0aa 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -24,11 +24,13 @@
 extern int evm_initialized;
 extern char *evm_hmac;
 extern char *evm_hash;
-extern int evm_hmac_version;
+extern int evm_hmac_attrs;
 
 extern struct crypto_shash *hmac_tfm;
 extern struct crypto_shash *hash_tfm;
 
+#define EVM_HMAC_ATTR_FSUUID		0x0001
+
 /* List of EVM protected security xattrs */
 extern char *evm_config_xattrnames[];
 
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index babd862..ab034e5 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -112,7 +112,7 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
 	hmac_misc.gid = from_kgid(&init_user_ns, inode->i_gid);
 	hmac_misc.mode = inode->i_mode;
 	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
-	if (evm_hmac_version > 1)
+	if (evm_hmac_attrs & EVM_HMAC_ATTR_FSUUID)
 		crypto_shash_update(desc, inode->i_sb->s_uuid,
 				    sizeof(inode->i_sb->s_uuid));
 	crypto_shash_final(desc, digest);
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 996092f..9c05929 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -32,7 +32,7 @@ static char *integrity_status_msg[] = {
 };
 char *evm_hmac = "hmac(sha1)";
 char *evm_hash = "sha1";
-int evm_hmac_version = CONFIG_EVM_HMAC_VERSION;
+int evm_hmac_attrs;
 
 char *evm_config_xattrnames[] = {
 #ifdef CONFIG_SECURITY_SELINUX
@@ -57,6 +57,19 @@ static int __init evm_set_fixmode(char *str)
 }
 __setup("evm=", evm_set_fixmode);
 
+static int __init evm_init_config(void)
+{
+	char *attrs = CONFIG_EVM_HMAC_ATTRS;
+	char *p;
+
+	while ((p = strsep(&attrs, ", \t"))) {
+		if (!strcmp(p, "fsuuid"))
+			evm_hmac_attrs |= EVM_HMAC_ATTR_FSUUID;
+	}
+	pr_info("HMAC attrs: 0x%x\n", evm_hmac_attrs);
+	return 0;
+}
+
 static int evm_find_protected_xattrs(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
@@ -432,6 +445,12 @@ static int __init init_evm(void)
 {
 	int error;
 
+	error = evm_init_config();
+	if (error < 0) {
+		pr_info("Error parsing config lists\n");
+		goto err;
+	}
+
 	error = evm_init_secfs();
 	if (error < 0) {
 		pr_info("Error registering secfs\n");
-- 
1.8.3.2

