Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaFWNLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:11:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbaFWNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 73/93] mm: rmap: fix use-after-free in __put_anon_vma
Date: Mon, 23 Jun 2014 14:02:52 +0100
Message-Id: <1403528592-2163-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Ryabinin <a.ryabinin@samsung.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/rmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 54935c5c9d60..f23ea5f31a31 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1684,10 +1684,9 @@ void __put_anon_vma(struct anon_vma *anon_vma)
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
1.9.1

