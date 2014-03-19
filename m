Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbaCSCnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766AbaCSCnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:43:39 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND -mm 2/2] mm/mempolicy.c: add comment in queue_pages_hugetlb()
Date: Tue, 18 Mar 2014 22:29:39 -0400
Message-Id: <1395196179-4075-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1395196179-4075-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1395196179-4075-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a race where we try to migrate an invalid page, resulting in
hitting VM_BUG_ON_PAGE in isolate_huge_page().
queue_pages_hugetlb() is OK to fail, so let's check !PageHeadHuge to keep
invalid hugepage from queuing.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/mempolicy.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git v3.14-rc7-mmotm-2014-03-18-16-37.orig/mm/mempolicy.c v3.14-rc7-mmotm-2014-03-18-16-37/mm/mempolicy.c
index 9d2ef4111a4c..ae6e2d9dc855 100644
--- v3.14-rc7-mmotm-2014-03-18-16-37.orig/mm/mempolicy.c
+++ v3.14-rc7-mmotm-2014-03-18-16-37/mm/mempolicy.c
@@ -530,6 +530,17 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long addr,
 	if (!pte_present(entry))
 		return 0;
 	page = pte_page(entry);
+
+	/*
+	 * Trinity found that page could be a non-hugepage. This is an
+	 * unexpected behavior, but it's not clear how this problem happens.
+	 * So let's simply skip such corner case. Page migration can often
+	 * fail for various reasons, so it's ok to just skip the address
+	 * unsuitable to hugepage migration.
+	 */
+	if (!PageHeadHuge(page))
+		return 0;
+
 	nid = page_to_nid(page);
 	if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
 		return 0;
-- 
1.8.5.3

