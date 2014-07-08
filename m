Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbaGHT23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:28:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54211 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755716AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mimi Zohar" <zohar@linux.vnet.ibm.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.816205370@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 076/125] evm: prohibit userspace writing
 'security.evm' HMAC value
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 2fb1c9a4f2dbc2f0bd2431c7fa64d0b5483864e4 upstream.

Calculating the 'security.evm' HMAC value requires access to the
EVM encrypted key.  Only the kernel should have access to it.  This
patch prevents userspace tools(eg. setfattr, cp --preserve=xattr)
from setting/modifying the 'security.evm' HMAC value directly.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/integrity/evm/evm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -207,12 +207,20 @@ static int evm_protect_xattr(struct dent
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

