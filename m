Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaBLIgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:36:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50099 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881AbaBLINw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jianguo Wu" <wujianguo@huawei.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.863672482@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 20/79] mm/memory-failure.c: recheck PageHuge() after
 hugetlb page migrate successfully
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/memory-failure.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1441,10 +1441,18 @@ static int soft_offline_huge_page(struct
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

