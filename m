Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3APAeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:34:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:41473 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706Ab3AOW2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ 055/221] ext4: fix possible use after free with metadata csum
Date: Tue, 15 Jan 2013 10:49:42 -0800
Message-Id: <20130115185001.999847521@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -762,7 +762,6 @@ got:
 
 		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
 		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
-		brelse(block_bitmap_bh);
 
 		/* recheck and clear flag under lock if we still need to */
 		ext4_lock_group(sb, group);
@@ -775,6 +774,7 @@ got:
 			ext4_group_desc_csum_set(sb, group, gdp);
 		}
 		ext4_unlock_group(sb, group);
+		brelse(block_bitmap_bh);
 
 		if (err)
 			goto fail;


