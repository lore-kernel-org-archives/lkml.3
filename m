Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaHRJl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:41:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaHRJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/137] sparc64: Do not insert non-valid PTEs into the TSB hash table.
Date: Mon, 18 Aug 2014 10:33:04 +0100
Message-Id: <1408354398-10226-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 18f38132528c3e603c66ea464727b29e9bbcb91b upstream.

The assumption was that update_mmu_cache() (and the equivalent for PMDs) would
only be called when the PTE being installed will be accessible by the user.

This is not true for code paths originating from remove_migration_pte().

There are dire consequences for placing a non-valid PTE into the TSB.  The TLB
miss frramework assumes thatwhen a TSB entry matches we can just load it into
the TLB and return from the TLB miss trap.

So if a non-valid PTE is in there, we will deadlock taking the TLB miss over
and over, never satisfying the miss.

Just exit early from update_mmu_cache() and friends in this situation.

Based upon a report and patch from Christopher Alexander Tobias Schulze.

Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.11: used davem's backport to 3.10 and 3.12 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/mm/init_64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index ed82edad1a39..774ba41dba4d 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -350,6 +350,10 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 
 	mm = vma->vm_mm;
 
+	/* Don't insert a non-valid PTE into the TSB, we'll deadlock.  */
+	if (!pte_accessible(mm, pte))
+		return;
+
 	spin_lock_irqsave(&mm->context.lock, flags);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
-- 
1.9.1

