Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799Ab3IFEDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:03:17 -0400
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:47136 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705Ab3IFEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:03:14 -0400
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 1/5] Squashfs: fix corruption check in get_dir_index_using_name()
Date: Fri,  6 Sep 2013 04:54:37 +0100
Message-Id: <1378439682-12830-2-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
References: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
X-MDF-HostID: 19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "Squashfs: sanity check information from disk" from
Dan Carpenter adds a missing check for corruption in the
"size" field while reading the directory index from disk.

It, however, sets err to -EINVAL, this value is not used later, and
so setting it is completely redundant.  So remove it.

Errors in reading the index are deliberately non-fatal.  If we
get an error in reading the index we just return the part of the
index we have managed to read - the index isn't essential,
just quicker.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/namei.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index f866d42..342a5aa 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -104,10 +104,8 @@ static int get_dir_index_using_name(struct super_block *sb,
 
 
 		size = le32_to_cpu(index->size) + 1;
-		if (size > SQUASHFS_NAME_LEN) {
-			err = -EINVAL;
+		if (size > SQUASHFS_NAME_LEN)
 			break;
-		}
 
 		err = squashfs_read_metadata(sb, index->name, &index_start,
 					&index_offset, size);
-- 
1.8.3.2

