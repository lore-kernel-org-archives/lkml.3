Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaHQN3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:29:55 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61106 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaHQN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:29:54 -0400
Date: Sun, 17 Aug 2014 16:29:43 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: pshelar@nicira.com, davem@davemloft.net, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] net/openvswitch/flow.c: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140817132943.GA2142@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "rcu_dereference()" call is used directly in a condition.
Since its return value is never dereferenced it is recommended to use
"rcu_access_pointer()" instead of "rcu_dereference()".
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
@@

(
 if(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
|
 while(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 net/openvswitch/flow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 334751c..a329112 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -89,7 +89,7 @@ void ovs_flow_stats_update(struct sw_flow *flow, struct sk_buff *skb)
 			 * allocated stats as we have already locked them.
 			 */
 			if (likely(flow->stats_last_writer != NUMA_NO_NODE)
-			    && likely(!rcu_dereference(flow->stats[node]))) {
+			    && likely(!rcu_access_pointer(flow->stats[node]))) {
 				/* Try to allocate node-specific stats. */
 				struct flow_stats *new_stats;
 
-- 
1.9.1

