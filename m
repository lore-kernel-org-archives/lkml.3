Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3LLMjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:39:10 -0500
Received: from multi.imgtec.com ([194.200.65.239]:7221 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3LLMjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:39:08 -0500
From: Qais Yousef <qais.yousef@imgtec.com>
To: Yang Yingliang <yangyingliang@huawei.com>
CC: Qais Yousef <qais.yousef@imgtec.com>, Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: [PATCH] net/sched/sch_tbf.c: fix linking error
Date: Thu, 12 Dec 2013 12:38:56 +0000
Message-ID: <1386851936-1582-1-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.36]
X-SEF-Processed: 7_3_0_01192__2013_12_12_12_39_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "__udivdi3" [net/sched/sch_tbf.ko] undefined!

introduced by: cc106e441a63 (net: sched: tbf: fix the calculation of max_size)

which adds a 64 by 32 bit division without using do_div().
Fix it by using do_div(len/ 53) instead of len/53.

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-next@vger.kernel.org
---
We caught this error on linux-next today. This is my quick attemp of a fix.
If it's not appropriate or doesn't make sense my apologies and feel free to
resend a better fix :)

 net/sched/sch_tbf.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index a44928c..771cbec 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -131,8 +131,10 @@ static u64 psched_ns_t2l(const struct psched_ratecfg *r,
 
 	do_div(len, NSEC_PER_SEC);
 
-	if (unlikely(r->linklayer == TC_LINKLAYER_ATM))
-		len = (len / 53) * 48;
+	if (unlikely(r->linklayer == TC_LINKLAYER_ATM)) {
+		do_div(len, 53);
+		len *= 48;
+	}
 
 	if (len > r->overhead)
 		len -= r->overhead;
-- 
1.7.1


