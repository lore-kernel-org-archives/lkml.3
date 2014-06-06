Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaFFMcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:32:45 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49251 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaFFMco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:32:44 -0400
Message-ID: <5391B494.6050908@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2014 18:01:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: ego@linux.vnet.ibm.com, matt@ozlabs.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, suzuki@in.ibm.com, ebiederm@xmission.com,
        mahesh@linux.vnet.ibm.com, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] powerpc, kexec: Fix "Processor X is stuck" issue during
 kexec from ST mode
References: <20140527105511.24309.74320.stgit@srivatsabhat.in.ibm.com> <20140528133143.GK14863@redhat.com> <538E2FF8.8060707@linux.vnet.ibm.com> <20140604134108.GA27557@redhat.com>
In-Reply-To: <20140604134108.GA27557@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060612-8878-0000-0000-00000CD6E659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 07:11 PM, Vivek Goyal wrote:
> On Wed, Jun 04, 2014 at 01:58:40AM +0530, Srivatsa S. Bhat wrote:
>> On 05/28/2014 07:01 PM, Vivek Goyal wrote:
>>> On Tue, May 27, 2014 at 04:25:34PM +0530, Srivatsa S. Bhat wrote:
>>>> If we try to perform a kexec when the machine is in ST (Single-Threaded) mode
>>>> (ppc64_cpu --smt=off), the kexec operation doesn't succeed properly, and we
>>>> get the following messages during boot:
>>>>
[...]
>>>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>>>> index c8380ad..28c5706 100644
>>>> --- a/kernel/kexec.c
>>>> +++ b/kernel/kexec.c
>>>> @@ -1683,6 +1683,14 @@ int kernel_kexec(void)
>>>>  		kexec_in_progress = true;
>>>>  		kernel_restart_prepare(NULL);
>>>>  		migrate_to_reboot_cpu();
>>>> +
>>>> +		/*
>>>> +		 * migrate_to_reboot_cpu() disables CPU hotplug assuming that
>>>> +		 * no further code needs to use CPU hotplug (which is true in
>>>> +		 * the reboot case). However, the kexec path depends on using
>>>> +		 * CPU hotplug again; so re-enable it here.
>>>> +		 */
>>>> +		cpu_hotplug_enable();
>>>>  		printk(KERN_EMERG "Starting new kernel\n");
>>>>  		machine_shutdown();
>>>
>>> After migrate_to_reboot_cpu(), we are calling machine_shutdown() which
>>> calls disable_nonboot_cpus() and which in turn calls _cpu_down().
>>>
>>
>> Hmm? I see only 'arm' calling disable_nonboot_cpus() from machine_shutdown().
>> None of the other architectures call it. Is that a leftover in arm?
> 
> You are right. I did not notice that only arm is doing that. Looks like
> it is calling into some platform code, I am not sure what exactly arm
> does for disabling cpu.
> 
> x86 code calls stop_other_cpus() in machine_shutdown() which sends
> REBOOT_VECTOR to other cpus and calls stop_this_cpu() which in turn
> does.
> 
>         for (;;)
>                 halt();
> 
> IIUC, upon receipt of certain interrupts cpu will come out of halt state.
> Not sure how safe it is from kexec point of view as we will be replacing
> original kernel that means if cpu comes out of halt state it might be
> running some random code.
> 
> Eric/hpa might know better the context here and what safeguards us on x86.
> 
> So one should not make cpu spin on some code as kexec will change that
> code. It should be some other platform specific mechanism which brings
> cpu in to hlt like state. So that way arm seems to be doing right thing.
> 
> I am not sure what powerpc does to stop cpus.
> 

powerpc shepherds all CPUs to a safe state, by making them run kexec_smp_down(),
and eventually those CPUs end up calling kexec_wait() in assembly.

Regards,
Srivatsa S. Bhat

