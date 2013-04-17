Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3DQAg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:36:56 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55543 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3DQAgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:36:53 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/6] mm/hugetlb: enable gigantic hugetlb page pools shrinking
Date: Wed, 17 Apr 2013 08:36:31 +0800
Message-Id: <1366158995-3116-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366158995-3116-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1366158995-3116-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041700-1396-0000-0000-000002D09696
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable gigantic hugetlb page pools shrinking.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eeaf6f2..328f140 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1416,7 +1416,8 @@ static unsigned long set_max_huge_pages(struct hstate *h, unsigned long count,
 {
 	unsigned long min_count, ret;
 
-	if (h->order >= MAX_ORDER)
+	if (h->order >= MAX_ORDER && (!hugetlb_shrink_gigantic_pool ||
+				count > persistent_huge_pages(h)))
 		return h->max_huge_pages;
 
 	/*
@@ -1542,7 +1543,7 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 		goto out;
 
 	h = kobj_to_hstate(kobj, &nid);
-	if (h->order >= MAX_ORDER) {
+	if (h->order >= MAX_ORDER && !hugetlb_shrink_gigantic_pool) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -2036,7 +2037,7 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 
 	tmp = h->max_huge_pages;
 
-	if (write && h->order >= MAX_ORDER)
+	if (write && h->order >= MAX_ORDER && !hugetlb_shrink_gigantic_pool)
 		return -EINVAL;
 
 	table->data = &tmp;
-- 
1.7.10.4

