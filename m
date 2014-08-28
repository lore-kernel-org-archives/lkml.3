Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaH1S7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:59:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaH1Sgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:31 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 42/97] mm: don't pointlessly use BUG_ON() for sanity check
Date: Thu, 28 Aug 2014 19:34:50 +0100
Message-Id: <1409250945-30874-43-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 50f5aa8a9b248fa4262cf379863ec9a531b49737 upstream.

BUG_ON() is a big hammer, and should be used _only_ if there is some
major corruption that you cannot possibly recover from, making it
imperative that the current process (and possibly the whole machine) be
terminated with extreme prejudice.

The trivial sanity check in the vmacache code is *not* such a fatal
error.  Recovering from it is absolutely trivial, and using BUG_ON()
just makes it harder to debug for no actual advantage.

To make matters worse, the placement of the BUG_ON() (only if the range
check matched) actually makes it harder to hit the sanity check to begin
with, so _if_ there is a bug (and we just got a report from Srivatsa
Bhat that this can indeed trigger), it is harder to debug not just
because the machine is possibly dead, but because we don't have better
coverage.

BUG_ON() must *die*.  Maybe we should add a checkpatch warning for it,
because it is simply just about the worst thing you can ever do if you
hit some "this cannot happen" situation.

Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmacache.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmacache.c b/mm/vmacache.c
index d4224b3..1037a3ba 100644
--- a/mm/vmacache.c
+++ b/mm/vmacache.c
@@ -81,10 +81,12 @@ struct vm_area_struct *vmacache_find(struct mm_struct *mm, unsigned long addr)
 	for (i = 0; i < VMACACHE_SIZE; i++) {
 		struct vm_area_struct *vma = current->vmacache[i];
 
-		if (vma && vma->vm_start <= addr && vma->vm_end > addr) {
-			BUG_ON(vma->vm_mm != mm);
+		if (!vma)
+			continue;
+		if (WARN_ON_ONCE(vma->vm_mm != mm))
+			break;
+		if (vma->vm_start <= addr && vma->vm_end > addr)
 			return vma;
-		}
 	}
 
 	return NULL;
-- 
1.8.4.5

