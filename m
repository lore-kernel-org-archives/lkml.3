Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3KAHya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:54:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:12758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3KAHy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,615,1378882800"; 
   d="scan'208";a="420728660"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 4/4] mm/rmap.c: move anon_vma initialization code into anon_vma_ctor
Date: Fri,  1 Nov 2013 15:54:27 +0800
Message-Id: <1383292467-28922-5-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 mm/rmap.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 246b5fe..831dd4e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -67,19 +67,7 @@ static struct kmem_cache *anon_vma_chain_cachep;
 
 static inline struct anon_vma *anon_vma_alloc(void)
 {
-	struct anon_vma *anon_vma;
-
-	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
-	if (anon_vma) {
-		atomic_set(&anon_vma->refcount, 1);
-		/*
-		 * Initialise the anon_vma root to point to itself. If called
-		 * from fork, the root will be reset to the parents anon_vma.
-		 */
-		anon_vma->root = anon_vma;
-	}
-
-	return anon_vma;
+	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 }
 
 static inline void anon_vma_free(struct anon_vma *anon_vma)
@@ -293,8 +281,15 @@ static void anon_vma_ctor(void *data)
 	struct anon_vma *anon_vma = data;
 
 	rwlock_init(&anon_vma->rwlock);
-	atomic_set(&anon_vma->refcount, 0);
 	anon_vma->rb_root = RB_ROOT;
+
+	atomic_set(&anon_vma->refcount, 1);
+	/*
+	 * Initialise the anon_vma root to point to itself. If called
+	 * from fork, the root will be reset to the parents anon_vma.
+	 */
+	anon_vma->root = anon_vma;
+
 }
 
 void __init anon_vma_init(void)
-- 
1.7.7.6

