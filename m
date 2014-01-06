Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbaAFXVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:21:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949AbaAFWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 069/129] mm: clear pmd_numa before invalidating
Date: Mon,  6 Jan 2014 14:38:18 -0800
Message-Id: <20140106223901.583162375@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 67f87463d3a3362424efcbe8b40e4772fd34fc61 upstream.

On x86, PMD entries are similar to _PAGE_PROTNONE protection and are
handled as NUMA hinting faults.  The following two page table protection
bits are what defines them

	_PAGE_NUMA:set	_PAGE_PRESENT:clear

A PMD is considered present if any of the _PAGE_PRESENT, _PAGE_PROTNONE,
_PAGE_PSE or _PAGE_NUMA bits are set.  If pmdp_invalidate encounters a
pmd_numa, it clears the present bit leaving _PAGE_NUMA which will be
considered not present by the CPU but present by pmd_present.  The
existing caller of pmdp_invalidate should handle it but it's an
inconsistent state for a PMD.  This patch keeps the state consistent
when calling pmdp_invalidate.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/pgtable-generic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -166,6 +166,9 @@ pgtable_t pgtable_trans_huge_withdraw(st
 void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
+	pmd_t entry = *pmdp;
+	if (pmd_numa(entry))
+		entry = pmd_mknonnuma(entry);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 }


