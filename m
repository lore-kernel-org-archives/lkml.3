Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbaBDVJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:09:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122AbaBDVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 106/133] net: rds: fix per-cpu helper usage
Date: Tue,  4 Feb 2014 13:08:27 -0800
Message-Id: <20140204210740.028571934@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

[ Upstream commit c196403b79aa241c3fefb3ee5bb328aa7c5cc860 ]

commit ae4b46e9d "net: rds: use this_cpu_* per-cpu helper" broke per-cpu
handling for rds. chpfirst is the result of __this_cpu_read(), so it is
an absolute pointer and not __percpu. Therefore, __this_cpu_write()
should not operate on chpfirst, but rather on cache->percpu->first, just
like __this_cpu_read() did before.

Signed-off-byd Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_recv.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -421,8 +421,7 @@ static void rds_ib_recv_cache_put(struct
 				 struct rds_ib_refill_cache *cache)
 {
 	unsigned long flags;
-	struct list_head *old;
-	struct list_head __percpu *chpfirst;
+	struct list_head *old, *chpfirst;
 
 	local_irq_save(flags);
 
@@ -432,7 +431,7 @@ static void rds_ib_recv_cache_put(struct
 	else /* put on front */
 		list_add_tail(new_item, chpfirst);
 
-	__this_cpu_write(chpfirst, new_item);
+	__this_cpu_write(cache->percpu->first, new_item);
 	__this_cpu_inc(cache->percpu->count);
 
 	if (__this_cpu_read(cache->percpu->count) < RDS_IB_RECYCLE_BATCH_COUNT)
@@ -452,7 +451,7 @@ static void rds_ib_recv_cache_put(struct
 	} while (old);
 
 
-	__this_cpu_write(chpfirst, NULL);
+	__this_cpu_write(cache->percpu->first, NULL);
 	__this_cpu_write(cache->percpu->count, 0);
 end:
 	local_irq_restore(flags);


