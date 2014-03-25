Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaCYStw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:49:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29289 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaCYStC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:49:02 -0400
Message-ID: <5331CF58.8000909@oracle.com>
Date: Tue, 25 Mar 2014 12:47:52 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk,
        riel@redhat.com, snorcht@gmail.com, dhowells@redhat.com,
        luto@amacapital.net, daeseok.youn@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com> <871txqp2cr.fsf@tassilo.jf.intel.com>
In-Reply-To: <871txqp2cr.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 12:20 PM, Andi Kleen wrote:
> Khalid Aziz <khalid.aziz@oracle.com> writes:
>
> First it would be nice to have some standard reference lock library that
> uses this. What would it take to support this in glibc?

I am not sure if it would be practical and useful to integrate this into 
any of the standard locking interfaces, but I have not looked into it 
much either. My initial intent is to let individual apps decide if they 
could benefit from this interface and code it in if so since the 
interface is meant to be very simple. Do you see any of the standard 
locking interfaces where it would make sense to integrate this feature 
in, or are you thinking of creating a new interface?

>
>> +==================================
>> +Using the preemption delay feature
>> +==================================
>> +
>> +This feature is enabled in the kernel by setting
>> +CONFIG_SCHED_PREEMPT_DELAY in kernel configuration. Once this feature is
>> +enabled, the userspace process communicates with the kernel using a
>> +4-byte memory location in its address space. It first gives the kernel
>> +address for this memory location by writing its address to
>> +/proc/<tgid>/task/<tid>/sched_preempt_delay. This memory location is
>> +interpreted as a sequence of 4 bytes:
>> +
>> +	byte[0] = flag to request preemption delay
>> +	byte[1] = flag from kernel indicating preemption delay was granted
>> +	byte[2] = reserved for future use
>> +	byte[3] = reserved for future use
>
> Should reserve more bytes (64, 128?) and rename the proc flag
> to a more generic name. I could well assume other things
> using such a mechanism in the future. Also please add a flag
> word with feature bits (similar to the perf mmap page)

I am reluctant to make it too big since reading larger quantities from 
userspace will take longer and start to impact performance. Keeping 
shared data limited to 32-bits allows us to move it between userspace 
and kernel with one instruction.

>
> How about alignment? x86 will not care, but other architectures
> may.
>

You are right. These 4-bytes need to be aligned to a 4-byte boundary. I 
will look into adding an alignment check at the time this address is 
passed to kernel.

>>   #endif
>> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
>> +	REG("sched_preempt_delay", S_IRUGO|S_IWUSR,
>> proc_tid_preempt_delay_ops),
>
> This shouldn't be readable by group/other, as it exposes the address space,
> so could help exploits.

I like Oleg's suggestion of using prctl() instead of procfs to pass the 
userspace address to kernel. Above problem will disappear when I switch 
to prctl() in v3 of this patch.

>
>> @@ -2061,6 +2069,13 @@ extern u64 scheduler_tick_max_deferment(void);
>>   static inline bool sched_can_stop_tick(void) { return false; }
>>   #endif
>>
>> +#if defined(CONFIG_SCHED_PREEMPT_DELAY) && defined(CONFIG_PROC_FS)
>> +extern void sched_preempt_delay_show(struct seq_file *m,
>> +					struct task_struct *task);
>> +extern void sched_preempt_delay_set(struct task_struct *task,
>> +					unsigned char *val);
>> +#endif
>
> Prototypes don't need to be ifdefed.
>
> -Andi
>

Ah, you are right. Thanks, Andi!

--
Khalid

