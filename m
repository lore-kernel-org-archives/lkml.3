Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbaHHWGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:06:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673AbaHHVgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 19/24] sparc64: Do not insert non-valid PTEs into the TSB hash table.
Date: Fri,  8 Aug 2014 14:35:12 -0700
Message-Id: <20140808213336.216680921@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213335.421758947@linuxfoundation.org>
References: <20140808213335.421758947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/init_64.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -350,6 +350,10 @@ void update_mmu_cache(struct vm_area_str
 
 	mm = vma->vm_mm;
 
+	/* Don't insert a non-valid PTE into the TSB, we'll deadlock.  */
+	if (!pte_accessible(mm, pte))
+		return;
+
 	spin_lock_irqsave(&mm->context.lock, flags);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)


