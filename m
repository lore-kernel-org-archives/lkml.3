Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab3AOW46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:56:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:48280 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934301Ab3AOW4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>, Jan Kara <jack@suse.cz>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 39/71] udf: dont increment lenExtents while writing to a hole
Date: Tue, 15 Jan 2013 14:54:36 -0800
Message-Id: <20130115225343.242358853@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <namjae.jeon@samsung.com>

commit fb719c59bdb4fca86ee1fd1f42ab3735ca12b6b2 upstream.

Incrementing lenExtents even while writing to a hole is bad
for performance as calls to udf_discard_prealloc and
udf_truncate_tail_extent would not return from start if
isize != lenExtents

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -575,6 +575,7 @@ static struct buffer_head *inode_getblk(
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int goal = 0, pgoal = iinfo->i_location.logicalBlockNum;
 	int lastblock = 0;
+	bool isBeyondEOF;
 
 	prev_epos.offset = udf_file_entry_alloc_offset(inode);
 	prev_epos.block = iinfo->i_location;
@@ -653,7 +654,7 @@ static struct buffer_head *inode_getblk(
 	/* Are we beyond EOF? */
 	if (etype == -1) {
 		int ret;
-
+		isBeyondEOF = 1;
 		if (count) {
 			if (c)
 				laarr[0] = laarr[1];
@@ -696,6 +697,7 @@ static struct buffer_head *inode_getblk(
 		endnum = c + 1;
 		lastblock = 1;
 	} else {
+		isBeyondEOF = 0;
 		endnum = startnum = ((count > 2) ? 2 : count);
 
 		/* if the current extent is in position 0,
@@ -743,7 +745,8 @@ static struct buffer_head *inode_getblk(
 			*err = -ENOSPC;
 			return NULL;
 		}
-		iinfo->i_lenExtents += inode->i_sb->s_blocksize;
+		if (isBeyondEOF)
+			iinfo->i_lenExtents += inode->i_sb->s_blocksize;
 	}
 
 	/* if the extent the requsted block is located in contains multiple


