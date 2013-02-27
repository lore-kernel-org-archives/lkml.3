Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab3B0VlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:41:13 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:48514 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3B0VlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:41:11 -0500
Date: Wed, 27 Feb 2013 15:56:30 -0500
From: Andrew Shewmaker <agshew@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/2] mm: tuning hardcoded reserved memory
Message-ID: <20130227205629.GA8429@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are against the mmtom git tree as of February 27th.

The first patch only affects OVERCOMMIT_NEVER mode, entirely removing 
the 3% reserve for other user processes.

The second patch affects both OVERCOMMIT_GUESS and OVERCOMMIT_NEVER 
modes, replacing the hardcoded 3% reserve for the root user with a 
tunable knob.

Signed-off-by: Andrew Shewmaker <agshew@gmail.com>

---

__vm_enough_memory reserves 3% of free pages with the default 
overcommit mode and 6% when overcommit is disabled. These hardcoded 
values have become less reasonable as memory sizes have grown.

On scientific clusters, systems are generally dedicated to one user. 
Also, overcommit is sometimes disabled in order to prevent a long 
running job from suddenly failing days or weeks into a calculation.
In this case, a user wishing to allocate as much memory as possible 
to one process may be prevented from using, for example, around 7GB 
out of 128GB.

The effect is less, but still significant when a user starts a job 
with one process per core. I have repeatedly seen a set of processes 
requesting the same amount of memory fail because one of them could  
not allocate the amount of memory a user would expect to be able to 
allocate.

diff --git a/mm/mmap.c b/mm/mmap.c
index d1e4124..5993f33 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -182,11 +182,6 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		allowed -= allowed / 32;
 	allowed += total_swap_pages;
 
-	/* Don't let a single process grow too big:
-	   leave 3% of the size of this process for other processes */
-	if (mm)
-		allowed -= mm->total_vm / 32;
-
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
 error:
