Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaFLFcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:32:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50156 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaFLFcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:32:52 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-70-53993b81a14e
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/3] f2fs: avoid to truncate non-updated page
 partially
Date: Thu, 12 Jun 2014 13:31:50 +0800
Message-id: <000201cf85ff$c0715040$4153f0c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+F/4H49Kkt2X6hTXuNPUIzkfpZhA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd1G65nBBpfn6lo8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXHu5UP2gt/sFRce
	3WRpYNzN1sXIySEhYCLxdcFBJghbTOLCvfVAcS4OIYFFjBITP3xggXB+MEocuDOBBaSKTUBF
	YnnHf7AOESD70KLL7CA2s0CmxL2mGcwgtrBAsMTO7mdgNSwCqhKz5nwFi/MKWEp0fNvBAmEL
	SvyYfI8FoldLYv3O40wQtrzE5jVvmSEuUpDYcfY1I8QuPYmTH/5C1YtLbDxyi2UCo8AsJKNm
	IRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDuVnUjsYVzZYHGIU4GBU
	4uGNqJ8RLMSaWFZcmXuIUYKDWUmE1/E8UIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB
	9MSS1OzU1ILUIpgsEwenVAMjb4WfvXHkTskipb6CU8KWYddyY9xZ5rA1Zuw88nK5w6Hgt8rS
	938XmprsWvjVc/ansj/XvXRd8t/KGuwW9RKdHZbad2hmLf+/9Cmn7pz6xZ4Q5BHx76IRd1q2
	6zU9J8cc960Gfj+fzWYI/3lTI6DyimOW/DmlygWLYudoltvdO9R672B4LasSS3FGoqEWc1Fx
	IgCfRv7UYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we call find_data_page in truncate_partial_data_page, we could not
guarantee this page is updated or not as error may occurred in lower layer.

We'd better check status of the page to avoid this no updated page be
writebacked to device.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/file.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9c49c59..fc569ca 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -380,13 +380,15 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 		return;
 
 	lock_page(page);
-	if (unlikely(page->mapping != inode->i_mapping)) {
-		f2fs_put_page(page, 1);
-		return;
-	}
+	if (unlikely(!PageUptodate(page) ||
+			page->mapping != inode->i_mapping))
+		goto out;
+
 	f2fs_wait_on_page_writeback(page, DATA);
 	zero_user(page, offset, PAGE_CACHE_SIZE - offset);
 	set_page_dirty(page);
+
+out:
 	f2fs_put_page(page, 1);
 }
 
-- 
1.7.9.5


