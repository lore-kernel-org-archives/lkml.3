Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3FWNma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 09:42:30 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56585 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3FWNmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 09:42:24 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 05/45] CPU hotplug: Protect set_cpu_online() to avoid
 false-positives
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
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Sun, 23 Jun 2013 19:09:02 +0530
Message-ID: <20130623133858.19094.70477.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062313-8878-0000-0000-000007A61883
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bringing a secondary CPU online, the task running on the CPU coming up
sets itself in the cpu_online_mask. This is safe even though this task is not
the hotplug writer task.

But it is kinda hard to teach this to the CPU hotplug debug infrastructure,
and if we get it wrong, we risk making the debug code too lenient, risking
false-negatives.

Luckily, all architectures use set_cpu_online() to manipulate the
cpu_online_mask. So, to avoid false-positive warnings from the CPU hotplug
debug code, encapsulate the body of set_cpu_online() within
get/put_online_cpus_atomic().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index e90d9d7..23df9ba 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -818,10 +818,14 @@ void set_cpu_present(unsigned int cpu, bool present)
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
+	get_online_cpus_atomic();
+
 	if (online)
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+
+	put_online_cpus_atomic();
 }
 
 void set_cpu_active(unsigned int cpu, bool active)

