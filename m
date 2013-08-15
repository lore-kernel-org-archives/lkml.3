Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3HOFxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:53:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3HOFxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:53:53 -0400
Date: Thu, 15 Aug 2013 08:53:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] xfs: check for underflow in xfs_iformat_fork()
Message-ID: <20130815055338.GC23580@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "di_size" variable comes from the disk and it's a signed 64 bit.
We check the upper limit but we should check for negative numbers as
well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 123971b..849fc70 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -167,7 +167,8 @@ xfs_iformat_fork(
 			}
 
 			di_size = be64_to_cpu(dip->di_size);
-			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
+			if (unlikely(di_size < 0 ||
+				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_warn(ip->i_mount,
 			"corrupt inode %Lu (bad size %Ld for local inode).",
 					(unsigned long long) ip->i_ino,
