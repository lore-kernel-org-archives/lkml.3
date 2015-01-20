Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbbATSfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:35:10 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34151 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752474AbbATSdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:33:13 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dev@openvswitch.org, pshelar@nicira.com
Subject: [PATCH net-next v13 2/5] openvswitch: Refactor ovs_flow_tbl_insert().
Date: Tue, 20 Jan 2015 10:32:49 -0800
Message-Id: <1421778772-11879-3-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421778772-11879-1-git-send-email-joestringer@nicira.com>
References: <1421778772-11879-1-git-send-email-joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework so that ovs_flow_tbl_insert() calls flow_{key,mask}_insert().
This tidies up a future patch.

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
 net/openvswitch/flow_table.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 5899bf1..81b977d 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -585,16 +585,10 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 }
 
 /* Must be called with OVS mutex held. */
-int ovs_flow_tbl_insert(struct flow_table *table, struct sw_flow *flow,
-			const struct sw_flow_mask *mask)
+static void flow_key_insert(struct flow_table *table, struct sw_flow *flow)
 {
 	struct table_instance *new_ti = NULL;
 	struct table_instance *ti;
-	int err;
-
-	err = flow_mask_insert(table, flow, mask);
-	if (err)
-		return err;
 
 	flow->hash = flow_hash(&flow->key, flow->mask->range.start,
 			flow->mask->range.end);
@@ -613,6 +607,19 @@ int ovs_flow_tbl_insert(struct flow_table *table, struct sw_flow *flow,
 		table_instance_destroy(ti, true);
 		table->last_rehash = jiffies;
 	}
+}
+
+/* Must be called with OVS mutex held. */
+int ovs_flow_tbl_insert(struct flow_table *table, struct sw_flow *flow,
+			const struct sw_flow_mask *mask)
+{
+	int err;
+
+	err = flow_mask_insert(table, flow, mask);
+	if (err)
+		return err;
+	flow_key_insert(table, flow);
+
 	return 0;
 }
 
-- 
1.7.10.4

