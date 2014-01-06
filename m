Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaAFXvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:51:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbaAFWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.12 106/144] ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
Date: Mon,  6 Jan 2014 14:37:47 -0800
Message-Id: <20140106223748.389829919@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit df4e7ac0bb70abc97fbfd9ef09671fc084b3f9db upstream.

ext2_quota_write() doesn't properly setup bh it passes to
ext2_get_block() and thus we hit assertion BUG_ON(maxblocks == 0) in
ext2_get_blocks() (or we could actually ask for mapping arbitrary number
of blocks depending on whatever value was on stack).

Fix ext2_quota_write() to properly fill in number of blocks to map.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1493,6 +1493,7 @@ static ssize_t ext2_quota_write(struct s
 				sb->s_blocksize - offset : towrite;
 
 		tmp_bh.b_state = 0;
+		tmp_bh.b_size = sb->s_blocksize;
 		err = ext2_get_block(inode, blk, &tmp_bh, 1);
 		if (err < 0)
 			goto out;


