Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab3EGNlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42258 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab3EGNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vasily Averin <vvs@openvz.org>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 042/118] cbq: incorrect processing of high limits
Date: Tue,  7 May 2013 14:38:08 +0100
Message-Id: <1367933964-1564-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

commit f0f6ee1f70c4eaab9d52cf7d255df4bd89f8d1c2 upstream.

currently cbq works incorrectly for limits > 10% real link bandwidth,
and practically does not work for limits > 50% real link bandwidth.
Below are results of experiments taken on 1 Gbit link

 In shaper | Actual Result
-----------+---------------
  100M     | 108 Mbps
  200M     | 244 Mbps
  300M     | 412 Mbps
  500M     | 893 Mbps

This happen because of q->now changes incorrectly in cbq_dequeue():
when it is called before real end of packet transmitting,
L2T is greater than real time delay, q_now gets an extra boost
but never compensate it.

To fix this problem we prevent change of q->now until its synchronization
with real time.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Reviewed-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sched/sch_cbq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 564b9fc..611d5e9 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -963,8 +963,11 @@ cbq_dequeue(struct Qdisc *sch)
 		cbq_update(q);
 		if ((incr -= incr2) < 0)
 			incr = 0;
+		q->now += incr;
+	} else {
+		if (now > q->now)
+			q->now = now;
 	}
-	q->now += incr;
 	q->now_rt = now;
 
 	for (;;) {
-- 
1.8.1.2

