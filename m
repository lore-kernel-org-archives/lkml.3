Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaAMQXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:23:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaAMQEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 151/208] mm: numa: clear numa hinting information on mprotect
Date: Mon, 13 Jan 2014 15:59:52 +0000
Message-Id: <1389628849-1614-152-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 1667918b6483b12a6496bf54151b827b8235d7b1 upstream.

On a protection change it is no longer clear if the page should be still
accessible.  This patch clears the NUMA hinting fault bits on a
protection change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/huge_memory.c | 2 ++
 mm/mprotect.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0db1517..1385bf9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1495,6 +1495,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		pmd_t entry;
 		if (!prot_numa) {
 			entry = pmdp_get_and_clear(mm, addr, pmd);
+			if (pmd_numa(entry))
+				entry = pmd_mknonnuma(entry);
 			entry = pmd_modify(entry, newprot);
 			BUG_ON(pmd_write(entry));
 			set_pmd_at(mm, addr, pmd, entry);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 3277121..00edb75 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -56,6 +56,8 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 			if (!prot_numa) {
 				ptent = ptep_modify_prot_start(mm, addr, pte);
+				if (pte_numa(ptent))
+					ptent = pte_mknonnuma(ptent);
 				ptent = pte_modify(ptent, newprot);
 				updated = true;
 			} else {
-- 
1.8.3.2

