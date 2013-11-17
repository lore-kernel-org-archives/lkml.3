Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3KQLim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:38:42 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43240 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3KQLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:38:31 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v2 4/5] fat: fallback to buffered write in case of fallocatded region on direct IO
Date: Sun, 17 Nov 2013 20:38:23 +0900
Message-Id: <1384688303-2969-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

For normal cases of direct IO write, trying to seek to location greater
than file size, makes it fall back to buffered write to fill that region.
Similarly, in case for write in Fallocated region, make it fall
to buffered write.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 12a37a9..c9fb9b6 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -217,6 +217,14 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 		loff_t size = offset + iov_iter_count(iter);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
+
+		/*
+		 * In case of writing in fallocated region, return 0 and
+		 * fallback to buffered write.
+		 */
+		if (MSDOS_I(inode)->i_disksize >
+		    round_up(i_size_read(inode), inode->i_sb->s_blocksize))
+			return 0;
 	}
 
 	/*
-- 
1.7.9.5

