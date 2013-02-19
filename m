Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296Ab3BSTIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:08:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934189Ab3BSSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhigang Lu <zlu@tilera.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 36/81] mm/hugetlb: set PTE as huge in hugetlb_change_protection and remove_migration_pte
Date: Tue, 19 Feb 2013 15:48:59 -0300
Message-Id: <1361299784-8830-37-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lu <zlu@tilera.com>

commit be7517d6ab9722f0abad6ba5ffd39cfced95549c upstream.

When setting a huge PTE, besides calling pte_mkhuge(), we also need to
call arch_make_huge_pte(), which we indeed do in make_huge_pte(), but we
forget to do in hugetlb_change_protection() and remove_migration_pte().

Signed-off-by: Zhigang Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/hugetlb.c |    1 +
 mm/migrate.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9c34eb5..33d8b38 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2972,6 +2972,7 @@ void hugetlb_change_protection(struct vm_area_struct *vma,
 		if (!huge_pte_none(huge_ptep_get(ptep))) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(pte_modify(pte, newprot));
+			pte = arch_make_huge_pte(pte, vma, NULL, 0);
 			set_huge_pte_at(mm, address, ptep, pte);
 		}
 	}
diff --git a/mm/migrate.c b/mm/migrate.c
index be26d5c..2e03986 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -142,8 +142,10 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
 #ifdef CONFIG_HUGETLB_PAGE
-	if (PageHuge(new))
+	if (PageHuge(new)) {
 		pte = pte_mkhuge(pte);
+		pte = arch_make_huge_pte(pte, vma, new, 0);
+	}
 #endif
 	flush_cache_page(vma, addr, pte_pfn(pte));
 	set_pte_at(mm, addr, ptep, pte);
-- 
1.7.9.5

