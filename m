Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3FPWVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:21:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46470 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764Ab3FPWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alexander Beregalov" <a.beregalov@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, "Zheng Liu" <wenqing.lz@taobao.com>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.220610690@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [28/83] ext4: lock i_mutex when truncating orphan inodes
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2260,7 +2260,9 @@ static void ext4_orphan_cleanup(struct s
 				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
+			mutex_lock(&inode->i_mutex);
 			ext4_truncate(inode);
+			mutex_unlock(&inode->i_mutex);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,

