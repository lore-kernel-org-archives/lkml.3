Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaLIVQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:16:02 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:43124 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbaLIVP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:15:59 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: [PATCH] fix suspicious rcu_dereference_check in net/sched/sch_fq_codel.c
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 09 Dec 2014 16:15:50 -0500
Message-ID: <58905.1418159750@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 46e5da40ae (net: qdisc: use rcu prefix and silence
 sparse warnings) triggers a spurious warning:

net/sched/sch_fq_codel.c:97 suspicious rcu_dereference_check() usage!

The code should be using the _bh variant of rcu_dereference.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
 net/sched/sch_fq_codel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index b9ca32ebc1de..1e52decb7b59 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -94,7 +94,7 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 	    TC_H_MIN(skb->priority) <= q->flows_cnt)
 		return TC_H_MIN(skb->priority);
 
-	filter = rcu_dereference(q->filter_list);
+	filter = rcu_dereference_bh(q->filter_list);
 	if (!filter)
 		return fq_codel_hash(q, skb) + 1;
 
-- 
2.2.0


