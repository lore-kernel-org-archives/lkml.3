Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbaAFXsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:48:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaAFWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianguo Wu <wujianguo@huawei.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 117/144] mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully
Date: Mon,  6 Jan 2014 14:37:58 -0800
Message-Id: <20140106223748.702549910@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory-failure.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1519,10 +1519,16 @@ static int soft_offline_huge_page(struct
 		if (ret > 0)
 			ret = -EIO;
 	} else {
-		set_page_hwpoison_huge_page(hpage);
-		dequeue_hwpoisoned_huge_page(hpage);
-		atomic_long_add(1 << compound_order(hpage),
-				&num_poisoned_pages);
+		/* overcommit hugetlb page will be freed to buddy */
+		if (PageHuge(page)) {
+			set_page_hwpoison_huge_page(hpage);
+			dequeue_hwpoisoned_huge_page(hpage);
+			atomic_long_add(1 << compound_order(hpage),
+					&num_poisoned_pages);
+		} else {
+			SetPageHWPoison(page);
+			atomic_long_inc(&num_poisoned_pages);
+		}
 	}
 	return ret;
 }


