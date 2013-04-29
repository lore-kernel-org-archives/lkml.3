Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab3D2TT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:19:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763Ab3D2TDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vasily Averin <vvs@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/34] cbq: incorrect processing of high limits
Date: Mon, 29 Apr 2013 12:02:25 -0700
Message-Id: <20130429184702.943709248@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


