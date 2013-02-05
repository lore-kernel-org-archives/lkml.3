Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3BEN34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:29:56 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33434 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab3BEN3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:29:53 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] evm: add file system uuid to EVM hmac
Date: Tue,  5 Feb 2013 08:28:14 -0500
Message-Id: <1360070895-29895-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020513-9360-0000-0000-00001024BEB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

EVM uses the same key for all file systems to calculate the HMAC,
making it possible to paste inodes from one file system on to another
one, without EVM being able to detect it.  To prevent such an attack,
it is necessary to make the EVM HMAC file system specific.

This patch uses the file system UUID, a file system unique identifier,
to bind the EVM HMAC to the file system. The value inode->i_sb->s_uuid
is used for the HMAC hash calculation, instead of using it for deriving
the file system specific key.  Initializing the key for every inode HMAC
calculation is a bit more expensive operation than adding the uuid to
the HMAC hash.

Changing the HMAC calculation method or adding additional info to the
calculation, requires existing EVM labeled file systems to be relabeled.
This patch adds a Kconfig HMAC version option for backwards compatability.

Changelog v1:
- squash "hmac version setting"
Changelog v0:
- add missing Kconfig depends (Mimi)

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/evm/Kconfig      | 13 +++++++++++++
 security/integrity/evm/evm.h        |  1 +
 security/integrity/evm/evm_crypto.c |  3 +++
 security/integrity/evm/evm_main.c   |  1 +
 4 files changed, 18 insertions(+)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index afbb59d..fea9749 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -11,3 +11,16 @@ config EVM
 	  integrity attacks.
 
 	  If you are unsure how to answer this question, answer N.
+
+config EVM_HMAC_VERSION
+	int "EVM HMAC version"
+	depends on EVM
+	default 2
+	help
+	  This options adds EVM HMAC version support.
+	  1 - original version
+	  2 - add per filesystem unique identifier (UUID) (default)
+
+	  WARNING: changing the HMAC calculation method or adding 
+	  additional info to the calculation, requires existing EVM
+	  labeled file systems to be relabeled.  
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 3eb30c6..30bd1ec 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -24,6 +24,7 @@
 extern int evm_initialized;
 extern char *evm_hmac;
 extern char *evm_hash;
+extern int evm_hmac_version;
 
 extern struct crypto_shash *hmac_tfm;
 extern struct crypto_shash *hash_tfm;
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index dfb2691..ff8e2ab 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -110,6 +110,9 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
 	hmac_misc.gid = from_kgid(&init_user_ns, inode->i_gid);
 	hmac_misc.mode = inode->i_mode;
 	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof hmac_misc);
+	if (evm_hmac_version > 1)
+		crypto_shash_update(desc, inode->i_sb->s_uuid,
+				    sizeof(inode->i_sb->s_uuid));
 	crypto_shash_final(desc, digest);
 }
 
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index a78a5e2..cdbde17 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -26,6 +26,7 @@ int evm_initialized;
 
 char *evm_hmac = "hmac(sha1)";
 char *evm_hash = "sha1";
+int evm_hmac_version = CONFIG_EVM_HMAC_VERSION;
 
 char *evm_config_xattrnames[] = {
 #ifdef CONFIG_SECURITY_SELINUX
-- 
1.8.1.rc3

