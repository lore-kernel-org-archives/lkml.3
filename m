Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab3D2Tmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:42:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759391Ab3D2TCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vasily Averin <vvs@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/42] cbq: incorrect processing of high limits
Date: Mon, 29 Apr 2013 12:02:01 -0700
Message-Id: <20130429184754.548083065@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cbq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -962,8 +962,11 @@ cbq_dequeue(struct Qdisc *sch)
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


