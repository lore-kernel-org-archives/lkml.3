Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3IYBmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:42:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3IYAI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:08:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 27/28] fuse: postpone end_page_writeback() in fuse_writepage_locked()
Date: Tue, 24 Sep 2013 17:07:58 -0700
Message-Id: <20130925000654.871694135@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925000648.404447782@linuxfoundation.org>
References: <20130925000648.404447782@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1298,7 +1298,6 @@ static int fuse_writepage_locked(struct
 
 	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	end_page_writeback(page);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
@@ -1306,6 +1305,8 @@ static int fuse_writepage_locked(struct
 	fuse_flush_writepages(inode);
 	spin_unlock(&fc->lock);
 
+	end_page_writeback(page);
+
 	return 0;
 
 err_free:


