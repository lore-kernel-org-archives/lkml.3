Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaG3CI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:08:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaG3Btd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Guillaume Morin <guillaume@morinfr.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 17/21] mm: hugetlb: fix copy_hugetlb_page_range()
Date: Tue, 29 Jul 2014 18:48:46 -0700
Message-Id: <20140730014831.202690528@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014830.424826215@linuxfoundation.org>
References: <20140730014830.424826215@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 0253d634e0803a8376a0d88efee0bf523d8673f9 upstream.

Commit 4a705fef9862 ("hugetlb: fix copy_hugetlb_page_range() to handle
migration/hwpoisoned entry") changed the order of
huge_ptep_set_wrprotect() and huge_ptep_get(), which leads to breakage
in some workloads like hugepage-backed heap allocation via libhugetlbfs.
This patch fixes it.

The test program for the problem is shown below:

  $ cat heap.c
  #include <unistd.h>
  #include <stdlib.h>
  #include <string.h>

  #define HPS 0x200000

  int main() {
  	int i;
  	char *p = malloc(HPS);
  	memset(p, '1', HPS);
  	for (i = 0; i < 5; i++) {
  		if (!fork()) {
  			memset(p, '2', HPS);
  			p = malloc(HPS);
  			memset(p, '3', HPS);
  			free(p);
  			return 0;
  		}
  	}
  	sleep(1);
  	free(p);
  	return 0;
  }

  $ export HUGETLB_MORECORE=yes ; export HUGETLB_NO_PREFAULT= ; hugectl --heap ./heap

Fixes 4a705fef9862 ("hugetlb: fix copy_hugetlb_page_range() to handle
migration/hwpoisoned entry"), so is applicable to -stable kernels which
include it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Guillaume Morin <guillaume@morinfr.org>
Suggested-by: Guillaume Morin <guillaume@morinfr.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2400,6 +2400,7 @@ int copy_hugetlb_page_range(struct mm_st
 		} else {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
 			get_page(ptepage);
 			page_dup_rmap(ptepage);


