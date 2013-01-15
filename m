Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab3AOX4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:56:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:45507 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758741Ab3AOWtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:49:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ 029/171] ext4: fix possible use after free with metadata csum
Date: Tue, 15 Jan 2013 14:43:14 -0800
Message-Id: <20130115224315.514942838@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit aeb1e5d69a5be592e86a926be73efb38c55af404 upstream.

Commit fa77dcfafeaa introduces block bitmap checksum calculation into
ext4_new_inode() in the case that block group was uninitialized.
However we brelse() the bitmap buffer before we attempt to checksum it
so we have no guarantee that the buffer is still there.

Fix this by releasing the buffer after the possible checksum
computation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -734,7 +734,6 @@ got:
 
 		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
 		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
-		brelse(block_bitmap_bh);
 
 		/* recheck and clear flag under lock if we still need to */
 		ext4_lock_group(sb, group);
@@ -746,6 +745,7 @@ got:
 								gdp);
 		}
 		ext4_unlock_group(sb, group);
+		brelse(block_bitmap_bh);
 
 		if (err)
 			goto fail;


