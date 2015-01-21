Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbbAUGNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:13:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54322 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbbAUGNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:13:41 -0500
From: Shiraz Hashim <shashim@codeaurora.org>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, oleg@redhat.com, gorcunov@openvz.org,
        linux-kernel@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        Shiraz Hashim <shashim@codeaurora.org>
Subject: [PATCH] mm: pagewalk: call pte_hole() for VM_PFNMAP during walk_page_range
Date: Wed, 21 Jan 2015 11:43:13 +0530
Message-Id: <1421820793-28883-1-git-send-email-shashim@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

walk_page_range silently skips vma having VM_PFNMAP set,
which leads to undesirable behaviour at client end (who
called walk_page_range). For example for pagemap_read,
when no callbacks are called against VM_PFNMAP vma,
pagemap_read may prepare pagemap data for next virtual
address range at wrong index.

Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>
---
The fix is revised, based upon the suggestion here at
http://www.spinics.net/lists/linux-mm/msg83058.html

 mm/pagewalk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index ad83195..b264bda 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -199,7 +199,10 @@ int walk_page_range(unsigned long addr, unsigned long end,
 			 */
 			if ((vma->vm_start <= addr) &&
 			    (vma->vm_flags & VM_PFNMAP)) {
-				next = vma->vm_end;
+				if (walk->pte_hole)
+					err = walk->pte_hole(addr, next, walk);
+				if (err)
+					break;
 				pgd = pgd_offset(walk->mm, next);
 				continue;
 			}
-- 
Shiraz Hashim

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

