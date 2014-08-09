Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaHIAGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:06:44 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:56743 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaHIAGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:06:42 -0400
MIME-Version: 1.0
In-Reply-To: <CALZtONBNEg7kzUtwKihQuAU48MNh5NjhZcWoOxe-1-vgWqSLiw@mail.gmail.com>
References: <20140808075316.GA21919@www.outflux.net>
	<CALZtONBNEg7kzUtwKihQuAU48MNh5NjhZcWoOxe-1-vgWqSLiw@mail.gmail.com>
Date: Fri, 8 Aug 2014 17:06:41 -0700
X-Google-Sender-Auth: N9l810CFz7LRel7z-syhGfKgo6w
Message-ID: <CAGXu5jL3GjrqsixS6U+GYD1pxAOOcXsXbt5XOVC8KhZB+naXAA@mail.gmail.com>
Subject: Re: [PATCH] mm/zpool: use prefixed module loading
From: Kees Cook <keescook@chromium.org>
To: Dan Streetman <ddstreet@ieee.org>, Greg KH <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux-MM <linux-mm@kvack.org>, Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 10:11 AM, Dan Streetman <ddstreet@ieee.org> wrote:
> On Fri, Aug 8, 2014 at 3:53 AM, Kees Cook <keescook@chromium.org> wrote:
>> To avoid potential format string expansion via module parameters,
>> do not use the zpool type directly in request_module() without a
>> format string. Additionally, to avoid arbitrary modules being loaded
>> via zpool API (e.g. via the zswap_zpool_type module parameter) add a
>> "zpool-" prefix to the requested module, as well as module aliases for
>> the existing zpool types (zbud and zsmalloc).
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  mm/zbud.c     | 1 +
>>  mm/zpool.c    | 2 +-
>>  mm/zsmalloc.c | 1 +
>>  3 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/zbud.c b/mm/zbud.c
>> index a05790b1915e..aa74f7addab1 100644
>> --- a/mm/zbud.c
>> +++ b/mm/zbud.c
>> @@ -619,3 +619,4 @@ module_exit(exit_zbud);
>>  MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Seth Jennings <sjenning@linux.vnet.ibm.com>");
>>  MODULE_DESCRIPTION("Buddy Allocator for Compressed Pages");
>> +MODULE_ALIAS("zpool-zbud");
>
> If we keep this, I'd recommend putting this inside the #ifdef
> CONFIG_ZPOOL section, to keep all the zpool stuff together in zbud and
> zsmalloc.
>
>> diff --git a/mm/zpool.c b/mm/zpool.c
>> index e40612a1df00..739cdf0d183a 100644
>> --- a/mm/zpool.c
>> +++ b/mm/zpool.c
>> @@ -150,7 +150,7 @@ struct zpool *zpool_create_pool(char *type, gfp_t gfp, struct zpool_ops *ops)
>>         driver = zpool_get_driver(type);
>>
>>         if (!driver) {
>> -               request_module(type);
>> +               request_module("zpool-%s", type);
>
> I agree with a change of (type) to ("%s", type), but what's the need
> to prefix "zpool-"?  Anyone who has access to modify the
> zswap_zpool_type parameter is already root and can just as easily load
> any module they want.  Additionally, the zswap_compressor parameter
> also runs through request_module() (in crypto/api.c) and could be used
> to load any kernel module.

Yeah, the "%s" should be the absolute minimum. :)

> I'd prefer to leave out the "zpool-" prefix unless there is a specific
> reason to include it.

The reason is that the CAP_SYS_MODULE capability is supposed to be
what controls the loading of arbitrary modules, and that's separate
permission than changing module parameters via sysfs
(/sys/modules/...). Which begs the question: maybe those parameters
shouldn't be writable without CAP_SYS_MODULE? Greg, any thoughts here?
kobjects don't seem to carry any capabilities checks.

This is certainly much less serious than letting a non-root user load
an arbitrary module, but it would be great if we could have a clear
path to making sure that arbitrary module loading isn't the default
case here (given this new ability). In the past (netdev module
loading), a CVE was assigned for a CAP_NET_ADMIN privilege being able
to load arbitrary modules, so I don't see this as much different.

Ugh, yes, I didn't see the call to crypto_has_comp. Other users of
this routine use const char arrays, so there wasn't any danger here.
This would be the first user of the crypto API to expose this via a
userspace-controlled arbitrary string.

Herbert, what do you think here? I'm concerned we're going to get into
a situation like we had to deal with for netdev:

http://git.kernel.org/linus/8909c9ad8ff03611c9c96c9a92656213e4bb495b

I think we need to fix zswap now before it gets too far, and likely
adjust the crypto API to use a module prefix as well. Perhaps we need
a "crypto-" prefix?

-Kees

>
>>                 driver = zpool_get_driver(type);
>>         }
>>
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index 4e2fc83cb394..36af729eb3f6 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -1199,3 +1199,4 @@ module_exit(zs_exit);
>>
>>  MODULE_LICENSE("Dual BSD/GPL");
>>  MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
>> +MODULE_ALIAS("zpool-zsmalloc");
>> --
>> 1.9.1
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



-- 
Kees Cook
Chrome OS Security
