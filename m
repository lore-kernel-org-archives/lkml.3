Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621Ab3BMR63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:58:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49271 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965081Ab3BMR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:08 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Date: Wed, 13 Feb 2013 09:51:12 -0800
Message-Id: <1360777934-5663-23-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18xzjvgsqdXEeVgsQtgP/Jsx8H9qXGvjwQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 23/85] ocfs2: Convert uid and gids between in core and on disk inodes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ocfs2/inode.c |   12 ++++++------
 fs/ocfs2/namei.c |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index d89e08a..f87f9bd 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -269,8 +269,8 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	inode->i_generation = le32_to_cpu(fe->i_generation);
 	inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
 	inode->i_mode = le16_to_cpu(fe->i_mode);
-	inode->i_uid = le32_to_cpu(fe->i_uid);
-	inode->i_gid = le32_to_cpu(fe->i_gid);
+	i_uid_write(inode, le32_to_cpu(fe->i_uid));
+	i_gid_write(inode, le32_to_cpu(fe->i_gid));
 
 	/* Fast symlinks will have i_size but no allocated clusters. */
 	if (S_ISLNK(inode->i_mode) && !fe->i_clusters) {
@@ -1259,8 +1259,8 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 
 	fe->i_size = cpu_to_le64(i_size_read(inode));
 	ocfs2_set_links_count(fe, inode->i_nlink);
-	fe->i_uid = cpu_to_le32(inode->i_uid);
-	fe->i_gid = cpu_to_le32(inode->i_gid);
+	fe->i_uid = cpu_to_le32(i_uid_read(inode));
+	fe->i_gid = cpu_to_le32(i_gid_read(inode));
 	fe->i_mode = cpu_to_le16(inode->i_mode);
 	fe->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
 	fe->i_atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
@@ -1290,8 +1290,8 @@ void ocfs2_refresh_inode(struct inode *inode,
 	ocfs2_set_inode_flags(inode);
 	i_size_write(inode, le64_to_cpu(fe->i_size));
 	set_nlink(inode, ocfs2_read_links_count(fe));
-	inode->i_uid = le32_to_cpu(fe->i_uid);
-	inode->i_gid = le32_to_cpu(fe->i_gid);
+	i_uid_write(inode, le32_to_cpu(fe->i_uid));
+	i_gid_write(inode, le32_to_cpu(fe->i_gid));
 	inode->i_mode = le16_to_cpu(fe->i_mode);
 	if (S_ISLNK(inode->i_mode) && le32_to_cpu(fe->i_clusters) == 0)
 		inode->i_blocks = 0;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f1fd074..04ee1b5 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -512,8 +512,8 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	fe->i_suballoc_loc = cpu_to_le64(suballoc_loc);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
 	fe->i_suballoc_slot = cpu_to_le16(inode_ac->ac_alloc_slot);
-	fe->i_uid = cpu_to_le32(inode->i_uid);
-	fe->i_gid = cpu_to_le32(inode->i_gid);
+	fe->i_uid = cpu_to_le32(i_uid_read(inode));
+	fe->i_gid = cpu_to_le32(i_gid_read(inode));
 	fe->i_mode = cpu_to_le16(inode->i_mode);
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 		fe->id1.dev1.i_rdev = cpu_to_le64(huge_encode_dev(dev));
-- 
1.7.5.4

