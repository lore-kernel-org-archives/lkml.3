Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3FOSoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 14:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3FOSod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 14:44:33 -0400
Date: Sat, 15 Jun 2013 20:40:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] vfree: don't schedule free_work() if llist_add() returns F
Message-ID: <20130615184026.GA21287@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfree() only needs schedule_work(&p->wq) if p->list was empty,
otherwise vfree_deferred->wq is already pending or it is running
and didn't do llist_del_all() yet.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/vmalloc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d365724..2b8f644 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1524,7 +1524,6 @@ static void __vunmap(const void *addr, int deallocate_pages)
  *	conventions for vfree() arch-depenedent would be a really bad idea)
  *
  *	NOTE: assumes that the object at *addr has a size >= sizeof(llist_node)
- *	
  */
 void vfree(const void *addr)
 {
@@ -1536,8 +1535,8 @@ void vfree(const void *addr)
 		return;
 	if (unlikely(in_interrupt())) {
 		struct vfree_deferred *p = &__get_cpu_var(vfree_deferred);
-		llist_add((struct llist_node *)addr, &p->list);
-		schedule_work(&p->wq);
+		if (llist_add((struct llist_node *)addr, &p->list))
+			schedule_work(&p->wq);
 	} else
 		__vunmap(addr, 1);
 }
-- 
1.5.5.1


