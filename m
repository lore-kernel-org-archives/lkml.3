Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3CKLu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:50:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58401 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3CKLuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:50:55 -0400
X-AuditID: cbfec7f4-b7f4c6d0000018de-5c-513dc51eab2c
From: Igor Zhbanov <i.zhbanov@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Igor Zhbanov <i.zhbanov@samsung.com>
Subject: [PATCH] Fix common_audit_data type for smack_inode_unlink() and
 smack_inode_rmdir()
Date: Mon, 11 Mar 2013 15:50:36 +0400
Message-id: <1363002636-14158-1-git-send-email-i.zhbanov@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJMWRmVeSWpSXmKPExsVy+t/xa7pyR20DDbb1cVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Myxu6WAoOSVZ8ecrdwDhdtIuRk0NCwERi6sH/jBC2mMSFe+vZ
	QGwhgaWMErOuOnYxcgHZq5kkHu6YC5ZgE9CS2Pt8BTOILSKgILG59xkriM0sECrxau9Dli5G
	Dg5hgTiJCe2mIGEWAVWJhon7wVp5BVwltkxawQaxS0Hi15FVrBMYuRcwMqxiFE0tTS4oTkrP
	NdQrTswtLs1L10vOz93ECPHelx2Mi49ZHWIU4GBU4uGdqGMbKMSaWFZcmXuIUYKDWUmEd+Um
	m0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjBN+Nq76U/NjX3o4b9Jyzhkr2j+zqB/z/b5eXTAn
	VDlPQO1LyPbLKVbtj+s4uEL+mzOaOPU4pDBN+Fwq+XyPWpT5y9mijv9Y1142XOG25Phddqlj
	q155vNz1/OPDtdeTr+f+9i1av8tbcwPjX+eVXx9seixTcM3n/o1Wz1n3PtY+lpLjEm/YqKjE
	UpyRaKjFXFScCABqR1H7vAEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes kernel Oops because of wrong common_audit_data type
in smack_inode_unlink() and smack_inode_rmdir().

When SMACK security module is enabled and SMACK logging is on (/smack/logging
is not zero) and you try to delete the file which
1) you cannot delete due to SMACK rules and logging of failures is on
or
2) you can delete and logging of success is on,

you will see following:

	Unable to handle kernel NULL pointer dereference at virtual address 000002d7

	[<...>] (strlen+0x0/0x28)
	[<...>] (audit_log_untrustedstring+0x14/0x28)
	[<...>] (common_lsm_audit+0x108/0x6ac)
	[<...>] (smack_log+0xc4/0xe4)
	[<...>] (smk_curacc+0x80/0x10c)
	[<...>] (smack_inode_unlink+0x74/0x80)
	[<...>] (security_inode_unlink+0x2c/0x30)
	[<...>] (vfs_unlink+0x7c/0x100)
	[<...>] (do_unlinkat+0x144/0x16c)

The function smack_inode_unlink() (and smack_inode_rmdir()) need
to log two structures of different types. First of all it does:

	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);

This will set common audit data type to LSM_AUDIT_DATA_DENTRY
and store dentry for auditing (by function smk_curacc(), which in turn calls
dump_common_audit_data(), which is actually uses provided data and logs it).

	/*
	 * You need write access to the thing you're unlinking
	 */
	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE, &ad);
	if (rc == 0) {
		/*
		 * You also need write access to the containing directory
		 */

Then this function wants to log anoter data:

		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
		smk_ad_setfield_u_fs_inode(&ad, dir);

The function sets inode field, but don't change common_audit_data type.

		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
	}

So the dump_common_audit() function incorrectly interprets inode structure
as dentry, and Oops will happen.

This patch reinitializes common_audit_data structures with correct type.
Also I removed unneeded
	smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
initialization, because both dentry and inode pointers are stored
in the same union.

Signed-off-by: Igor Zhbanov <i.zhbanov@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 security/smack/smack_lsm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fa64740..d52c780 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -654,7 +654,7 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
 		/*
 		 * You also need write access to the containing directory
 		 */
-		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
+		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
 		smk_ad_setfield_u_fs_inode(&ad, dir);
 		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
 	}
@@ -685,7 +685,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 		/*
 		 * You also need write access to the containing directory
 		 */
-		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
+		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
 		smk_ad_setfield_u_fs_inode(&ad, dir);
 		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
 	}
-- 
1.7.5.4

