Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaHTMQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:16:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59575 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbaHTMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:16:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 062/104] mm: hugetlb: fix copy_hugetlb_page_range()
Date: Wed, 20 Aug 2014 13:43:25 +0200
Message-Id: <14caac0809872e49094ecd8ee6412759222a218f.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: <stable@vger.kernel.org>	[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/hugetlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 11c2b7fed052..f80b17106d24 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2453,6 +2453,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 		} else {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
-- 
2.0.4

