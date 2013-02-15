Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3BOXAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:00:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3BOW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, CAI Qian <caiqian@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [ 01/10] Revert: xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
Date: Fri, 15 Feb 2013 14:56:33 -0800
Message-Id: <20130215225543.743915307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225543.586012193@linuxfoundation.org>
References: <20130215225543.586012193@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit a56040731e5b00081c6d6c26b99e6e257a5d63d7 which was
commit eb178619f930fa2ba2348de332a1ff1c66a31424 upstream.

It has been reported to cause problems:
	http://bugzilla.redhat.com/show_bug.cgi?id=909602

Acked-by: Ben Myers <bpm@sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_buf.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -487,7 +487,6 @@ _xfs_buf_find(
 	struct rb_node		*parent;
 	xfs_buf_t		*bp;
 	xfs_daddr_t		blkno = map[0].bm_bn;
-	xfs_daddr_t		eofs;
 	int			numblks = 0;
 	int			i;
 
@@ -499,23 +498,6 @@ _xfs_buf_find(
 	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
 	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
 
-	/*
-	 * Corrupted block numbers can get through to here, unfortunately, so we
-	 * have to check that the buffer falls within the filesystem bounds.
-	 */
-	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
-	if (blkno >= eofs) {
-		/*
-		 * XXX (dgc): we should really be returning EFSCORRUPTED here,
-		 * but none of the higher level infrastructure supports
-		 * returning a specific error on buffer lookup failures.
-		 */
-		xfs_alert(btp->bt_mount,
-			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
-			  __func__, blkno, eofs);
-		return NULL;
-	}
-
 	/* get tree root */
 	pag = xfs_perag_get(btp->bt_mount,
 				xfs_daddr_to_agno(btp->bt_mount, blkno));


