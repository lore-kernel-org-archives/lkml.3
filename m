Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaEURYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:24:17 -0400
Received: from mout.gmx.net ([212.227.17.20]:56682 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaEURYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:24:15 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: shahed.shaikh@qlogic.com
Cc: Dept-HSGLinuxNICDev@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] qlogic: Use time_before()
Date: Wed, 21 May 2014 19:24:03 +0200
Message-Id: <1400693043-15786-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:CNY83UkS9dDXAzjGnXE7VI1oy76t1vyy/sA9hLBcC3ksCEkiLp+
 TN6cOZ8kdzeiC0ccJMv9t9UxuGIZlbrJY588z8Z4Uf/llgN/d27WMfUoOX3W7vE+xnQwk6F
 YbWXy+cw68QXjkv+tnOpAwNIkj7faoceKtrTPgJYKPQMcFWYCJ83KW376yuwOjHS7iRDyK7
 ooPGCjWy3oX3DqEDCItHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 9f3adf4..c2a2ad4 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -630,7 +630,7 @@ void qlcnic_prune_lb_filters(struct qlcnic_adapter *adapter)
 	struct hlist_node *n;
 	struct hlist_head *head;
 	int i;
-	unsigned long time;
+	unsigned long expires;
 	u8 cmd;
 
 	for (i = 0; i < adapter->fhash.fbucket_size; i++) {
@@ -638,8 +638,8 @@ void qlcnic_prune_lb_filters(struct qlcnic_adapter *adapter)
 		hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 			cmd =  tmp_fil->vlan_id ? QLCNIC_MAC_VLAN_DEL :
 						  QLCNIC_MAC_DEL;
-			time = tmp_fil->ftime;
-			if (jiffies > (QLCNIC_FILTER_AGE * HZ + time)) {
+			expires = tmp_fil->ftime + QLCNIC_FILTER_AGE * HZ;
+			if (time_before(expires, jiffies)) {
 				qlcnic_sre_macaddr_change(adapter,
 							  tmp_fil->faddr,
 							  tmp_fil->vlan_id,
@@ -657,8 +657,8 @@ void qlcnic_prune_lb_filters(struct qlcnic_adapter *adapter)
 
 		hlist_for_each_entry_safe(tmp_fil, n, head, fnode)
 		{
-			time = tmp_fil->ftime;
-			if (jiffies > (QLCNIC_FILTER_AGE * HZ + time)) {
+			expires = tmp_fil->ftime + QLCNIC_FILTER_AGE * HZ;
+			if (time_before(expires, jiffies)) {
 				spin_lock_bh(&adapter->rx_mac_learn_lock);
 				adapter->rx_fhash.fnum--;
 				hlist_del(&tmp_fil->fnode);
-- 
1.7.10.4

