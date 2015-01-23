Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbbAWEpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:45:46 -0500
Received: from ozlabs.org ([103.22.144.67]:47804 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbAWEpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:45:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: Oded Gabbay <oded.gabbay@amd.com>, Andi Kleen <ak@linux.intel.com>,
        Alex Deucher <alexdeucher@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
In-Reply-To: <CAGXu5jJFn_H1RQmffqvm-4OSbk0MXb5P3Re--5JK13aK3sGRUw@mail.gmail.com>
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com> <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com> <20141222184940.GB17192@tassilo.jf.intel.com> <20141222190041.GC17192@tassilo.jf.intel.com> <54986EA2.106@amd.com> <874msmt1hi.fsf@rustcorp.com.au> <549A85DE.1040006@amd.com> <87r3v96ebd.fsf@rustcorp.com.au> <CAGXu5jJFn_H1RQmffqvm-4OSbk0MXb5P3Re--5JK13aK3sGRUw@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 23 Jan 2015 14:40:17 +1030
Message-ID: <878uguuogm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> On Sun, Jan 4, 2015 at 8:28 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Oded Gabbay <oded.gabbay@amd.com> writes:
>>> On 12/24/2014 01:01 AM, Rusty Russell wrote:
>>>> Oded Gabbay <oded.gabbay@amd.com> writes:
>>>>> I didn't say it doesn't always work.
>>>>> The actual thing that doesn't work is the define symbol_get and only in a
>>>>> specific case of 32bit kernel AND CONFIG_MODULES is unset AND
>>>>> CONFIG_RANDOMIZE_BASE is set.
>>>>> The define in that case is:
>>>>> #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak)); &(x); })
>>>>>
>>>>> Why it doesn't work (doesn't return NULL when symbol doesn't exists) ?
>>>>
>>>> Hmm, I'd guess CONFIG_RANDOMIZE_BASE is relocating NULL symbols...
>>>>
>>>> No, I can't reproduce this.  Please send your .config privately.
>>>>
>>>> Here's my test case:
>>>>
>>>> diff --git a/init/main.c b/init/main.c
>>>> index 61b993767db5..a3ee1ec97ec3 100644
>>>> --- a/init/main.c
>>>> +++ b/init/main.c
>>>> @@ -683,6 +683,12 @@ asmlinkage __visible void __init start_kernel(void)
>>>>
>>>>      ftrace_init();
>>>>
>>>> +    {
>>>> +            extern void nonexistent_fn(void);
>>>> +            printk("symbol_get(nonexistent_fn) = %p\n",
>>>> +                   symbol_get(nonexistent_fn));
>>>> +    }
>>>> +
>>>>      /* Do the rest non-__init'ed, we're now alive */
>>>>      rest_init();
>>>>   }
>>>>
>>>> Thanks,
>>>> Rusty.
>>>>
>>> Hi Rusty,
>>>
>>> Attached is the bad config file. (config-bad)
>>> I have narrowed the changes you need to do to the config file in order to
>>> reproduce this bug.
>>> The base assumption is a 32-bit kernel and without modules support. Rest of the
>>> config file is pretty standard, IMO.
>>> Then, its not enough to enable CONFIG_RANDOMIZE_BASE like I wrote in my original
>>> post. You need also to unset CONFIG_HIBERNATION.
>>
>> Indeed, thanks; your config breaks as reported.  With CONFIG_HIBERNATION
>> the kernel offset is 0, so we don't see this.
>>
>> Kees, as far as I can tell you need another 0-terminated vmlinux.relocs
>> section for weak symbols.  These should not be relocated if already 0.
>>
>> Put this somewhere to test.  It fails for x86_64, too:
>>
>> diff --git a/init/main.c b/init/main.c
>> index 61b993767db5..c9e0195c792a 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -683,6 +683,12 @@ asmlinkage __visible void __init start_kernel(void)
>>
>>         ftrace_init();
>>
>> +       {
>> +               extern void __attribute__((weak)) nonexistent_fn(void);
>> +               printk("nonexistent_fn = %p\n", nonexistent_fn);
>> +               BUG_ON(nonexistent_fn != NULL);
>> +       }
>> +
>>         /* Do the rest non-__init'ed, we're now alive */
>>         rest_init();
>>  }
>
> Hm, I can't reproduce this on v3.19-rc4. My nonexistent_fn comes back
> NULL regardless of CONFIG and kaslr on/off states I've tried. Could
> this be a (yet another) linker bug? What was the toolchain used? I
> built with gcc 4.8.2 and binutils 2.24.

$ ld --version
GNU ld (GNU Binutils for Ubuntu) 2.24.90.20141014
...
$ gcc --version
gcc (Ubuntu 4.9.1-16ubuntu6) 4.9.1

I tested with gcc 4.8.3 as well, same fail.

I'll send you the config I used separately.

Cheers,
Rusty.



