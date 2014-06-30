Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaF3FiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:38:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11210 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaF3FiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:38:08 -0400
X-AuditID: cbfee61b-f79f86d00000144c-6d-53b0f7b64541
From: Chao Yu <chao2.yu@samsung.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] udf: avoid redundant memcpy when writing data in ICB
Date: Mon, 30 Jun 2014 13:37:15 +0800
Message-id: <000901cf9425$71219200$5364b600$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+UJFZibV68kWVbSEO8wwp+5bw25Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jAd1t3zcEG1ztE7aYPb2ZyeLyrjls
	DkweZxYcYff4vEkugCmKyyYlNSezLLVI3y6BK+P8uUdsBVe4K2a1L2RuYDzB2cXIySEhYCJx
	4MFJFghbTOLCvfVsXYxcHEICixglTv5/zQLh/GCUOLFpHitIFZuAisTyjv9MILaIgIDE22M/
	2UBsZgEFiV/3NoHVCAu4Stxc/RwsziKgKrF2zROwel4BS4nera1QtqDEj8n3WCB6tSTW7zzO
	BGHLS2xe85YZ4iIFiR1nXzNC7NKTWPDmLCNEjbjExiO3WCYwCsxCMmoWklGzkIyahaRlASPL
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgcH0mvYNxVYPFIUYBDkYlHl6NZRuChVgTy4or
	cw8xSnAwK4nwCtUBhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgsky
	cXBKNTB2ydfV+N9YK6qj8vjXnFkbGtNUUhT8tTPy1Tf9n/vZ8Y7itVV7f+tx9m0We/MsYTGf
	2S9h/xlvJpR9ZtMPzViw2Wu3bebe7EtPe2er1sZx5T5MUipayFVnu31nrdWLhZt8XXSnO+mz
	7hI2NKv4Ymku77NX87ani/LT70xbws98MY//2p5hb6zEUpyRaKjFXFScCAAzg6FGUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have already copied the changed data of page to extent area in ICB when call
->write_end() of adinicb aops, so we do not need to copy them another time in
->writepage() of adinicb aops. SetPageUptodate is redundant too, so it's better
to remove these redundant codes.

Also it looks more reasonable to set inode dirty after extent area are modified,
we'd better move mark_inode_dirty() from ->writepage() to ->write_end().

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/udf/file.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index d80738f..3cd0a50 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -65,17 +65,7 @@ static int udf_adinicb_readpage(struct file *file, struct page *page)
 static int udf_adinicb_writepage(struct page *page,
 				 struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
-	char *kaddr;
-	struct udf_inode_info *iinfo = UDF_I(inode);
-
 	BUG_ON(!PageLocked(page));
-
-	kaddr = kmap(page);
-	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
-	mark_inode_dirty(inode);
-	SetPageUptodate(page);
-	kunmap(page);
 	unlock_page(page);
 
 	return 0;
@@ -115,6 +105,8 @@ static int udf_adinicb_write_end(struct file *file,
 		kaddr + offset, copied);
 	kunmap_atomic(kaddr);
 
+	mark_inode_dirty(inode);
+
 	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
 }
 
-- 
1.7.9.5


