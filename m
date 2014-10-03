Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbaJCXHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:07:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940AbaJCWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Rohner <andreas.rohner@gmx.net>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 184/238] nilfs2: fix data loss with mmap()
Date: Fri,  3 Oct 2014 14:31:39 -0700
Message-Id: <20141003212919.555993883@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Rohner <andreas.rohner@gmx.net>

commit 56d7acc792c0d98f38f22058671ee715ff197023 upstream.

This bug leads to reproducible silent data loss, despite the use of
msync(), sync() and a clean unmount of the file system.  It is easily
reproducible with the following script:

  ----------------[BEGIN SCRIPT]--------------------
  mkfs.nilfs2 -f /dev/sdb
  mount /dev/sdb /mnt

  dd if=/dev/zero bs=1M count=30 of=/mnt/testfile

  umount /mnt
  mount /dev/sdb /mnt
  CHECKSUM_BEFORE="$(md5sum /mnt/testfile)"

  /root/mmaptest/mmaptest /mnt/testfile 30 10 5

  sync
  CHECKSUM_AFTER="$(md5sum /mnt/testfile)"
  umount /mnt
  mount /dev/sdb /mnt
  CHECKSUM_AFTER_REMOUNT="$(md5sum /mnt/testfile)"
  umount /mnt

  echo "BEFORE MMAP:\t$CHECKSUM_BEFORE"
  echo "AFTER MMAP:\t$CHECKSUM_AFTER"
  echo "AFTER REMOUNT:\t$CHECKSUM_AFTER_REMOUNT"
  ----------------[END SCRIPT]--------------------

The mmaptest tool looks something like this (very simplified, with
error checking removed):

  ----------------[BEGIN mmaptest]--------------------
  data = mmap(NULL, file_size - file_offset, PROT_READ | PROT_WRITE,
              MAP_SHARED, fd, file_offset);

  for (i = 0; i < write_count; ++i) {
        memcpy(data + i * 4096, buf, sizeof(buf));
        msync(data, file_size - file_offset, MS_SYNC))
  }
  ----------------[END mmaptest]--------------------

The output of the script looks something like this:

  BEFORE MMAP:    281ed1d5ae50e8419f9b978aab16de83  /mnt/testfile
  AFTER MMAP:     6604a1c31f10780331a6850371b3a313  /mnt/testfile
  AFTER REMOUNT:  281ed1d5ae50e8419f9b978aab16de83  /mnt/testfile

So it is clear, that the changes done using mmap() do not survive a
remount.  This can be reproduced a 100% of the time.  The problem was
introduced in commit 136e8770cd5d ("nilfs2: fix issue of
nilfs_set_page_dirty() for page at EOF boundary").

If the page was read with mpage_readpage() or mpage_readpages() for
example, then it has no buffers attached to it.  In that case
page_has_buffers(page) in nilfs_set_page_dirty() will be false.
Therefore nilfs_set_file_dirty() is never called and the pages are never
collected and never written to disk.

This patch fixes the problem by also calling nilfs_set_file_dirty() if the
page has no buffers attached to it.

[akpm@linux-foundation.org: s/PAGE_SHIFT/PAGE_CACHE_SHIFT/]
Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Tested-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nilfs2/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -24,6 +24,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
+#include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/aio.h>
 #include "nilfs.h"
@@ -219,10 +220,10 @@ static int nilfs_writepage(struct page *
 
 static int nilfs_set_page_dirty(struct page *page)
 {
+	struct inode *inode = page->mapping->host;
 	int ret = __set_page_dirty_nobuffers(page);
 
 	if (page_has_buffers(page)) {
-		struct inode *inode = page->mapping->host;
 		unsigned nr_dirty = 0;
 		struct buffer_head *bh, *head;
 
@@ -245,6 +246,10 @@ static int nilfs_set_page_dirty(struct p
 
 		if (nr_dirty)
 			nilfs_set_file_dirty(inode, nr_dirty);
+	} else if (ret) {
+		unsigned nr_dirty = 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+		nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }


