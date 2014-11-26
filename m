Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaKZX6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:58:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34659 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaKZX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:58:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC v2 2/2] fs: correctly check for signed integer overflow in vfs_fallocate
Date: Wed, 26 Nov 2014 18:58:02 -0500
Message-Id: <1417046282-31825-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>
References: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both "offset" and "len" are signed integers who's addition may overflow
and trigger undefined behaviour.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/open.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 813be03..33d5cae 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -287,7 +287,8 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -ENODEV;
 
 	/* Check for wrap through zero too */
-	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
+	if (check_add_overflow(offset, len) ||
+	   (offset + len) > inode->i_sb->s_maxbytes)
 		return -EFBIG;
 
 	if (!file->f_op->fallocate)
-- 
1.7.10.4

