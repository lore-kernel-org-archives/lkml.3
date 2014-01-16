Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaAPPy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:54:56 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:56864 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaAPPyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:54:54 -0500
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Shan Wei <davidshan@tencent.com>, Christoph Lameter <cl@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH] net: rds: fix per-cpu helper usage
Date: Thu, 16 Jan 2014 16:54:48 +0100
Message-Id: <1389887688-55632-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.8.4.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011615-6892-0000-0000-0000077D6ECB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ae4b46e9d "net: rds: use this_cpu_* per-cpu helper" broke per-cpu
handling for rds. chpfirst is the result of __this_cpu_read(), so it is
an absolute pointer and not __percpu. Therefore, __this_cpu_write()
should not operate on chpfirst, but rather on cache->percpu->first, just
like __this_cpu_read() did before.

Cc: <stable@vger.kernel.org> # 3.8+
Signed-off-byd Gerald Schaefer <gerald.schaefer@de.ibm.com>
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
1.8.4.5

