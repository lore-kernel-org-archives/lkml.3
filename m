Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbaEPM5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:57:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49535 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kazuya Mio" <k-mio@sx.jp.nec.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Fri, 16 May 2014 13:47:20 +0100
Message-ID: <lsq.1400244440.666503446@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 01/34] ext4: FIBMAP ioctl causes BUG_ON due to handle
 EXT_MAX_BLOCKS
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuya Mio <k-mio@sx.jp.nec.com>

commit 4adb6ab3e0fa71363a5ef229544b2d17de6600d7 upstream.

When we try to get 2^32-1 block of the file which has the extent
(ee_block=2^32-2, ee_len=1) with FIBMAP ioctl, it causes BUG_ON
in ext4_ext_put_gap_in_cache().

To avoid the problem, ext4_map_blocks() needs to check the file logical block
number. ext4_ext_put_gap_in_cache() called via ext4_map_blocks() cannot
handle 2^32-1 because the maximum file logical block number is 2^32-2.

Note that ext4_ind_map_blocks() returns -EIO when the block number is invalid.
So ext4_map_blocks() should also return the same errno.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -481,6 +481,11 @@ int ext4_map_blocks(handle_t *handle, st
 	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
+
+	/* We can handle the block number less than EXT_MAX_BLOCKS */
+	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
+		return -EIO;
+
 	/*
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.

