Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaFJTwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:52:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35431 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbaFJTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/160] ext4: avoid possible overflow in ext4_map_blocks()
Date: Tue, 10 Jun 2014 12:44:57 -0700
Message-Id: <1402429600-20477-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit e861b5e9a47bd8c6a7491a2b9f6e9a230b1b8e86 upstream.

The ext4_map_blocks() function returns the number of blocks which
satisfying the caller's request.  This number of blocks requested by
the caller is specified by an unsigned integer, but the return value
of ext4_map_blocks() is a signed integer (to accomodate error codes
per the kernel's standard error signalling convention).

Historically, overflows could never happen since mballoc() will refuse
to allocate more than 2048 blocks at a time (which is something we
should fix), and if the blocks were already allocated, the fact that
there would be some number of intervening metadata blocks pretty much
guaranteed that there could never be a contiguous region of data
blocks that was greater than 2**31 blocks.

However, this is now possible if there is a file system which is a bit
bigger than 8TB, and is created using the new mke2fs hugeblock
feature, which can create a perfectly contiguous file.  In that case,
if a userspace program attempted to call fallocate() on this already
fully allocated file, it's possible that ext4_map_blocks() could
return a number large enough that it would overflow a signed integer,
resulting in a ext4 thinking that the ext4_map_blocks() call had
failed with some strange error code.

Since ext4_map_blocks() is always free to return a smaller number of
blocks than what was requested by the caller, fix this by capping the
number of blocks that ext4_map_blocks() will ever try to map to 2**31
- 1.  In practice this should never get hit, except by someone
deliberately trying to provke the above-described bug.

Thanks to the PaX team for asking whethre this could possibly happen
in some off-line discussions about using some static code checking
technology they are developing to find bugs in kernel code.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3617e33..18e1871 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -515,6 +515,12 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
 
+	/*
+	 * ext4_map_blocks returns an int, and m_len is an unsigned int
+	 */
+	if (unlikely(map->m_len > INT_MAX))
+		map->m_len = INT_MAX;
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
 		ext4_es_lru_add(inode);
-- 
1.9.1

