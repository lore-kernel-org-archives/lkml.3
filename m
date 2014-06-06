Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaFFVSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:18:13 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36830 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaFFVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:18:11 -0400
Message-ID: <53922FB8.6070408@linux.vnet.ibm.com>
Date: Sat, 07 Jun 2014 02:46:40 +0530
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
References: <20140527105511.24309.74320.stgit@srivatsabhat.in.ibm.com> <20140528133143.GK14863@redhat.com> <538E2FF8.8060707@linux.vnet.ibm.com> <1401833365.3247.36.camel@pasglop> <5391B413.100@linux.vnet.ibm.com>
In-Reply-To: <5391B413.100@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060621-1396-0000-0000-000004FA6A90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 05:59 PM, Srivatsa S. Bhat wrote:
> On 06/04/2014 03:39 AM, Benjamin Herrenschmidt wrote:
>> On Wed, 2014-06-04 at 01:58 +0530, Srivatsa S. Bhat wrote:
>>> Yep, that makes sense. But unfortunately I don't have enough insight into
>>> why exactly powerpc has to online the CPUs before doing a kexec. I just
>>> know from the commit log and the comment mentioned above (and from my own
>>> experiments) that the CPUs will get stuck if they were offline. Perhaps
>>> somebody more knowledgeable can explain this in detail and suggest a proper
>>> long-term solution.
>>>
>>> Matt, Ben, any thoughts on this?
>>
>> The problem is with our "soft offline" which we do on some platforms. When we
>> offline we don't actually send the CPUs back to firmware or anything like that.
>>
>> We put them into a very low low power loop inside Linux.
>>
>> The new kernel has no way to extract them from that loop. So we must re-"online"
>> them before we kexec so they can be passed to the new kernel normally (or returned
>> to firmware like we do on powernv).
>>
> 
> Thanks a lot for the explanation Ben!
> 
> I thought about this and this is what I think: whether the CPU is in the kernel
> or in the firmware is a hard-boundary. But once we know it is still in the
> kernel, whether it is online or offline is a soft-boundary, something that
> ideally shouldn't make any difference to kexec.
> 
> Then I looked at what is that special state that kexec expects the online CPUs
> to be in, before performing kexec, and I found that that state is entered via
> kexec_smp_down().
> 
> Which means, if we poke the soft-offline CPUs and make them execute
> kexec_smp_down(), we should be able to do a successful kexec without having to
> actually online them. After all, the core kexec code doesn't mandate that they
> should be online. So if we satisfy powerpc's requirement that all the CPUs are
> in a sane state, that should be good enough. (This would be similar to how the
> subcore code wakes up offline CPUs to perform the split-core procedure).
> 
> I know, this is all theory for now since I haven't tested it yet, but I think
> we can make this work.
> 
> Below are the 4 preliminary patches I'm have so far, to implement this.
> 

And with the following hunk added (which I had forgotten earlier), it worked just
fine on powernv :-)


diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 2ef6c58..84e91293 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -243,6 +243,9 @@ static void wake_offline_cpus(void)
 {
 	int cpu = 0;
 
+	if (ppc_md.kexec_wake_prepare)
+		ppc_md.kexec_wake_prepare();
+
 	for_each_present_cpu(cpu) {
 		if (!cpu_online(cpu)) {
 			printk(KERN_INFO "kexec: Waking offline cpu %d.\n",

I tried putting the machine into ST mode, and in a separate experiment, I kept
just CPU 0 online in the first kernel, and then issued a kexec. The second kernel
booted successfully with all the CPUs in both the cases.

I haven't explored the crashed-kernel case though, it might need some auditing
to check if the code handles that as well.

Regards,
Srivatsa S. Bhat

