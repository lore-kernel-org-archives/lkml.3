Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaLNUve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:51:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaLNUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.10 20/24] ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
Date: Sun, 14 Dec 2014 12:20:40 -0800
Message-Id: <20141214201801.286709991@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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


