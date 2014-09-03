Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555AbaICW24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:28:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934479AbaICW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:28:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.16 096/125] ext4: fix incorect journal credits reservation in ext4_zero_range
Date: Wed,  3 Sep 2014 15:07:33 -0700
Message-Id: <20140903220626.559692334@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 69dc9536405213c1d545fcace1fc15c481d00aae upstream.

Currently we reserve only 4 blocks but in worst case scenario
ext4_zero_partial_blocks() may want to zeroout and convert two
non adjacent blocks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4730,6 +4730,7 @@ static long ext4_zero_range(struct file
 	loff_t new_size = 0;
 	int ret = 0;
 	int flags;
+	int credits;
 	int partial;
 	loff_t start, end;
 	ext4_lblk_t lblk;
@@ -4829,8 +4830,14 @@ static long ext4_zero_range(struct file
 		if (ret)
 			goto out_dio;
 	}
-
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, 4);
+	/*
+	 * In worst case we have to writeout two nonadjacent unwritten
+	 * blocks and update the inode
+	 */
+	credits = (2 * ext4_ext_index_trans_blocks(inode, 2)) + 1;
+	if (ext4_should_journal_data(inode))
+		credits += 2;
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		ext4_std_error(inode->i_sb, ret);


