Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbaKLBgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:36:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbaKLBgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Jie Liu <jeff.u.liu@gmail.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.17 312/319] xfs: Check error during inode btree iteration in xfs_bulkstat()
Date: Wed, 12 Nov 2014 10:17:30 +0900
Message-Id: <20141112011044.484436529@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 7a19dee116c8fae7ba7a778043c245194289f5a2 upstream.

xfs_bulkstat() doesn't check error return from xfs_btree_increment(). In
case of specific fs corruption that could result in xfs_bulkstat()
entering an infinite loop because we would be looping over the same
chunk over and over again. Fix the problem by checking the return value
and terminating the loop properly.

Coverity-id: 1231338
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jie Liu <jeff.u.liu@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_itable.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -474,6 +474,10 @@ xfs_bulkstat(
 			 */
 			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			error = xfs_btree_increment(cur, 0, &tmp);
+			if (error) {
+				end_of_ag = 1;
+				goto del_cursor;
+			}
 			cond_resched();
 		}
 


