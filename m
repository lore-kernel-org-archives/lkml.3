Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaDEDWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 23:22:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45409 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbaDEDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 23:22:24 -0400
Date: Fri, 4 Apr 2014 21:22:16 -0600
From: Jens Axboe <axboe@fb.com>
To: <akpm@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix bad percpu counter state during suspend
Message-ID: <20140405032216.GA18464@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-04_08:2014-04-04,2014-04-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.16962973195633e-08 kscore.compositescore=0
 circleOfTrustscore=37.7501936418875 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404040273
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got a bug report yesterday from Laszlo Ersek <lersek@redhat.com>, in
which he states that his kvm instance fails to suspend. He Laszlo
bisected it down to this commit:

commit 1cf7e9c68fe84248174e998922b39e508375e7c1
  Author: Jens Axboe <axboe@kernel.dk>
  Date:   Fri Nov 1 10:52:52 2013 -0600

      virtio_blk: blk-mq support

where virtio-blk is converted to use the blk-mq infrastructure. After
digging a bit, it became clear that the issue was with the queue drain.
blk-mq tracks queue usage in a percpu counter, which is incremented on
request alloc and decremented when the request is freed. The initial
hunt was for an inconsistency in blk-mq, but everything seemed fine. In
fact, the counter only returned crazy values when suspend was in
progress. When a CPU is unplugged, the percpu counters merges that CPU
state with the general state. blk-mq takes care to register a hotcpu
notifier with the appropriate priority, so we know it runs after the
percpu counter notifier. However, the percpu counter notifier only
merges the state when the CPU is fully gone. This leaves a state
transition where the CPU going away is no longer in the online mask, yet
it still holds private values. This means that in this state,
percpu_counter_sum() returns invalid results, and the suspend then hangs
waiting for abs(dead-cpu-value) requests to complete which of course
will never happen.

Fix this by clearing the state earlier, so we never have a case where
the CPU isn't in online mask but still holds private state. This bug has
been there since forever, I guess we don't have a lot of users where
percpu counters needs to be reliable during the suspend cycle.

Reported-by: Laszlo Ersek <lersek@redhat.com>
Tested-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 8280a5dd1727..7dd33577b905 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -169,7 +169,7 @@ static int percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	struct percpu_counter *fbc;
 
 	compute_batch_value();
-	if (action != CPU_DEAD)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	cpu = (unsigned long)hcpu;

-- 
Jens Axboe

