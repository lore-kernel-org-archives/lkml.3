Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190AbaKLDt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:49:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbaKLB1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:27:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3.17 162/319] ext4: fix overflow when updating superblock backups after resize
Date: Wed, 12 Nov 2014 10:15:00 +0900
Message-Id: <20141112011019.478867695@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9378c6768e4fca48971e7b6a9075bc006eda981d upstream.

When there are no meta block groups update_backups() will compute the
backup block in 32-bit arithmetics thus possibly overflowing the block
number and corrupting the filesystem. OTOH filesystems without meta
block groups larger than 16 TB should be rare. Fix the problem by doing
the counting in 64-bit arithmetics.

Coverity-id: 741252
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1081,7 +1081,7 @@ static void update_backups(struct super_
 			break;
 
 		if (meta_bg == 0)
-			backup_block = group * bpg + blk_off;
+			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
 		else
 			backup_block = (ext4_group_first_block_no(sb, group) +
 					ext4_bg_has_super(sb, group));


