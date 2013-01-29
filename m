Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3A2OyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:54:20 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:42733 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab3A2OyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:54:01 -0500
Message-ID: <5107E285.8060304@gmail.com>
Date: Tue, 29 Jan 2013 08:53:57 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Daniel Santos <daniel.santos@pobox.com>,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] arm: use built-in byte swap function
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
In-Reply-To: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 07:30 PM, Kim Phillips wrote:
> Enable the compiler intrinsic for byte swapping on arch ARM.  This
> allows the compiler to detect and be able to optimize out byte
> swappings, e.g. in big endian to big endian moves.
> 
> AFAICT, arm gcc got __builtin_bswap{32,64} support in 4.6,
> and for the 16-bit version in 4.8.

I think these are the versions ARM got optimized swap support. The newer
compilers are smart enough to replace a swap written in C with a rev
instruction. Last time I checked, they did not do rev16, but that is
probably what was added in 4.8 (and backported to Linaro gcc). The
Linaro backports make it impossible to define what gcc version has a
specific feature.

If you specify to use the builtin's, do you still get inline rev
instructions emitted?

Rob

> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
> akin to: http://comments.gmane.org/gmane.linux.kernel.cross-arch/16016
> 
> based on linux-next.  Depends on commit "compiler-gcc{3,4}.h: Use
> GCC_VERSION macro" by Daniel Santos <daniel.santos@pobox.com>,
> currently in the akpm branch.
> 
> RFC because of unfamiliarity with arch ARM, and that at91sam9rl,
> at91rm9200, and lpd270 (so far, at least) builds fail with:
> 
> include/uapi/linux/swab.h:60: undefined reference to `__bswapsi2'
> 
> I'm using eldk-5.2.1/armv7a's arm-linux-gnueabi-gcc (GCC) 4.6.4
> 20120303 (prerelease)
> 
>  arch/arm/Kconfig              |    1 +
>  include/linux/compiler-gcc4.h |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index eda8711..437d11a 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -3,6 +3,7 @@ config ARM
>  	default y
>  	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
>  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
> +	select ARCH_USE_BUILTIN_BSWAP
>  	select ARCH_HAVE_CUSTOM_GPIO_H
>  	select ARCH_WANT_IPC_PARSE_VERSION
>  	select BUILDTIME_EXTABLE_SORT if MMU
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 68b162d..da5f728 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -67,7 +67,8 @@
>  
>  
>  #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
> -#if GCC_VERSION >= 40400
> +#if (!defined(__arm__) && GCC_VERSION >= 40400) || \
> +    (defined(__arm__) && GCC_VERSION >= 40600)
>  #define __HAVE_BUILTIN_BSWAP32__
>  #define __HAVE_BUILTIN_BSWAP64__
>  #endif
> 

