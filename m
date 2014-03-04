Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaCDVm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:42:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaCDUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.13 009/172] ext4: fix xfstest generic/299 block validity failures
Date: Tue,  4 Mar 2014 12:01:33 -0800
Message-Id: <20140304200300.004495685@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3906,6 +3906,7 @@ ext4_ext_handle_uninitialized_extents(ha
 		} else
 			err = ret;
 		map->m_flags |= EXT4_MAP_MAPPED;
+		map->m_pblk = newblock;
 		if (allocated > map->m_len)
 			allocated = map->m_len;
 		map->m_len = allocated;


