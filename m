Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813Ab3BANNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:13:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:45427 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422729Ab3BANNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:13:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Ben Myers <bpm@sgi.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 68/89] xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
Date: Fri,  1 Feb 2013 14:08:23 +0100
Message-Id: <20130201130212.381996681@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit eb178619f930fa2ba2348de332a1ff1c66a31424 upstream.

When _xfs_buf_find is passed an out of range address, it will fail
to find a relevant struct xfs_perag and oops with a null
dereference. This can happen when trying to walk a filesystem with a
metadata inode that has a partially corrupted extent map (i.e. the
block number returned is corrupt, but is otherwise intact) and we
try to read from the corrupted block address.

In this case, just fail the lookup. If it is readahead being issued,
it will simply not be done, but if it is real read that fails we
will get an error being reported.  Ideally this case should result
in an EFSCORRUPTED error being reported, but we cannot return an
error through xfs_buf_read() or xfs_buf_get() so this lookup failure
may result in ENOMEM or EIO errors being reported instead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Cc: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_buf.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -487,6 +487,7 @@ _xfs_buf_find(
 	struct rb_node		*parent;
 	xfs_buf_t		*bp;
 	xfs_daddr_t		blkno = map[0].bm_bn;
+	xfs_daddr_t		eofs;
 	int			numblks = 0;
 	int			i;
 
@@ -498,6 +499,23 @@ _xfs_buf_find(
 	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
 	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
 
+	/*
+	 * Corrupted block numbers can get through to here, unfortunately, so we
+	 * have to check that the buffer falls within the filesystem bounds.
+	 */
+	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
+	if (blkno >= eofs) {
+		/*
+		 * XXX (dgc): we should really be returning EFSCORRUPTED here,
+		 * but none of the higher level infrastructure supports
+		 * returning a specific error on buffer lookup failures.
+		 */
+		xfs_alert(btp->bt_mount,
+			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
+			  __func__, blkno, eofs);
+		return NULL;
+	}
+
 	/* get tree root */
 	pag = xfs_perag_get(btp->bt_mount,
 				xfs_daddr_to_agno(btp->bt_mount, blkno));


