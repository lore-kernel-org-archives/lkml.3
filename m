Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3JHRkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:40:35 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:40225 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3JHRkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMFOmVcANaPBau-gVkhna33WdOsajD9vHjivuyqFES0csu=-Q@mail.gmail.com>
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
	<1381248622-27809-1-git-send-email-anatol.pomozov@gmail.com>
	<1381249090.2081.240.camel@joe-AO722>
	<CAFLxGvzrEQGE8+QAFCQL=z2hwe578pBdWOu4B+DkJDjxkM0=hw@mail.gmail.com>
	<CAOMFOmVcANaPBau-gVkhna33WdOsajD9vHjivuyqFES0csu=-Q@mail.gmail.com>
Date: Tue, 8 Oct 2013 10:40:30 -0700
Message-ID: <CAOMFOmWwQSnxwDT30CwFsvr6KCsNtDL=PU8OTAKo2E4505PLvA@mail.gmail.com>
Subject: Re: [PATCH] core: Catch overflows in do_div() function
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Oct 8, 2013 at 10:28 AM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> Hi
>
> On Tue, Oct 8, 2013 at 9:45 AM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Tue, Oct 8, 2013 at 6:18 PM, Joe Perches <joe@perches.com> wrote:
>>> On Tue, 2013-10-08 at 09:10 -0700, Anatol Pomozov wrote:
>>>> If second parameter passed to this function was 64 then it silently
>>>> truncates to 32 bits. Catch such situation.
>>> []
>>>> diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
>>> []
>>>> @@ -25,6 +26,7 @@
>>>>  # define do_div(n,base) ({                                   \
>>>>       uint32_t __base = (base);                               \
>>>>       uint32_t __rem;                                         \
>>>> +     BUG_ON(sizeof(base) > 4 && base >= (1UL<<32));          \
>>>
>>> I think this would be better as a BUILD_BUG_ON
>>
>> No. BUILD_BUG_ON works only for constants.
>
> BUILD_BUG_ON might actually work. In case if 'base' is const it will
> check if it fits 32 bits. As far as I see all such usages (when 'base'
> is const) are fine. In case if 'base' is 64 bit variable the
> compilation fails.
>
> Comparing with previous patch (without "&& base >= (1UL<<32)") it
> eliminates warnings in situations when we pass small constants as long
> (dozens of such places in HEAD).
>
> Looking at the cases when we use do_div() I see that in many cases we
> pass "long" as a second parameter (see __setup_per_zone_wmarks). If we
> replace it with div64_s64() we force to use 64 bit arithmetic. But on
> 32bit platform "long" is 32bit and using div64_s64() here is
> redundant. Wouldn't it be better if do_div() would handle this
> situation and called required functions based on a) current
> architecture b) size of base/n parameters. Something like this
> (completely untested and we need __div64_64 on 32 bit platform):
>
> --- a/include/asm-generic/div64.h
> +++ b/include/asm-generic/div64.h
> @@ -22,12 +22,12 @@
>
>  #if BITS_PER_LONG == 64
>
> -# define do_div(n,base) ({                                     \
> -       uint32_t __base = (base);                               \
> -       uint32_t __rem;                                         \
> -       __rem = ((uint64_t)(n)) % __base;                       \
> -       (n) = ((uint64_t)(n)) / __base;                         \
> -       __rem;                                                  \
> +# define do_div(n,base) ({             \
> +       typeof(base) __base = (base);   \

Documentation says typeof() has side-effects and can be used on
arithmetic types only. :(

> +       typeof(base) __rem;             \
> +       __rem = (n) % __base;           \
> +       (n) = (n) / __base;             \
> +       __rem;                          \
>   })
>
>  #elif BITS_PER_LONG == 32
> @@ -37,16 +37,20 @@ extern uint32_t __div64_32(uint64_t *dividend,
> uint32_t divisor);
>  /* The unnecessary pointer compare is there
>   * to check for type safety (n must be 64bit)
>   */
> -# define do_div(n,base) ({                             \
> -       uint32_t __base = (base);                       \
> -       uint32_t __rem;                                 \
> -       (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
> -       if (likely(((n) >> 32) == 0)) {                 \
> -               __rem = (uint32_t)(n) % __base;         \
> -               (n) = (uint32_t)(n) / __base;           \
> -       } else                                          \
> -               __rem = __div64_32(&(n), __base);       \
> -       __rem;                                          \
> +# define do_div(n,base) ({                                     \
> +       typeof(base) __base = (base);                           \
> +       typeof(base) __rem;                                     \
> +       (void)(((typeof((n)) *)0) == ((uint64_t *)0));          \
> +       if (sizeof(__base) <= 4 || (__builtin_constant_p(__base) &&
> __base < (1ULL<<32)) ) { \
> +               if (likely(((n) >> 32) == 0)) {                 \
> +                       __rem = (uint32_t)(n) % __base;         \
> +                       (n) = (uint32_t)(n) / __base;           \
> +               } if (sizeof(base) <= 4)                        \
> +                       __rem = __div64_32(&(n), __base);       \
> +       } else {                                                \
> +               __rem = __div64_64(&(n), __base);               \
> +       }                                                       \
> +       __rem;                                                  \
>   })
>
>  #else /* BITS_PER_LONG == ?? */
