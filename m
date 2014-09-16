Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaIPM7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:59:53 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:45553 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIPM7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:59:41 -0400
Date: Tue, 16 Sep 2014 08:59:41 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1798564920.23378380.1410872381622.JavaMail.zimbra@redhat.com>
In-Reply-To: <1501522376.20961158.1410449372237.JavaMail.zimbra@redhat.com>
Subject: [PATCH][try5] fs: if block_map clears buffer_holesize bit skip hole
 size from b_size
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF32 (Linux)/8.0.6_GA_5922)
Thread-Topic: if block_map clears buffer_holesize bit skip hole size from b_size
Thread-Index: 9ncowILXcLR7esL4QZ0HKZeBhsoQUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've previously sent this patch to linux-fsdevel (and Viro) and gotten
little to no response, so I thought I'd send it here.

The problem:
If you do a fiemap operation on a very large sparse file, it can take
an extremely long amount of time (we're talking days here) because
function __generic_block_fiemap does a block-for-block search when it
encounters a hole.

The solution:
Allow the underlying file system to return the hole size so that function
__generic_block_fiemap can quickly skip the hole. This will be followed
by another patch to GFS2 that takes advantage of this new flag to speed
up its fiemap on sparse files. Other file systems can do the same as they
see fit. For GFS2, the time it takes to skip a 1PB hole in a sparse file
goes from several days to milliseconds.

Patch description:

This patch changes function __generic_block_fiemap so that it sets a new
buffer_holesize bit. The new bit signals to the underlying file system
to return a hole size from its block_map function (if possible) in the
event that a hole is encountered at the requested block. If the block_map
function encounters a hole, and clears buffer_holesize, fiemap takes the
returned b_size to be the size of the hole, in bytes. It then skips the
hole and moves to the next block. This may be repeated several times
in a row, especially for large holes, due to possible limitations of the
fs-specific block_map function. This is still much faster than trying
each block individually when large holes are encountered. If the
block_map function does not clear buffer_holesize, the request for
holesize has been ignored, and it falls back to today's method of doing a
block-by-block search for the next valid block.

Regards,

Bob Peterson
Red Hat File Systems

Signed-off-by: Bob Peterson <rpeterso@redhat.com> 
---
 fs/ioctl.c                  | 7 ++++++-
 include/linux/buffer_head.h | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad..ae63b1f 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -291,13 +291,18 @@ int __generic_block_fiemap(struct inode *inode,
 		memset(&map_bh, 0, sizeof(struct buffer_head));
 		map_bh.b_size = len;
 
+		set_buffer_holesize(&map_bh); /* return hole size if able */
 		ret = get_block(inode, start_blk, &map_bh, 0);
 		if (ret)
 			break;
 
 		/* HOLE */
 		if (!buffer_mapped(&map_bh)) {
-			start_blk++;
+			if (buffer_holesize(&map_bh)) /* holesize ignored */
+				start_blk++;
+			else
+				start_blk += logical_to_blk(inode,
+							    map_bh.b_size);
 
 			/*
 			 * We want to handle the case where there is an
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 324329c..b8ce396 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -37,6 +37,7 @@ enum bh_state_bits {
 	BH_Meta,	/* Buffer contains metadata */
 	BH_Prio,	/* Buffer should be submitted with REQ_PRIO */
 	BH_Defer_Completion, /* Defer AIO completion to workqueue */
+	BH_Holesize,    /* Return hole size (and clear) if possible */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -128,6 +129,7 @@ BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(Meta, meta)
+BUFFER_FNS(Holesize, holesize)
 BUFFER_FNS(Prio, prio)
 BUFFER_FNS(Defer_Completion, defer_completion)
 
