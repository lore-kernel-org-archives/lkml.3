Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaAaRgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:36:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55197 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:32:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 11/14] net: rds: fix per-cpu helper usage
Date: Fri, 31 Jan 2014 09:32:14 -0800
Message-Id: <1391189537-20777-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391189537-20777-1-git-send-email-kamal@canonical.com>
References: <1391189537-20777-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit c196403b79aa241c3fefb3ee5bb328aa7c5cc860 upstream.

commit ae4b46e9d "net: rds: use this_cpu_* per-cpu helper" broke per-cpu
handling for rds. chpfirst is the result of __this_cpu_read(), so it is
an absolute pointer and not __percpu. Therefore, __this_cpu_write()
should not operate on chpfirst, but rather on cache->percpu->first, just
like __this_cpu_read() did before.

Signed-off-byd Gerald Schaefer <gerald.schaefer@de.ibm.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/rds/ib_recv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 8eb9501..b7ebe23 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -421,8 +421,7 @@ static void rds_ib_recv_cache_put(struct list_head *new_item,
 				 struct rds_ib_refill_cache *cache)
 {
 	unsigned long flags;
-	struct list_head *old;
-	struct list_head __percpu *chpfirst;
+	struct list_head *old, *chpfirst;
 
 	local_irq_save(flags);
 
@@ -432,7 +431,7 @@ static void rds_ib_recv_cache_put(struct list_head *new_item,
 	else /* put on front */
 		list_add_tail(new_item, chpfirst);
 
-	__this_cpu_write(chpfirst, new_item);
+	__this_cpu_write(cache->percpu->first, new_item);
 	__this_cpu_inc(cache->percpu->count);
 
 	if (__this_cpu_read(cache->percpu->count) < RDS_IB_RECYCLE_BATCH_COUNT)
@@ -452,7 +451,7 @@ static void rds_ib_recv_cache_put(struct list_head *new_item,
 	} while (old);
 
 
-	__this_cpu_write(chpfirst, NULL);
+	__this_cpu_write(cache->percpu->first, NULL);
 	__this_cpu_write(cache->percpu->count, 0);
 end:
 	local_irq_restore(flags);
-- 
1.8.3.2

