Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaF1R6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:58:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaF1RxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.15 116/139] Btrfs: read inode size after acquiring the mutex when punching a hole
Date: Sat, 28 Jun 2014 10:47:57 -0700
Message-Id: <20140628174610.713332276@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@gmail.com>

commit a1a50f60a6bf4f861eb94793420274bc1ccd409a upstream.

In a previous change, commit 12870f1c9b2de7d475d22e73fd7db1b418599725,
I accidentally moved the roundup of inode->i_size to outside of the
critical section delimited by the inode mutex, which is not atomic and
not correct since the size can be changed by other task before we acquire
the mutex. Therefore fix it.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2200,13 +2200,14 @@ static int btrfs_punch_hole(struct inode
 	bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
 			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
-	u64 ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
+	u64 ino_size;
 
 	ret = btrfs_wait_ordered_range(inode, offset, len);
 	if (ret)
 		return ret;
 
 	mutex_lock(&inode->i_mutex);
+	ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
 	/*
 	 * We needn't truncate any page which is beyond the end of the file
 	 * because we are sure there is no data there.


