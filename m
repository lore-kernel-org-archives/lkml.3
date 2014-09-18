Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaIRPEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:04:40 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44924 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbaIRPEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:04:38 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH] nilfs2: fix data loss with mmap()
Date: Thu, 18 Sep 2014 23:56:25 +0900
Message-Id: <1411052185-8118-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <1411052185-8118-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1411052185-8118-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Rohner <andreas.rohner@gmx.net>

This bug leads to reproducible silent data loss, despite the use of
msync(), sync() and a clean unmount of the file system. It is easily
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
remount. This can be reproduced a 100% of the time. The problem was
introduced with the following commit:

136e877 nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF
boundary

If the page was read with mpage_readpage() or mpage_readpages() for
example, then  it has no buffers attached to it. In that case
page_has_buffers(page) in nilfs_set_page_dirty() will be false.
Therefore nilfs_set_file_dirty() is never called and the pages are never
collected and never written to disk.

This patch fixes the problem by also calling nilfs_set_file_dirty() if
the page has no buffers attached to it.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Tested-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
---
 fs/nilfs2/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6252b17..9e3c525 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -219,10 +219,10 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 
 static int nilfs_set_page_dirty(struct page *page)
 {
+	struct inode *inode = page->mapping->host;
 	int ret = __set_page_dirty_nobuffers(page);
 
 	if (page_has_buffers(page)) {
-		struct inode *inode = page->mapping->host;
 		unsigned nr_dirty = 0;
 		struct buffer_head *bh, *head;
 
@@ -245,6 +245,10 @@ static int nilfs_set_page_dirty(struct page *page)
 
 		if (nr_dirty)
 			nilfs_set_file_dirty(inode, nr_dirty);
+	} else if (ret) {
+		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+
+		nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
-- 
1.7.9.4

