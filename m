Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3JBOaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:30:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3JBO3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:29:01 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH 25/26] ib: Convert mthca_map_user_db() to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:28:06 +0200
Message-Id: <1380724087-13927-26-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function mthca_map_user_db() appears to call get_user_pages() without
holding mmap_sem. Fix the bug by using get_user_pages_fast() instead
which also takes care of the locking.

CC: Roland Dreier <roland@kernel.org>
CC: linux-rdma@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/infiniband/hw/mthca/mthca_memfree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 7d2e42dd6926..c3543b27a2a7 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -472,8 +472,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		goto out;
 	}
 
-	ret = get_user_pages(current, current->mm, uaddr & PAGE_MASK, 1, 1, 0,
-			     pages, NULL);
+	ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, 1, pages);
 	if (ret < 0)
 		goto out;
 
-- 
1.8.1.4

