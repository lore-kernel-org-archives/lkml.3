Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3CTKEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:04:47 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49884 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CTKEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:04:45 -0400
Message-ID: <514988F9.2000005@linux.vnet.ibm.com>
Date: Wed, 20 Mar 2013 15:31:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        andi@firstfloor.org, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] x86/mce: Rework cmci_rediscover() to play well with CPU hotplug
References: <20130319224408.GB18152@redhat.com> <20130320031647.GA13311@gchen.bj.intel.com>
In-Reply-To: <20130320031647.GA13311@gchen.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 13032009-3568-0000-0000-00000350EC12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 08:46 AM, Chen Gong wrote:
> On Tue, Mar 19, 2013 at 06:44:08PM -0400, Dave Jones wrote:
>>
>> offlining a CPU in 3.9-rc3 gets me this trace..
>>
>> numa_remove_cpu cpu 1 node 0: mask now 0,2-3
>> smpboot: CPU 1 is now offline
>> BUG: using smp_processor_id() in preemptible [00000000] code: cpu-offline.sh/10591
>> caller is cmci_rediscover+0x6a/0xe0
>> Pid: 10591, comm: cpu-offline.sh Not tainted 3.9.0-rc3+ #2
>> Call Trace:
>>  [<ffffffff81333bbd>] debug_smp_processor_id+0xdd/0x100
>>  [<ffffffff8101edba>] cmci_rediscover+0x6a/0xe0
>>  [<ffffffff815f5b9f>] mce_cpu_callback+0x19d/0x1ae
>>  [<ffffffff8160ea66>] notifier_call_chain+0x66/0x150
>>  [<ffffffff8107ad7e>] __raw_notifier_call_chain+0xe/0x10
>>  [<ffffffff8104c2e3>] cpu_notify+0x23/0x50
>>  [<ffffffff8104c31e>] cpu_notify_nofail+0xe/0x20
>>  [<ffffffff815ef082>] _cpu_down+0x302/0x350
>>  [<ffffffff815ef106>] cpu_down+0x36/0x50
>>  [<ffffffff815f1c9d>] store_online+0x8d/0xd0
>>  [<ffffffff813edc48>] dev_attr_store+0x18/0x30
>>  [<ffffffff81226eeb>] sysfs_write_file+0xdb/0x150
>>  [<ffffffff811adfb2>] vfs_write+0xa2/0x170
>>  [<ffffffff811ae16c>] sys_write+0x4c/0xa0
>>  [<ffffffff81613019>] system_call_fastpath+0x16/0x1b
>>
> Try this patch:
> 
> diff a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 402c454..692c91e 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -311,10 +311,12 @@ void cmci_rediscover(int dying)
>                 if (cpu == dying)
>                         continue;
> 
> -               if (cpu == smp_processor_id()) {
> +               if (cpu == get_cpu()) {
> +                       put_cpu();
>                         cmci_rediscover_work_func(NULL);
>                         continue;
> -               }
> +               } else
> +                       put_cpu();
> 
>                 work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
>         }
> 

That doesn't really look right to me. In fact, the function cmci_rediscover()
looks like it needs some attention. Let me quote the function here, so
that its easier to discuss what's wrong with it..


/*
 * After a CPU went down cycle through all the others and rediscover
 * Must run in process context.
 */
void cmci_rediscover(int dying)
{
        int cpu, banks;

        if (!cmci_supported(&banks))
                return;

        for_each_online_cpu(cpu) {
                if (cpu == dying)
                        continue;

                if (cpu == smp_processor_id()) {
                        cmci_rediscover_work_func(NULL);
                        continue;
                }

                work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
	}
}

First of all, I think the comment that says that it must run in process
context, is stale. I think its a remnant of the code which used to do
GFP_KERNEL allocations for a temporary cpumask (looking at git logs).
The function cmci_discover() takes a spin lock with irqs disabled. So
obviously this whole thing can run in atomic context.

And cmci_rediscover() is called from CPU_POST_DEAD handler. So the CPU
which was supposed to go offline would have already gone offline and
out of the cpu_online_mask. So there is no point checking
'if (cpu == dying)' in that for-loop.

So, how about something like this:

------------------------------------------------------------>

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] x86/mce: Rework cmci_rediscover() to play well with CPU hotplug

Dave Jones reports that offlining a CPU leads to this trace:

numa_remove_cpu cpu 1 node 0: mask now 0,2-3
smpboot: CPU 1 is now offline
BUG: using smp_processor_id() in preemptible [00000000] code:
cpu-offline.sh/10591
caller is cmci_rediscover+0x6a/0xe0
Pid: 10591, comm: cpu-offline.sh Not tainted 3.9.0-rc3+ #2
Call Trace:
 [<ffffffff81333bbd>] debug_smp_processor_id+0xdd/0x100
 [<ffffffff8101edba>] cmci_rediscover+0x6a/0xe0
 [<ffffffff815f5b9f>] mce_cpu_callback+0x19d/0x1ae
 [<ffffffff8160ea66>] notifier_call_chain+0x66/0x150
 [<ffffffff8107ad7e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff8104c2e3>] cpu_notify+0x23/0x50
 [<ffffffff8104c31e>] cpu_notify_nofail+0xe/0x20
 [<ffffffff815ef082>] _cpu_down+0x302/0x350
 [<ffffffff815ef106>] cpu_down+0x36/0x50
 [<ffffffff815f1c9d>] store_online+0x8d/0xd0
 [<ffffffff813edc48>] dev_attr_store+0x18/0x30
 [<ffffffff81226eeb>] sysfs_write_file+0xdb/0x150
 [<ffffffff811adfb2>] vfs_write+0xa2/0x170
 [<ffffffff811ae16c>] sys_write+0x4c/0xa0
 [<ffffffff81613019>] system_call_fastpath+0x16/0x1b


However, a look at cmci_rediscover shows that it can be simplified quite
a bit, apart from solving the above issue. It invokes functions that
take spin locks with interrupts disabled, and hence it can run in atomic
context. Also, it is run in the CPU_POST_DEAD phase, so the dying CPU
is already dead and out of the cpu_online_mask. So take these points into
account and simplify the code, and thereby also fix the above issue.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/include/asm/mce.h             |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c       |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   25 +++++--------------------
 3 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index f4076af..fa5f71e 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -146,13 +146,13 @@ DECLARE_PER_CPU(struct device *, mce_device);
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
-void cmci_rediscover(int dying);
+void cmci_rediscover(void);
 void cmci_recheck(void);
 #else
 static inline void mce_intel_feature_init(struct cpuinfo_x86 *c) { }
 static inline void cmci_clear(void) {}
 static inline void cmci_reenable(void) {}
-static inline void cmci_rediscover(int dying) {}
+static inline void cmci_rediscover(void) {}
 static inline void cmci_recheck(void) {}
 #endif
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7bc1263..9239504 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2358,7 +2358,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 	if (action == CPU_POST_DEAD) {
 		/* intentionally ignoring frozen here */
-		cmci_rediscover(cpu);
+		cmci_rediscover();
 	}
 
 	return NOTIFY_OK;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 402c454..ae1697c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -285,39 +285,24 @@ void cmci_clear(void)
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
-static long cmci_rediscover_work_func(void *arg)
+static void cmci_rediscover_work_func(void *arg)
 {
 	int banks;
 
 	/* Recheck banks in case CPUs don't all have the same */
 	if (cmci_supported(&banks))
 		cmci_discover(banks);
-
-	return 0;
 }
 
-/*
- * After a CPU went down cycle through all the others and rediscover
- * Must run in process context.
- */
-void cmci_rediscover(int dying)
+/* After a CPU went down cycle through all the others and rediscover */
+void cmci_rediscover(void)
 {
-	int cpu, banks;
+	int banks;
 
 	if (!cmci_supported(&banks))
 		return;
 
-	for_each_online_cpu(cpu) {
-		if (cpu == dying)
-			continue;
-
-		if (cpu == smp_processor_id()) {
-			cmci_rediscover_work_func(NULL);
-			continue;
-		}
-
-		work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
-	}
+	on_each_cpu(cmci_rediscover_work_func, NULL, 1);
 }
 
 /*

