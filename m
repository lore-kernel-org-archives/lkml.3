Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaIOTwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:52:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbaIOTrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.10 62/71] CIFS: Fix wrong directory attributes after rename
Date: Mon, 15 Sep 2014 12:27:00 -0700
Message-Id: <20140915192640.765802025@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit b46799a8f28c43c5264ac8d8ffa28b311b557e03 upstream.

When we requests rename we also need to update attributes
of both source and target parent directories. Not doing it
causes generic/309 xfstest to fail on SMB2 mounts. Fix this
by marking these directories for force revalidating.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1647,6 +1647,12 @@ unlink_target:
 				    target_dentry, to_name);
 	}
 
+	/* force revalidate to go get info when needed */
+	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
+
+	source_dir->i_ctime = source_dir->i_mtime = target_dir->i_ctime =
+		target_dir->i_mtime = current_fs_time(source_dir->i_sb);
+
 cifs_rename_exit:
 	kfree(info_buf_source);
 	kfree(from_name);


