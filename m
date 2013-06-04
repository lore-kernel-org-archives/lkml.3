Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3FDWnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:12 -0400
Received: from 1wt.eu ([62.212.114.60]:35646 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab3FDWnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:04 -0400
Message-Id: <20130604172135.325390178@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Allison Henderson <achender@us.ibm.com>, "Theodore Tso" <tytso@mit.edu>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 121/184] ext4: dont dereference null pointer when
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 make_indexed_dir() fails

From: Allison Henderson <achender@linux.vnet.ibm.com>

Fix for a null pointer bug found while running punch hole tests

Signed-off-by: Allison Henderson <achender@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 6976a6f2acde2b0443cd64f1d08af90630e4ce81)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index afe3148..902f69b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1457,6 +1457,10 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
+
+	ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	ext4_handle_dirty_metadata(handle, dir, bh);
+
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
 	if (!de) {
 		/*
@@ -1465,8 +1469,6 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		 * with corrupted filesystem.
 		 */
 		ext4_mark_inode_dirty(handle, dir);
-		ext4_handle_dirty_metadata(handle, dir, frame->bh);
-		ext4_handle_dirty_metadata(handle, dir, bh);
 		dx_release(frames);
 		return retval;
 	}
-- 
1.7.12.2.21.g234cd45.dirty



