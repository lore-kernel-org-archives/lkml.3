Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3F0AmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:42:18 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59414 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3F0Al4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:41:56 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        lllllinux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 2/3] mm/slab: Sharing s_next and s_stop between slab and slub
Date: Thu, 27 Jun 2013 08:41:39 +0800
Message-Id: <1372293700-15916-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062700-3864-0000-0000-000008D0EAC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v1 -> v2:
  * give these slab-specific names instead of exporting "s_next" and "s_stop"

This patch shares s_next and s_stop between slab and slub.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab.c        | 10 ----------
 mm/slab.h        |  3 +++
 mm/slab_common.c |  8 ++++----
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index f58eb0b..f3f454ad 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4431,16 +4431,6 @@ static int leaks_show(struct seq_file *m, void *p)
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
index f96b49e..620ceed 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -271,3 +271,6 @@ struct kmem_cache_node {
 #endif
 
 };
+
+void *slab_next(struct seq_file *m, void *p, loff_t *pos);
+void slab_stop(struct seq_file *m, void *p);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2d41450..4ee4325 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -531,12 +531,12 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	return seq_list_start(&slab_caches, *pos);
 }
 
-static void *s_next(struct seq_file *m, void *p, loff_t *pos)
+void *slab_next(struct seq_file *m, void *p, loff_t *pos)
 {
 	return seq_list_next(p, &slab_caches, pos);
 }
 
-static void s_stop(struct seq_file *m, void *p)
+void slab_stop(struct seq_file *m, void *p)
 {
 	mutex_unlock(&slab_mutex);
 }
@@ -613,8 +613,8 @@ static int s_show(struct seq_file *m, void *p)
  */
 static const struct seq_operations slabinfo_op = {
 	.start = s_start,
-	.next = s_next,
-	.stop = s_stop,
+	.next = slab_next,
+	.stop = slab_stop,
 	.show = s_show,
 };
 
-- 
1.8.1.2

