Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaLPPxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:53:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15589 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaLPPx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:53:29 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-cd-54905576aeff
Content-transfer-encoding: 8BIT
From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, l.skalski@samsung.com,
        m.wereski@partner.samsung.com, r.krypa@samsung.com,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2] smack: introduce a special case for tmpfs in
 smack_d_instantiate()
Date: Tue, 16 Dec 2014 16:53:08 +0100
Message-id: <1418745188-23662-1-git-send-email-l.stelmach@samsung.com>
X-Mailer: git-send-email 1.9.1
Organization: Samsung R&D Institute Poland
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xK7ploRNCDA59MLC4t+0Xm0Xf4yCL
	xk9zmS3mnGtksrh5aAWjxeVdc9gsPvQ8YrPYu/Ekq8XbSSuYLc5fOMfuwOVxbXekx8ent1g8
	Dr7bw+TRt2UVo8fR/YvYPD5vkgtgi+KySUnNySxLLdK3S+DK6Jq+n7XgC3dF49LjTA2M6zm7
	GDk5JARMJI7t/8AMYYtJXLi3nq2LkYtDSGApo8TyiefZQRK8AoISPybfY+li5OBgFpCXOHIp
	GyTMLKAuMWneImaI+iYmiZO7FjOBJNgEHCX6l55gBUmICBxnlOh7tpMRxGEW2MMo8aRrDzPI
	JGGBCIk5ZwpATBYBVYlZk1MgdrlJrGloYoE4SE7i5LHJrCA2v4CWxJqm6ywTGPlnITlpFsJJ
	s5CctICReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSLh/2cG4+JjVIUYBDkYlHt6C3v4Q
	IdbEsuLK3EOMEhzMSiK8QcoTQoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwrjbNe638Kf2Liobt
	xNshF0KXZp+b/zKrNrqrZcM23XpTM2/za+yhi3asc/0RxDbVK/Ohxo9YVy3O23cerF57fV0I
	R8htE/sdF5czrvJ2N+J8t2qNt3LTnrRl/6pFZVszBGRizrvvFbmx7VqtwfePni+WTd8Udnm5
	2dTV8uFms6Kr9pYw/r68X4mlOCPRUIu5qDgRAF2RzFdVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Files created with __shmem_file_stup() appear to have somewhat fake
dentries which make them look like root directories and not get
the label the current process or ("*") star meant for tmpfs files.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 security/smack/smack_lsm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index e8bed86..b774029 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3036,18 +3036,30 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	 * If that is the case use the root value out
 	 * of the superblock.
 	 */
 	if (opt_dentry->d_parent == opt_dentry) {
-		if (sbp->s_magic == CGROUP_SUPER_MAGIC) {
+		switch (sbp->s_magic) {
+		case CGROUP_SUPER_MAGIC:
 			/*
 			 * The cgroup filesystem is never mounted,
 			 * so there's no opportunity to set the mount
 			 * options.
 			 */
 			sbsp->smk_root = &smack_known_star;
 			sbsp->smk_default = &smack_known_star;
+			isp->smk_inode = sbsp->smk_root;
+			break;
+		case TMPFS_MAGIC:
+			/*
+			 * What about shmem/tmpfs anonymous files with dentry
+			 * obtained from d_alloc_pseudo()?
+			 */
+			isp->smk_inode = smk_of_current();
+			break;
+		default:
+			isp->smk_inode = sbsp->smk_root;
+			break;
 		}
-		isp->smk_inode = sbsp->smk_root;
 		isp->smk_flags |= SMK_INODE_INSTANT;
 		goto unlockandout;
 	}
 
-- 
1.9.1

