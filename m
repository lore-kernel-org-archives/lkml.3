Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3LJPwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:52:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab3LJPvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:51:49 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 16/18] mm: numa: Do not automatically migrate KSM pages
Date: Tue, 10 Dec 2013 15:51:34 +0000
Message-Id: <1386690695-27380-17-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KSM pages can be shared between tasks that are not necessarily related
to each other from a NUMA perspective. This patch causes those pages to
be ignored by automatic NUMA balancing so they do not migrate and do not
cause unrelated tasks to be grouped together.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/mprotect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9b1be30..c258137 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -23,6 +23,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/perf_event.h>
+#include <linux/ksm.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
@@ -63,7 +64,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 				ptent = *pte;
 				page = vm_normal_page(vma, addr, oldpte);
-				if (page) {
+				if (page && !PageKsm(page)) {
 					if (!pte_numa(oldpte)) {
 						ptent = pte_mknuma(ptent);
 						updated = true;
-- 
1.8.4

