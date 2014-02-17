Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBQMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:25:57 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:43862 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752972AbaBQMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:25:55 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 07:25:54 EST
Message-ID: <1392639647.29849.11.camel@ultrabook>
Subject: [PATCH] hfsplus: fix concurrent acess of alloc_blocks
From: Sougata Santra <sougata@tuxera.com>
Reply-To: <sougata@tuxera.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        "Joe Perches" <joe@perches.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Mon, 17 Feb 2014 14:20:47 +0200
Organization: Tuxera
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Concurrent access to alloc_blocks in hfsplus_inode_info is
protected by extents_lock mutex. This patch fixes two
instances where alloc_blocks modification was not protected
with this lock. This fixes possible allocation bitmap
corruption in race conditions while extending and truncating
files.

Signed-off-by: Sougata Santra <sougata@tuxera.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/hfsplus/extents.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index fbb212f..314c858 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -498,11 +498,13 @@ int hfsplus_file_extend(struct inode *inode)
 			goto insert_extent;
 	}
 out:
-	mutex_unlock(&hip->extents_lock);
 	if (!res) {
 		hip->alloc_blocks += len;
+		mutex_unlock(&hip->extents_lock);
 		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ALLOC_DIRTY);
+		return 0;
 	}
+	mutex_unlock(&hip->extents_lock);
 	return res;
 
 insert_extent:
@@ -592,9 +594,9 @@ void hfsplus_file_truncate(struct inode *inode)
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	mutex_unlock(&hip->extents_lock);
 
 	hip->alloc_blocks = blk_cnt;
+	mutex_unlock(&hip->extents_lock);
 out:
 	hip->phys_size = inode->i_size;
 	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>
-- 
1.8.1.4



