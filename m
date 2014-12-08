Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaLHX6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:58:23 -0500
Received: from ozlabs.org ([103.22.144.67]:59509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaLHX6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:58:22 -0500
Date: Tue, 9 Dec 2014 10:58:19 +1100
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, tj@kernel.org, fengguang.wu@intel.com,
        rafael.j.wysocki@intel.com, yuyang.du@intel.com, lkp@01.org,
        yuanhan.liu@linux.intel.com, pjt@google.com, bsegall@google.com,
        daniel@numascale.com, subbaram@codeaurora.org,
        computersforpeace@gmail.com, sp@datera.io,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au
Subject: [PATCH] powerpc: secondary CPUs signal to master before setting
 active and online (fixes kernel BUG at kernel/smpboot.c:134!)
Message-ID: <20141209105819.0e847b4b@kryten>
In-Reply-To: <20141208211859.6e81ec81@kryten>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
	<20141208083408.GA8023@gmail.com>
	<20141208211859.6e81ec81@kryten>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> At that point I thought the previous task_cpu() was somewhat ingrained
> in the scheduler and came up with the patch. If not, we could go on a
> hunt to see what else needs fixing.

I had another look. The scheduled does indeed make assumptions about the
previous task_cpu, but we have a hammer to fix it up called
select_fallback_rq.

I annotated select_fallback_rq, and did hit a case where the CPU was
not active. ppc64 patch below.

I think x86 have a similar (although harder to hit) issue. While it
does wait for the cpu_online bit to be set:

        while (!cpu_online(cpu)) {
                cpu_relax();
                touch_nmi_watchdog();
        }

The cpu_active bit is set after the cpu_online bit:

void set_cpu_online(unsigned int cpu, bool online)
{
        if (online) {
                cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
                cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));

If the CPU got delayed between the two stores (eg a KVM guest had the CPU
scheduled out), then we'd end up with cpu_active unset and hit the same
issue in select_fallback_rq.

Anton
--

I have a busy ppc64le KVM box where guests sometimes hit the infamous
"kernel BUG at kernel/smpboot.c:134!" issue during boot:

BUG_ON(td->cpu != smp_processor_id());

Basically a per CPU hotplug thread scheduled on the wrong CPU. The oops
output confirms it:

CPU: 0
Comm: watchdog/130

The problem is that we aren't ensuring the CPU active and online bits are set
before allowing the master to continue on. The master unparks the secondary
CPUs kthreads and the scheduler looks for a CPU to run on. It calls
select_task_rq and realises the suggested CPU is not in the cpus_allowed
mask. It then ends up in select_fallback_rq, and since the active and
online bits aren't set we choose some other CPU to run on.

Cc: stable@vger.kernel.org
Signed-off-by: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/kernel/smp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 71e186d..d40e46e 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -700,7 +700,6 @@ void start_secondary(void *unused)
 	smp_store_cpu_info(cpu);
 	set_dec(tb_ticks_per_jiffy);
 	preempt_disable();
-	cpu_callin_map[cpu] = 1;
 
 	if (smp_ops->setup_cpu)
 		smp_ops->setup_cpu(cpu);
@@ -739,6 +738,14 @@ void start_secondary(void *unused)
 	notify_cpu_starting(cpu);
 	set_cpu_online(cpu, true);
 
+	/*
+	 * CPU must be marked active and online before we signal back to the
+	 * master, because the scheduler needs to see the cpu_online and
+	 * cpu_active bits set.
+	 */
+	smp_wmb();
+	cpu_callin_map[cpu] = 1;
+
 	local_irq_enable();
 
 	cpu_startup_entry(CPUHP_ONLINE);
-- 
2.1.0

