Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab3LHN76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 08:59:58 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47795 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab3LHN7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 08:59:47 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: viro@zeniv.linux.org.uk, dchinner@fromorbit.com, bpm@sgi.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v4 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Date: Sun,  8 Dec 2013 22:59:24 +0900
Message-Id: <1386511164-3251-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch series is in response of the following post:
http://lwn.net/Articles/556136/
"ext4: introduce two new ioctls"

Dave chinner suggested that truncate_block_range
(which was one of the ioctls name) should be an fallocate operation
and not any fs specific ioctl, hence we add this functionality to fallocate.

This patch series introduces new flag FALLOC_FL_COLLAPSE_RANGE for fallocate
and implements it for XFS and Ext4.

The semantics of this flag are following:
1) It collapses the range lying between offset and length by removing any data
   blocks which are present in this range and than updates all the logical
   offsets of extents beyond "offset + len" to nullify the hole created by
   removing blocks. In short, it does not leave a hole.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Collaspe range does not work beyond i_size.

This new functionality of collapsing range could be used by media editing tools
which does non linear editing to quickly purge and edit parts of a media file.
This will immensely improve the performance of these operations.
The limitation of fs block size aligned offsets can be easily handled
by media codecs which are encapsulated in a conatiner as they have to
just change the offset to next keyframe value to match the proper alignment.

Change log
v4:
 - vfs: Move block size aligned check from VFS layer to FS specific layer.
 - vfs: update comments for FALLOC_FL_COLLAPSE_RANGE in user visible header file.
 - xfs: update comments for xfs_bmap_shift_extents and change variable name
        to more reasonable name.
 - xfs: add ASSERTs for pointers in XFS patch.
 - xfs: drop all the xfs_bmbt_get*() wrappers.
 - xfs and ext4: change return errno from EFSCORRUPTED to EINVAL
                 when hole is not large enough to shift.
 - xfs: remove extents from on-disk btree also in case of merge.
 - xfstest: separate shared/316 test to shared/001 ~ 004 in xfstest.
 - xfstest: update multi collapse test shared/005 for block size less than page size case.
 - manpage: update description.

v3:
 Fix checkpatch.pl errors

v2:
 Fix review points from Dave Chinner.

 Namjae Jeon (10):
  fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
  xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
  ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
  xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
  xfstest: shared/001: Standard collapse range tests
  xfstest: shared/002: Delayed allocation collapse range
  xfstest: shared/003: Multi collapse range tests
  xfstest: shared/004: Delayed allocation multi collapse
  xfstest: shared/005: Test multiple fallocate collapse
  manpage: update FALLOC_FL_COLLAPSE_RANGE flag in fallocate
-- 
1.7.9.5

