Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBGLYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaBGLXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:23:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianguo Wu <wujianguo@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 12/88] mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully
Date: Fri,  7 Feb 2014 11:22:09 +0000
Message-Id: <1391772205-22239-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@huawei.com>

commit a49ecbcd7b0d5a1cda7d60e03df402dd0ef76ac8 upstream.

After a successful hugetlb page migration by soft offline, the source
page will either be freed into hugepage_freelists or buddy(over-commit
page).  If page is in buddy, page_hstate(page) will be NULL.  It will
hit a NULL pointer dereference in dequeue_hwpoisoned_huge_page().

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
  IP: [<ffffffff81163761>] dequeue_hwpoisoned_huge_page+0x131/0x1d0
  PGD c23762067 PUD c24be2067 PMD 0
  Oops: 0000 [#1] SMP

So check PageHuge(page) after call migrate_pages() successfully.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[wujg: backport to 3.4:
 - adjust context
 - s/num_poisoned_pages/mce_bad_pages/]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory-failure.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 1bf1092..5eb3f727 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1447,10 +1447,18 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		return ret;
 	}
 done:
-	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
-	set_page_hwpoison_huge_page(hpage);
-	dequeue_hwpoisoned_huge_page(hpage);
+	/* overcommit hugetlb page will be freed to buddy */
+	if (PageHuge(hpage)) {
+		if (!PageHWPoison(hpage))
+			atomic_long_add(1 << compound_trans_order(hpage),
+					&mce_bad_pages);
+		set_page_hwpoison_huge_page(hpage);
+		dequeue_hwpoisoned_huge_page(hpage);
+	} else {
+		SetPageHWPoison(page);
+		atomic_long_inc(&mce_bad_pages);
+	}
+
 	/* keep elevated page count for bad page */
 	return ret;
 }
-- 
1.8.3.2

