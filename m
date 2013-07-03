Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3GCAuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:50:22 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60897 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3GCAuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:50:15 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 2/5] mm/slab: Sharing s_next and s_stop between slab and slub
Date: Wed,  3 Jul 2013 08:49:50 +0800
Message-Id: <1372812593-7617-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070300-1396-0000-0000-000003348BC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shares s_next and s_stop between slab and slub.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab.c        | 10 ----------
 mm/slab.h        |  3 +++
 mm/slab_common.c |  4 ++--
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 13f5ecc..bd14ea2 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4433,16 +4433,6 @@ static int leaks_show(struct seq_file *m, void *p)
 	return 0;
 }
 
-static void *s_next(struct seq_file *m, void *p, loff_t *pos)
-{
-	return seq_list_next(p, &slab_caches, pos);
-}
-
-static void s_stop(struct seq_file *m, void *p)
-{
-	mutex_unlock(&slab_mutex);
-}
-
 static const struct seq_operations slabstats_op = {
 	.start = leaks_start,
 	.next = s_next,
diff --git a/mm/slab.h b/mm/slab.h
index f96b49e..95c8860 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -271,3 +271,6 @@ struct kmem_cache_node {
 #endif
 
 };
+
+void *s_next(struct seq_file *m, void *p, loff_t *pos);
+void s_stop(struct seq_file *m, void *p);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2d41450..d161b81 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -531,12 +531,12 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	return seq_list_start(&slab_caches, *pos);
 }
 
-static void *s_next(struct seq_file *m, void *p, loff_t *pos)
+void *s_next(struct seq_file *m, void *p, loff_t *pos)
 {
 	return seq_list_next(p, &slab_caches, pos);
 }
 
-static void s_stop(struct seq_file *m, void *p)
+void s_stop(struct seq_file *m, void *p)
 {
 	mutex_unlock(&slab_mutex);
 }
-- 
1.8.1.2

