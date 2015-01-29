Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbbA2LwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:52:00 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:48171 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966AbbA2Lv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:51:58 -0500
Authentication-Results: smtpcorp1m.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Roman Gushchin <klamm@yandex-team.ru>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Shewmaker <agshew@gmail.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] mm: don't account shared file pages in user_reserve_pages
Date: Thu, 29 Jan 2015 14:51:27 +0300
Message-Id: <1422532287-23601-1-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shared file pages are never accounted in memory overcommit code,
so it isn't reasonable to count them in a code that limits the
maximal size of a process in OVERCOMMIT_NONE mode.

If a process has few large file mappings, the consequent attempts
to allocate anonymous memory may unexpectedly fail with -ENOMEM,
while there is free memory and overcommit limit if significantly
larger than the committed amount (as displayed in /proc/meminfo).

The problem is significantly smoothed by commit c9b1d0981fcc
("mm: limit growth of 3% hardcoded other user reserve"),
which limits the impact of this check with 128Mb (tunable via sysctl),
but it can still be a problem on small machines.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Shewmaker <agshew@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7f684d5..151fadf 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -220,7 +220,7 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min(mm->total_vm / 32, reserve);
+		allowed -= min((mm->total_vm - mm->shared_vm) / 32, reserve);
 	}
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
-- 
2.1.0

