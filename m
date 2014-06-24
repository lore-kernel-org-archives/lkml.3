Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFXIJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:09:41 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42442 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaFXIJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:09:38 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: clameter@sgi.com, cl@linux.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] slub: reduce duplicate creation on the first object
Date: Tue, 24 Jun 2014 16:08:55 +0800
Message-Id: <1403597335-5465-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062408-5140-0000-0000-0000055F26CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a kmem_cache is created with ctor, each object in the kmem_cache will be
initialized before ready to use. While in slub implementation, the first
object will be initialized twice.

This patch reduces the duplication of initialization of the first object.

Fix commit 7656c72b: SLUB: add macros for scanning objects in a slab.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index b2b0473..beefd45 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1433,7 +1433,7 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 		memset(start, POISON_INUSE, PAGE_SIZE << order);
 
 	last = start;
-	for_each_object(p, s, start, page->objects) {
+	for_each_object(p, s, start + s->size, page->objects - 1) {
 		setup_object(s, page, last);
 		set_freepointer(s, last, p);
 		last = p;
-- 
1.7.9.5

