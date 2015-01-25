Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbbAYK6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 05:58:11 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42468 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbAYK6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 05:58:09 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] block: bio: stop to pin pages if bio can't hold more
Date: Sun, 25 Jan 2015 18:57:56 +0800
Message-Id: <1422183476-20611-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make sense to continue to pin user pages when
bio can't hold more pages.

Also this patch fixes possible double page release issue
when get_user_pages_fast() failure happens just after some
of pages in last round weren't added in the bio.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/bio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 471d738..fcf0b15 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1365,9 +1365,13 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 		cur_page = j;
 		/*
 		 * release the pages we didn't map into the bio, if any
+		 * and stop to pin pages if page can't be added.
 		 */
-		while (j < page_limit)
-			page_cache_release(pages[j++]);
+		if (j < page_limit) {
+			while (j < page_limit)
+				page_cache_release(pages[j++]);
+			break;
+		}
 	}
 
 	kfree(pages);
-- 
1.7.9.5

