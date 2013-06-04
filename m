Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3FDWqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:46:17 -0400
Received: from 1wt.eu ([62.212.114.60]:35935 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab3FDWov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:51 -0400
Message-Id: <20130604172135.408844518@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>,
        "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 123/184] ext4: fix memory leak in ext4_xattr_set_acl()s
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 error path

From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>

commit 24ec19b0ae83a385ad9c55520716da671274b96c upstream.

In ext4_xattr_set_acl(), if ext4_journal_start() returns an error,
posix_acl_release() will not be called for 'acl' which may result in a
memory leak.

This patch fixes that.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/acl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 0df88b2..d29a06b 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -454,8 +454,10 @@ ext4_xattr_set_acl(struct inode *inode, int type, const void *value,
 
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
1.7.12.2.21.g234cd45.dirty



