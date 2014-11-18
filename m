Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaKRApa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:45:30 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63025 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKRAp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+rthh-NuaapKLOE_83KoO2ztV1e8LUXPVBefKEX_OTZM=bTMw@mail.gmail.com>
References: <20141117200248.GA15294@www.outflux.net>
	<CA+rthh-NuaapKLOE_83KoO2ztV1e8LUXPVBefKEX_OTZM=bTMw@mail.gmail.com>
Date: Mon, 17 Nov 2014 16:45:27 -0800
X-Google-Sender-Auth: q6DUccwfuvWcdaL8i4rBcIfG4SE
Message-ID: <CAGXu5jLGS4cNv_+xLH1fPzg8rUnXL5S+eKmHFn4jckaJkdeRjA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: prefix module autoloading with "crypto-"
From: Kees Cook <keescook@chromium.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 3:20 PM, Mathias Krause <minipli@googlemail.com> wrote:
> On 17 November 2014 21:02, Kees Cook <keescook@chromium.org> wrote:
>> This prefixes all crypto module loading with "crypto-" so we never run
>> the risk of exposing module auto-loading to userspace via a crypto API,
>> as demonstrated by Mathias Krause:
>>
>> https://lkml.org/lkml/2013/3/4/70
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v2:
>>  - added missing #include, thanks to minipli
>>  - built with allmodconfig
>> [...snip...]
>> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>> index d45e949699ea..d14230f6e977 100644
>> --- a/include/linux/crypto.h
>> +++ b/include/linux/crypto.h
>> @@ -26,6 +26,13 @@
>>  #include <linux/uaccess.h>
>>
>>  /*
>> + * Autoloaded crypto modules should only use a prefixed name to avoid allowing
>> + * arbitrary modules to be loaded.
>> + */
>> +#define MODULE_ALIAS_CRYPTO(name)      \
>> +               MODULE_ALIAS("crypto-" name)
>
> This would break userland relying on the old aliases, e.g. 'modprobe
> aes' no longer works.
>
> Why not have both aliases, one with the "crypto-" prefix for on-demand
> loading within the crypto API and one without for manual loading from
> userland? E.g., something like this:
>
> #define MODULE_ALIAS_CRYPTO(name)      \
>                MODULE_ALIAS(name); \
>                MODULE_ALIAS("crypto-" name)
>
> That would prevent the userland breakage and still achieves the goal
> of restricting the request_module() call offered by the means of the
> AF_ALG API.

That was my intention originally, and I should go back to it. The
trouble is with the use of __UNIQUE_ID in the MODULE_ALIAS macro. It
uses __LINE__ to produce the id, so the suggested macro expansion
(which is what I started with) won't work on non-gcc compilers.

I haven't found any solutions for C89 version of gcc's __COUNTER__,
and I haven't found any C89 ways to force a macro to be expanded as
being multi-line.

I'd like to avoid having to open-code both MODULE_ALIAS and
MODULE_ALIAS_CRYPTO in each module's source.

Anyone see some sneaky way to accomplish this?

-Kees

-- 
Kees Cook
Chrome OS Security
