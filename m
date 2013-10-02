Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3JBOcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:32:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab3JBO27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:59 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 15/26] ceph: Convert ceph_get_direct_page_vector() to get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:56 +0200
Message-Id: <1380724087-13927-16-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Sage Weil <sage@inktank.com>
CC: ceph-devel@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 net/ceph/pagevec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index 815a2249cfa9..1b1ac7887767 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -23,17 +23,15 @@ struct page **ceph_get_direct_page_vector(const void __user *data,
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
-	down_read(&current->mm->mmap_sem);
 	while (got < num_pages) {
-		rc = get_user_pages(current, current->mm,
+		rc = get_user_pages_fast(
 		    (unsigned long)data + ((unsigned long)got * PAGE_SIZE),
-		    num_pages - got, write_page, 0, pages + got, NULL);
+		    num_pages - got, write_page, pages + got);
 		if (rc < 0)
 			break;
 		BUG_ON(rc == 0);
 		got += rc;
 	}
-	up_read(&current->mm->mmap_sem);
 	if (rc < 0)
 		goto fail;
 	return pages;
-- 
1.8.1.4

