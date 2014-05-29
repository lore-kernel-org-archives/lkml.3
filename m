Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbaE2Efq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbaE2Efg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Fastabend <john.r.fastabend@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 105/140] net: sched: lock imbalance in hhf qdisc
Date: Wed, 28 May 2014 21:34:04 -0700
Message-Id: <20140529043103.094942791@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit f6a082fed1e6407c2f4437d0d963b1bcbe5f9f58 ]

hhf_change() takes the sch_tree_lock and releases it but misses the
error cases. Fix the missed case here.

To reproduce try a command like this,

# tc qdisc change dev p3p2 root hhf quantum 40960 non_hh_weight 300000

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hhf.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -553,11 +553,6 @@ static int hhf_change(struct Qdisc *sch,
 	if (err < 0)
 		return err;
 
-	sch_tree_lock(sch);
-
-	if (tb[TCA_HHF_BACKLOG_LIMIT])
-		sch->limit = nla_get_u32(tb[TCA_HHF_BACKLOG_LIMIT]);
-
 	if (tb[TCA_HHF_QUANTUM])
 		new_quantum = nla_get_u32(tb[TCA_HHF_QUANTUM]);
 
@@ -567,6 +562,12 @@ static int hhf_change(struct Qdisc *sch,
 	non_hh_quantum = (u64)new_quantum * new_hhf_non_hh_weight;
 	if (non_hh_quantum > INT_MAX)
 		return -EINVAL;
+
+	sch_tree_lock(sch);
+
+	if (tb[TCA_HHF_BACKLOG_LIMIT])
+		sch->limit = nla_get_u32(tb[TCA_HHF_BACKLOG_LIMIT]);
+
 	q->quantum = new_quantum;
 	q->hhf_non_hh_weight = new_hhf_non_hh_weight;
 


