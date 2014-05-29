Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaE2GTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:19:35 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:65031 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbaE2GTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:19:34 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] vmalloc: use rcu list iterator to reduce vmap_area_lock contention
Date: Thu, 29 May 2014 15:22:34 +0900
Message-Id: <1401344554-3596-1-git-send-email-iamjoonsoo.kim@lge.com>
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
to use rcu list iterator in get_vmalloc_info(). This function only needs
values on vmap_area structure, so we don't need to grab a spinlock.

Reported-by: Richard Yao <ryao@gentoo.org>
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

