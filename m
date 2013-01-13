Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3AMRuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:50:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473Ab3AMRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:38 -0500
Message-Id: <20130113174302.248363034@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>, Jan Kara <jack@suse.cz>
Subject: [ 31/49] udf: dont increment lenExtents while writing to a hole
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -581,6 +581,7 @@ static struct buffer_head *inode_getblk(
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int goal = 0, pgoal = iinfo->i_location.logicalBlockNum;
 	int lastblock = 0;
+	bool isBeyondEOF;
 
 	prev_epos.offset = udf_file_entry_alloc_offset(inode);
 	prev_epos.block = iinfo->i_location;
@@ -659,7 +660,7 @@ static struct buffer_head *inode_getblk(
 	/* Are we beyond EOF? */
 	if (etype == -1) {
 		int ret;
-
+		isBeyondEOF = 1;
 		if (count) {
 			if (c)
 				laarr[0] = laarr[1];
@@ -702,6 +703,7 @@ static struct buffer_head *inode_getblk(
 		endnum = c + 1;
 		lastblock = 1;
 	} else {
+		isBeyondEOF = 0;
 		endnum = startnum = ((count > 2) ? 2 : count);
 
 		/* if the current extent is in position 0,
@@ -749,7 +751,8 @@ static struct buffer_head *inode_getblk(
 			*err = -ENOSPC;
 			return NULL;
 		}
-		iinfo->i_lenExtents += inode->i_sb->s_blocksize;
+		if (isBeyondEOF)
+			iinfo->i_lenExtents += inode->i_sb->s_blocksize;
 	}
 
 	/* if the extent the requsted block is located in contains multiple


