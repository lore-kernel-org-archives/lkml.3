Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbaE2QXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:23:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18511 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbaE2QXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:23:38 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-36-53875f08a73f
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] Smack: fix bug with empty label causing memory read beyond
 range
Date: Thu, 29 May 2014 18:23:32 +0200
Message-id: <1401380612-20006-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 2.0.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xa7oc8e3BBkv6hCzubfvFZnF51xw2
	iw89j9gs3k5awezA4tG3ZRWjx9H9i9g8Pm+SC2CO4rJJSc3JLEst0rdL4Mo4u2sVa8EUyYrz
	s5axNDC+Eeli5OSQEDCRONP7jRnCFpO4cG89WxcjF4eQwFJGiXOb17BDOL1MEq1nfzOBVLEJ
	qEssnd/LBmKLCOhI7NvznB3EZhbIkbg9bykLiC0sECxx6cwMsDiLgKrEs7UNjCA2r4CzxM0P
	j1khtslJNNz4xDaBkXsBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjBCvf93BuPSY1SFG
	AQ5GJR7eDJf2YCHWxLLiytxDjBIczEoivHKhQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MW4MO
	tFs79hvMbM8S4Szxs15Td25V4/R1ixJyNri9MH7/c1Lhok8vd6vpr3Bdf/XHmvfR+f8eLHrq
	c8DKfgGfV/4O3agCE/3y+W9b1sje0mB//iayQ8FM6k6UUmTPD3Uu887vc+d+6DktFHSZ06rc
	P29RhWvGpXdli7gmaH2VWOdqK+Sgm7RciaU4I9FQi7moOBEA9OjdnNgBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting zero-length Smack label on a file crashes the kernel.
The following command:
 # setfattr -n security.SMACK64 /dev/null

causes kernel panic. Call Trace:
 [<601a3b1e>] smk_parse_smack+0x1e/0xb2
 [<601a3cb0>] smk_import_entry+0x16/0x180
 [<601a1d0f>] smack_inode_setxattr+0x1ac/0x269
 [<6001ea92>] ? strncpy_chunk_from_user+0x0/0x56
 [<6001ecdb>] ? do_op_one_page+0x142/0x1e9
 [<6019e88f>] security_inode_setxattr+0x1e/0x23
 [<600e23e9>] vfs_setxattr+0x79/0xbd
 [<600e2579>] setxattr+0x14c/0x1a2
 [<600e27c3>] SyS_setxattr+0x7e/0xd1
 [<60043fad>] ? ptrace_notify+0xbc/0xc3
 [<6001ea26>] handle_syscall+0x65/0x7c
 [<60031c10>] userspace+0x441/0x547
 [<6001b9b3>] ? interrupt_end+0x0/0x80
 [<6001ea69>] ? copy_chunk_to_user+0x0/0x29
 [<6002d98f>] ? save_registers+0x1f/0x39
 [<6003488e>] ? arch_prctl+0xf9/0x173
 [<6001b867>] fork_handler+0x85/0x87

It is caused by passing len=0 to function smk_parse_smack(). In such case
the function assumes that the string to parse is null-terminated and tries
to calculate it's length by strlen(). But the string in this case is empty
and not null-terminated.

During investigation of all other calls leading to smk_parse_smack()
another similar issue was found in smk_write_onlycap().

This patch fixes both cases by ensuring that smk_parse_smack() by handling
of zero-length labels.

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smack_lsm.c | 9 ++++++---
 security/smack/smackfs.c   | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 14f52be..be8651d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -800,8 +800,8 @@ static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
  * smack_inode_setxattr - Smack check for setting xattrs
  * @dentry: the object
  * @name: name of the attribute
- * @value: unused
- * @size: unused
+ * @value: attribute value
+ * @size: attribute size
  * @flags: unused
  *
  * This protects the Smack attribute explicitly.
@@ -842,6 +842,9 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 	if (check_priv && !smack_privileged(CAP_MAC_ADMIN))
 		rc = -EPERM;
 
+	if (value == NULL || size > SMK_LONGLABEL || size == 0)
+		return -EINVAL;
+
 	if (rc == 0 && check_import) {
 		skp = smk_import_entry(value, size);
 		if (skp == NULL || (check_star &&
@@ -2076,7 +2079,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	int rc = 0;
 
 	if (value == NULL || size > SMK_LONGLABEL || size == 0)
-		return -EACCES;
+		return -EINVAL;
 
 	skp = smk_import_entry(value, size);
 	if (skp == NULL)
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3198cfe..c29e8ee 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1667,7 +1667,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	if (smack_onlycap != NULL && smack_onlycap != skp)
 		return -EPERM;
 
-	data = kzalloc(count, GFP_KERNEL);
+	data = kzalloc(count + 1, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
-- 
2.0.0

