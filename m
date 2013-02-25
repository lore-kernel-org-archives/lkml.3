Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab3BYXXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:23:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3BYXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:23:30 -0500
Date: Mon, 25 Feb 2013 18:23:26 -0500
From: Andrew Shewmaker <agshew@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 1/1] mm: tuning hardcoded reserved memory
Message-ID: <20130225232326.GB1704@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__vm_enough_memory reserves a hardcoded 3% of free memory for other processes
when overcommit is disabled. However, 3% is becoming excessive as memory sizes 
increase and memory cgroups provide a more flexible way to manage the issue anyway.
This patch against 3.8 removes the "other" reserve.

I've found that reducing this reserve is beneficial in the case where a system 
with overcommit disabled has one primary user that wants to allocate as much 
memory as possible with a just few processes.

An additional hardcoded 3% is reserved for root, both when overcommit is enabled 
and when it is disabled. I've made it tunable in private patches, and I plan on 
submitting some version of them, but I can't decide whether a ratio or a byte 
count would be more acceptable. What would people prefer see?

Signed-off-by: Andrew Shewmaker <agshew@gmail.com>

diff --git a/mm/mmap.c b/mm/mmap.c
index 09da0b2..eef9505 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -183,11 +183,6 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
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
