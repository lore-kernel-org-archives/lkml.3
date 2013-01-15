Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3APARL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:17:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:42528 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824Ab3AOWcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>, Jan Kara <jack@suse.cz>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 117/221] udf: fix memory leak while allocating blocks during write
Date: Tue, 15 Jan 2013 10:50:44 -0800
Message-Id: <20130115185006.485519840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 2fb7d99d0de3fd8ae869f35ab682581d8455887a upstream.

Need to brelse the buffer_head stored in cur_epos and next_epos.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -765,6 +765,8 @@ static sector_t inode_getblk(struct inod
 				goal, err);
 		if (!newblocknum) {
 			brelse(prev_epos.bh);
+			brelse(cur_epos.bh);
+			brelse(next_epos.bh);
 			*err = -ENOSPC;
 			return 0;
 		}
@@ -795,6 +797,8 @@ static sector_t inode_getblk(struct inod
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
+	brelse(cur_epos.bh);
+	brelse(next_epos.bh);
 
 	newblock = udf_get_pblock(inode->i_sb, newblocknum,
 				iinfo->i_location.partitionReferenceNum, 0);


