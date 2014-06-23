Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaFWIgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:36:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55651 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/111] evm: prohibit userspace writing 'security.evm' HMAC value
Date: Mon, 23 Jun 2014 10:32:01 +0200
Message-Id: <f422f975187e23c15cf8be951490623428659eba.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2fb1c9a4f2dbc2f0bd2431c7fa64d0b5483864e4 upstream.

Calculating the 'security.evm' HMAC value requires access to the
EVM encrypted key.  Only the kernel should have access to it.  This
patch prevents userspace tools(eg. setfattr, cp --preserve=xattr)
from setting/modifying the 'security.evm' HMAC value directly.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 security/integrity/evm/evm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index af9b6852f4e1..9add08a2be02 100644
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
2.0.0

