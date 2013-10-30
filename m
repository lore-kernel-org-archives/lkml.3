Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3J2P3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:29:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab3J2P3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:29:00 -0400
Date: Wed, 30 Oct 2013 23:27:52 +0800
From: Baoquan He <bhe@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: fengguang.wu@intel.com, jingbai.ma@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, ebiederm@xmission.com,
        akpm@linux-foundation.org, hpa@linux.intel.com, vgoyal@redhat.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131030152752.GA3315@localhost.localdomain>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131029142151.GA2782@dhcp-16-105.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029142151.GA2782@dhcp-16-105.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 at 10:21pm, Baoquan He wrote:
> Hi,
> 
> I am reviewing this patchset, and found there's a cpu0 hotplug feature

Forget to attach the link of patch for cpu0 hotplug.
http://lwn.net/Articles/475018/

In this patchset, BSP is also called CPU0.

> posted by intel which we can borrow an idea from. In that implementation,
> CPU0 is waken up by nmi not INIT to avoid the realmode bootstrap code
> execution. I tried it by below patch which includes one line of change.
> 
> By console printing, I got the boot cpu is always 0(namely cpu=0),
> however the apicid related to each processor keeps the same as in 1st
> kernel. In my HP Z420 machine, the apicid for BSP is 0, so I just make a
> test patch which depends on the fact that apicid for BSP is 0. Maybe
> generally the apicid for BSP can't be guaranteed, then passing it from
> 1st kernel to 2nd kernel in cmdline is very helpful, just as you have
> done for disable_cpu_apic.
> 
> On my HP z420, I add nr_cpus=4 in /etc/sysconfig/kdump, and then execute
> below command, then 3 APs (1 boot cpu and 2 AP) can be waken up
> correctly, but BSP failed because NMI received for unknown reason 21 on
> CPU0. I think I need further check why BSP failed to wake up by nmi. But
> 3 processors are brought up successfully and kdump is successful too.
> 
> sudo taskset -c 1 sh -c "echo c >/proc/sysrq-trigger"
> 
> [    0.296831] smpboot: Booting Node   0, Processors  #   1
> [    0.302095]
> *****************************************************cpu=1, apicid=0, wakeup_cpu_via_init_nmi
> [    0.311942] cpu=1, apicid=0, register_nmi_handlercpu=1, apicid=0, wakeup_secondary_cpu_via_nmi
> [    0.320826] Uhhuh. NMI received for unknown reason 21 on CPU 0.
> [    0.327129] Do you have a strange power saving mode enabled?
> [    0.333858] Dazed and confused, but trying to continue
> [    0.339290] cpu=1, apicid=0, wakeup_cpu_via_init_nmi
> [    2.409099] Uhhuh. NMI received for unknown reason 21 on CPU 0.
> [    2.415393] Do you have a strange power saving mode enabled?
> [    2.421142] Dazed and confused, but trying to continue
> [    5.379519] smpboot: CPU1: Not responding
> [    5.383692] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 6cacab6..e45fe5b 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -702,7 +702,7 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long
> start_ip, int apicid,
>         /*
>          * Wake up AP by INIT, INIT, STARTUP sequence.
>          */
> -       if (cpu)
> +       if (cpu && apicid)
>                 return wakeup_secondary_cpu_via_init(apicid, start_ip);
>  
>         /*
> 
> 
> 
> On 10/23/13 at 12:01am, HATAYAMA Daisuke wrote:
> > This patch set is to allow kdump 2nd kernel to wake up multiple CPUs
> > even if 1st kernel crashs on some AP, a continueing work from:
> > 
> >   [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
> >   https://lkml.org/lkml/2013/10/16/300.
> > 
> > In this version, basic design has changed. Now users need to figure
> > out initial APIC ID of BSP in the 1st kernel and configures kernel
> > parameter for the 2nd kernel manually using disable_cpu_apic kernel
> > parameter to be newly introduced in this patch set. This design is
> > more flexible than the previous version in that we no longer have to
> > rely on ACPI/MP table to get initial APIC ID of BSP.
> > 
> > Sorry, this patch set have not include in-source documentation
> > requested by Borislav Petkov yet, but I'll post it later separately,
> > which would be better to focus on documentation reviewing.
> > 
> > ChangeLog
> > 
> > v3 => v4)
> > 
> > - Rebased on top of v3.12-rc6
> > 
> > - Basic design has been changed. Now users need to figure out initial
> >   APIC ID of BSP in the 1st kernel and configures kernel parameter for
> >   the 2nd kernel manually using disable_cpu_apic kernel parameter to
> >   be newly introduced in this patch set. This design is more flexible
> >   than the previous version in that we no longer have to rely on
> >   ACPI/MP table to get initial APIC ID of BSP.
> > 
> > v2 => v3)
> > 
> > - Change default value of boot_cpu_is_bsp to true.
> > 
> > - Before executing rdmsr(MSR_IA32_APICBASE), check if the number of
> >   processor family is larger than or equal to 6 in order to avoid
> >   invalid opcode exception on processors where MSR_IA32_APICBASE is
> >   not supported.
> > 
> > v1 => v2)
> > 
> > - Rebased on top of v3.12-rc5.
> > 
> > - Fix linking time error of boot_cpu_is_bsp_init() in case of
> >   CONFIG_LOCAL_APIC disabled by adding empty static inline function
> >   instead.
> > 
> > - Fix missing feature check by means of cpu_has_apic macro in
> >   boot_cpu_is_bsp_init() before calling rdmsr_safe(MSR_IA32_APICBASE).
> > 
> >   NOTE: I've checked local apic-present case only; I don't have any
> >   x86 processor without local apic.
> > 
> > - Add __init annotation to boot_cpu_is_bsp_init().
> > 
> > Test
> > 
> > - built with and without CONFIG_LOCAL_APIC
> > - tested x86_64 in case of acpi and MP table
> > 
> > ---
> > 
> > HATAYAMA Daisuke (3):
> >       x86, apic: Don't count the CPU with BP flag from MP table as booting-up CPU
> >       x86, apic: Add disable_cpu_apicid kernel parameter
> >       Documentation, x86, apic, kexec: Add disable_cpu_apicid kernel parameter
> > 
> > 
> >  Documentation/kernel-parameters.txt |    9 +++++++++
> >  arch/x86/kernel/apic/apic.c         |   29 +++++++++++++++++++++++++++++
> >  arch/x86/kernel/mpparse.c           |    1 -
> >  3 files changed, 38 insertions(+), 1 deletion(-)
> > 
> > -- 
> > 
> > Thanks.
> > HATAYAMA, Daisuke
> > 
> > _______________________________________________
> > kexec mailing list
> > kexec@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kexec
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
