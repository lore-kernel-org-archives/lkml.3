Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3CEXiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:38:19 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:53415 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3CEXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:38:16 -0500
Date: Tue, 5 Mar 2013 18:38:12 -0500
From: Andrew Shewmaker <agshew@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: [PATCH v4 001/002] mm: limit growth of 3% hardcoded other user
 reserve
Message-ID: <20130305233811.GA1948@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the growth of the memory reserved for other processes
to the smaller of 3% or 8MB.

This affects only OVERCOMMIT_NEVER.

Signed-off-by: Andrew Shewmaker <agshew@gmail.com>

---

Rebased onto v3.8-mmotm-2013-03-01-15-50

No longer assumes 4kb pages.
Code duplicated for nommu.

diff --git a/mm/mmap.c b/mm/mmap.c
index 49dc7d5..4eb2b1a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -184,9 +184,11 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 	allowed += total_swap_pages;
 
 	/* Don't let a single process grow too big:
-	   leave 3% of the size of this process for other processes */
+	 * leave the smaller of 3% of the size of this process 
+         * or 8MB for other processes
+         */
 	if (mm)
-		allowed -= mm->total_vm / 32;
+		allowed -= min(mm->total_vm / 32, 1 << (23 - PAGE_SHIFT));
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
diff --git a/mm/nommu.c b/mm/nommu.c
index f5d57a3..a93d214 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1945,9 +1945,11 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 	allowed += total_swap_pages;
 
 	/* Don't let a single process grow too big:
-	   leave 3% of the size of this process for other processes */
+	 * leave the smaller of 3% of the size of this process 
+         * or 8MB for other processes
+         */
 	if (mm)
-		allowed -= mm->total_vm / 32;
+		allowed -= min(mm->total_vm / 32, 1 << (23 - PAGE_SHIFT));
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
