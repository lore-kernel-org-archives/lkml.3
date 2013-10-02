Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3JBO3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:29:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab3JBO25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 03/26] dma: Use get_user_pages_fast() in dma_pin_iovec_pages()
Date: Wed,  2 Oct 2013 16:27:44 +0200
Message-Id: <1380724087-13927-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/dma/iovlock.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
index bb48a57c2fc1..8b16332da8a9 100644
--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -95,17 +95,10 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
 		pages += page_list->nr_pages;
 
 		/* pin pages down */
-		down_read(&current->mm->mmap_sem);
-		ret = get_user_pages(
-			current,
-			current->mm,
-			(unsigned long) iov[i].iov_base,
-			page_list->nr_pages,
-			1,	/* write */
-			0,	/* force */
-			page_list->pages,
-			NULL);
-		up_read(&current->mm->mmap_sem);
+		ret = get_user_pages_fast((unsigned long) iov[i].iov_base,
+					  page_list->nr_pages,
+					  1,	/* write */
+					  page_list->pages);
 
 		if (ret != page_list->nr_pages)
 			goto unpin;
-- 
1.8.1.4

