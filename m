Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaJOVXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:23:16 -0400
Received: from mail.ispras.ru ([83.149.199.45]:44680 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaJOVXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:23:15 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Dave Chinner <david@fromorbit.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, spruce-project@linuxtesting.org
Subject: [PATCH] xfs: fix deadlock on failure path in xfs_setattr_nonsize()
Date: Wed, 15 Oct 2014 23:22:48 +0200
Message-Id: <1413408168-3086-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If xfs_trans_reserve() fails, xfs_setattr_nonsize() does not deallocate
the transaction and does not release "freeze" lock. That leads to the
following warning from lockdep:
  [ BUG: lock held when returning to user space! ]
  ------------------------------------------------
  fs-driver-tests/7127 is leaving the kernel with locks still held!
  1 lock held by fs-driver-tests/7127:
   #0:  (sb_internal){.+.+.+}, at: [<ffffffffa0389a44>] xfs_trans_alloc+0x24/0x40 [xfs]

The patch adds xfs_trans_cancel() on the failure path.

Found by Linux File System Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/xfs/xfs_iops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 72129493e9d3..e2e785eec831 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -599,8 +599,10 @@ xfs_setattr_nonsize(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
-	if (error)
+	if (error) {
+		xfs_trans_cancel(tp, 0);
 		goto out_dqrele;
+	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-- 
1.9.1

