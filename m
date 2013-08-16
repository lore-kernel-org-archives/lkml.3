Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3HPWhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:37:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3HPWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:37:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Steven T Hampson <steven.t.hampson@intel.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 078/133] mm: mempolicy: fix mbind_range() && vma_adjust() interaction
Date: Fri, 16 Aug 2013 15:33:40 -0700
Message-Id: <1376692475-28413-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 3964acd0dbec123aa0a621973a2a0580034b4788 upstream.

vma_adjust() does vma_set_policy(vma, vma_policy(next)) and this
is doubly wrong:

1. This leaks vma->vm_policy if it is not NULL and not equal to
   next->vm_policy.

   This can happen if vma_merge() expands "area", not prev (case 8).

2. This sets the wrong policy if vma_merge() joins prev and area,
   area is the vma the caller needs to update and it still has the
   old policy.

Revert commit 1444f92c8498 ("mm: merging memory blocks resets
mempolicy") which introduced these problems.

Change mbind_range() to recheck mpol_equal() after vma_merge() to fix
the problem that commit tried to address.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven T Hampson <steven.t.hampson@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/mempolicy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3df6d12..efabe65 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -745,7 +745,10 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
-			continue;
+			if (mpol_equal(vma_policy(vma), new_pol))
+				continue;
+			/* vma_merge() joined vma && vma->next, case 8 */
+			goto replace;
 		}
 		if (vma->vm_start != vmstart) {
 			err = split_vma(vma->vm_mm, vma, vmstart, 1);
@@ -757,6 +760,7 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 			if (err)
 				goto out;
 		}
+ replace:
 		err = vma_replace_policy(vma, new_pol);
 		if (err)
 			goto out;
-- 
1.8.1.2

