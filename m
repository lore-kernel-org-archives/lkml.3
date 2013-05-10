Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3EJOns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:43:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57051 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab3EJOUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vasily Averin" <vvs@parallels.com>,
        "Eric Dumazet" <edumazet@google.com>, "Vasily Averin" <vvs@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.15040882@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [085/118] cbq: incorrect processing of high limits
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

[ Upstream commit f0f6ee1f70c4eaab9d52cf7d255df4bd89f8d1c2 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_cbq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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

