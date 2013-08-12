Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3HLQjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:39:37 -0400
Received: from relay.parallels.com ([195.214.232.42]:38211 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab3HLQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:39:34 -0400
Subject: [PATCH 1/2] fuse: postpone end_page_writeback() in
 fuse_writepage_locked()
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, xemul@parallels.com
Date: Mon, 12 Aug 2013 20:39:30 +0400
Message-ID: <20130812163906.10366.29310.stgit@maximpc.sw.ru>
In-Reply-To: <20130812163739.10366.64896.stgit@maximpc.sw.ru>
References: <20130812163739.10366.64896.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Moving end_page_writeback to the end of fuse_writepage_locked fixes the race
because now the fact that truncate_pagecache is successfully returned infers
that fuse_writepage_locked has already called end_page_writeback. And this,
in turn, infers that fuse_flush_writepages has already called
fuse_send_writepage, and the latter used valid (shrunk) i_size. write(2)
could not extend it because of i_mutex held by ftruncate(2).

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5c121fe..d1715b3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1529,7 +1529,6 @@ static int fuse_writepage_locked(struct page *page)
 
 	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	end_page_writeback(page);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
@@ -1537,6 +1536,8 @@ static int fuse_writepage_locked(struct page *page)
 	fuse_flush_writepages(inode);
 	spin_unlock(&fc->lock);
 
+	end_page_writeback(page);
+
 	return 0;
 
 err_free:

