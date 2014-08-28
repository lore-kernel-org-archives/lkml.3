Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaH1Sol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:44:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbaH1ShT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:19 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 90/97] vmalloc: use rcu list iterator to reduce vmap_area_lock contention
Date: Thu, 28 Aug 2014 19:35:38 +0100
Message-Id: <1409250945-30874-91-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit 474750aba88817c53f39424e5567b8e4acc4b39b upstream.

Richard Yao reported a month ago that his system have a trouble with
vmap_area_lock contention during performance analysis by /proc/meminfo.
Andrew asked why his analysis checks /proc/meminfo stressfully, but he
didn't answer it.

  https://lkml.org/lkml/2014/4/10/416

Although I'm not sure that this is right usage or not, there is a
solution reducing vmap_area_lock contention with no side-effect.  That
is just to use rcu list iterator in get_vmalloc_info().

rcu can be used in this function because all RCU protocol is already
respected by writers, since Nick Piggin commit db64fe02258f1 ("mm:
rewrite vmap layer") back in linux-2.6.28

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

Peter:

: While rcu list traversal over the vmap_area_list is safe, this may
: arrive at different results than the spinlocked version. The rcu list
: traversal version will not be a 'snapshot' of a single, valid instant
: of the entire vmap_area_list, but rather a potential amalgam of
: different list states.

Joonsoo:

: Yes, you are right, but I don't think that we should be strict here.
: Meminfo is already not a 'snapshot' at specific time.  While we try to get
: certain stats, the other stats can change.  And, although we may arrive at
: different results than the spinlocked version, the difference would not be
: large and would not make serious side-effect.

[edumazet@google.com: add more commit description]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Richard Yao <ryao@gentoo.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e2be0f8..060dc36 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2685,14 +2685,14 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 
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
@@ -2719,7 +2719,7 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 		vmi->largest_chunk = VMALLOC_END - prev_end;
 
 out:
-	spin_unlock(&vmap_area_lock);
+	rcu_read_unlock();
 }
 #endif
 
-- 
1.8.4.5

