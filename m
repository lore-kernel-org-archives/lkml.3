Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaFKCPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:15:17 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44405 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaFKCPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:15:15 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2] vmalloc: use rcu list iterator to reduce vmap_area_lock contention
Date: Wed, 11 Jun 2014 11:19:06 +0900
Message-Id: <1402453146-10057-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Yao reported a month ago that his system have a trouble
with vmap_area_lock contention during performance analysis
by /proc/meminfo. Andrew asked why his analysis checks /proc/meminfo
stressfully, but he didn't answer it.

https://lkml.org/lkml/2014/4/10/416

Although I'm not sure that this is right usage or not, there is a solution
reducing vmap_area_lock contention with no side-effect. That is just
to use rcu list iterator in get_vmalloc_info().

rcu can be used in this function because all RCU protocol is already
respected by writers, since Nick Piggin commit db64fe02258f1507e13fe5
("mm: rewrite vmap layer") back in linux-2.6.28

Specifically :
   insertions use list_add_rcu(),
   deletions use list_del_rcu() and kfree_rcu().

Note the rb tree is not used from rcu reader (it would not be safe),
only the vmap_area_list has full RCU protection.

Note that __purge_vmap_area_lazy() already uses this rcu protection.

        rcu_read_lock();
        list_for_each_entry_rcu(va, &vmap_area_list, list) {
                if (va->flags & VM_LAZY_FREE) {
                        if (va->va_start < *start)
                                *start = va->va_start;
                        if (va->va_end > *end)
                                *end = va->va_end;
                        nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
                        list_add_tail(&va->purge_list, &valist);
                        va->flags |= VM_LAZY_FREEING;
                        va->flags &= ~VM_LAZY_FREE;
                }
        }
        rcu_read_unlock();

v2: add more commit description from Eric

[edumazet@google.com: add more commit description]
Reported-by: Richard Yao <ryao@gentoo.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f64632b..fdbb116 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2690,14 +2690,14 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 
 	prev_end = VMALLOC_START;
 
-	spin_lock(&vmap_area_lock);
+	rcu_read_lock();
 
 	if (list_empty(&vmap_area_list)) {
 		vmi->largest_chunk = VMALLOC_TOTAL;
 		goto out;
 	}
 
-	list_for_each_entry(va, &vmap_area_list, list) {
+	list_for_each_entry_rcu(va, &vmap_area_list, list) {
 		unsigned long addr = va->va_start;
 
 		/*
@@ -2724,7 +2724,7 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 		vmi->largest_chunk = VMALLOC_END - prev_end;
 
 out:
-	spin_unlock(&vmap_area_lock);
+	rcu_read_unlock();
 }
 #endif
 
-- 
1.7.9.5

