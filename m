Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaBEUV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:21:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:55484 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbaBEUHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 174/213] ext4: fix memory leak in ext4_xattr_set_acl()'s error path
Date: Wed, 5 Feb 2014 15:02:09 -0500
Message-ID: <1391630568-49251-175-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 24ec19b0ae83a385ad9c55520716da671274b96c upstream.

In ext4_xattr_set_acl(), if ext4_journal_start() returns an error,
posix_acl_release() will not be called for 'acl' which may result in a
memory leak.

This patch fixes that.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/acl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 8a2a29d35a6f..f14fa786dad0 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -442,8 +442,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
 
 retry:
 	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		error = PTR_ERR(handle);
+		goto release_and_out;
+	}
 	error = ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
 	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.8.5.2

