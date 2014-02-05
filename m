Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaBEUWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:22:45 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48530 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaBEUHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Allison Henderson <achender@linux.vnet.ibm.com>,
        Allison Henderson <achender@us.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 173/213] ext4: don't dereference null pointer when make_indexed_dir() fails
Date: Wed, 5 Feb 2014 15:02:08 -0500
Message-ID: <1391630568-49251-174-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Allison Henderson <achender@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6976a6f2acde2b0443cd64f1d08af90630e4ce81 upstream.

Fix for a null pointer bug found while running punch hole tests

Signed-off-by: Allison Henderson <achender@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index caa3c77f1743..41198b355a26 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1451,6 +1451,10 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
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
@@ -1459,8 +1463,6 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		 * with corrupted filesystem.
 		 */
 		ext4_mark_inode_dirty(handle, dir);
-		ext4_handle_dirty_metadata(handle, dir, frame->bh);
-		ext4_handle_dirty_metadata(handle, dir, bh);
 		dx_release(frames);
 		return retval;
 	}
-- 
1.8.5.2

