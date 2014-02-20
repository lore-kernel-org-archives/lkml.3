Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaBTWJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:09:08 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17071 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaBTWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:09:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 20 Feb 2014 14:05:51 -0800
Message-ID: <53067C82.4080807@nvidia.com>
Date: Thu, 20 Feb 2014 14:06:58 -0800
From: Sai <sgurrappadi@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <peterz@infradead.org>, <mingo@redhat.com>
Subject: [RFC PATCH] sched: Update cpu_load before nohz ilb
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the cpu_load of the kickee in run_rebalance_domains before
calling rebalance_domains if the kickee is in nohz_idle. This avoids
using stale cpu_load for the subsequent load_balance.

cpu_load in the nohz path is updated on tick_nohz_idle_exit or if a
kickee performances balancing on the behalf of tickless cpus in
nohz_idle_balance. However, the kickee's cpu_load is never updated if it
doesn't exit nohz_idle. This causes stale cpu_load to be used which
causes incorrect load balancing decisions.

Tested on k3.10.

Signed-off-by: Sai Gurrappadi <sgurrappadi@nvidia.com>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 860a152..1d4eb4a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7140,6 +7140,13 @@ static void run_rebalance_domains(struct
softirq_action *h)
        enum cpu_idle_type idle = this_rq->idle_balance ?
                                                CPU_IDLE : CPU_NOT_IDLE;

+       if (test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_rq->cpu))) {
+               raw_spin_lock_irq(&this_rq->lock);
+               update_rq_clock(this_rq);
+               update_idle_cpu_load(this_rq);
+               raw_spin_unlock_irq(&this_rq->lock);
+       }
+
        rebalance_domains(this_rq, idle);

        /*
-- 
1.8.1.5
