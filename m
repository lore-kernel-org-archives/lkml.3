Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbbAMVRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:17:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38230 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbbAMVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:17:06 -0500
Date: Tue, 13 Jan 2015 13:16:18 -0800
From: Calvin Owens <calvinowens@fb.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <calvinowens@fb.com>
Subject: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before poking
 RCU
Message-ID: <20150113211618.GA21498@mail.thefacebook.com>
References: <1420594659-16996-1-git-send-email-calvinowens@fb.com>
 <20150107014906.GA27996@mail.thefacebook.com>
 <20150107021926.GT5280@linux.vnet.ibm.com>
 <20150107165223.GA21555@linux.vnet.ibm.com>
 <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com>
 <20150108214644.GC27996@mail.thefacebook.com>
 <alpine.DEB.2.11.1501131215380.5526@nanos>
 <20150113184301.GO9719@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150113184301.GO9719@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_07:2015-01-13,2015-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=3.45033029023803
 compositescore=0.928708196901072 urlsuspect_oldscore=0.928708196901072
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928708196901072 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501130207
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging an issue with excessive softirq usage, I encountered the
following note in commit 3e339b5dae24a706 ("softirq: Use hotplug thread
infrastructure"):

    [ paulmck: Call rcu_note_context_switch() with interrupts enabled. ]

...but despite this note, the patch still calls RCU with IRQs disabled.

This seemingly innocuous change caused a significant regression in softirq
CPU usage on the sending side of a large TCP transfer (~1 GB/s): when
introducing 0.01% packet loss, the softirq usage would jump to around 25%,
spiking as high as 50%. Before the change, the usage would never exceed 5%.

Moving the call to rcu_note_context_switch() after the cond_sched() call,
as it was originally before the hotplug patch, completely eliminated this
problem.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
Cc: stable@vger.kernel.org
---
This version includes the "cpu" argument to rcu_note_context_switch() in
order to apply cleanly to stable kernels. It will need to be removed to
apply to 3.18+ and 3.19 (upstream commit 38200cf2 removed the argument).

 kernel/softirq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 501baa9..9e787d8 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -656,9 +656,13 @@ static void run_ksoftirqd(unsigned int cpu)
 		 * in the task stack here.
 		 */
 		__do_softirq();
-		rcu_note_context_switch(cpu);
 		local_irq_enable();
 		cond_resched();
+
+		preempt_disable();
+		rcu_note_context_switch(cpu);
+		preempt_enable();
+
 		return;
 	}
 	local_irq_enable();
-- 
2.1.1

