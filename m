Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaGNL5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:57:53 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63499 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaGNL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:57:32 -0400
MIME-Version: 1.0
In-Reply-To: <87lhrw4515.fsf@rustcorp.com.au>
References: <20140713130407.GA27344@archDesk> <87lhrw4515.fsf@rustcorp.com.au>
From: Lucas Tanure <tanure@linux.com>
Date: Mon, 14 Jul 2014 08:57:15 -0300
X-Google-Sender-Auth: 1d1EIdwDJQrX-T_YcdP08CQt80U
Message-ID: <CAJyon0sTcZNpWZaBmiUBv99T4=BRTfEV+sJukc4deGMN1ZPFyw@mail.gmail.com>
Subject: Re: [PATCH] NoMoreModuleVmalloc - Try alloc_pages_exact before
 vmalloc, if fails do vmalloc
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

I found that project
http://kernelnewbies.org/KernelProjects/NoMoreModuleVmalloc.
So I thought that doing first a alloc_pages_exact would be the goal.
The kernel/module.c doesn't need this task any more, or I just did in
the wrong way ?

Thanks
--
Lucas Tanure
+55 (19) 988176559


On Mon, Jul 14, 2014 at 7:18 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Lucas Tanure <tanure@linux.com> writes:
>> Convert vmalloc() call to alloc_pages_exact(). If alloc_pages_exact() fails,
>> then fall back to vmalloc(). If the address is a vmalloc address, then
>> call vfree(), otherwise call free_pages_exact().
>
> Hi Lucas,
>
>         This patch is wrong.
>
> Firstly, you didn't list a motivation for getting rid of vmalloc.  But
> this patch doesn't make modules avoid vmalloc, it just makes the
> temporary copy we create avoid vmalloc.
>
> It also doesn't avoid the vfree() on the normal path; I'm pretty sure
> this would crash if you tested it.
>
> Thanks,
> Rusty.
>
>> Signed-off-by: Lucas Tanure <tanure@linux.com>
>> ---
>>  kernel/module.c | 16 ++++++++++++----
>>  1 file changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index ae79ce6..50c1e77 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2484,6 +2484,7 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
>>                                 struct load_info *info)
>>  {
>>       int err;
>> +     bool alloc_from_vmalloc = false;
>>
>>       info->len = len;
>>       if (info->len < sizeof(*(info->hdr)))
>> @@ -2494,12 +2495,19 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
>>               return err;
>>
>>       /* Suck in entire file: we'll want most of it. */
>> -     info->hdr = vmalloc(info->len);
>> -     if (!info->hdr)
>> -             return -ENOMEM;
>> +     info->hdr = alloc_pages_exact(info->len, GFP_KERNEL);
>> +     if (!info->hdr) {
>> +             info->hdr = vmalloc(info->len);
>> +             if (!info->hdr)
>> +                     return -ENOMEM;
>> +             alloc_from_vmalloc = true;
>> +     }
>>
>>       if (copy_from_user(info->hdr, umod, info->len) != 0) {
>> -             vfree(info->hdr);
>> +             if(alloc_from_vmalloc)
>> +                     vfree(info->hdr);
>> +             else
>> +                     free_pages_exact(info->hdr,info->len);
>>               return -EFAULT;
>>       }
>>
>> --
>> 2.0.1
