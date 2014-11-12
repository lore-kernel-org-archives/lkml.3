Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaKLCw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:52:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934495AbaKLBm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:42:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 108/203] ext4: fix oops when loading block bitmap failed
Date: Wed, 12 Nov 2014 10:16:18 +0900
Message-Id: <20141112011547.642516529@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 599a9b77ab289d85c2d5c8607624efbe1f552b0f upstream.

When we fail to load block bitmap in __ext4_new_inode() we will
dereference NULL pointer in ext4_journal_get_write_access(). So check
for error from ext4_read_block_bitmap().

Coverity-id: 989065
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -864,6 +864,10 @@ got:
 		struct buffer_head *block_bitmap_bh;
 
 		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
+		if (!block_bitmap_bh) {
+			err = -EIO;
+			goto out;
+		}
 		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
 		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
 		if (err) {


