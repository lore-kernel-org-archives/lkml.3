Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaGHT1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:27:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54202 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <peterz@infradead.org>,
        "Andrey Ryabinin" <a.ryabinin@samsung.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.327189412@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 078/125] mm: rmap: fix use-after-free in __put_anon_vma
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/rmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1671,10 +1671,9 @@ void __put_anon_vma(struct anon_vma *ano
 {
 	struct anon_vma *root = anon_vma->root;
 
+	anon_vma_free(anon_vma);
 	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
 		anon_vma_free(root);
-
-	anon_vma_free(anon_vma);
 }
 
 #ifdef CONFIG_MIGRATION

