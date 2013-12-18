Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3LRWD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:03:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab3LRWD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 17:03:26 -0500
Date: Wed, 18 Dec 2013 17:03:14 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Chao Yang <chayang@redhat.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, mgorman@suse.de,
        Veaceslav Falico <vfalico@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH] mm,numa,THP: initialize hstate for THP page size
Message-ID: <20131218170314.1e57bea7@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hugetlbfs is started with a non-default page size, it is
possible that no hstate is initialized for the page sized used
by transparent huge pages.

This causes copy_huge_page to crash on a null pointer. Make
sure we always have an hpage initialized for the page sized
used by THP.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Chao Yang <chayang@redhat.com>
---
 mm/huge_memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5749bcf..583e9d3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -624,6 +624,13 @@ static int __init hugepage_init(void)
 		return -EINVAL;
 	}
 
+	/*
+	 * Make sure an hstate is initialized for our page size,
+	 * even if hugetlbfs is using a non-default page size.
+	 */
+	if (!size_to_hstate(PMD_PAGE_SIZE))
+		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
+
 	err = hugepage_init_sysfs(&hugepage_kobj);
 	if (err)
 		return err;


-- 
All Rights Reversed
