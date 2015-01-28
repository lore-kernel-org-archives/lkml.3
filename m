Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbbA1E5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:57:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:39423 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815AbbA1EVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:03 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 77/91] ext4: avoid trying to kfree an ERR_PTR pointer
Date: Wed, 28 Jan 2015 12:08:41 +0800
Message-Id: <1422418236-12852-154-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit a9cfcd63e8d206ce4235c355d857c4fbdf0f4587 upstream.

Thanks to Dan Carpenter for extending smatch to find bugs like this.
(This was found using a development version of smatch.)

Fixes: 36de928641ee48b2078d3fe9514242aaa2f92013
Reported-by: Dan Carpenter <dan.carpenter@oracle.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[lizf: Backported to 3.4:
- s/new.bh/new_bh/
- drop the change to ext4_cross_rename()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/namei.c  | 1 +
 fs/ext4/resize.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a2efbda..665e55c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2452,6 +2452,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name, &new_de);
 	if (IS_ERR(new_bh)) {
 		retval = PTR_ERR(new_bh);
+		new_bh = NULL;
 		goto end_rename;
 	}
 	if (new_bh) {
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 50992c3..a43e43c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -528,6 +528,7 @@ handle_bb:
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 		if (ext4_bg_has_super(sb, group)) {
@@ -556,6 +557,7 @@ handle_ib:
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 
-- 
1.9.1

