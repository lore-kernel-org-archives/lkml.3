Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3LPJei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:34:38 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:9688 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3LPJeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:34:36 -0500
Message-ID: <52AEC8FD.6050200@huawei.com>
Date: Mon, 16 Dec 2013 17:33:49 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, qiuxishi <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] mm/hugetlb: check for pte NULL pointer in __page_check_address()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __page_check_address(), if address's pud is not present,
huge_pte_offset() will return NULL, we should check the return value.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/rmap.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 55c8b8d..068522d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -600,7 +600,11 @@ pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
 	spinlock_t *ptl;
 
 	if (unlikely(PageHuge(page))) {
+		/* when pud is not present, pte will be NULL */
 		pte = huge_pte_offset(mm, address);
+		if (!pte)
+			return NULL;
+
 		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
 		goto check;
 	}
-- 
1.7.1


