Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3HFIpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:45:21 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56320 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3HFInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:43:42 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-45-5200b73c234e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/4] mm, rmap: allocate anon_vma_chain before starting to link anon_vma_chain
Date: Tue,  6 Aug 2013 17:43:38 +0900
Message-Id: <1375778620-31593-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we allocate anon_vma_chain before starting to link, we can reduce
the lock hold time. This patch implement it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/rmap.c b/mm/rmap.c
index c2f51cb..1603f64 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -240,18 +240,21 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
+	LIST_HEAD(avc_list);
+
+	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+		avc = anon_vma_chain_alloc(GFP_KERNEL);
+		if (unlikely(!avc))
+			goto enomem_failure;
+
+		list_add_tail(&avc->same_vma, &avc_list);
+	}
 
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
-		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
-		if (unlikely(!avc)) {
-			unlock_anon_vma_root(root);
-			root = NULL;
-			avc = anon_vma_chain_alloc(GFP_KERNEL);
-			if (!avc)
-				goto enomem_failure;
-		}
+		avc = list_entry((&avc_list)->next, typeof(*avc), same_vma);
+		list_del(&avc->same_vma);
 		anon_vma = pavc->anon_vma;
 		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_chain_link(dst, avc, anon_vma);
@@ -259,8 +262,11 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	unlock_anon_vma_root(root);
 	return 0;
 
- enomem_failure:
-	unlink_anon_vmas(dst);
+enomem_failure:
+	list_for_each_entry_safe(avc, pavc, &avc_list, same_vma) {
+		list_del(&avc->same_vma);
+		anon_vma_chain_free(avc);
+	}
 	return -ENOMEM;
 }
 
-- 
1.7.9.5

