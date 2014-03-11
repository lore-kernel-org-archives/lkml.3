Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaCKSs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:48:29 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46701 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbaCKSs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:48:28 -0400
X-IronPort-AV: E=Sophos;i="4.97,632,1389744000"; 
   d="scan'208";a="110337525"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <xen-devel@lists.xenproject.org>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCHv2] mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges
Date: Tue, 11 Mar 2014 18:40:23 +0000
Message-ID: <1394563223-5045-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If vunmap() is used to unmap a large (e.g., 50 GB) region, it may take
sufficiently long that it triggers soft lockup warnings.

Add a cond_resched() into vunmap_pmd_range() so the calling task may
be resheduled after unmapping each PMD entry.  This is how
zap_pmd_range() fixes the same problem for userspace mappings.

All callers may sleep except for the APEI GHES driver (apei/ghes.c)
which calls unmap_kernel_range_no_flush() from NMI and IRQ contexts.
This driver only unmaps a single pages so don't call cond_resched() if
the unmap doesn't cross a PMD boundary.

Reported-by: Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
v2: don't call cond_resched() at the end of a PMD range.
---
 mm/vmalloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0fdf968..1a8b162 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -75,6 +75,8 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end)
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next);
+		if (next != end)
+			cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
-- 
1.7.2.5

