Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbaCEP1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:27:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbaCEOYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Whitney <enwlinux@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 021/131] ext4: fix xfstest generic/299 block validity failures
Date: Wed,  5 Mar 2014 14:22:25 +0000
Message-Id: <1394029455-23128-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Whitney <enwlinux@gmail.com>

commit 15cc17678547676c82a5da9ccf357447333fc342 upstream.

Commit a115f749c1 (ext4: remove wait for unwritten extent conversion from
ext4_truncate) exposed a bug in ext4_ext_handle_uninitialized_extents().
It can be triggered by xfstest generic/299 when run on a test file
system created without a journal.  This test continuously fallocates and
truncates files to which random dio/aio writes are simultaneously
performed by a separate process.  The test completes successfully, but
if the test filesystem is mounted with the block_validity option, a
warning message stating that a logical block has been mapped to an
illegal physical block is posted in the kernel log.

The bug occurs when an extent is being converted to the written state
by ext4_end_io_dio() and ext4_ext_handle_uninitialized_extents()
discovers a mapping for an existing uninitialized extent. Although it
sets EXT4_MAP_MAPPED in map->m_flags, it fails to set map->m_pblk to
the discovered physical block number.  Because map->m_pblk is not
otherwise initialized or set by this function or its callers, its
uninitialized value is returned to ext4_map_blocks(), where it is
stored as a bogus mapping in the extent status tree.

Since map->m_pblk can accidentally contain illegal values that are
larger than the physical size of the file system,  calls to
check_block_validity() in ext4_map_blocks() that are enabled if the
block_validity mount option is used can fail, resulting in the logged
warning message.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 878338f..9b2d6e6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3833,6 +3833,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 		} else
 			err = ret;
 		map->m_flags |= EXT4_MAP_MAPPED;
+		map->m_pblk = newblock;
 		if (allocated > map->m_len)
 			allocated = map->m_len;
 		map->m_len = allocated;
-- 
1.9.0

