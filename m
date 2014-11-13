Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbaKMTZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:36 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:53181 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbaKMTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:31 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>, Joerg Roedel <jroedel@suse.de>,
        NeilBrown <neilb@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
        Paul McQuade <paulmcquad@gmail.com>,
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 13/16] ksm: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:19 -0500
Message-Id: <1415906662-4576-14-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 mm/ksm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index d247efa..a67de79 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -542,15 +542,14 @@ static struct page *get_ksm_page(struct stable_node *stable_node, bool lock_it)
 	expected_mapping = (void *)stable_node +
 				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 again:
-	kpfn = ACCESS_ONCE(stable_node->kpfn);
-	page = pfn_to_page(kpfn);
-
 	/*
 	 * page is computed from kpfn, so on most architectures reading
 	 * page->mapping is naturally ordered after reading node->kpfn,
 	 * but on Alpha we need to be more careful.
 	 */
-	smp_read_barrier_depends();
+	kpfn = lockless_dereference(stable_node->kpfn);
+	page = pfn_to_page(kpfn);
+
 	if (ACCESS_ONCE(page->mapping) != expected_mapping)
 		goto stale;
 
-- 
1.9.1

