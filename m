Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaBUVV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:21:57 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39365 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaBUVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:21:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140221131531.2db80023c59895a930cf374f@linux-foundation.org>
References: <20140221202110.GA29885@www.outflux.net>
	<20140221123658.5752f75eea6506d17bfa313b@linux-foundation.org>
	<CAGXu5jLGBJp7oKXjausV70bXF-RTVDXxdZriS0cJ7X6NO90Ybg@mail.gmail.com>
	<20140221131531.2db80023c59895a930cf374f@linux-foundation.org>
Date: Fri, 21 Feb 2014 13:21:54 -0800
X-Google-Sender-Auth: ZFMXHgV5BIynfgOAFWqdSknx2Jg
Message-ID: <CAGXu5j+SHTm5MbzWSaMABSv-ZJHrzSCm2ts-rUAoTVjTFidyAw@mail.gmail.com>
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

On Fri, Feb 21, 2014 at 1:15 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 21 Feb 2014 13:05:08 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>> >> +#ifdef CONFIG_RANDOMIZE_BASE
>> >> +static unsigned long module_load_offset;
>> >> +static int randomize_modules = 1;
>> >
>> > It's pretty common for people to later come back and say "hey I want to
>> > set the default in Kconfig".  Perhaps we should do that from day 1.
>>
>> I've been slapped down for adding more config options in the past, and
>> I think it's unlikely that people using CONFIG_RANDOMIZE_BASE won't
>> want the modules base randomized too. I think this is a safe default,
>> but if you see it as a requirement, I can change it.
>
> I think there were issues with some embedded systems where it's
> hard/impossible to provide/alter boot parameters.
>
> I suppose we can leave it this way until there are complaints.
>
>> > This implies that parse_nokaslr() will need to be renamed and taught to
>> > handle 0->1 changing.
>> >
>> >> +static int __init parse_nokaslr(char *p)
>> >> +{
>> >> +     randomize_modules = 0;
>> >> +     return 0;
>> >> +}
>> >> +early_param("nokaslr", parse_nokaslr);
>> >
>> > Documentation/kernel-parameters.txt, please.   This isn't hard :(
>>
>> "nokaslr" is already documented. Do you mean adding a note about
>> modules as well to the existing documentation?
>
> Yes, it should now mention modules as well.

Okay, I will add this to the v2 patch.

>
>> >> +static unsigned long int get_module_load_offset(void)
>> >> +{
>> >> +     if (randomize_modules) {
>> >> +             mutex_lock(&module_mutex);
>> >> +             /*
>> >> +              * Calculate the module_load_offset the first time this
>> >> +              * code is called. Once calculated it stays the same until
>> >> +              * reboot.
>> >> +              */
>> >> +             if (module_load_offset == 0)
>> >> +                     module_load_offset =
>> >> +                             (get_random_int() % 1024 + 1) * PAGE_SIZE;
>> >> +             mutex_unlock(&module_mutex);
>> >> +     }
>> >> +     return module_load_offset;
>> >> +}
>> >
>> > This seems unnecessarily complex and inefficient.  We only set
>> > module_load_offset a single time, so why not do it that way?
>> > Mark it __init, run it during initcalls then throw it away.
>>
>> I'd like to make sure this is running well after the pRNG is up and
>> running. I can run some tests to see how the entropy looks if this is
>> done during __init, though.
>
> That may be a bit optimistic, dunno.  I suppose that doing it this way
> we will already have done a bit of disk IO, so there will be more
> randomness.

Right -- it's probably not much, but this doesn't seem like much
overhead for module loading. It's a relatively infrequent event.

> btw, would it be better to make each module have its own offset rather
> than using the same offset for all of them?  That could cause problems
> with vmap space fragmentation I guess.

Right -- we felt this was sufficient. And in my experience, other
attempts and trying to do per-allocat randomization and avoid the
fragmentation problem (e.g. "greedy random positioning"), like done
with RedHat's ASCII-Armor memory randomization proved to have _less_
entropy than just randomizing the base address.

-Kees

-- 
Kees Cook
Chrome OS Security
