Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab3AOWuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:50:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:45946 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab3AOWuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Beregalov <a.beregalov@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
Subject: [ 061/171] ext4: lock i_mutex when truncating orphan inodes
Date: Tue, 15 Jan 2013 14:43:46 -0800
Message-Id: <20130115224317.806265462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 721e3eba21e43532e438652dd8f1fcdfce3187e7 upstream.

Commit c278531d39 added a warning when ext4_flush_unwritten_io() is
called without i_mutex being taken.  It had previously not been taken
during orphan cleanup since races weren't possible at that point in
the mount process, but as a result of this c278531d39, we will now see
a kernel WARN_ON in this case.  Take the i_mutex in
ext4_orphan_cleanup() to suppress this warning.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2120,7 +2120,9 @@ static void ext4_orphan_cleanup(struct s
 				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
+			mutex_lock(&inode->i_mutex);
 			ext4_truncate(inode);
+			mutex_unlock(&inode->i_mutex);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,


