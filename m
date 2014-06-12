Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaFLISn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:18:43 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58497 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbaFLISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:18:38 -0400
Message-ID: <539961FF.3080903@linux.vnet.ibm.com>
Date: Thu, 12 Jun 2014 13:47:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joel Stanley <joel@jms.id.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, ego@linux.vnet.ibm.com,
        matt@ozlabs.org, Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        suzuki@in.ibm.com, ebiederm@xmission.com,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] powerpc, kexec: Fix "Processor X is stuck" issue during
 kexec from ST mode
References: <20140527105511.24309.74320.stgit@srivatsabhat.in.ibm.com> <20140528133143.GK14863@redhat.com> <538E2FF8.8060707@linux.vnet.ibm.com> <1401833365.3247.36.camel@pasglop> <5391B413.100@linux.vnet.ibm.com> <53922FB8.6070408@linux.vnet.ibm.com> <CACPK8Xea+7rPHSCp51fVkX=GTmEwbV0T=JHDZ-XYt6RU96uyyg@mail.gmail.com>
In-Reply-To: <CACPK8Xea+7rPHSCp51fVkX=GTmEwbV0T=JHDZ-XYt6RU96uyyg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061208-2000-0000-0000-000000804BF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

On 06/12/2014 12:09 PM, Joel Stanley wrote:
> Hi Srivatsa,
> 
> On Sat, Jun 7, 2014 at 7:16 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> And with the following hunk added (which I had forgotten earlier), it worked just
>> fine on powernv :-)
> 
> How are the patches coming along?
> 

I'm still waiting to test this patch series on a PowerVM box, and unfortunately
there are some machine issues to debug first :-( So that's why this is taking
time... :-(

> I just hung a machine here while attempting to kexec. It appears to
> have onlined all of the secondary threads, and then hung here:
> 
> kexec: Waking offline cpu 1.
> kvm: enabling virtualization on CPU1
> kexec: Waking offline cpu 2.
> kvm: enabling virtualization on CPU2
> kexec: Waking offline cpu 3.
> kvm: enabling virtualization on CPU3
> kexec: Waking offline cpu 5.
> kvm: enabling virtualization on CPU5
> [...]
> kvm: enabling virtualization on CPU63
> kexec: waiting for cpu 1 (physical 1) to enter OPAL
> kexec: waiting for cpu 2 (physical 2) to enter OPAL
> kexec: waiting for cpu 3 (physical 3) to enter OPAL
> 
> I'm running benh's next branch as of thismorning, and SMT was off.
> 

Oh! This looks like a different hang than the one I tried to fix. My patch
("powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode")
which is already in benh's next branch was aimed at fixing the "CPU is stuck"
issue which was observed during the second kernel boot. If the first kernel
itself is hanging in the down-path, then it looks like a different problem
altogether.

> Could you please post your latest patches a series? I will test them here.
> 

The 4 patches that I proposed in this thread are aimed at making the above
solution more elegant, by not having to actually online the secondary threads
while doing kexec. I don't think it will solve the hang that you are seeing.
In any case, I'll provide the consolidated patch below if you want to give it
a try.

By the way, I have a few questions regarding the hang you observed: is it
always reproducible with SMT=off? And if SMT was 8 (i.e, all CPUs in the system
were online) and then you did a kexec, do you still see the hang?

Regards,
Srivatsa S. Bhat

---------------------------------------------------------------------------

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
index 879b3aa..84e91293 100644
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
 
@@ -228,16 +236,22 @@ static void kexec_prepare_cpus_wait(int wait_state)
  * threads as offline -- and again, these CPUs will be stuck.
  *
  * So, we online all CPUs that should be running, including secondary threads.
+ *
+ * TODO: Update this comment
  */
 static void wake_offline_cpus(void)
 {
 	int cpu = 0;
 
+	if (ppc_md.kexec_wake_prepare)
+		ppc_md.kexec_wake_prepare();
+
 	for_each_present_cpu(cpu) {
 		if (!cpu_online(cpu)) {
 			printk(KERN_INFO "kexec: Waking offline cpu %d.\n",
 			       cpu);
-			WARN_ON(cpu_up(cpu));
+			/* This should work even though the cpu is offline */
+			smp_send_reschedule(cpu);
 		}
 	}
 }
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

