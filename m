Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3KXBXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 20:23:05 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:45791 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755972Ab3KXBXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 20:23:01 -0500
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org
Cc: r.peniaev@gmail.com, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH] Squashfs: fix failure to unlock pages on decompress error
Date: Sun, 24 Nov 2013 01:22:26 +0000
Message-Id: <1385256147-15649-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct decompression into the page cache.  If we fall back
to using an intermediate buffer (because we cannot grab all the
page cache pages) and we get a decompress fail, we forgot to
release the pages.

Reported-by: Roman Peniaev <r.peniaev@gmail.com>
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/file_direct.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
index 2943b2b..62a0de6 100644
--- a/fs/squashfs/file_direct.c
+++ b/fs/squashfs/file_direct.c
@@ -84,6 +84,9 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize)
 		 */
 		res = squashfs_read_cache(target_page, block, bsize, pages,
 								page);
+		if (res < 0)
+			goto mark_errored;
+
 		goto out;
 	}
 
@@ -119,7 +122,7 @@ mark_errored:
 	 * dealt with by the caller
 	 */
 	for (i = 0; i < pages; i++) {
-		if (page[i] == target_page)
+		if (page[i] == NULL || page[i] == target_page)
 			continue;
 		flush_dcache_page(page[i]);
 		SetPageError(page[i]);
-- 
1.7.10.4

