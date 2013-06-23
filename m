Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3FWNsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 09:48:55 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41040 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab3FWNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 09:48:51 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 32/45] blackfin/smp: Use get/put_online_cpus_atomic() to
 prevent CPU offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        Steven Miao <realmz6@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        uclinux-dist-devel@blackfin.uclinux.org
Date: Sun, 23 Jun 2013 19:15:29 +0530
Message-ID: <20130623134526.19094.17070.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062313-8878-0000-0000-000007A61AA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able
to depend on disabling preemption to prevent CPUs from going offline
from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/blackfin/mach-common/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 1bc2ce6..11496cd 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -238,13 +238,13 @@ void smp_send_stop(void)
 {
 	cpumask_t callmap;
 
-	preempt_disable();
+	get_online_cpus_atomic();
 	cpumask_copy(&callmap, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &callmap);
 	if (!cpumask_empty(&callmap))
 		send_ipi(&callmap, BFIN_IPI_CPU_STOP);
 
-	preempt_enable();
+	put_online_cpus_atomic();
 
 	return;
 }

