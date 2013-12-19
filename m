Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3LSMMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:12:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3LSL7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 170/208] xfs: growfs overruns AGFL buffer on V4 filesystems
Date: Thu, 19 Dec 2013 11:54:28 +0000
Message-Id: <1387454106-19326-171-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit f94c44573e7c22860e2c3dfe349c45f72ba35ad3 upstream.

This loop in xfs_growfs_data_private() is incorrect for V4
superblocks filesystems:

		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);

For V4 filesystems, we don't have a agfl header structure, and so
XFS_AGFL_SIZE() returns an entire sector's worth of entries, which
we then index from an offset into the sector. Hence: buffer overrun.

This problem was introduced in 3.10 by commit 77c95bba ("xfs: add
CRC checks to the AGFL") which changed the AGFL structure but failed
to update the growfs code to handle the different structures.

Fix it by using the correct offset into the buffer for both V4 and
V5 filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

(cherry picked from commit b7d961b35b3ab69609aeea93f870269cb6e7ba4d)
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/xfs/xfs_fsops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 614eb0c..e0f1d97 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -216,6 +216,8 @@ xfs_growfs_data_private(
 	 */
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
+		__be32	*agfl_bno;
+
 		/*
 		 * AG freespace header block
 		 */
@@ -275,8 +277,10 @@ xfs_growfs_data_private(
 			agfl->agfl_seqno = cpu_to_be32(agno);
 			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
 		}
+
+		agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
 		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
-			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
+			agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
-- 
1.8.3.2

