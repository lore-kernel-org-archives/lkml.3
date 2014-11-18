Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaKRXM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:12:26 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:61793 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaKRXMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:12:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLGS4cNv_+xLH1fPzg8rUnXL5S+eKmHFn4jckaJkdeRjA@mail.gmail.com>
References: <20141117200248.GA15294@www.outflux.net>
	<CA+rthh-NuaapKLOE_83KoO2ztV1e8LUXPVBefKEX_OTZM=bTMw@mail.gmail.com>
	<CAGXu5jLGS4cNv_+xLH1fPzg8rUnXL5S+eKmHFn4jckaJkdeRjA@mail.gmail.com>
Date: Wed, 19 Nov 2014 00:12:24 +0100
Message-ID: <CA+rthh80M=NN710zOFW7Hfid8aV-TuwdhHdoB0UF0Bboshy9zw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: prefix module autoloading with "crypto-"
From: Mathias Krause <minipli@googlemail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 01:45, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Nov 17, 2014 at 3:20 PM, Mathias Krause <minipli@googlemail.com> wrote:
>> On 17 November 2014 21:02, Kees Cook <keescook@chromium.org> wrote:
>>> This prefixes all crypto module loading with "crypto-" so we never run
>>> the risk of exposing module auto-loading to userspace via a crypto API,
>>> as demonstrated by Mathias Krause:
>>>
>>> https://lkml.org/lkml/2013/3/4/70
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>> v2:
>>>  - added missing #include, thanks to minipli
>>>  - built with allmodconfig
>>> [...snip...]
>>> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>>> index d45e949699ea..d14230f6e977 100644
>>> --- a/include/linux/crypto.h
>>> +++ b/include/linux/crypto.h
>>> @@ -26,6 +26,13 @@
>>>  #include <linux/uaccess.h>
>>>
>>>  /*
>>> + * Autoloaded crypto modules should only use a prefixed name to avoid allowing
>>> + * arbitrary modules to be loaded.
>>> + */
>>> +#define MODULE_ALIAS_CRYPTO(name)      \
>>> +               MODULE_ALIAS("crypto-" name)
>>
>> This would break userland relying on the old aliases, e.g. 'modprobe
>> aes' no longer works.
>>
>> Why not have both aliases, one with the "crypto-" prefix for on-demand
>> loading within the crypto API and one without for manual loading from
>> userland? E.g., something like this:
>>
>> #define MODULE_ALIAS_CRYPTO(name)      \
>>                MODULE_ALIAS(name); \
>>                MODULE_ALIAS("crypto-" name)
>>
>> That would prevent the userland breakage and still achieves the goal
>> of restricting the request_module() call offered by the means of the
>> AF_ALG API.
>
> That was my intention originally, and I should go back to it. The
> trouble is with the use of __UNIQUE_ID in the MODULE_ALIAS macro. It
> uses __LINE__ to produce the id, so the suggested macro expansion
> (which is what I started with) won't work on non-gcc compilers.
>
> I haven't found any solutions for C89 version of gcc's __COUNTER__,
> and I haven't found any C89 ways to force a macro to be expanded as
> being multi-line.

Well, clang should support it as well, according to [1]. But still, a
compiler independent solution would be nice.
Anyway, the __COUNTER__ support is gcc >= 4.3 only. So, according to
Documentation/Changes, stating gcc 3.2 is the minimum supported
version for compiling the kernel, this would be a no-go, too.

[1] http://clang.llvm.org/docs/LanguageExtensions.html#builtin-macros

>
> I'd like to avoid having to open-code both MODULE_ALIAS and
> MODULE_ALIAS_CRYPTO in each module's source.
>
> Anyone see some sneaky way to accomplish this?

Unfortunately, I do not ... beside this, maybe:

#define MODULE_ALIAS_CRYPTO(name)      \
               __MODULE_INFO(alias, alias_userland, name); \
               __MODULE_INFO(alias, alias_crypto, "crypto-" name)

Looks ugly, but works. ;)


Regards,
Mathias
