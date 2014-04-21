Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaDUEhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:37:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaDUEfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:35:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.13 21/32] ext4: fix error return from ext4_ext_handle_uninitialized_extents()
Date: Sun, 20 Apr 2014 19:13:38 -0700
Message-Id: <20140421021136.769167485@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Whitney <enwlinux@gmail.com>

commit ce37c42919608e96ade3748fe23c3062a0a966c5 upstream.

Commit 3779473246 breaks the return of error codes from
ext4_ext_handle_uninitialized_extents() in ext4_ext_map_blocks().  A
portion of the patch assigns that function's signed integer return
value to an unsigned int.  Consequently, negatively valued error codes
are lost and can be treated as a bogus allocated block count.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4128,7 +4128,7 @@ int ext4_ext_map_blocks(handle_t *handle
 	struct ext4_extent newex, *ex, *ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
-	int free_on_err = 0, err = 0, depth;
+	int free_on_err = 0, err = 0, depth, ret;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0;
 	struct ext4_allocation_request ar;
@@ -4189,9 +4189,13 @@ int ext4_ext_map_blocks(handle_t *handle
 			if (!ext4_ext_is_uninitialized(ex))
 				goto out;
 
-			allocated = ext4_ext_handle_uninitialized_extents(
+			ret = ext4_ext_handle_uninitialized_extents(
 				handle, inode, map, path, flags,
 				allocated, newblock);
+			if (ret < 0)
+				err = ret;
+			else
+				allocated = ret;
 			goto out3;
 		}
 	}


