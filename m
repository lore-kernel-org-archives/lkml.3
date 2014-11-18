Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaKROMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:12:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbaKROKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 183/206] xfs: avoid false quotacheck after unclean shutdown
Date: Tue, 18 Nov 2014 15:08:58 +0100
Message-Id: <0277558a6cc692295cb568b22970c12db2587f9a.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5ef828c4152726f56751c78ea844f08d2b2a4fa3 upstream.

The commit

83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD

added a new function xfs_sb_quota_from_disk() which swaps
on-disk XFS_OQUOTA_* flags for in-core XFS_GQUOTA_* and XFS_PQUOTA_*
flags after the superblock is read.

However, if log recovery is required, the superblock is read again,
and the modified in-core flags are re-read from disk, so we have
XFS_OQUOTA_* flags in memory again.  This causes the
XFS_QM_NEED_QUOTACHECK() test to be true, because the XFS_OQUOTA_CHKD
is still set, and not XFS_GQUOTA_CHKD or XFS_PQUOTA_CHKD.

Change xfs_sb_from_disk to call xfs_sb_quota_from disk and always
convert the disk flags to in-memory flags.

Add a lower-level function which can be called with "false" to
not convert the flags, so that the sb verifier can verify
exactly what was on disk, per Brian Foster's suggestion.

Reported-by: Cyril B. <cbay@excellency.fr>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Arkadiusz Miśkiewicz <arekm@maven.pl>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_mount.c |  1 -
 fs/xfs/xfs_sb.c    | 24 ++++++++++++++++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5dcc68019d1b..dc602b564255 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -318,7 +318,6 @@ reread:
 	 * Initialize the mount structure from the superblock.
 	 */
 	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
-	xfs_sb_quota_from_disk(&mp->m_sb);
 
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 38b7df67ba7c..1351ff0d77ab 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -406,10 +406,11 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	}
 }
 
-void
-xfs_sb_from_disk(
+static void
+__xfs_sb_from_disk(
 	struct xfs_sb	*to,
-	xfs_dsb_t	*from)
+	xfs_dsb_t	*from,
+	bool		convert_xquota)
 {
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
 	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
@@ -465,6 +466,17 @@ xfs_sb_from_disk(
 	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
+	/* Convert on-disk flags to in-memory flags? */
+	if (convert_xquota)
+		xfs_sb_quota_from_disk(to);
+}
+
+void
+xfs_sb_from_disk(
+	struct xfs_sb	*to,
+	xfs_dsb_t	*from)
+{
+	__xfs_sb_from_disk(to, from, true);
 }
 
 static inline void
@@ -580,7 +592,11 @@ xfs_sb_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
 
-	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+	/*
+	 * Use call variant which doesn't convert quota flags from disk
+	 * format, because xfs_mount_validate_sb checks the on-disk flags.
+	 */
+	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
 
 	/*
 	 * Only check the in progress field for the primary superblock as
-- 
2.1.3

