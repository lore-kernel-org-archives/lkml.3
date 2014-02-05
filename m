Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbaBEVEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:04:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:54503 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbaBEUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 052/213] net_sched: gred: Fix oops in gred_dump() in WRED mode
Date: Wed, 5 Feb 2014 15:00:07 -0500
Message-ID: <1391630568-49251-53-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ward <david.ward@ll.mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 244b65dbfede788f2fa3fe2463c44d0809e97c6b upstream.

A parameter set exists for WRED mode, called wred_set, to hold the same
values for qavg and qidlestart across all VQs. The WRED mode values had
been previously held in the VQ for the default DP. After these values
were moved to wred_set, the VQ for the default DP was no longer created
automatically (so that it could be omitted on purpose, to have packets
in the default DP enqueued directly to the device without using RED).

However, gred_dump() was overlooked during that change; in WRED mode it
still reads qavg/qidlestart from the VQ for the default DP, which might
not even exist. As a result, this command sequence will cause an oops:

tc qdisc add dev $DEV handle $HANDLE parent $PARENT gred setup \
    DPs 3 default 2 grio
tc qdisc change dev $DEV handle $HANDLE gred DP 0 prio 8 $RED_OPTIONS
tc qdisc change dev $DEV handle $HANDLE gred DP 1 prio 8 $RED_OPTIONS

This fixes gred_dump() in WRED mode to use the values held in wred_set.

Signed-off-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
[PG: in 2.6.34 it is tab[]->parms vs. tab[]->vars of 3.4 baseline]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sched/sch_gred.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 51dcc2aa5c92..7d97904c7dae 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -545,11 +545,8 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 		opt.packets	= q->packetsin;
 		opt.bytesin	= q->bytesin;
 
-		if (gred_wred_mode(table)) {
-			q->parms.qidlestart =
-				table->tab[table->def]->parms.qidlestart;
-			q->parms.qavg = table->tab[table->def]->parms.qavg;
-		}
+		if (gred_wred_mode(table))
+			gred_load_wred_set(table, q);
 
 		opt.qave = red_calc_qavg(&q->parms, q->parms.qavg);
 
-- 
1.8.5.2

