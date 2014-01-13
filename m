Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaAMRKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:10:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaAMQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianguo Wu <wujianguo@huawei.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, qiuxishi <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 014/208] mm/hugetlb: check for pte NULL pointer in __page_check_address()
Date: Mon, 13 Jan 2014 15:57:35 +0000
Message-Id: <1389628849-1614-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@huawei.com>

commit 98398c32f6687ee1e1f3ae084effb4b75adb0747 upstream.

In __page_check_address(), if address's pud is not present,
huge_pte_offset() will return NULL, we should check the return value.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: qiuxishi <qiuxishi@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/rmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index b2e29ac..75f4c82 100644
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
 		ptl = &mm->page_table_lock;
 		goto check;
 	}
-- 
1.8.3.2

