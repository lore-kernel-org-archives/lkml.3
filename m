Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbbA2NON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:14:13 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52486 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbbA2NOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:14:11 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 08:14:11 EST
Authentication-Results: smtpcorp1m.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Roman Gushchin <klamm@yandex-team.ru>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Shewmaker <agshew@gmail.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        stable@vger.kernel.org
Subject: [PATCH] mm: fix arithmetic overflow in __vm_enough_memory()
Date: Thu, 29 Jan 2015 16:06:03 +0300
Message-Id: <1422536763-31325-1-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed, that "allowed" can easily overflow by falling below 0,
because (total_vm / 32) can be larger than "allowed". The problem
occurs in OVERCOMMIT_NONE mode.

In this case, a huge allocation can success and overcommit the system
(despite OVERCOMMIT_NONE mode). All subsequent allocations will fall
(system-wide), so system become unusable.

The problem was masked out by commit c9b1d0981fcc
("mm: limit growth of 3% hardcoded other user reserve"),
but it's easy to reproduce it on older kernels:
1) set overcommit_memory sysctl to 2
2) mmap() large file multiple times (with VM_SHARED flag)
3) try to malloc() large amount of memory

It also can be reproduced on newer kernels, but miss-configured
sysctl_user_reserve_kbytes is required.

Fix this issue by switching to signed arithmetic here.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Shewmaker <agshew@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: stable@vger.kernel.org
---
 mm/mmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7f684d5..5aa8dfe 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -152,7 +152,7 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
  */
 int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
-	unsigned long free, allowed, reserve;
+	long free, allowed, reserve;
 
 	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
 			-(s64)vm_committed_as_batch * num_online_cpus(),
@@ -220,7 +220,7 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min(mm->total_vm / 32, reserve);
+		allowed -= min((long)mm->total_vm / 32, reserve);
 	}
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
-- 
2.1.0

