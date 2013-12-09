Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab3LIHKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:10:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760640Ab3LIHJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:09:29 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 16/18] mm: numa: Do not automatically migrate KSM pages
Date: Mon,  9 Dec 2013 07:09:10 +0000
Message-Id: <1386572952-1191-17-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386572952-1191-1-git-send-email-mgorman@suse.de>
References: <1386572952-1191-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KSM pages can be shared between tasks that are not necessarily related
to each other from a NUMA perspective. This patch causes those pages to
be ignored by automatic NUMA balancing so they do not migrate and do not
cause unrelated tasks to be grouped together.

Signed-off-by: Mel Gorman <mgorman@suse.de>
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

