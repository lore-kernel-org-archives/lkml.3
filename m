Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944Ab3BNT42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934908Ab3BNTzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:55:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: [PATCH 3/6] ima/evm: Differentiate between ima/evm nolabel return code
Date: Thu, 14 Feb 2013 14:55:42 -0500
Message-Id: <1360871745-20616-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if no IMA/EVM label was present, both return error code
INTEGRITY_NOLABEL. This works fine so far as nobody cares to differentiate
between two error paths.

But with appraise_type=optional, we want to allow file access if IMA
security label is not present. But still disallow access if EVM
security label is not present.

Hence, start using different error codes for two different paths.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/integrity.h             |    3 ++-
 security/integrity/evm/evm_main.c     |    2 +-
 security/integrity/ima/ima_appraise.c |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 66c5fe9..9be4a98 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -15,7 +15,8 @@
 enum integrity_status {
 	INTEGRITY_PASS = 0,
 	INTEGRITY_FAIL,
-	INTEGRITY_NOLABEL,
+	INTEGRITY_IMA_NOLABEL,
+	INTEGRITY_EVM_NOLABEL,
 	INTEGRITY_NOXATTRS,
 	INTEGRITY_UNKNOWN,
 };
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index a78a5e2..254eefe 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -111,7 +111,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		else if (rc == -ENODATA) {
 			rc = evm_find_protected_xattrs(dentry);
 			if (rc > 0)
-				evm_status = INTEGRITY_NOLABEL;
+				evm_status = INTEGRITY_EVM_NOLABEL;
 			else if (rc == 0)
 				evm_status = INTEGRITY_NOXATTRS; /* new file */
 		}
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 6f1eeb8..1750556 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -143,13 +143,13 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 
 		cause = "missing-hash";
 		status =
-		    (inode->i_size == 0) ? INTEGRITY_PASS : INTEGRITY_NOLABEL;
+		    (inode->i_size == 0) ? INTEGRITY_PASS : INTEGRITY_IMA_NOLABEL;
 		goto out;
 	}
 
 	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
 	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
-		if ((status == INTEGRITY_NOLABEL)
+		if ((status == INTEGRITY_EVM_NOLABEL)
 		    || (status == INTEGRITY_NOXATTRS))
 			cause = "missing-HMAC";
 		else if (status == INTEGRITY_FAIL)
-- 
1.7.7.6

