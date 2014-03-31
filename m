Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaCaNgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:36:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbaCaNYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 49/71] Btrfs: fix data corruption when reading/updating compressed extents
Date: Mon, 31 Mar 2014 14:22:55 +0100
Message-Id: <1396272197-13394-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe David Borba Manana <fdmanana@gmail.com>

commit a2aa75e18a21b21952dc6daa9bac7c9f4426f81f upstream.

When using a mix of compressed file extents and prealloc extents, it
is possible to fill a page of a file with random, garbage data from
some unrelated previous use of the page, instead of a sequence of zeroes.

A simple sequence of steps to get into such case, taken from the test
case I made for xfstests, is:

   _scratch_mkfs
   _scratch_mount "-o compress-force=lzo"
   $XFS_IO_PROG -f -c "pwrite -S 0x06 -b 18670 266978 18670" $SCRATCH_MNT/foobar
   $XFS_IO_PROG -c "falloc 26450 665194" $SCRATCH_MNT/foobar
   $XFS_IO_PROG -c "truncate 542872" $SCRATCH_MNT/foobar
   $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar

This results in the following file items in the fs tree:

   item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
       inode generation 6 transid 6 size 542872 block group 0 mode 100600
   item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
       inode ref index 2 namelen 6 name: foobar
   item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
       extent data disk byte 0 nr 0 gen 6
       extent data offset 0 nr 24576 ram 266240
       extent compression 0
   item 7 key (257 EXTENT_DATA 24576) itemoff 15757 itemsize 53
       prealloc data disk byte 12849152 nr 241664 gen 6
       prealloc data offset 0 nr 241664
   item 8 key (257 EXTENT_DATA 266240) itemoff 15704 itemsize 53
       extent data disk byte 12845056 nr 4096 gen 6
       extent data offset 0 nr 20480 ram 20480
       extent compression 2
   item 9 key (257 EXTENT_DATA 286720) itemoff 15651 itemsize 53
       prealloc data disk byte 13090816 nr 405504 gen 6
       prealloc data offset 0 nr 258048

The on disk extent at offset 266240 (which corresponds to 1 single disk block),
contains 5 compressed chunks of file data. Each of the first 4 compress 4096
bytes of file data, while the last one only compresses 3024 bytes of file data.
Therefore a read into the file region [285648 ; 286720[ (length = 4096 - 3024 =
1072 bytes) should always return zeroes (our next extent is a prealloc one).

The solution here is the compression code path to zero the remaining (untouched)
bytes of the last page it uncompressed data into, as the information about how
much space the file data consumes in the last page is not known in the upper layer
fs/btrfs/extent_io.c:__do_readpage(). In __do_readpage we were correctly zeroing
the remainder of the page but only if it corresponds to the last page of the inode
and if the inode's size is not a multiple of the page size.

This would cause not only returning random data on reads, but also permanently
storing random data when updating parts of the region that should be zeroed.
For the example above, it means updating a single byte in the region [285648 ; 286720[
would store that byte correctly but also store random data on disk.

A test case for xfstests follows soon.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/compression.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 86eff48..503a6bd 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -995,6 +995,8 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 		bytes = min(bytes, working_bytes);
 		kaddr = kmap_atomic(page_out);
 		memcpy(kaddr + *pg_offset, buf + buf_offset, bytes);
+		if (*pg_index == (vcnt - 1) && *pg_offset == 0)
+			memset(kaddr + bytes, 0, PAGE_CACHE_SIZE - bytes);
 		kunmap_atomic(kaddr);
 		flush_dcache_page(page_out);
 
-- 
1.9.1

