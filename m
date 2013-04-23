Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3DWOOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:14:05 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64471 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3DWOOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com>
	<CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com>
	<201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
	<201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
Date: Tue, 23 Apr 2013 17:14:01 +0300
Message-ID: <CAHp75VerTMSR3=hHtxV2_3+CcQrtZfs7JJPNTD4bQPFmeGRukg@mail.gmail.com>
Subject: Re: [PATCH] x86_32: Fix module version table mismatch.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: arjan@infradead.org, hpa@zytor.com, james.hogan@imgtec.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 3:40 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Commit a4b6a77b "module: fix symbol versioning with symbol prefixes" broke
> loading of net/ipv6/ipv6.ko

I would rephrase this to "any module uses memcmp, e.g. ipv6"
Otherwise: Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
...and
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> built with CONFIG_MODVERSIONS=y for x86_32.
>
>   # modprobe ipv6
>   FATAL: Error inserting ipv6 (/lib/modules/3.9.0-rc8-next-20130422/kernel/net/ipv6/ipv6.ko): Invalid argument
>   # dmesg
>   ipv6: no symbol version for memcmp
>   ipv6: Unknown symbol memcmp (err -22)
>
> The reason for breakage is that check_version() in kernel/module.c tries to
> find symname == "memcmp" but versions[i].name == "__builtin_memcmp".
>
> The reason for versions[i].name == "__builtin_memcmp" is that
> memcmp() for x86_32 is defined as
>
>   #define memcmp __builtin_memcmp
>
> in arch/x86/include/asm/string_32.h while memcmp() for x86_64 is defined as
>
>   int memcmp(const void *cs, const void *ct, size_t count);
>
> in arch/x86/include/asm/string_64.h.
>
> Since __builtin_memcmp is a gcc's built-in function which might emit a call to
> memcmp, __builtin_memcmp should not be used for versions[i].name field.
>
> In order to make sure that versions[i].name == "memcmp", make the definition of
> memcmp() for x86_32 identical with that of x86_64.
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: James Hogan <james.hogan@imgtec.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/include/asm/string_32.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
> index 3d3e835..bb85b4e 100644
> --- a/arch/x86/include/asm/string_32.h
> +++ b/arch/x86/include/asm/string_32.h
> @@ -199,7 +199,7 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
>  #define __HAVE_ARCH_MEMMOVE
>  void *memmove(void *dest, const void *src, size_t n);
>
> -#define memcmp __builtin_memcmp
> +int memcmp(const void *cs, const void *ct, size_t count);
>
>  #define __HAVE_ARCH_MEMCHR
>  extern void *memchr(const void *cs, int c, size_t count);
> --
> 1.7.1



--
With Best Regards,
Andy Shevchenko
