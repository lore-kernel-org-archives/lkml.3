Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912Ab3BNTzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab3BNTzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:55:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: [PATCH 4/6] ima: Introduce new integrity error code INTEGRITY_XATTR_NOTSUPP
Date: Thu, 14 Feb 2013 14:55:43 -0500
Message-Id: <1360871745-20616-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently file system does not support xattr or security xattr are not
enabled, we return INTEGRITY_UNKNOWN. INTEGRITY_UNKNOWN is returned in
so many other conditions too, evm not initialized etc.

So far nobody cared but with appraise_type=optional, I need to
to differentiate between different error paths. For example, I want
to allow access to file when xattr are not enabled or specific security
attr is not enabled by file system. But I don't want to allow access
for all cases of INTEGRITY_UNKNOWN. For example,
if vfs_getxattr_alloc() returns -ENOMEM, then also INTEGRITY_UNKNOWN
will be returned and I don't think we want to allow access to file
in that case.

So to differentiate the errors where we can allow acccess to file,
introduce the new error code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/integrity.h             |    1 +
 security/integrity/ima/ima_appraise.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 9be4a98..37074be 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -19,6 +19,7 @@ enum integrity_status {
 	INTEGRITY_EVM_NOLABEL,
 	INTEGRITY_NOXATTRS,
 	INTEGRITY_UNKNOWN,
+	INTEGRITY_XATTR_NOTSUPP,
 };
 
 /* List of EVM protected security xattrs */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 1750556..af39a08 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -129,14 +129,14 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	if (!ima_appraise)
 		return 0;
 	if (!inode->i_op->getxattr)
-		return INTEGRITY_UNKNOWN;
+		return INTEGRITY_XATTR_NOTSUPP;
 
 	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
 				0, GFP_NOFS);
 	if (rc <= 0) {
 		/* File system does not support security xattr */
 		if (rc == -EOPNOTSUPP)
-			return INTEGRITY_UNKNOWN;
+			return INTEGRITY_XATTR_NOTSUPP;
 
 		if (rc && rc != -ENODATA)
 			goto out;
-- 
1.7.7.6

