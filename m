Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaHKLlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:41:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52608 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaHKLlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:41:06 -0400
Subject: [RFC PATCH V2 14/19] sched: add power/performance balance allow flag
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:09:58 +0530
Message-ID: <20140811113948.31956.86.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-9332-0000-0000-000001A6A4DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

If a sched domain is idle enough for regular power balance, LBF_POWER_BAL
will be set, LBF_PERF_BAL will be clean. If a sched domain is busy,
their value will be set oppositely.

If the domain is suitable for power balance, but balance should not
be down by this cpu(this cpu is already idle or full), both of flags
are cleared to wait a suitable cpu to do power balance.
That mean no any balance, neither power balance nor performance balance
will be done on this cpu.

Above logical will be implemented by incoming patches.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e7a677e..f9b2a21 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5372,6 +5372,11 @@ enum fbq_type { regular, remote, all };
 #define LBF_DST_PINNED  0x04
 #define LBF_SOME_PINNED	0x08
 
+#ifdef CONFIG_SCHED_POWER
+#define LBF_POWER_BAL  0x08    /* if power balance allowed */
+#define LBF_PERF_BAL   0x10    /* if performance balance allowed */
+#endif
+
 struct lb_env {
 	struct sched_domain	*sd;
 
@@ -6866,6 +6871,9 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+#ifdef CONFIG_SCHED_POWER
+		.flags		= LBF_PERF_BAL,
+#endif
 		.fbq_type	= all,
 	};
 

