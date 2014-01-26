Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaAZDIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:08:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaAZDEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:04:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianguo Wu <wujianguo@huawei.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 04/12] mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully
Date: Sat, 25 Jan 2014 19:05:07 -0800
Message-Id: <20140126030452.263912330@linuxfoundation.org>
X-Mailer: git-send-email 1.9.rc0.19.gb594c97
In-Reply-To: <20140126030451.934281002@linuxfoundation.org>
References: <20140126030451.934281002@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

[wujg: backport to 3.4:
 - adjust context
 - s/num_poisoned_pages/mce_bad_pages/]

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/memory-failure.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1447,10 +1447,18 @@ static int soft_offline_huge_page(struct
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


