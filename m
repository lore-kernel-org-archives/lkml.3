Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbbATTO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:14:28 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53230 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbbATTNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:16 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 10/11] evm: make rootfs a special case
Date: Tue, 20 Jan 2015 14:12:59 -0500
Message-Id: <1421781180-24425-11-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0029-0000-0000-000001BC85C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the EVM HMAC and signature xattr formats are file system
specific and can not be copied from one filesystem to another.

EVM differentiates files without any xattrs (INTEGRITY_UNKNOWN)
from those having protected xattrs (INTEGRITY_NOLABEL).  This
patch treats the rootfs filesystem as a special case, returning
INTEGRITY_UNKNOWN.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/evm/evm_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index f589c9a0..9140016 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/audit.h>
+#include <linux/magic.h>
 #include <linux/xattr.h>
 #include <linux/integrity.h>
 #include <linux/evm.h>
@@ -128,11 +129,16 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	if (rc <= 0) {
 		evm_status = INTEGRITY_FAIL;
 		if (rc == -ENODATA) {
+			struct super_block *sb = dentry->d_inode->i_sb;
+
 			rc = evm_find_protected_xattrs(dentry);
-			if (rc > 0)
-				evm_status = INTEGRITY_NOLABEL;
-			else if (rc == 0)
+			if (rc == 0)
 				evm_status = INTEGRITY_NOXATTRS; /* new file */
+			else if (rc > 0 && sb->s_magic == TMPFS_MAGIC
+				 && strcmp(sb->s_id, "rootfs") == 0)
+				evm_status = INTEGRITY_UNKNOWN;
+			else if (rc > 0)
+				evm_status = INTEGRITY_NOLABEL;
 		} else if (rc == -EOPNOTSUPP) {
 			evm_status = INTEGRITY_UNKNOWN;
 		}
-- 
1.8.1.4

