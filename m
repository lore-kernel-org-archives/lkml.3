Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3HTSNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:13:46 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43002 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3HTSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130820081848.GB11072@gmail.com>
References: <1376546616-17489-1-git-send-email-yinghai@kernel.org>
	<20130820081848.GB11072@gmail.com>
Date: Tue, 20 Aug 2013 11:13:44 -0700
X-Google-Sender-Auth: WqQyFPKR8RXoEWgtIswsUxxQkkw
Message-ID: <CAE9FiQVBdqnZtXx_5-YsBECEPOumd6Hf6KrxtD3=-gwY=V1=iA@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: Add comments for step_size shift
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 1:18 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> As request by hpa, add comments for why we choose 5 for
>> step size shift.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
>> Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
>>
>> ---
>>  arch/x86/mm/init.c |   21 ++++++++++++++++++---
>>  1 file changed, 18 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/arch/x86/mm/init.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/init.c
>> +++ linux-2.6/arch/x86/mm/init.c
>> @@ -395,8 +395,23 @@ static unsigned long __init init_range_m
>>       return mapped_ram_size;
>>  }
>>
>> -/* (PUD_SHIFT-PMD_SHIFT)/2 */
>> -#define STEP_SIZE_SHIFT 5
>> +static unsigned long __init get_new_step_size(unsigned long step_size)
>> +{
>> +     /*
>> +      * initial mapped size is PMD_SIZE, aka 2M.
>> +      * We can not set step_size to be PUD_SIZE aka 1G yet.
>> +      * In worse case, when 1G is cross the 1G boundary, and
>> +      * PG_LEVEL_2M is not set, we will need 1+1+512 pages (aka 2M + 8k)
>> +      * to map 1G range with PTE. Use 5 as shift for now.
>> +      */
>
> This is much more readable:
>
> +       /*
> +        * initial mapped size is PMD_SIZE (2M).
> +        * We can not set step_size to be PUD_SIZE (1G) yet.
> +        * In the worst case, when we cross the 1G boundary, and
> +        * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M+8k)
> +        * to map 1G range with PTE. Use 5 as shift for now.
> +        */

ok.

>
>
>> +     unsigned long new_step_size = step_size << 5;
>> +
>> +     if (new_step_size > step_size)
>> +             step_size = new_step_size;
>> +
>> +     return  step_size;
>> +}
>> +
>>  void __init init_mem_mapping(void)
>>  {
>>       unsigned long end, real_end, start, last_start;
>> @@ -445,7 +460,7 @@ void __init init_mem_mapping(void)
>>               min_pfn_mapped = last_start >> PAGE_SHIFT;
>>               /* only increase step_size after big range get mapped */
>>               if (new_mapped_ram_size > mapped_ram_size)
>> -                     step_size <<= STEP_SIZE_SHIFT;
>> +                     step_size = get_new_step_size(step_size);
>>               mapped_ram_size += new_mapped_ram_size;
>>       }
>
> As-is the changelog claims it only adds comments - but it
> obviously does more than that ...
>
> Yinghai, for the 1001st time, please use the customary
> changelog style we use in the kernel:
>
>   " Current code does (A), this has a problem when (B).
>     We can improve this doing (C), because (D)."
>
> I'm also going to suggest something radical: how about you
> keep this sugestion of mine in mind for _all_ future
> patches so I don't have to repeat it for every 3rd patch
> like I had to for the past 4 years, non-stop? Okay?

ok.

Sent updated one with new changelog and comments.

Thanks

Yinghai
