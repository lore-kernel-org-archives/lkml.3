Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3LPXPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:15:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3LPXPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:15:23 -0500
Date: Mon, 16 Dec 2013 18:15:13 -0500
From: Rik van Riel <riel@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, chegu_vinod@hp.com
Subject: [PATCH 19/18] mm,numa: write pte_numa pte back to the page tables
Message-ID: <20131216181513.14eda80d@annuminas.surriel.com>
In-Reply-To: <1386690695-27380-6-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
	<1386690695-27380-6-git-send-email-mgorman@suse.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 15:51:23 +0000
Mel Gorman <mgorman@suse.de> wrote:

> The TLB must be flushed if the PTE is updated but change_pte_range is clearing
> the PTE while marking PTEs pte_numa without necessarily flushing the TLB if it
> reinserts the same entry. Without the flush, it's conceivable that two processors
> have different TLBs for the same virtual address and at the very least it would
> generate spurious faults. This patch only unmaps the pages in change_pte_range for
> a full protection change.

Turns out the patch optimized out not one, but both
pte writes. Oops.

We'll need this one too, Andrew :)

---8<---

Subject: mm,numa: write pte_numa pte back to the page tables

The patch "mm: numa: Do not clear PTE for pte_numa update" cleverly
optimizes out an extraneous PTE write when changing the protection
of pages to pte_numa.

It also optimizes out actually writing the new pte_numa entry back
to the page tables. Oops.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Chegu Vinod <chegu_vinod@hp.com>
---
 mm/mprotect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index edc4e22..4114acf 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -67,6 +67,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				if (page && !PageKsm(page)) {
 					if (!pte_numa(oldpte)) {
 						ptent = pte_mknuma(ptent);
+						set_pte_at(mm, addr, pte, ptent);
 						updated = true;
 					}
 				}
