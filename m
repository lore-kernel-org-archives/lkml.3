Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbaCSLvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933380AbaCSLvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:51:20 -0400
Message-ID: <532984A9.8080001@redhat.com>
Date: Wed, 19 Mar 2014 07:51:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, drjones@redhat.com, toshi.kani@hp.com,
        x86@kernel.org, riel@redhat.com, gong.chen@linux.intel.com
Subject: Re: [PATCH 0/3] x86: fix hang when AP bringup is too slow
References: <1394720720-8484-1-git-send-email-imammedo@redhat.com> <53283A3F.6040302@redhat.com> <20140318194951.17fd61ea@thinkpad>
In-Reply-To: <20140318194951.17fd61ea@thinkpad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/18/2014 02:49 PM, Igor Mammedov wrote:
> On Tue, 18 Mar 2014 08:21:19 -0400
> Prarit Bhargava <prarit@redhat.com> wrote:
> 
>>
>>
>> On 03/13/2014 10:25 AM, Igor Mammedov wrote:
>>> Hang is observed on virtual machines during CPU hotplug,
>>> especially in big guests with many CPUs. (It happens more
>>> often if host is over-committed).
>>>
>>
>> Hey Igor, I like this better than the previous version.  Thanks for taking into
>> account the possible races in this code.
>>
>> A quick question on system behaviour.  As you know I've been more concerned
>> lately with error handling, etc., through the cpu hotplug code as we've seen
>> several customer reports of silent failures or cascading failures in the cpu
>> hotplug code when users have been attempting to perform physical hotplug.
>>
>> After your patches have been applied, in theory the following can happen:
>>
>> The master CPU is completing the AP cpu's bring up.  The AP cpu is doing (sorry
>> for the cut-and-paste),
>>
>> void cpu_init(void)
>> {
>>         int cpu = smp_processor_id();
>>         struct task_struct *curr = current;
>>         struct tss_struct *t = &per_cpu(init_tss, cpu);
>>         struct thread_struct *thread = &curr->thread;
>>
>>         /*
>>          * wait till the master CPU completes it's STARTUP sequence,
>>          * and decides to wait till this AP boots
>>          */
>>         while (!cpumask_test_cpu(cpu, cpu_callout_mask)) {
>>                 cpu_relax();
>>                 if (per_cpu(x86_cpu_to_apicid, cpu) == BAD_APICID)
>>                         halt();
>>         }
>>
>> and is spinning on cpu_relax().  Suppose something goes wrong and the softlockup
>> watchdog fires on the AP cpu:
>>
>> 1.  Can it? :) ie) will the softlockup fire at this point of the AP init?  Okay,
>> I'm being really lazy and not looking at the code ;)
> It shouldn't, CPU is in pristine state and just came from boot trampoline at
> this point without interrupts configured yet.

Okay, not a big problem.

> 
>>
>> 2.  Is there anything we can do in this code to notify the user of a problem?
>> Even a pr_crit() here I think would help to indicate what went wrong; it might
>> be useful for future debugging in this area to have some sort of output.  I
>> think a WARN() or BUG() is necessary here as there are several calls to cpu_init().
> Do you mean something like this:
> 
> +		if (per_cpu(x86_cpu_to_apicid, cpu) == BAD_APICID) {
> +                       WARN(1);
> +			halt();
> +               }

Yeah, maybe WARN_ON(1, "some comment") though.

> 
>>
>> 3.  Change this comment:
>>
>>          * wait till the master CPU completes it's STARTUP sequence,
>>          * and decides to wait till this AP boots
>>
>> to
>>
>> 	/* wait for the master CPU to complete this cpu's STARTUP. */ ?
> well, that is not quite the same as above, comment should underline that
> AP waits for ACK from master CPU before continuing with this AP initialization.
> 
> How about:
> /* wait for ACK from master CPU before continuing with AP initialization */

Awesome :)

P.

> 
>>
>> Apologies for the late review,
>>
>> P.
> 
> 
