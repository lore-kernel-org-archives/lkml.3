Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3IKCMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:12:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3IKCMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:12:45 -0400
Date: Tue, 10 Sep 2013 22:12:17 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Message-ID: <1378865537-a7m9pwpv-mutt-n-horiguchi@ah.jp.nec.com>
Subject: [PATCH][mmotm] mm/mempolicy.c: add check to avoid queuing hugepage
 under migration
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_pages_pmd_range() checks pmd_huge() to find hugepage, but this check
assumes the pmd is in the normal format and does not work on migration entry
whoes format is like swap entry. We can distinguish them with present bit,
so we need to check it before cheking pmd_huge(). Otherwise, pmd_huge() can
wrongly return false for hugepage, and the behavior is unpredictable.

This patch is against mmotm-2013-08-27.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 64d00c4..0472964 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -553,6 +553,8 @@ static inline int queue_pages_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (!pmd_present(*pmd))
+			continue;
 		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
 			queue_pages_hugetlb_pmd_range(vma, pmd, nodes,
 						flags, private);
-- 
1.8.3.1
