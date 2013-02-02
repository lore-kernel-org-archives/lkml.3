Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3BBOwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:52:10 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38167 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab3BBOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:52:08 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/6] f2fs: optimize get node page readahead part
Date: Sat,  2 Feb 2013 23:51:51 +0900
Message-Id: <1359816711-16252-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

We can remove the call to find_get_page to get a page from the cache
and check for up-to-date, instead we can make use of grab_cache_page
part itself to fetch the page from the cache.
So, removing the call and moving the PageUptodate at proper place, also
taken care of moving the lock_page condition in the page_hit part.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/node.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 33fa6d5..723185b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -920,15 +920,12 @@ struct page *get_node_page_ra(struct page *parent, int start)
 	if (!nid)
 		return ERR_PTR(-ENOENT);
 
-	page = find_get_page(mapping, nid);
-	if (page && PageUptodate(page))
-		goto page_hit;
-	f2fs_put_page(page, 0);
-
 repeat:
 	page = grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
+	else if (PageUptodate(page))
+		goto page_hit;
 
 	err = read_node_page(page, READA);
 	if (err) {
@@ -946,8 +943,9 @@ repeat:
 		ra_node_page(sbi, nid);
 	}
 
-page_hit:
 	lock_page(page);
+
+page_hit:
 	if (PageError(page)) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
-- 
1.7.9.5

