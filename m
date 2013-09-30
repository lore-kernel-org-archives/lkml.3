Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3I3KVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:21:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3I3KNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxim Patlasov <mpatlasov@parallels.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 075/104] fuse: postpone end_page_writeback() in fuse_writepage_locked()
Date: Mon, 30 Sep 2013 11:10:52 +0100
Message-Id: <1380535881-9239-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Patlasov <MPatlasov@parallels.com>

commit 4a4ac4eba1010ef9a804569058ab29e3450c0315 upstream.

The patch fixes a race between ftruncate(2), mmap-ed write and write(2):

1) An user makes a page dirty via mmap-ed write.
2) The user performs shrinking truncate(2) intended to purge the page.
3) Before fuse_do_setattr calls truncate_pagecache, the page goes to
   writeback. fuse_writepage_locked fills FUSE_WRITE request and releases
   the original page by end_page_writeback.
4) fuse_do_setattr() completes and successfully returns. Since now, i_mutex
   is free.
5) Ordinary write(2) extends i_size back to cover the page. Note that
   fuse_send_write_pages do wait for fuse writeback, but for another
   page->index.
6) fuse_writepage_locked proceeds by queueing FUSE_WRITE request.
   fuse_send_writepage is supposed to crop inarg->size of the request,
   but it doesn't because i_size has already been extended back.

Moving end_page_writeback to the end of fuse_writepage_locked fixes the
race because now the fact that truncate_pagecache is successfully returned
infers that fuse_writepage_locked has already called end_page_writeback.
And this, in turn, infers that fuse_flush_writepages has already called
fuse_send_writepage, and the latter used valid (shrunk) i_size. write(2)
could not extend it because of i_mutex held by ftruncate(2).

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fuse/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 514f12a..e7785e4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1296,7 +1296,6 @@ static int fuse_writepage_locked(struct page *page)
 
 	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	end_page_writeback(page);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
@@ -1304,6 +1303,8 @@ static int fuse_writepage_locked(struct page *page)
 	fuse_flush_writepages(inode);
 	spin_unlock(&fc->lock);
 
+	end_page_writeback(page);
+
 	return 0;
 
 err_free:
-- 
1.8.3.2

