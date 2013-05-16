Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3EPKRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:17:50 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:9970 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab3EPKRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:17:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>
CC: <leoli@freescale.com>, <scottwood@freescale.com>,
        <Priyanka.Jain@freescale.com>
Subject: [PATCH][RFC] kernel/cpu: do not change the cpus_allowed of the current task when unplugging cpus
Date: Thu, 16 May 2013 18:17:19 +0800
Message-ID: <1368699439-13034-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found a problem. When a cpu is brought down using _cpu_down(),
the corresponding cpu bit in the cpus_allowed of the current task is
cleared. But this bit will not be set when the same cpu is online again.
Then, the current task and its child processes will not be allowed to
run on this cpu.

To fix this problem, some related code in the commit cc4088a (hotplug:
Lightweight get online cpus) is removed.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 kernel/cpu.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index bfeeb00..e25b05f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -524,14 +524,13 @@ static int __ref take_cpu_down(void *_param)
 /* Requires cpu_add_remove_lock to be held */
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
-	int mycpu, err, nr_calls = 0;
+	int err, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
 		.mod = mod,
 		.hcpu = hcpu,
 	};
-	cpumask_var_t cpumask;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -539,19 +538,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	/* Move the downtaker off the unplug cpu */
-	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
-		return -ENOMEM;
-	cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
-	set_cpus_allowed_ptr(current, cpumask);
-	free_cpumask_var(cpumask);
 	migrate_disable();
-	mycpu = smp_processor_id();
-	if (mycpu == cpu) {
-		printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
-		migrate_enable();
-		return -EBUSY;
-	}
 
 	cpu_hotplug_begin();
 	err = cpu_unplug_begin(cpu);
-- 
1.7.3


