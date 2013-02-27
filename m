Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab3B0CpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:45:23 -0500
Received: from mail1.windriver.com ([147.11.146.13]:61774 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3B0CpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:45:22 -0500
Message-ID: <512D7312.8080503@windriver.com>
Date: Wed, 27 Feb 2013 10:44:34 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jason Wessel <jason.wessel@windriver.com>, Cong Ding <dinggnu@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Michael Neuling <mikey@neuling.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: kernel/kgdb.c: fix memory leakage
References: <1358184395-31418-1-git-send-email-dinggnu@gmail.com>  <510B22C2.90606@windriver.com> <1360291273.2650.52.camel@pasglop>
In-Reply-To: <1360291273.2650.52.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.178.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 10:41 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-01-31 at 20:04 -0600, Jason Wessel wrote:
>
>>> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
>>> index 8747447..5ca82cd 100644
>>> --- a/arch/powerpc/kernel/kgdb.c
>>> +++ b/arch/powerpc/kernel/kgdb.c
>>> @@ -154,12 +154,12 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>>>   static int kgdb_singlestep(struct pt_regs *regs)
>>>   {
>>>   	struct thread_info *thread_info, *exception_thread_info;
>>> -	struct thread_info *backup_current_thread_info = \
>>> -		(struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>>> +	struct thread_info *backup_current_thread_info;
>>
>>
>>
>> Woh...  This is definitely wrong.  You have found a problem for sure,
>> but this is not the right way to fix it.
>>
>> It is not a good idea to kmalloc while single stepping because you can
>> hang the kernel if you single step any operation in kmalloc().
>
> Ok. I applied the fix because it was obviously correct vs. the previous
> version of the code (ie. the kmalloc was already there)
>
>> I am in the process of going through all the kgdb mails from the last
>> few months while I had been away from the project, so I didn't catch
>> this one and I see it has upstream commit (fefd9e6f8).  I'll submit
>> another patch to fix this the right way and use a static variable.
>> This is ok to use a static variable here because this is not something
>> we can recursively call at a single CPU level.
>
> But a static will be shared by all CPUs or do you mean a per-cpu one ?
>
>> If Ben prefers we not burn the memory unless kgdb is active we can
>> kmalloc / kfree the space we need at the time that kgdb is
>> initialized.  Else we can go with this patch you see below.  We'll see
>> what Ben desires.
>
> What about the stack ? thread info isn't very big...


Actually booke already copy the thread_info when we enter the debug exception, 
and I will send a patch to do the same thing for book3e, so I also remove these 
copying action here then we're happy without these nasty stuff :)

Tiejun

>
> Cheers,
> Ben.
>
>> -----
>> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
>> index a7bc752..bb12c8b 100644
>> --- a/arch/powerpc/kernel/kgdb.c
>> +++ b/arch/powerpc/kernel/kgdb.c
>> @@ -151,15 +151,16 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>>   	return 1;
>>   }
>>
>> +static struct thread_info kgdb_backup_thread_info[NR_CPUS];
>> +
>>   static int kgdb_singlestep(struct pt_regs *regs)
>>   {
>>   	struct thread_info *thread_info, *exception_thread_info;
>> -	struct thread_info *backup_current_thread_info;
>> +	int cpu = raw_smp_processor_id();
>>
>>   	if (user_mode(regs))
>>   		return 0;
>>
>> -	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>>   	/*
>>   	 * On Book E and perhaps other processors, singlestep is handled on
>>   	 * the critical exception stack.  This causes current_thread_info()
>> @@ -175,7 +176,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
>>
>>   	if (thread_info != exception_thread_info) {
>>   		/* Save the original current_thread_info. */
>> -		memcpy(backup_current_thread_info, exception_thread_info, sizeof *thread_info);
>> +		memcpy(&kgdb_backup_thread_info[cpu], exception_thread_info, sizeof *thread_info);
>>   		memcpy(exception_thread_info, thread_info, sizeof *thread_info);
>>   	}
>>
>> @@ -183,9 +184,8 @@ static int kgdb_singlestep(struct pt_regs *regs)
>>
>>   	if (thread_info != exception_thread_info)
>>   		/* Restore current_thread_info lastly. */
>> -		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
>> +		memcpy(exception_thread_info, &kgdb_backup_thread_info[cpu], sizeof *thread_info);
>>
>> -	kfree(backup_current_thread_info);
>>   	return 1;
>>   }
>>
>>
>> -----
>>
>>
>> Thanks,
>> Jason.
>>
>>
>>>
>>>   	if (user_mode(regs))
>>>   		return 0;
>>>
>>> +	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>>>   	/*
>>>   	 * On Book E and perhaps other processors, singlestep is handled on
>>>   	 * the critical exception stack.  This causes current_thread_info()
>>> @@ -185,6 +185,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
>>>   		/* Restore current_thread_info lastly. */
>>>   		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
>>>
>>> +	kfree(backup_current_thread_info);
>>>   	return 1;
>>>   }
>>>
>>>
>
>
>
>

