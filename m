Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBLIX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:23:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50245 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbaBLIOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:06 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, "Christoph Hellwig" <hch@lst.de>,
        "Christoph Hellwig" <hch@infradead.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.763222242@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 35/79] ext2: Fix oops in ext2_get_block() called from
 ext2_quota_write()
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1448,6 +1448,7 @@ static ssize_t ext2_quota_write(struct s
 				sb->s_blocksize - offset : towrite;
 
 		tmp_bh.b_state = 0;
+		tmp_bh.b_size = sb->s_blocksize;
 		err = ext2_get_block(inode, blk, &tmp_bh, 1);
 		if (err < 0)
 			goto out;

