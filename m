Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3LRVNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3LRVNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Jie Liu <jeff.liu@oracle.com>,
        Ben Myers <bpm@sgi.com>
Subject: [PATCH 3.12 024/118] xfs: growfs overruns AGFL buffer on V4 filesystems
Date: Wed, 18 Dec 2013 13:11:01 -0800
Message-Id: <20131218211220.162931889@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_fsops.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -217,6 +217,8 @@ xfs_growfs_data_private(
 	 */
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
+		__be32	*agfl_bno;
+
 		/*
 		 * AG freespace header block
 		 */
@@ -276,8 +278,10 @@ xfs_growfs_data_private(
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


