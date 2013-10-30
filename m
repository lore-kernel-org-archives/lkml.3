Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3J3ArZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:47:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46662 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J3ArY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:47:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5270567D.8000706@jp.fujitsu.com>
Date: Wed, 30 Oct 2013 09:44:45 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Baoquan He <bhe@redhat.com>
CC: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6> <20131029142151.GA2782@dhcp-16-105.nay.redhat.com>
In-Reply-To: <20131029142151.GA2782@dhcp-16-105.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/29 23:21), Baoquan He wrote:
> Hi,
>
> I am reviewing this patchset, and found there's a cpu0 hotplug feature
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

We've already discussed this approach and concluded this is not applicable
to our issue.
Follow http://lists.infradead.org/pipermail/kexec/2012-October/006905.html.

The reason is:

- The cpu0-hotplugging approach assumes BSP to be halting before initiating
   NMI to it while in our case, BSP is halting in the 1st kernel or is
   running in arbitrary position of the 1st kernel in catastrophic state.

- In general, NMI modifies stack, which means if throwing NMI to the BSP
   in the 1st kernel, stack on the 1st kernel is modified. It's unpermissible
   from kdump's perspective.

- On x86_64, there are two cases where stack is changed to another one
   when receiving interrupts. One is when receiving interrupt in user mode.
   The other is when using Interrupt Stack Table (IST), which is already
   used in the current x86_64 implementation.

   By using either, it would be possible to wake up BSP in the 1st kernel
   by modifying the contexts on the 2nd kernel's NMI stack pushed on when NMI
   to the 1st kernel is initiated.

   However, this approach depends on the logic in the 1st kernel, there's
   no guarantee that it works well. Consider severely buggy situation again.

- To do this approach rigorously, we need to check if states of BSP and APs
   are kept in just what we assume in the place where logic is guaranteed to be
   sane, i.e., at least after purgatory. However, adding new logic in the
   purgatory means we are forced to introduce additional dependency between
   kernel and kexec. The process performed in purgatory itself is not so
   simple.I don't like this complication.

To sum up, I think the current idea is simple enough approach.

-- 
Thanks.
HATAYAMA, Daisuke

