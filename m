Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaEVFKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:10:14 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33709 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaEVFKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:10:12 -0400
Message-ID: <537D8641.8090600@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 10:38:17 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: mikey@neuling.org, avagin@openvz.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, michael@ellerman.id.au, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com> <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com> <537252C0.6090005@redhat.com> <53730326.6000400@linux.vnet.ibm.com> <53735044.5030008@redhat.com> <537479FD.2010200@linux.vnet.ibm.com> <5374AE24.1030302@redhat.com> <5379EF0E.6090504@linux.vnet.ibm.com> <537A1889.8030801@redhat.com> <537B0EE0.4080406@linux.vnet.ibm.com> <537B2F5E.4040102@redhat.com>
In-Reply-To: <537B2F5E.4040102@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052205-1396-0000-0000-000004E4811A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 04:03 PM, Pedro Alves wrote:
> On 05/20/2014 09:14 AM, Anshuman Khandual wrote:
>> On 05/19/2014 08:13 PM, Pedro Alves wrote:
>>> On 05/19/2014 12:46 PM, Anshuman Khandual wrote:
>>>
>>>>>> I couldn't actually find any arch that currently returns -ENODEV in
>>>>>> the "active" hook.  I see that binfmt_elf.c doesn't handle
>>>>>> regset->active() returning < 0.  Guess that may be why.  Looks like
>>>>>> something that could be cleaned up, to me.
>>>>>>
>>>> Also it does not consider the return value of regset->active(t->task, regset)
>>>> (whose objective is to figure out whether we need to request regset->n number
>>>> of elements or less than that) in the subsequent call to regset->get function.
>>>
>>> Indeed.
>>>
>>> TBC, do you plan on fixing this?  Otherwise ...
>>
>> Sure, thinking something like this as mentioned below. But still not sure how to use
>> the return type of -ENODEV from the function regset->active(). Right now if any
>> regset does have the active hook and it returns anything but positive value, it will
>> be ignored and the control moves to the next regset in view. This prevents the thread
>> core note type being written to the core dump.
> 
> Looks to me that that's exactly what should happen for -ENODEV too.  The regset
> should be ignored.  If regset->active() returns -ENODEV, then the machine
> doesn't have the registers at all, so what makes sense to me is to not write the
> corresponding core note in the dump.  IOW, on such a machine, the kernel
> generates a core exactly like if the support for these registers that don't
> make sense for this machine wasn't compiled in at all.  And generates a core
> exactly like an older kernel that didn't know about that regset
> (which is fine for that same machine) yet.
> 

All of this happen right now even without specifically checking for the return type
of -ENODEV and just checking for a positive value. I guess thats the reason they had
omitted -ENODEV in the first place. 

 
>>
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index aa3cb62..80672fb 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -1553,7 +1553,15 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
>>                 if (regset->core_note_type && regset->get &&
>>                     (!regset->active || regset->active(t->task, regset))) {
>>                         int ret;
> 
> So, here, this ?
> 
>                     (!regset->active || regset->active(t->task, regset) > 0)) {
> 
> 
>> -                       size_t size = regset->n * regset->size;
>> +                       size_t size;
>> +
>> +                       /* Request only the active elements in the regset */
>> +                       if (!regset->active)
>> +                               size = regset->n * regset->size;
>> +                       else
>> +                               size = regset->active(t->task, regset)
>> +                                                               * regset->size;
>> +
> 
> 
> I wonder if it wouldn't be cleaner to add a function like:
> 
> int
> regset_active (tast *task, regseg *regset)
> {
>    if (!regset->active)
>         return regset->n * regset->size;
>    else
>         return regset->active(task, regset);
> }
> 
> And then use it like
> 
>                if (regset->core_note_type && regset->get) {
>                    int size = regset_active (t->task, regset);
> 
>                    if (size > 0) {
>                           ...
>                    }
> 

Yeah this makes sense.

> Though at this point, we don't actually make use of
> the distinction between -ENODEV vs 0.  Guess that's what
> we should be thinking about.  Seems like there some details that
> need to be sorted out, and some verification that consumers aren't
> broken by outputting smaller notes -- e.g., ia64 makes me
> wonder that.

I agree.

> 
> Maybe we should leave this for another day, and have tm_spr_active
> return 0 instead of -ENODEV when the machine doesn't have the hardware,
> or not install that hook at all.  Seems like the effect will be the same,
> as the note isn't output if ->get fails.

Agree. Active hooks which return 0 in case of -ENODEV sounds good to me and shall
incorporate this in the next version.

> 
>>                         void *data = kmalloc(size, GFP_KERNEL);
>>                         if (unlikely(!data))
>>                                 return 0;
>>
>>>
>>>> Now coming to the installation of the .active hooks part for all the new regsets, it
>>>> should be pretty straight forward as well. Though its optional and used for elf_core_dump
>>>> purpose only, its worth adding them here. Example of an active function should be something
>>>> like this. The function is inexpensive as required.
>>>>
>>>> +static int tm_spr_active(struct task_struct *target,
>>>> +                               const struct user_regset *regset)
>>>> +{
>>>> +       if (!cpu_has_feature(CPU_FTR_TM))
>>>> +               return -ENODEV;
>>>
>>> ... unfortunately this will do the wrong thing.
>>
>> I am not sure whether I understand this correctly. Are you saying that its wrong to return
>> -ENODEV in this case as above ?
> 
> No, sorry for not being clear.  The (...)'s were connected:
> 
>    "do you plan on fixing this?  Otherwise ... ... unfortunately
>     this will do the wrong thing."
> 

:)

