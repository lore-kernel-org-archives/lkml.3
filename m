Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaERVc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 17:32:57 -0400
Received: from mout.gmx.net ([212.227.17.22]:52812 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaERVcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 17:32:55 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: chien.yen@oracle.com
Cc: davem@davemloft.net, rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] net: rds: Use time_after() for time comparison
Date: Sun, 18 May 2014 23:32:49 +0200
Message-Id: <1400448769-5945-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:zStPYcWJ9iSp8FvExo5VeqZlq5Ty1FqWtnZ+nmz1qbkzXnRXEIG
 Xk6wcLhB4XzHM6I8QDQ9kQrFTiIZ9/QMgbW75UAjXlR0FJd1BYyubGKLzCuaOGGhWaZe1xr
 IuDGFhUP9HW8B9sANcoGZCMVCzmaJHNJGoWjYgP/KFFS2jv2Ql4JZLUTqhBnlpLBWqRz1cC
 j0Q09XkTEEihuC+KEHw0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_after() instead of raw math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 net/rds/ib_send.c |    4 ++--
 net/rds/iw_send.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 37be6e2..1dde91e 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -298,7 +298,7 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 		rds_ib_stats_inc(s_ib_tx_cq_event);
 
 		if (wc.wr_id == RDS_IB_ACK_WR_ID) {
-			if (ic->i_ack_queued + HZ/2 < jiffies)
+			if (time_after(jiffies, ic->i_ack_queued + HZ/2))
 				rds_ib_stats_inc(s_ib_tx_stalled);
 			rds_ib_ack_send_complete(ic);
 			continue;
@@ -315,7 +315,7 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 
 			rm = rds_ib_send_unmap_op(ic, send, wc.status);
 
-			if (send->s_queued + HZ/2 < jiffies)
+			if (time_after(jiffies, send->s_queued + HZ/2))
 				rds_ib_stats_inc(s_ib_tx_stalled);
 
 			if (send->s_op) {
diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index e40c3c5..9105ea0 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -232,7 +232,7 @@ void rds_iw_send_cq_comp_handler(struct ib_cq *cq, void *context)
 		}
 
 		if (wc.wr_id == RDS_IW_ACK_WR_ID) {
-			if (ic->i_ack_queued + HZ/2 < jiffies)
+			if (time_after(jiffies, ic->i_ack_queued + HZ/2))
 				rds_iw_stats_inc(s_iw_tx_stalled);
 			rds_iw_ack_send_complete(ic);
 			continue;
@@ -267,7 +267,7 @@ void rds_iw_send_cq_comp_handler(struct ib_cq *cq, void *context)
 
 			send->s_wr.opcode = 0xdead;
 			send->s_wr.num_sge = 1;
-			if (send->s_queued + HZ/2 < jiffies)
+			if (time_after(jiffies, send->s_queued + HZ/2))
 				rds_iw_stats_inc(s_iw_tx_stalled);
 
 			/* If a RDMA operation produced an error, signal this right
-- 
1.7.10.4

