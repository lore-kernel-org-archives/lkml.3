Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3CAXcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:32:13 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49316 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CAXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:32:12 -0500
Date: Fri, 1 Mar 2013 18:32:08 -0500
From: Andrew Shewmaker <agshew@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: [PATCH v3 001/002] mm: limit growth of 3% hardcoded other user
 reserve
Message-ID: <20130301233208.GA1848@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the growth of the memory reserved for other processes
to the smaller of 3% or 2000 pages.

This affects OVERCOMMIT_NEVER mode.

Signed-off-by: Andrew Shewmaker <agshew@gmail.com>

---

I had simply removed the reserve previously, but that caused forks 
to fail easily. This allows a user to recover similar to the 
simple 3% reserve, but allows a single process to allocate more 
memory.

Alan suggested the min(3%, k), and I've k=2000 pages seems to work well.
It allows enough free pages to for sshd, bash, and top, in case some 
sort of recovery is necessary. Of course, memory will still be exhausted 
eventually.

diff --git a/mm/mmap.c b/mm/mmap.c
index d1e4124..6134b1d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -183,9 +183,10 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 	allowed += total_swap_pages;
 
 	/* Don't let a single process grow too big:
-	   leave 3% of the size of this process for other processes */
+	 * leave the smaller of 3% of the size of this process 
+         * or 2000 pages for other processes */
 	if (mm)
-		allowed -= mm->total_vm / 32;
+		allowed -= min(mm->total_vm / 32, 2000UL);
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
