Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaC3XwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:52:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbaC3Xnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "qiuxishi" <qiuxishi@huawei.com>, "Hanjun Guo" <guohanjun@huawei.com>,
        "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "Mel Gorman" <mgorman@suse.de>, "Jianguo Wu" <wujianguo@huawei.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.167018481@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 180/200] mm/hugetlb: check for pte NULL pointer in
 __page_check_address()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/rmap.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -581,7 +581,11 @@ pte_t *__page_check_address(struct page
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

