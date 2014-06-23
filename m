Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaFWJB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55471 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/111] mm: rmap: fix use-after-free in __put_anon_vma
Date: Mon, 23 Jun 2014 10:31:31 +0200
Message-Id: <3e1b305b53c104d93e1f5d4ac1e682bdf31bb139.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Ryabinin <a.ryabinin@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 624483f3ea82598ab0f62f1bdb9177f531ab1892 upstream.

While working address sanitizer for kernel I've discovered
use-after-free bug in __put_anon_vma.

For the last anon_vma, anon_vma->root freed before child anon_vma.
Later in anon_vma_free(anon_vma) we are referencing to already freed
anon_vma->root to check rwsem.

This fixes it by freeing the child anon_vma before freeing
anon_vma->root.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/rmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6e3139835e00..91ab22878103 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1681,10 +1681,9 @@ void __put_anon_vma(struct anon_vma *anon_vma)
 {
 	struct anon_vma *root = anon_vma->root;
 
+	anon_vma_free(anon_vma);
 	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
 		anon_vma_free(root);
-
-	anon_vma_free(anon_vma);
 }
 
 #ifdef CONFIG_MIGRATION
-- 
2.0.0

