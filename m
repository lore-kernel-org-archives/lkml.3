Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaBUVFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:05:14 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55433 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaBUVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:05:09 -0500
MIME-Version: 1.0
In-Reply-To: <20140221123658.5752f75eea6506d17bfa313b@linux-foundation.org>
References: <20140221202110.GA29885@www.outflux.net>
	<20140221123658.5752f75eea6506d17bfa313b@linux-foundation.org>
Date: Fri, 21 Feb 2014 13:05:08 -0800
X-Google-Sender-Auth: eXRZa1JtDY-waAWBx_-kjhIupsA
Message-ID: <CAGXu5jLGBJp7oKXjausV70bXF-RTVDXxdZriS0cJ7X6NO90Ybg@mail.gmail.com>
Subject: Re: [PATCH] x86, kaslr: randomize module base load address
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, Jianguo Wu <wujianguo@huawei.com>,
        Andy Honig <ahonig@google.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:36 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 21 Feb 2014 12:21:10 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>> From: Andy Honig <ahonig@google.com>
>>
>> Randomize the load address of modules in the kernel to make kASLR
>> effective for modules.  Modules can only be loaded within a particular
>> range of virtual address space.  This patch adds 10 bits of entropy to
>> the load address by adding 1-1024 * PAGE_SIZE to the beginning range
>> where modules are loaded.
>>
>> Example kASLR boot without this change, with a single module loaded:
>> ---[ Modules ]---
>> 0xffffffffc0000000-0xffffffffc0001000           4K     ro     GLB x  pte
>> 0xffffffffc0001000-0xffffffffc0002000           4K     ro     GLB NX pte
>> 0xffffffffc0002000-0xffffffffc0004000           8K     RW     GLB NX pte
>> 0xffffffffc0004000-0xffffffffc0200000        2032K                   pte
>> 0xffffffffc0200000-0xffffffffff000000        1006M                   pmd
>> ---[ End Modules ]---
>>
>> Example kASLR boot after this change, same module loaded:
>> ---[ Modules ]---
>> 0xffffffffc0000000-0xffffffffc0200000           2M                   pmd
>> 0xffffffffc0200000-0xffffffffc03bf000        1788K                   pte
>> 0xffffffffc03bf000-0xffffffffc03c0000           4K     ro     GLB x  pte
>> 0xffffffffc03c0000-0xffffffffc03c1000           4K     ro     GLB NX pte
>> 0xffffffffc03c1000-0xffffffffc03c3000           8K     RW     GLB NX pte
>> 0xffffffffc03c3000-0xffffffffc0400000         244K                   pte
>> 0xffffffffc0400000-0xffffffffff000000        1004M                   pmd
>> ---[ End Modules ]---
>>
>> ...
>>
>> --- a/arch/x86/kernel/module.c
>> +++ b/arch/x86/kernel/module.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/gfp.h>
>>  #include <linux/jump_label.h>
>> +#include <linux/random.h>
>>
>>  #include <asm/page.h>
>>  #include <asm/pgtable.h>
>> @@ -43,13 +44,49 @@ do {                                                      \
>>  } while (0)
>>  #endif
>>
>> +#ifdef CONFIG_RANDOMIZE_BASE
>> +static unsigned long module_load_offset;
>> +static int randomize_modules = 1;
>
> It's pretty common for people to later come back and say "hey I want to
> set the default in Kconfig".  Perhaps we should do that from day 1.

I've been slapped down for adding more config options in the past, and
I think it's unlikely that people using CONFIG_RANDOMIZE_BASE won't
want the modules base randomized too. I think this is a safe default,
but if you see it as a requirement, I can change it.

> This implies that parse_nokaslr() will need to be renamed and taught to
> handle 0->1 changing.
>
>> +static int __init parse_nokaslr(char *p)
>> +{
>> +     randomize_modules = 0;
>> +     return 0;
>> +}
>> +early_param("nokaslr", parse_nokaslr);
>
> Documentation/kernel-parameters.txt, please.   This isn't hard :(

"nokaslr" is already documented. Do you mean adding a note about
modules as well to the existing documentation?

>> +static unsigned long int get_module_load_offset(void)
>> +{
>> +     if (randomize_modules) {
>> +             mutex_lock(&module_mutex);
>> +             /*
>> +              * Calculate the module_load_offset the first time this
>> +              * code is called. Once calculated it stays the same until
>> +              * reboot.
>> +              */
>> +             if (module_load_offset == 0)
>> +                     module_load_offset =
>> +                             (get_random_int() % 1024 + 1) * PAGE_SIZE;
>> +             mutex_unlock(&module_mutex);
>> +     }
>> +     return module_load_offset;
>> +}
>
> This seems unnecessarily complex and inefficient.  We only set
> module_load_offset a single time, so why not do it that way?
> Mark it __init, run it during initcalls then throw it away.

I'd like to make sure this is running well after the pRNG is up and
running. I can run some tests to see how the entropy looks if this is
done during __init, though.

>
>> +#else
>> +static unsigned long int get_module_load_offset(void)
>> +{
>> +     return 0;
>> +}
>> +#endif
>> +
>>  void *module_alloc(unsigned long size)
>>  {
>>       if (PAGE_ALIGN(size) > MODULES_LEN)
>>               return NULL;
>> -     return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
>> -                             GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
>> -                             NUMA_NO_NODE, __builtin_return_address(0));
>> +     return __vmalloc_node_range(size, 1,
>> +                                 MODULES_VADDR + get_module_load_offset(),
>> +                                 MODULES_END, GFP_KERNEL | __GFP_HIGHMEM,
>> +                                 PAGE_KERNEL_EXEC, NUMA_NO_NODE,
>> +                                 __builtin_return_address(0));
>>  }
>>
>>  #ifdef CONFIG_X86_32
>

Thanks for the review!

-Kees

-- 
Kees Cook
Chrome OS Security
