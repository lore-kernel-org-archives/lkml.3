Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3BRBLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:11:53 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51039 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3BRBLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:11:50 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:11:00 -0800
Message-Id: <1361149870-27732-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18Y717Zz1g7Yd/BTmTpwK5taWLYKu1/L/U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2666]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 07/16] xfs: Update ioctl(XFS_IOC_FREE_EOFBLOCKS) to handle callers in any userspace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Modify the ioctl to convert from uids, gid, and projids in the
  current user namespace to kuids, kgids, and kprojids, and to report
  an error if the conversion fails.

- Create struct xfs_internal_eofblocks to hold the same information as
  struct xfs_eofblocks but with uids, gids, and projids stored as
  kuids, kgids, and kprojids preventing confusion.

- Pass struct xfs_interanl_eofblocks into xfs_icache_free_eofblocks
  and it's helpers ensuring there will not be confusing about which
  user namespace identifiers that need to be compared are in.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_icache.c |    8 ++++----
 fs/xfs/xfs_icache.h |   11 ++++++++++-
 fs/xfs/xfs_ioctl.c  |   22 +++++++++++++++++++++-
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0583649..e4cdc02 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1199,7 +1199,7 @@ xfs_reclaim_inodes_count(
 STATIC int
 xfs_inode_match_id(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_internal_eofblocks	*eofb)
 {
 	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
 	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
@@ -1210,7 +1210,7 @@ xfs_inode_match_id(
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
-	    !projid_eq(ip->i_projid, eofb->eof_prid))
+	    !projid_eq(ip->i_projid, eofb->eof_projid))
 		return 0;
 
 	return 1;
@@ -1224,7 +1224,7 @@ xfs_inode_free_eofblocks(
 	void			*args)
 {
 	int ret;
-	struct xfs_eofblocks *eofb = args;
+	struct xfs_internal_eofblocks *eofb = args;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1263,7 +1263,7 @@ xfs_inode_free_eofblocks(
 int
 xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_internal_eofblocks	*eofb)
 {
 	int flags = SYNC_TRYLOCK;
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e0f138c..260dc27 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -35,9 +35,18 @@ void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+struct xfs_internal_eofblocks {
+	u32		eof_version;
+	u32		eof_flags;
+	kuid_t		eof_uid;
+	kgid_t		eof_gid;
+	kprojid_t	eof_projid;
+	u64		eof_min_file_size;
+};
+
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
+int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_internal_eofblocks *);
 void xfs_eofblocks_worker(struct work_struct *);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4a55f50..1a74b56 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1615,6 +1615,7 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
 		struct xfs_eofblocks eofb;
+		struct xfs_internal_eofblocks keofb;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
@@ -1629,7 +1630,26 @@ xfs_file_ioctl(
 		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
 			return -XFS_ERROR(EINVAL);
 
-		error = xfs_icache_free_eofblocks(mp, &eofb);
+		keofb.eof_version = eofb.eof_version;
+		keofb.eof_flags   = eofb.eof_flags;
+		if (eofb.eof_flags & XFS_EOF_FLAGS_UID) {
+			keofb.eof_uid = make_kuid(current_user_ns(), eofb.eof_uid);
+			if (!uid_valid(keofb.eof_uid))
+				return -XFS_ERROR(EINVAL);
+		}
+		if (eofb.eof_flags & XFS_EOF_FLAGS_GID) {
+			keofb.eof_gid = make_kgid(current_user_ns(), eofb.eof_gid);
+			if (!gid_valid(keofb.eof_gid))
+				return -XFS_ERROR(EINVAL);
+		}
+		if (eofb.eof_flags & XFS_EOF_FLAGS_PRID) {
+			keofb.eof_projid = make_kprojid(current_user_ns(), eofb.eof_prid);
+			if (!projid_valid(keofb.eof_projid))
+				return -XFS_ERROR(EINVAL);
+		}
+		keofb.eof_min_file_size = eofb.eof_min_file_size;
+
+		error = xfs_icache_free_eofblocks(mp, &keofb);
 		return -error;
 	}
 
-- 
1.7.5.4

