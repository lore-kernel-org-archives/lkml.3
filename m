Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3KHDcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:32:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab3KHDcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:32:22 -0500
Date: Fri, 8 Nov 2013 11:30:43 +0800
From: Baoquan He <bhe@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131108033043.GA3133@dhcp-16-105.nay.redhat.com>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Reccently people reported kexec didn't work correctly. After check, it's
a regression. Since a code block which migrate current thread to cpu0
when executing "kexec -e", this can be reproduced by setting affinity to
CPUn(n!=0). You can find this patch in this link:
https://lkml.org/lkml/2013/11/5/88

Then I thought why we don't do this in kdump. I tried migrating current
thread to cpu0 when crash happened, it works very well. Set affinity to
make crash happened on CPUn(n!=0), then all cpus can be brought up and
dump is successful. I pasted the patch as below.

Only one thing worried me, whether the context related to crash cpu will
be different, and do we care which cpu crashed. If it need be cared, or
it doesn't involve difference, That will be great. Multiple CPUs can be
supported easily in this simpler way. Meanwhile, this patch just try to
migrate, if it's failed, we can avoid to bring up bsp.

Watch do you think about it?

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e0e0841..9e6cf4b 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -102,6 +102,22 @@ static void kdump_nmi_shootdown_cpus(void)
 
 void native_machine_crash_shutdown(struct pt_regs *regs)
 {
+#ifdef CONFIG_SMP
+       /* The boot cpu is always logical cpu 0 */
+       int reboot_cpu_id = 0;
+
+       /* See if there has been given a command line override */
+       if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
+               cpu_online(reboot_cpu))
+               reboot_cpu_id = reboot_cpu;
+
+       /* Make certain the cpu I'm about to reboot on is online */
+       if (!cpu_online(reboot_cpu_id))
+               reboot_cpu_id = smp_processor_id();
+
+       /* Make certain I only run on the appropriate processor */
+       set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+
        /* This function is only called after the system
         * has panicked or is otherwise in a critical state.
         * The minimum amount of code to allow a kexec'd kernel
@@ -114,6 +130,7 @@ void native_machine_crash_shutdown(struct pt_regs
*regs)
        local_irq_disable();
 
        kdump_nmi_shootdown_cpus();
+#endif




On 10/23/13 at 12:01am, HATAYAMA Daisuke wrote:
> This patch set is to allow kdump 2nd kernel to wake up multiple CPUs
> even if 1st kernel crashs on some AP, a continueing work from:
> 
>   [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
>   https://lkml.org/lkml/2013/10/16/300.
> 
> In this version, basic design has changed. Now users need to figure
> out initial APIC ID of BSP in the 1st kernel and configures kernel
> parameter for the 2nd kernel manually using disable_cpu_apic kernel
> parameter to be newly introduced in this patch set. This design is
> more flexible than the previous version in that we no longer have to
> rely on ACPI/MP table to get initial APIC ID of BSP.
> 
> Sorry, this patch set have not include in-source documentation
> requested by Borislav Petkov yet, but I'll post it later separately,
> which would be better to focus on documentation reviewing.
> 
> ChangeLog
> 
> v3 => v4)
> 
> - Rebased on top of v3.12-rc6
> 
> - Basic design has been changed. Now users need to figure out initial
>   APIC ID of BSP in the 1st kernel and configures kernel parameter for
>   the 2nd kernel manually using disable_cpu_apic kernel parameter to
>   be newly introduced in this patch set. This design is more flexible
>   than the previous version in that we no longer have to rely on
>   ACPI/MP table to get initial APIC ID of BSP.
> 
> v2 => v3)
> 
> - Change default value of boot_cpu_is_bsp to true.
> 
> - Before executing rdmsr(MSR_IA32_APICBASE), check if the number of
>   processor family is larger than or equal to 6 in order to avoid
>   invalid opcode exception on processors where MSR_IA32_APICBASE is
>   not supported.
> 
> v1 => v2)
> 
> - Rebased on top of v3.12-rc5.
> 
> - Fix linking time error of boot_cpu_is_bsp_init() in case of
>   CONFIG_LOCAL_APIC disabled by adding empty static inline function
>   instead.
> 
> - Fix missing feature check by means of cpu_has_apic macro in
>   boot_cpu_is_bsp_init() before calling rdmsr_safe(MSR_IA32_APICBASE).
> 
>   NOTE: I've checked local apic-present case only; I don't have any
>   x86 processor without local apic.
> 
> - Add __init annotation to boot_cpu_is_bsp_init().
> 
> Test
> 
> - built with and without CONFIG_LOCAL_APIC
> - tested x86_64 in case of acpi and MP table
> 
> ---
> 
> HATAYAMA Daisuke (3):
>       x86, apic: Don't count the CPU with BP flag from MP table as booting-up CPU
>       x86, apic: Add disable_cpu_apicid kernel parameter
>       Documentation, x86, apic, kexec: Add disable_cpu_apicid kernel parameter
> 
> 
>  Documentation/kernel-parameters.txt |    9 +++++++++
>  arch/x86/kernel/apic/apic.c         |   29 +++++++++++++++++++++++++++++
>  arch/x86/kernel/mpparse.c           |    1 -
>  3 files changed, 38 insertions(+), 1 deletion(-)
> 
> -- 
> 
> Thanks.
> HATAYAMA, Daisuke
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
