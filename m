Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaHLNX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:23:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaHLNX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:23:58 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] hugetlb_cgroup: use lockdep_assert_held rather than spin_is_locked
Date: Tue, 12 Aug 2014 15:23:50 +0200
Message-Id: <1407849830-22500-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_lock may be an empty struct for !SMP configurations and so
arch_spin_is_locked may return unconditional 0 and trigger the VM_BUG_ON
even when the lock is held.

Replace spin_is_locked by lockdep_assert_held. We will not BUG anymore
but it is questionable whether crashing makes a lot of sense in the
uncharge path. Uncharge happens after the last page reference was
released so nobody should touch the page and the function doesn't update
any shared state except for res counter which uses synchronization of
its own.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/hugetlb_cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 9aae6f47433f..9edf189a5ef3 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -217,7 +217,7 @@ void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
 
 	if (hugetlb_cgroup_disabled())
 		return;
-	VM_BUG_ON(!spin_is_locked(&hugetlb_lock));
+	lockdep_assert_held(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(page);
 	if (unlikely(!h_cg))
 		return;
-- 
2.1.0.rc1

