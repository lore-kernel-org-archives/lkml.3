Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3ISQLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:11:38 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:56165 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3ISQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:11:36 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: mpatlasov@parallels.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fuse: fixes for writepages
Date: Thu, 19 Sep 2013 18:11:53 +0200
Message-Id: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim,

Please review and test these.  I've appended them to writepages.v2 and for-next.

Here's a test patch for the rewrites stuff.  It simply disables the waiting in
fuse_page_mkwrite() and is quite effective in generating rewrites in my
testcase.

Thanks,
Miklos

---
 fs/fuse/file.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1498,6 +1498,7 @@ static void fuse_writepage_end(struct fu
 
 	mapping_set_error(inode->i_mapping, req->out.h.error);
 	spin_lock(&fc->lock);
+	int count = 0;
 	while (req->misc.write.next) {
 		struct fuse_req *next = req->misc.write.next;
 		req->misc.write.next = next->misc.write.next;
@@ -1505,7 +1506,10 @@ static void fuse_writepage_end(struct fu
 		list_add(&next->writepages_entry, &fi->writepages);
 		list_add_tail(&next->list, &fi->queued_writes);
 		fuse_flush_writepages(inode);
+		count++;
 	}
+	if (count)
+		printk("rewrite: %i\n", count);
 	fi->writectr--;
 	fuse_writepage_finish(fc, req);
 	spin_unlock(&fc->lock);
@@ -1884,7 +1888,7 @@ static int fuse_page_mkwrite(struct vm_a
 		return VM_FAULT_NOPAGE;
 	}
 
-	fuse_wait_on_page_writeback(inode, page->index);
+	//fuse_wait_on_page_writeback(inode, page->index);
 	return VM_FAULT_LOCKED;
 }
 


