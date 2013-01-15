Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151Ab3AOWzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:55:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:47773 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934003Ab3AOWzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:55:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>,
        Eugene Shatokhin <eugene.shatokhin@rosalab.ru>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 16/71] ext4: fix memory leak in ext4_xattr_set_acl()s error path
Date: Tue, 15 Jan 2013 14:54:13 -0800
Message-Id: <20130115225341.614255634@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

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

---
 fs/ext4/acl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -450,8 +450,10 @@ ext4_xattr_set_acl(struct dentry *dentry
 
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


