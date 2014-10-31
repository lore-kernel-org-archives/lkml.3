Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbaJaE2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:28:30 -0400
Received: from out4133-66.mail.aliyun.com ([42.120.133.66]:13701 "EHLO
	out4133-66.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756922AbaJaE22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:28:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g08152;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=5;RT=5;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Michal Hocko'" <mhocko@suse.cz>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Hillf Danton" <hillf.zj@alibaba-inc.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC patch] mm: hugetlb: fix __unmap_hugepage_range
Date: Fri, 31 Oct 2014 12:22:12 +0800
Message-ID: <028701cff4c2$3e9e2ca0$bbda85e0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac/0wN3OLQJTT4qTTyyFwFVRBMzbDg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, after flushing TLB, we have no need to scan pte from start again.
Second, before bail out loop, the address is forwarded one step.

Signed-off-by: Hillf Danton <hillf.zj@alibaba-inc.com>
---

--- a/mm/hugetlb.c	Fri Oct 31 11:47:25 2014
+++ b/mm/hugetlb.c	Fri Oct 31 11:52:42 2014
@@ -2641,8 +2641,9 @@ void __unmap_hugepage_range(struct mmu_g
 
 	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+	address = start;
 again:
-	for (address = start; address < end; address += sz) {
+	for (; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
@@ -2689,6 +2690,7 @@ again:
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush) {
+			address += sz;
 			spin_unlock(ptl);
 			break;
 		}
--


