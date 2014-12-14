Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaLNUmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:42:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaLNUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 10/19] net: fix suspicious rcu_dereference_check in net/sched/sch_fq_codel.c
Date: Sun, 14 Dec 2014 12:21:21 -0800
Message-Id: <20141214201823.837896625@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201823.543296369@linuxfoundation.org>
References: <20141214201823.543296369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>

[ Upstream commit 69204cf7eb9c5a72067ce6922d4699378251d053 ]

commit 46e5da40ae (net: qdisc: use rcu prefix and silence
 sparse warnings) triggers a spurious warning:

net/sched/sch_fq_codel.c:97 suspicious rcu_dereference_check() usage!

The code should be using the _bh variant of rcu_dereference.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq_codel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -94,7 +94,7 @@ static unsigned int fq_codel_classify(st
 	    TC_H_MIN(skb->priority) <= q->flows_cnt)
 		return TC_H_MIN(skb->priority);
 
-	filter = rcu_dereference(q->filter_list);
+	filter = rcu_dereference_bh(q->filter_list);
 	if (!filter)
 		return fq_codel_hash(q, skb) + 1;
 


