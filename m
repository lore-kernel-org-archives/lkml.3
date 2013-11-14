Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab3KNWdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:33:04 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:46074 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab3KNWc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:32:59 -0500
MIME-Version: 1.0
In-Reply-To: <52853fe6b0fd9_bf6d31e7c1a@nysa.notmuch>
References: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
	<20131113000358.GA2420@gmail.com>
	<CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
	<52850B89.10605@linux.com>
	<52853fe6b0fd9_bf6d31e7c1a@nysa.notmuch>
Date: Thu, 14 Nov 2013 16:32:57 -0600
Message-ID: <CAMP44s0kGhPvuVZMe4zpmqFLtxrLW2gBPu6eHg0G6DFYKNpW7Q@mail.gmail.com>
Subject: Re: [PATCH v2] panic: setup panic_timeout early
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sending again since the previous one was rejected by the server.

On Thu, Nov 14, 2013 at 3:25 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Levente Kurusa wrote:
>> 2013-11-14 12:16 keltezéssel, Felipe Contreras írta:
>> > On Tue, Nov 12, 2013 at 6:03 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >>
>> >> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>> >>
>> >>> Otherwise we might not reboot when the user needs it the most (early
>> >>> on).
>> >>>
>> >>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> >>> ---
>> >>>
>> >> [...]
>> >>>
>> >>> diff --git a/kernel/panic.c b/kernel/panic.c
>> >>> index b6c482c..d865263 100644
>> >>> --- a/kernel/panic.c
>> >>> +++ b/kernel/panic.c
>> >>> @@ -468,9 +468,23 @@ EXPORT_SYMBOL(__stack_chk_fail);
>> >>>
>> >>>  #endif
>> >>>
>> >>> -core_param(panic, panic_timeout, int, 0644);
>> >>>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>> >>>
>> >>> +static int __init set_panic_timeout(char *val)
>> >>> +{
>> >>> +     long timeout;
>> >>> +     int ret;
>> >>> +
>> >>> +     ret = kstrtol(val, 0, &timeout);
>> >>> +     if (ret < 0)
>> >>> +             return ret;
>> >>> +
>> >>> +     panic_timeout = timeout;
>> >>> +     return 0;
>> >>> +}
>> >>
>> >> I think the type of the 'timeout' local variable should match the type of
>> >> 'panic_timeout' (which is 'int', not 'long').
>> >
>> > So you would rather have this?
>> >
>> >   kstrtol(val, 0, (long *)&timeout);
>> >
>> > Couldn't that potentially write the value beyond the memory allocated
>> > to 'timeout'?
>> >
>>
>> No, 'panic_timeout' is a variable of type 'int'.
>> Your 'long timeout;' line is wrong and should say 'int timeout;'
>
> Oh really? Something like this?
>
>   --- a/kernel/panic.c
>   +++ b/kernel/panic.c
>   @@ -472,7 +472,7 @@ core_param(pause_on_oops, pause_on_oops, int, 0644);
>
>    static int __init set_panic_timeout(char *val)
>    {
>   -       long timeout;
>   +       int timeout;
>           int ret;
>
>           ret = kstrtol(val, 0, &timeout);
>
> And then what happens?
>
>   kernel/panic.c: In function ‘set_panic_timeout’:
>   kernel/panic.c:478:2: warning: passing argument 3 of ‘kstrtol’ from incompatible pointer type [enabled by default]
>     ret = kstrtol(val, 0, &timeout);
>     ^
>   In file included from include/linux/debug_locks.h:4:0,
>                    from kernel/panic.c:11:
>   include/linux/kernel.h:268:95: note: expected ‘long int *’ but argument is of type ‘int *’
>    static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
>
> To fix that warning you need this:
>                                                                                                  ^
>   --- a/kernel/panic.c
>   +++ b/kernel/panic.c
>   @@ -472,10 +472,10 @@ core_param(pause_on_oops, pause_on_oops, int, 0644);
>
>    static int __init set_panic_timeout(char *val)
>    {
>   -       long timeout;
>   +       int timeout;
>           int ret;
>
>   -       ret = kstrtol(val, 0, &timeout);
>   +       ret = kstrtol(val, 0, (long *)&timeout);
>           if (ret < 0)
>                   return ret;
>
>
> Which is the only logical conclusion I arrived to. What else do you suggest to
> fix the problem that kstrtol() expects a long? And since this fix is not what
> we want because we would be writing to the wrong memory, we don't want 'timeout'
> to be int.
>
> Therefore 'timeout' should be a long. How is that not clear?
>
> You can even see that it's already done this way for parameters:
>
>   STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
>
>   #define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)             \
>           int param_set_##name(const char *val, const struct kernel_param *kp) \
>           {                                                             \
>                   tmptype l;                                            \
>                   int ret;                                              \
>                                                                           \
>                   ret = strtolfn(val, 0, &l);                           \
>                   if (ret < 0 || ((type)l != l))                                \
>                           return ret < 0 ? ret : -EINVAL;                       \
>                   *((type *)kp->arg) = l;                                       \
>                   return 0;                                             \
>           }                                                             \
>
> So yes, we obviously want the temporary variable 'timeout' to be a long, even
> though the final destination is an int.

-- 
Felipe Contreras
