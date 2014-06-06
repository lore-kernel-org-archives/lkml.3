Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaFFMan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:30:43 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55594 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaFFMal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:30:41 -0400
Message-ID: <5391B413.100@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2014 17:59:07 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: ego@linux.vnet.ibm.com, matt@ozlabs.org, mahesh@linux.vnet.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        suzuki@in.ibm.com, ebiederm@xmission.com, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, Vivek Goyal <vgoyal@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH] powerpc, kexec: Fix "Processor X is stuck" issue during
 kexec from ST mode
References: <20140527105511.24309.74320.stgit@srivatsabhat.in.ibm.com> <20140528133143.GK14863@redhat.com> <538E2FF8.8060707@linux.vnet.ibm.com> <1401833365.3247.36.camel@pasglop>
In-Reply-To: <1401833365.3247.36.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060612-9574-0000-0000-00000E1576EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 03:39 AM, Benjamin Herrenschmidt wrote:
> On Wed, 2014-06-04 at 01:58 +0530, Srivatsa S. Bhat wrote:
>> Yep, that makes sense. But unfortunately I don't have enough insight into
>> why exactly powerpc has to online the CPUs before doing a kexec. I just
>> know from the commit log and the comment mentioned above (and from my own
>> experiments) that the CPUs will get stuck if they were offline. Perhaps
>> somebody more knowledgeable can explain this in detail and suggest a proper
>> long-term solution.
>>
>> Matt, Ben, any thoughts on this?
> 
> The problem is with our "soft offline" which we do on some platforms. When we
> offline we don't actually send the CPUs back to firmware or anything like that.
> 
> We put them into a very low low power loop inside Linux.
> 
> The new kernel has no way to extract them from that loop. So we must re-"online"
> them before we kexec so they can be passed to the new kernel normally (or returned
> to firmware like we do on powernv).
> 

Thanks a lot for the explanation Ben!

I thought about this and this is what I think: whether the CPU is in the kernel
or in the firmware is a hard-boundary. But once we know it is still in the
kernel, whether it is online or offline is a soft-boundary, something that
ideally shouldn't make any difference to kexec.

Then I looked at what is that special state that kexec expects the online CPUs
to be in, before performing kexec, and I found that that state is entered via
kexec_smp_down().

Which means, if we poke the soft-offline CPUs and make them execute
kexec_smp_down(), we should be able to do a successful kexec without having to
actually online them. After all, the core kexec code doesn't mandate that they
should be online. So if we satisfy powerpc's requirement that all the CPUs are
in a sane state, that should be good enough. (This would be similar to how the
subcore code wakes up offline CPUs to perform the split-core procedure).

I know, this is all theory for now since I haven't tested it yet, but I think
we can make this work.

Below are the 4 preliminary patches I'm have so far, to implement this.


===============================================================================
				Patch 1
===============================================================================

diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index 16d7e33..2a31b52 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -68,6 +68,7 @@ static inline void crash_setup_regs(struct pt_regs *newregs,
 		ppc_save_regs(newregs);
 }
 
+extern bool kexec_cpu_wake(void);
 extern void kexec_smp_wait(void);	/* get and clear naca physid, wait for
 					  master to copy new code to 0 */
 extern int crashing_cpu;
diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index f92b0b5..39f721d 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -255,6 +255,16 @@ struct machdep_calls {
 	void (*machine_shutdown)(void);
 
 #ifdef CONFIG_KEXEC
+#if (defined CONFIG_PPC64) && (defined CONFIG_PPC_BOOK3S)
+
+	/*
+	 * The pseries and powernv book3s platforms have a special requirement
+	 * that soft-offline CPUs have to be woken up before kexec, to avoid
+	 * CPUs getting stuck. This callback prepares the system for the
+	 * impending wakeup of the offline CPUs.
+	 */
+	void (*kexec_wake_prepare)(void);
+#endif
 	void (*kexec_cpu_down)(int crash_shutdown, int secondary);
 
 	/* Called to do what every setup is needed on image and the
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 879b3aa..2ef6c58 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -182,6 +182,14 @@ static void kexec_smp_down(void *arg)
 	/* NOTREACHED */
 }
 
+bool kexec_cpu_wake(void)
+{
+	kexec_smp_down(NULL);
+
+	/* NOTREACHED */
+	return true;
+}
+
 static void kexec_prepare_cpus_wait(int wait_state)
 {
 	int my_cpu, i, notified=-1;
@@ -202,7 +210,7 @@ static void kexec_prepare_cpus_wait(int wait_state)
 	 * these possible-but-not-online-but-should-be CPUs and chaperone them
 	 * into kexec_smp_wait().
 	 */
-	for_each_online_cpu(i) {
+	for_each_present_cpu(i) {
 		if (i == my_cpu)
 			continue;
 
@@ -228,6 +236,8 @@ static void kexec_prepare_cpus_wait(int wait_state)
  * threads as offline -- and again, these CPUs will be stuck.
  *
  * So, we online all CPUs that should be running, including secondary threads.
+ *
+ * TODO: Update this comment
  */
 static void wake_offline_cpus(void)
 {
@@ -237,7 +247,8 @@ static void wake_offline_cpus(void)
 		if (!cpu_online(cpu)) {
 			printk(KERN_INFO "kexec: Waking offline cpu %d.\n",
 			       cpu);
-			WARN_ON(cpu_up(cpu));
+			/* This should work even though the cpu is offline */
+			smp_send_reschedule(cpu);
 		}
 	}
 }



===============================================================================
				Patch 2
===============================================================================

diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index 75501bf..910081c 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -27,4 +27,8 @@ extern void pnv_lpc_init(void);
 
 bool cpu_core_split_required(void);
 
+#ifdef CONFIG_KEXEC
+extern void pnv_kexec_wake_prepare(void);
+#endif
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 8c16a5f..8dbccb7 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -331,6 +331,7 @@ define_machine(powernv) {
 	.calibrate_decr		= generic_calibrate_decr,
 	.dma_set_mask		= pnv_dma_set_mask,
 #ifdef CONFIG_KEXEC
+	.kexec_wake_prepare	= pnv_kexec_wake_prepare,
 	.kexec_cpu_down		= pnv_kexec_cpu_down,
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 0062a43..0b017b0 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -32,6 +32,7 @@
 #include <asm/opal.h>
 #include <asm/runlatch.h>
 #include <asm/code-patching.h>
+#include <asm/kexec.h>
 
 #include "powernv.h"
 
@@ -140,6 +141,15 @@ static int pnv_smp_cpu_disable(void)
 	return 0;
 }
 
+#ifdef CONFIG_KEXEC
+static bool kexec_wake_offline_cpus;
+
+void pnv_kexec_wake_prepare(void)
+{
+	kexec_wake_offline_cpus = true;
+}
+#endif
+
 static void pnv_smp_cpu_kill_self(void)
 {
 	unsigned int cpu;
@@ -170,6 +180,11 @@ static void pnv_smp_cpu_kill_self(void)
 		if (cpu_core_split_required())
 			continue;
 
+#ifdef CONFIG_KEXEC
+		if (kexec_wake_offline_cpus)
+			kexec_cpu_wake(); /* This function won't return! */
+#endif
+
 		if (!generic_check_cpu_restart(cpu))
 			DBG("CPU%d Unexpected exit while offline !\n", cpu);
 	}




===============================================================================
				Patch 3
===============================================================================

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 20d6297..d026028 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -31,6 +31,7 @@
 #include <asm/vdso_datapage.h>
 #include <asm/xics.h>
 #include <asm/plpar_wrappers.h>
+#include <asm/kexec.h>
 
 #include "offline_states.h"
 
@@ -143,6 +144,13 @@ static void pseries_mach_cpu_die(void)
 			get_lppaca()->donate_dedicated_cpu = 0;
 		get_lppaca()->idle = 0;
 
+#if CONFIG_KEXEC
+		if (get_preferred_offline_state(cpu) == CPU_STATE_KEXEC_WAKE) {
+			/* This function won't return! */
+			kexec_cpu_wake();
+		}
+#endif
+
 		if (get_preferred_offline_state(cpu) == CPU_STATE_ONLINE) {
 			unregister_slb_shadow(hwcpu);
 
diff --git a/arch/powerpc/platforms/pseries/kexec.c b/arch/powerpc/platforms/pseries/kexec.c
index 13fa95b3..fc135e6 100644
--- a/arch/powerpc/platforms/pseries/kexec.c
+++ b/arch/powerpc/platforms/pseries/kexec.c
@@ -20,6 +20,17 @@
 #include <asm/plpar_wrappers.h>
 
 #include "pseries.h"
+#include "offline_states.h"
+
+void pseries_kexec_wake_prepare(void)
+{
+	unsigned int cpu;
+
+	for_each_present_cpu(cpu) {
+		if (!cpu_online(cpu))
+			set_preferred_offline_state(cpu, CPU_STATE_KEXEC_WAKE);
+	}
+}
 
 static void pseries_kexec_cpu_down(int crash_shutdown, int secondary)
 {
diff --git a/arch/powerpc/platforms/pseries/offline_states.h b/arch/powerpc/platforms/pseries/offline_states.h
index 08672d9..32fe5e8 100644
--- a/arch/powerpc/platforms/pseries/offline_states.h
+++ b/arch/powerpc/platforms/pseries/offline_states.h
@@ -5,6 +5,9 @@
 enum cpu_state_vals {
 	CPU_STATE_OFFLINE,
 	CPU_STATE_INACTIVE,
+#ifdef CONFIG_KEXEC
+	CPU_STATE_KEXEC_WAKE,
+#endif
 	CPU_STATE_ONLINE,
 	CPU_MAX_OFFLINE_STATES
 };
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index 361add6..35ecb99 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -38,6 +38,8 @@ static inline void smp_init_pseries_xics(void) { };
 #endif
 
 #ifdef CONFIG_KEXEC
+extern void pseries_kexec_wake_prepare(void);
+
 extern void setup_kexec_cpu_down_xics(void);
 extern void setup_kexec_cpu_down_mpic(void);
 #else
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index adc21a0..c1a0722 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -808,6 +808,7 @@ define_machine(pseries) {
 	.system_reset_exception = pSeries_system_reset_exception,
 	.machine_check_exception = pSeries_machine_check_exception,
 #ifdef CONFIG_KEXEC
+	.kexec_wake_prepare	= pseries_kexec_wake_prepare,
 	.machine_kexec          = pSeries_machine_kexec,
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE



===============================================================================
				Patch 4
===============================================================================

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 28c5706..55a6350 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1684,13 +1684,6 @@ int kernel_kexec(void)
 		kernel_restart_prepare(NULL);
 		migrate_to_reboot_cpu();
 
-		/*
-		 * migrate_to_reboot_cpu() disables CPU hotplug assuming that
-		 * no further code needs to use CPU hotplug (which is true in
-		 * the reboot case). However, the kexec path depends on using
-		 * CPU hotplug again; so re-enable it here.
-		 */
-		cpu_hotplug_enable();
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();
 	}

