Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3CBDln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:41:43 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56670 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3CBDlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:41:40 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 5/5] f2fs: avoid extra ++ while returning from get_node_path
Date: Sat,  2 Mar 2013 12:41:31 +0900
Message-Id: <1362195691-20819-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In all the breaking conditions in get_node_path, 'n' is used to
track index in offset[] array, but while breaking out also, in all
paths n++ is done.
So, remove the ++ from breaking paths. Also, avoid
reset of 'level=0' in first case.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/node.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e24f747..d10085c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -320,15 +320,14 @@ static int get_node_path(long block, int offset[4], unsigned int noffset[4])
 	noffset[0] = 0;
 
 	if (block < direct_index) {
-		offset[n++] = block;
-		level = 0;
+		offset[n] = block;
 		goto got;
 	}
 	block -= direct_index;
 	if (block < direct_blks) {
 		offset[n++] = NODE_DIR1_BLOCK;
 		noffset[n] = 1;
-		offset[n++] = block;
+		offset[n] = block;
 		level = 1;
 		goto got;
 	}
@@ -336,7 +335,7 @@ static int get_node_path(long block, int offset[4], unsigned int noffset[4])
 	if (block < direct_blks) {
 		offset[n++] = NODE_DIR2_BLOCK;
 		noffset[n] = 2;
-		offset[n++] = block;
+		offset[n] = block;
 		level = 1;
 		goto got;
 	}
@@ -346,7 +345,7 @@ static int get_node_path(long block, int offset[4], unsigned int noffset[4])
 		noffset[n] = 3;
 		offset[n++] = block / direct_blks;
 		noffset[n] = 4 + offset[n - 1];
-		offset[n++] = block % direct_blks;
+		offset[n] = block % direct_blks;
 		level = 2;
 		goto got;
 	}
@@ -356,7 +355,7 @@ static int get_node_path(long block, int offset[4], unsigned int noffset[4])
 		noffset[n] = 4 + dptrs_per_blk;
 		offset[n++] = block / direct_blks;
 		noffset[n] = 5 + dptrs_per_blk + offset[n - 1];
-		offset[n++] = block % direct_blks;
+		offset[n] = block % direct_blks;
 		level = 2;
 		goto got;
 	}
@@ -371,7 +370,7 @@ static int get_node_path(long block, int offset[4], unsigned int noffset[4])
 		noffset[n] = 7 + (dptrs_per_blk * 2) +
 			      offset[n - 2] * (dptrs_per_blk + 1) +
 			      offset[n - 1];
-		offset[n++] = block % direct_blks;
+		offset[n] = block % direct_blks;
 		level = 3;
 		goto got;
 	} else {
-- 
1.7.9.5

