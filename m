Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3JOTbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab3JOTbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:31:34 -0400
Date: Tue, 15 Oct 2013 15:30:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v2 2/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20131015193049.GO31215@redhat.com>
References: <20131015054214.13666.11737.stgit@localhost6.localdomain6>
 <20131015054327.13666.1689.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015054327.13666.1689.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 02:43:27PM +0900, HATAYAMA Daisuke wrote:
> Currently, on x86 architecture, if crash happens on AP in the kdump
> 1st kernel, the 2nd kernel fails to wake up multiple CPUs. The typical
> behaviour we actually see is immediate system reset or hang.
> 
> This comes from the hardware specification that the processor with BSP
> flag is jumped at BIOS init code when receiving INIT; the behaviour we
> then see depends on the init code.
> 
> This never happens if we use only one cpu in the 2nd kernel. So, we
> have avoided the issue by the workaround that specifying maxcpus=1 or
> nr_cpus=1 in kernel parameter of the 2nd kernel.
> 
> In order to address the issue, this patch disables BSP if boot cpu is
> an AP, and thus we don't try to wake up the BSP by sending INIT.
> 
> Before this idea we discussed the following two ideas but we cannot
> adopt them in each reasons:
> 
> 1. Switch CPU from AP to BSP via IPI NMI at crash in the 1st kernel
> 
>    This is done in the kdump crash path where logic is in inconsistent
>    state. Any part of memory can be corrupted, including
>    hardware-related table being accessed for example when paging is
>    performed or interruption is performed.
> 
> 2. Unset BSP flag of the boot cpu in the 1st kernel
> 
>    Unsetting BSP flag can affect some real world firmware badly. For
>    example, Ma verified that some HP systems fail to reboot under this
>    configuration. See:
> 
>    http://lkml.indiana.edu/hypermail/linux/kernel/1308.1/03574.html
> 
> Due to the idea 1, we have to address the issue in the 2nd kernel on
> AP. Then, it's impossible to know which CPU is BSP by rdmsr
> instruction because the CPU is the one we are now trying to wake
> up. From the same reason, it's also impossible to unset BSP flag of
> the BSP by wrmsr instruction.
> 
> Next, due to the idea 2, BSP is halting in the 1st kernel while
> keeping BSP flag set (or possibly could be running somewhere in
> catastrophic state.) In generall, CPUs except for the boot cpu in the
> 2nd kernel -- the cpu under which crash happened --- can be thought of
> as remaining in any inconsistent state in the 1st kernel. For APs,
> it's possible to recover sane state by initiating INIT to them; see
> 3.7.3 Processor-specific INIT in MultiProcessor
> specification. However, there's no way for BSP. Therefore, there's no
> other way to disable BSP.
> 
> My motivation is to generate crash dump quickly on the system with
> huge memory. We can assume such system also has a lot of N-cpus and
> (N-1)-cpus are still available.
> 
> To identify which CPU is BSP, we lookup ACPI table or MP table. One
> concern is that ACPI guidlines BIOS *should* list the BSP in the first
> MADT LAPIC entry; not *must*. In this sense, this logic relis on BIOS
> following ACPI's guideline. On the other hand, we don't need to worry
> about this in MP table case because it has explit BSP flag.
> 
> To avoid any undesirable bahaviour caused by any broken BIOS that
> doesn't conform to the guideline, it's enough to limit the number of
> cpus to 1 by specifying maxcpu=1 or nr_cpus=1, as is currently done in
> default kdump configuration. (But of course, it's problematic in
> maxcpu=1 case if trying to wake up other cpus later in user space.)
> 
> SFI and devicetree doesn't provide BSP information, so there's no
> functionality change in their codes, only assigning false for all the
> entries, keeping interface uniform.

Hi Hatayama,

So we rely on ACPI reporting BSP properly. And SFI and device tree does
not provide BSP info. So for those cases situations where BSP is not
reported, situaiton is little dicy. We might try to bring up those cpus
and bring down the system.

I am wondering if there is any attribute of cpu which we can pass to
second kernel on command line. And tell second kernel not to bring up
that specific cpu. (Say exclude_cpu=<cpu_attr>)? If this works, then
if ACPI or other mechanism don't report BSP, we could possibly assume
that cpu 0 is BSP and ask second kernel to not try to boot it.

Thanks
Vivek
