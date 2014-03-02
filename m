Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaCBOJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:09:34 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60985 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaCBOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:09:30 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 4/6] fat: fallback to buffered write in case of fallocated region on direct IO
Date: Sun,  2 Mar 2014 23:09:21 +0900
Message-Id: <1393769361-3574-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

For normal cases of direct IO write, trying to seek to location greater
than file size, makes it fall back to buffered write to fill that region.
Similarly, in case for write in Fallocated region, make it fall to
buffered write.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index a594dae..9509d07 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -229,6 +229,13 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 		loff_t size = offset + iov_length(iov, nr_segs);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
+
+		/*
+		 * In case of writing in fallocated region, return 0 and
+		 * fallback to buffered write.
+		 */
+		if (MSDOS_I(inode)->i_disksize > MSDOS_I(inode)->mmu_private)
+			return 0;
 	}
 
 	/*
-- 
1.7.11-rc0


