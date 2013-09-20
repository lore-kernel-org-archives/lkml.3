Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3ITUOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3ITUN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:13:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxim Patlasov <mpatlasov@parallels.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 60/93] fuse: postpone end_page_writeback() in fuse_writepage_locked()
Date: Fri, 20 Sep 2013 13:08:55 -0700
Message-Id: <1379707768-1804-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/fuse/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f3ab824..e9c40f3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1299,7 +1299,6 @@ static int fuse_writepage_locked(struct page *page)
 
 	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	end_page_writeback(page);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
@@ -1307,6 +1306,8 @@ static int fuse_writepage_locked(struct page *page)
 	fuse_flush_writepages(inode);
 	spin_unlock(&fc->lock);
 
+	end_page_writeback(page);
+
 	return 0;
 
 err_free:
-- 
1.8.1.2

