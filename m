Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbbAPA1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 19:27:45 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54744 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbAPA1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 19:27:43 -0500
MIME-Version: 1.0
In-Reply-To: <87r3v96ebd.fsf@rustcorp.com.au>
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com>
	<CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com>
	<20141222184940.GB17192@tassilo.jf.intel.com>
	<20141222190041.GC17192@tassilo.jf.intel.com>
	<54986EA2.106@amd.com>
	<874msmt1hi.fsf@rustcorp.com.au>
	<549A85DE.1040006@amd.com>
	<87r3v96ebd.fsf@rustcorp.com.au>
Date: Thu, 15 Jan 2015 16:27:42 -0800
X-Google-Sender-Auth: pL0g7BE1iYsb5vzY75qmvX-4XaE
Message-ID: <CAGXu5jJFn_H1RQmffqvm-4OSbk0MXb5P3Re--5JK13aK3sGRUw@mail.gmail.com>
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Oded Gabbay <oded.gabbay@amd.com>, Andi Kleen <ak@linux.intel.com>,
        Alex Deucher <alexdeucher@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 8:28 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Oded Gabbay <oded.gabbay@amd.com> writes:
>> On 12/24/2014 01:01 AM, Rusty Russell wrote:
>>> Oded Gabbay <oded.gabbay@amd.com> writes:
>>>> I didn't say it doesn't always work.
>>>> The actual thing that doesn't work is the define symbol_get and only in a
>>>> specific case of 32bit kernel AND CONFIG_MODULES is unset AND
>>>> CONFIG_RANDOMIZE_BASE is set.
>>>> The define in that case is:
>>>> #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak)); &(x); })
>>>>
>>>> Why it doesn't work (doesn't return NULL when symbol doesn't exists) ?
>>>
>>> Hmm, I'd guess CONFIG_RANDOMIZE_BASE is relocating NULL symbols...
>>>
>>> No, I can't reproduce this.  Please send your .config privately.
>>>
>>> Here's my test case:
>>>
>>> diff --git a/init/main.c b/init/main.c
>>> index 61b993767db5..a3ee1ec97ec3 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -683,6 +683,12 @@ asmlinkage __visible void __init start_kernel(void)
>>>
>>>      ftrace_init();
>>>
>>> +    {
>>> +            extern void nonexistent_fn(void);
>>> +            printk("symbol_get(nonexistent_fn) = %p\n",
>>> +                   symbol_get(nonexistent_fn));
>>> +    }
>>> +
>>>      /* Do the rest non-__init'ed, we're now alive */
>>>      rest_init();
>>>   }
>>>
>>> Thanks,
>>> Rusty.
>>>
>> Hi Rusty,
>>
>> Attached is the bad config file. (config-bad)
>> I have narrowed the changes you need to do to the config file in order to
>> reproduce this bug.
>> The base assumption is a 32-bit kernel and without modules support. Rest of the
>> config file is pretty standard, IMO.
>> Then, its not enough to enable CONFIG_RANDOMIZE_BASE like I wrote in my original
>> post. You need also to unset CONFIG_HIBERNATION.
>
> Indeed, thanks; your config breaks as reported.  With CONFIG_HIBERNATION
> the kernel offset is 0, so we don't see this.
>
> Kees, as far as I can tell you need another 0-terminated vmlinux.relocs
> section for weak symbols.  These should not be relocated if already 0.
>
> Put this somewhere to test.  It fails for x86_64, too:
>
> diff --git a/init/main.c b/init/main.c
> index 61b993767db5..c9e0195c792a 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -683,6 +683,12 @@ asmlinkage __visible void __init start_kernel(void)
>
>         ftrace_init();
>
> +       {
> +               extern void __attribute__((weak)) nonexistent_fn(void);
> +               printk("nonexistent_fn = %p\n", nonexistent_fn);
> +               BUG_ON(nonexistent_fn != NULL);
> +       }
> +
>         /* Do the rest non-__init'ed, we're now alive */
>         rest_init();
>  }

Hm, I can't reproduce this on v3.19-rc4. My nonexistent_fn comes back
NULL regardless of CONFIG and kaslr on/off states I've tried. Could
this be a (yet another) linker bug? What was the toolchain used? I
built with gcc 4.8.2 and binutils 2.24.

-Kees

-- 
Kees Cook
Chrome OS Security
