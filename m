Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaIKMen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:34:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51553 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbaIKMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.290741435@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 115/131] sparc64: Do not insert non-valid PTEs into
 the TSB hash  table.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 18f38132528c3e603c66ea464727b29e9bbcb91b ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/mm/init_64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index b4989f9..77ad815 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -309,6 +309,10 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 	tsb_index = MM_TSB_BASE;
 	tsb_hash_shift = PAGE_SHIFT;
 
+	/* Don't insert a non-valid PTE into the TSB, we'll deadlock.  */
+	if (!(pte_val(pte) & _PAGE_VALID))
+		return;
+
 	spin_lock_irqsave(&mm->context.lock, flags);
 
 #ifdef CONFIG_HUGETLB_PAGE

