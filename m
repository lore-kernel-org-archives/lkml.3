Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3CATqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3CATqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 24/46] ext4: check bh in ext4_read_block_bitmap()
Date: Fri,  1 Mar 2013 11:45:12 -0800
Message-Id: <20130301194434.776456568@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eryu Guan <guaneryu@gmail.com>

commit 15b49132fc972c63894592f218ea5a9a61b1a18f upstream.

Validate the bh pointer before using it, since
ext4_read_block_bitmap_nowait() might return NULL.

I've seen this in fsfuzz testing.

 EXT4-fs error (device loop0): ext4_read_block_bitmap_nowait:385: comm touch: Cannot get buffer for block bitmap - block_group = 0, block_bitmap = 3925999616
 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<ffffffff8121de25>] ext4_wait_block_bitmap+0x25/0xe0
 ...
 Call Trace:
  [<ffffffff8121e1e5>] ext4_read_block_bitmap+0x35/0x60
  [<ffffffff8125e9c6>] ext4_free_blocks+0x236/0xb80
  [<ffffffff811d0d36>] ? __getblk+0x36/0x70
  [<ffffffff811d0a5f>] ? __find_get_block+0x8f/0x210
  [<ffffffff81191ef3>] ? kmem_cache_free+0x33/0x140
  [<ffffffff812678e5>] ext4_xattr_release_block+0x1b5/0x1d0
  [<ffffffff812679be>] ext4_xattr_delete_inode+0xbe/0x100
  [<ffffffff81222a7c>] ext4_free_inode+0x7c/0x4d0
  [<ffffffff812277b8>] ? ext4_mark_inode_dirty+0x88/0x230
  [<ffffffff8122993c>] ext4_evict_inode+0x32c/0x490
  [<ffffffff811b8cd7>] evict+0xa7/0x1c0
  [<ffffffff811b8ed3>] iput_final+0xe3/0x170
  [<ffffffff811b8f9e>] iput+0x3e/0x50
  [<ffffffff812316fd>] ext4_add_nondir+0x4d/0x90
  [<ffffffff81231d0b>] ext4_create+0xeb/0x170
  [<ffffffff811aae9c>] vfs_create+0xac/0xd0
  [<ffffffff811ac845>] lookup_open+0x185/0x1c0
  [<ffffffff8129e3b9>] ? selinux_inode_permission+0xa9/0x170
  [<ffffffff811acb54>] do_last+0x2d4/0x7a0
  [<ffffffff811af743>] path_openat+0xb3/0x480
  [<ffffffff8116a8a1>] ? handle_mm_fault+0x251/0x3b0
  [<ffffffff811afc49>] do_filp_open+0x49/0xa0
  [<ffffffff811bbaad>] ? __alloc_fd+0xdd/0x150
  [<ffffffff8119da28>] do_sys_open+0x108/0x1f0
  [<ffffffff8119db51>] sys_open+0x21/0x30
  [<ffffffff81618959>] system_call_fastpath+0x16/0x1b

Also fix comment for ext4_read_block_bitmap_nowait()

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/balloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -326,7 +326,7 @@ err_out:
 	return 0;
 }
 /**
- * ext4_read_block_bitmap()
+ * ext4_read_block_bitmap_nowait()
  * @sb:			super block
  * @block_group:	given block group
  *
@@ -422,6 +422,8 @@ ext4_read_block_bitmap(struct super_bloc
 	struct buffer_head *bh;
 
 	bh = ext4_read_block_bitmap_nowait(sb, block_group);
+	if (!bh)
+		return NULL;
 	if (ext4_wait_block_bitmap(sb, block_group, bh)) {
 		put_bh(bh);
 		return NULL;


