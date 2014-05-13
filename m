Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaEMWw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:52:57 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:58251 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaEMWwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:52:50 -0400
Message-ID: <5372A23C.702@imgtec.com>
Date: Tue, 13 May 2014 23:52:44 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Helge Deller <deller@gmx.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: <linux-kernel@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        "John David Anglin" <dave.anglin@bell.net>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] parisc,metag: Do not hardcode maximum userspace stack
 size
References: <20140430212602.GA20601@p100.fritz.box>		 <53622DBA.807@imgtec.com> <1398966636.2174.21.camel@dabdike>	 <5363876A.2030709@imgtec.com> <1399042116.2202.1.camel@dabdike> <5365EC05.5080900@gmx.de> <5371FF97.7030205@imgtec.com> <5372764A.2060906@gmx.de>
In-Reply-To: <5372764A.2060906@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Helge,

On 13/05/14 20:45, Helge Deller wrote:
> On 05/13/2014 01:18 PM, James Hogan wrote:
>> On 04/05/14 08:28, Helge Deller wrote:
>>> On 05/02/2014 04:48 PM, James Bottomley wrote:
>>>> On Fri, 2014-05-02 at 12:54 +0100, James Hogan wrote:
>>>>> On 01/05/14 18:50, James Bottomley wrote:
>>>>>>
>>>>>>> +config MAX_STACK_SIZE_MB
>>>>>>> +	int "Maximum user stack size (MB)"
>>>>>>> +	default 80
>>>>>>> +	range 8 256 if METAG
>>>>>>> +	range 8 2048
>>>>>>> +	depends on STACK_GROWSUP
>>>>>>> +	help
>>>>>>> +	  This is the maximum stack size in Megabytes in the VM layout of user
>>>>>>> +	  processes when the stack grows upwards (currently only on parisc and
>>>>>>> +	  metag arch). The stack will be located at the highest memory address
>>>>>>> +	  minus the given value, unless the RLIMIT_STACK hard limit is changed
>>>>>>> +	  to a smaller value in which case that is used.
>>>>>>> +
>>>>>>> +	  A sane initial value is 80 MB.
>>>>>>
>>>>>> There's one final issue with this: placement of the stack only really
>>>>>> matters on 32 bits.  We have three expanding memory areas: stack, heap
>>>>>> and maps.  On 64 bits these are placed well separated from each other on
>>>>>> 64 bits, so an artificial limit like this doesn't matter.
>>>>>
>>>>> Does the following fixup diff look reasonable? It forces
>>>>> MAX_STACK_SIZE_MB to 1024 and hides the Kconfig option for 64BIT,
>>>>> effectively leaving the behaviour unchanged in that case.
>>>>>
>>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>>> index e80075979530..b0307f737bd7 100644
>>>>> --- a/mm/Kconfig
>>>>> +++ b/mm/Kconfig
>>>>> @@ -583,7 +583,8 @@ config GENERIC_EARLY_IOREMAP
>>>>>  	bool
>>>>>
>>>>>  config MAX_STACK_SIZE_MB
>>>>> -	int "Maximum user stack size (MB)"
>>>>> +	int "Maximum user stack size (MB)" if !64BIT
>>>>> +	default 1024 if 64BIT
>>>>>  	default 80
>>>>>  	range 8 256 if METAG
>>>>>  	range 8 2048
>>>>
>>>> Yes, I think that's probably correct ... 
>>>
>>> No, it's not correct.
>>> It will then choose then a 1GB stack for compat tasks on 64bit kernel.
>>
>> Sorry for the delay (I had most of last week off sick and still catching
>> up).
> 
> No problem.
>  
>> That's a good point. It makes me think the best way to handle it is in a
>> new definition in asm/processor.h, maybe STACK_SIZE_MAX. Does something
>> like this look better? This patch isn't getting any cleaner
>> unfortunately.
> 
> 
> Yes, it's correct now.
> Just tested it. Thanks!

Thanks.

> Another problem:
> I think you wanted to get it backported into older kernels?

Yeh, back to v3.9 ideally.

> It seems the changes to mm/Kconfig will not apply cleanly to 3.14 or lower,

Hmm, I guess the patch could be split easily though such that METAG
always defined STACK_SIZE_MAX as 256MB and parisc always as 1GB (i.e.
minimal fix for metag without actually changing any stack sizes), then
have a second patch (not for stable) to make it match the v3 patch.

I'll try that (I probably should have done that in the first place).

Thanks
James

> and the changes to arch/parisc/kernel/sys_parisc.c will not apply to 3.13 or lower...
> 
> Maybe cleaning up the patch to apply cleanly to 3.14 would make sense
> and ignore older kernels?
> 
> Helge
> 
> 
>> From 6ecb0392a3b670c4bf1641a6ec56f22427ca8b57 Mon Sep 17 00:00:00 2001
>> From: Helge Deller <deller@gmx.de>
>> Date: Wed, 30 Apr 2014 23:26:02 +0200
>> Subject: [PATCH 1/1] parisc,metag: Do not hardcode maximum userspace stack
>>  size
>>
>> This patch affects only architectures where the stack grows upwards
>> (currently parisc and metag only). On those do not hardcode the maximum
>> initial stack size to 1GB for 32-bit processes, but make it configurable
>> via a config option.
>>
>> The main problem with the hardcoded stack size is, that we have two
>> memory regions which grow upwards: stack and heap. To keep most of the
>> memory available for heap in a flexmap memoy layout, it makes no sense
>> to hard allocate up to 1GB of the memory for stack which can't be used
>> as heap then.
>>
>> This patch makes the stack size configurable and uses 80MB as default
>> value which has been in use during the last few years on parisc and
>> which didn't showed any problems yet.
>>
>> This also fixes a BUG on metag if the RLIMIT_STACK hard limit is
>> increased beyond a safe value by root. E.g. when starting a process
>> after running "ulimit -H -s unlimited" it will then attempt to use a
>> stack size of the maximum 1GB which is far too big for metag's limited
>> user virtual address space (stack_top is usually 0x3ffff000):
>> BUG: failure at fs/exec.c:589/shift_arg_pages()!
>>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: linux-parisc@vger.kernel.org
>> Cc: linux-metag@vger.kernel.org
>> Cc: John David Anglin <dave.anglin@bell.net>
>> Cc: stable@vger.kernel.org # only needed for >= v3.9 (arch/metag)
>> ---
>> v3 (James Hogan):
>>  - fix so that 64-bit parisc processes still use the 1GB limit.
>>    CONFIG_STACK_GROWSUP arches should provide a STACK_SIZE_MAX in their
>>    asm/processor.h, and for parisc it depends on USER_WIDE_MODE (whether
>>    the current process is 64-bit).
>> v2 (James Hogan):
>>  - updated description to mention BUG on metag.
>>  - added custom range limit for METAG.
>>  - moved Kconfig symbol to mm/Kconfig and reworded.
>>  - fixed "matag" typo.
>> ---
>>  arch/metag/include/asm/processor.h  |  2 ++
>>  arch/parisc/include/asm/processor.h |  5 +++++
>>  arch/parisc/kernel/sys_parisc.c     |  6 +++---
>>  fs/exec.c                           |  6 +++---
>>  mm/Kconfig                          | 15 +++++++++++++++
>>  5 files changed, 28 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/metag/include/asm/processor.h b/arch/metag/include/asm/processor.h
>> index f16477d1f571..a8a37477c66e 100644
>> --- a/arch/metag/include/asm/processor.h
>> +++ b/arch/metag/include/asm/processor.h
>> @@ -22,6 +22,8 @@
>>  /* Add an extra page of padding at the top of the stack for the guard page. */
>>  #define STACK_TOP	(TASK_SIZE - PAGE_SIZE)
>>  #define STACK_TOP_MAX	STACK_TOP
>> +/* Maximum virtual space for stack */
>> +#define STACK_SIZE_MAX	(CONFIG_MAX_STACK_SIZE_MB*1024*1024)
>>
>>  /* This decides where the kernel will search for a free chunk of vm
>>   * space during mmap's.
>> diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
>> index 198a86feb574..d951c9681ab3 100644
>> --- a/arch/parisc/include/asm/processor.h
>> +++ b/arch/parisc/include/asm/processor.h
>> @@ -55,6 +55,11 @@
>>  #define STACK_TOP	TASK_SIZE
>>  #define STACK_TOP_MAX	DEFAULT_TASK_SIZE
>>
>> +/* Allow bigger stacks for 64-bit processes */
>> +#define STACK_SIZE_MAX	(USER_WIDE_MODE					\
>> +			 ? (1 << 30)	/* 1 GB */			\
>> +			 : (CONFIG_MAX_STACK_SIZE_MB*1024*1024))
>> +
>>  #endif
>>
>>  #ifndef __ASSEMBLY__
>> diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
>> index 31ffa9b55322..e1ffea2f9a0b 100644
>> --- a/arch/parisc/kernel/sys_parisc.c
>> +++ b/arch/parisc/kernel/sys_parisc.c
>> @@ -72,10 +72,10 @@ static unsigned long mmap_upper_limit(void)
>>  {
>>  	unsigned long stack_base;
>>
>> -	/* Limit stack size to 1GB - see setup_arg_pages() in fs/exec.c */
>> +	/* Limit stack size - see setup_arg_pages() in fs/exec.c */
>>  	stack_base = rlimit_max(RLIMIT_STACK);
>> -	if (stack_base > (1 << 30))
>> -		stack_base = 1 << 30;
>> +	if (stack_base > STACK_SIZE_MAX)
>> +		stack_base = STACK_SIZE_MAX;
>>
>>  	return PAGE_ALIGN(STACK_TOP - stack_base);
>>  }
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 476f3ebf437e..238b7aa26f68 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -657,10 +657,10 @@ int setup_arg_pages(struct linux_binprm *bprm,
>>  	unsigned long rlim_stack;
>>
>>  #ifdef CONFIG_STACK_GROWSUP
>> -	/* Limit stack size to 1GB */
>> +	/* Limit stack size */
>>  	stack_base = rlimit_max(RLIMIT_STACK);
>> -	if (stack_base > (1 << 30))
>> -		stack_base = 1 << 30;
>> +	if (stack_base > STACK_SIZE_MAX)
>> +		stack_base = STACK_SIZE_MAX;
>>
>>  	/* Make sure we didn't let the argument array grow too large. */
>>  	if (vma->vm_end - vma->vm_start > stack_base)
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index ebe5880c29d6..1b5a95f0fa01 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -581,3 +581,18 @@ config PGTABLE_MAPPING
>>
>>  config GENERIC_EARLY_IOREMAP
>>  	bool
>> +
>> +config MAX_STACK_SIZE_MB
>> +	int "Maximum user stack size for 32-bit processes (MB)"
>> +	default 80
>> +	range 8 256 if METAG
>> +	range 8 2048
>> +	depends on STACK_GROWSUP && (!64BIT || COMPAT)
>> +	help
>> +	  This is the maximum stack size in Megabytes in the VM layout of 32-bit
>> +	  user processes when the stack grows upwards (currently only on parisc
>> +	  and metag arch). The stack will be located at the highest memory
>> +	  address minus the given value, unless the RLIMIT_STACK hard limit is
>> +	  changed to a smaller value in which case that is used.
>> +
>> +	  A sane initial value is 80 MB.
>>
> 
