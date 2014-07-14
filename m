Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaGNUIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:08:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:61424 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932435AbaGNUFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:05:47 -0400
Message-Id: <20140714200545.962848440@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 14 Jul 2014 16:05:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH RT 3/4] hrtimer:fix the miss of hrtimer_peek_ahead_timers in nort code
References: <20140714200535.671192970@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-hrtimer-fix-the-miss-of-hrtimer_peek_ahead_timers-in.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.97-rt121-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

When we run the test "taskset -c 1 stress -m 1 --vm-bytes 50M" and
"taskset -c 1 cyclictest -t 1 -p 80 -n -m -v" with rt closed 3.4.26-rt38 kernel,
the cyclictest's result is anomalous as follow:
       0:     278:       1
       0:     279:       2
       0:     280:      17
       0:     281:    1657
       0:     282:    1680
       0:     283:    4678
       0:     284:    7026
       0:     285:    6678
       0:     286:    9677
       0:     287:   12678
       0:     288:   13090
       0:     289:   14678
       0:     290:   17677
       0:     291:   20155
       0:     292:   19678
       0:     293:   22679
       0:     294:   25676
       0:     295:   26218
       0:     296:   27679
       0:     297:   30677
       0:     298:   33283
       0:     299:   32677
       0:     300:   35676
and the result is increase continuously forever. We find that the patch
("hrtimer: fixup hrtimer callback changes for preempt-rt") has missed
hrtimer_peek_ahead_timers() in hrtimer_rt_run_pending() fuction in nort
code. We fix this and the test result isn't increase continuously as same
as the result with nort 3.4.26 kernel as follow:
       0:     636:       8
       0:     637:       7
       0:     638:       8
       0:     639:       9
       0:     640:       7
       0:     641:       9
       0:     642:       8
       0:     643:       8
       0:     644:       8
       0:     645:      32
       0:     646:    8683
       0:     647:    7760
       0:     648:    6784
       0:     649:    5797
       0:     650:    4810
       0:     651:    3823
       0:     652:    2836
       0:     653:    1849
       0:     654:     862
       0:     655:       7
       0:     656:       7
       0:     657:       7
       0:     658:       6
       0:     659:       8
       0:     660:       7

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[PG: direct cherry pick of b236e408 from v3.6-rt]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/hrtimer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3f7d3b5b0717..afb62c7cc494 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1457,7 +1457,11 @@ static int hrtimer_rt_defer(struct hrtimer *timer)
 
 #else
 
-static inline void hrtimer_rt_run_pending(void) { }
+static inline void hrtimer_rt_run_pending(void)
+{
+	hrtimer_peek_ahead_timers();
+}
+
 static inline int hrtimer_rt_defer(struct hrtimer *timer) { return 0; }
 
 #endif
-- 
2.0.0


