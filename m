Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3DXMLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:11:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44396 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab3DXMLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:11:05 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] evm: audit integrity metadata failures
Date: Wed, 24 Apr 2013 08:10:41 -0400
Message-Id: <1366805441-12187-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1366805441-12187-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1366805441-12187-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042412-3620-0000-0000-0000022A3013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before modifying an EVM protected extended attribute or any other
metadata included in the HMAC calculation, the existing 'security.evm'
is verified.  This patch adds calls to integrity_audit_msg() to audit
integrity metadata failures.

Reported-by: Sven Vermeulen <sven.vermeulen@siphos.be>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/evm/evm_main.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index cdbde17..0c4c6e7 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/crypto.h>
+#include <linux/audit.h>
 #include <linux/xattr.h>
 #include <linux/integrity.h>
 #include <linux/evm.h>
@@ -24,6 +25,9 @@
 
 int evm_initialized;
 
+static char *integrity_status_msg[] = {
+	"pass", "fail", "no_label", "no_xattrs", "unknown"
+};
 char *evm_hmac = "hmac(sha1)";
 char *evm_hash = "sha1";
 int evm_hmac_version = CONFIG_EVM_HMAC_VERSION;
@@ -262,9 +266,15 @@ static int evm_protect_xattr(struct dentry *dentry, const char *xattr_name,
 		if ((evm_status == INTEGRITY_PASS) ||
 		    (evm_status == INTEGRITY_NOXATTRS))
 			return 0;
-		return -EPERM;
+		goto out;
 	}
 	evm_status = evm_verify_current_integrity(dentry);
+out:
+	if (evm_status != INTEGRITY_PASS)
+		integrity_audit_msg(AUDIT_INTEGRITY_METADATA, dentry->d_inode,
+				    dentry->d_name.name, "appraise_metadata",
+				    integrity_status_msg[evm_status],
+				    -EPERM, 0);
 	return evm_status == INTEGRITY_PASS ? 0 : -EPERM;
 }
 
@@ -357,6 +367,10 @@ int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
 	if ((evm_status == INTEGRITY_PASS) ||
 	    (evm_status == INTEGRITY_NOXATTRS))
 		return 0;
+	integrity_audit_msg(AUDIT_INTEGRITY_METADATA, dentry->d_inode,
+			    dentry->d_name.name, "appraise_metadata",
+			    integrity_status_msg[evm_status],
+			    -EPERM, 0);
 	return -EPERM;
 }
 
-- 
1.8.1.rc3

