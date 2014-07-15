Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbaGOWFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:05:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54551 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456AbaGOVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:36:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 133/198] evm: prohibit userspace writing 'security.evm' HMAC value
Date: Tue, 15 Jul 2014 14:30:03 -0700
Message-Id: <1405459868-15089-134-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 2fb1c9a4f2dbc2f0bd2431c7fa64d0b5483864e4 upstream.

Calculating the 'security.evm' HMAC value requires access to the
EVM encrypted key.  Only the kernel should have access to it.  This
patch prevents userspace tools(eg. setfattr, cp --preserve=xattr)
from setting/modifying the 'security.evm' HMAC value directly.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/integrity/evm/evm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 336b3dd..3c5cbb9 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -285,12 +285,20 @@ out:
  * @xattr_value: pointer to the new extended attribute value
  * @xattr_value_len: pointer to the new extended attribute value length
  *
- * Updating 'security.evm' requires CAP_SYS_ADMIN privileges and that
- * the current value is valid.
+ * Before allowing the 'security.evm' protected xattr to be updated,
+ * verify the existing value is valid.  As only the kernel should have
+ * access to the EVM encrypted key needed to calculate the HMAC, prevent
+ * userspace from writing HMAC value.  Writing 'security.evm' requires
+ * requires CAP_SYS_ADMIN privileges.
  */
 int evm_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len)
 {
+	const struct evm_ima_xattr_data *xattr_data = xattr_value;
+
+	if ((strcmp(xattr_name, XATTR_NAME_EVM) == 0)
+	    && (xattr_data->type == EVM_XATTR_HMAC))
+		return -EPERM;
 	return evm_protect_xattr(dentry, xattr_name, xattr_value,
 				 xattr_value_len);
 }
-- 
1.9.1

