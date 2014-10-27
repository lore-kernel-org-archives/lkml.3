Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaJ0KtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:49:04 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48864 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaJ0KtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:49:01 -0400
Date: Mon, 27 Oct 2014 10:48:48 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>
Subject: Re: [RFC V3] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Message-ID: <20141027104848.GD8768@arm.com>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18259@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D18259@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 08:02:08AM +0000, Wang, Yalin wrote:
> this change add CONFIG_HAVE_ARCH_BITREVERSE config option,
> so that we can use arm/arm64 rbit instruction to do bitrev operation
> by hardware.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  arch/arm/Kconfig                |  1 +
>  arch/arm/include/asm/bitrev.h   | 28 ++++++++++++++++++++++++++++
>  arch/arm64/Kconfig              |  1 +
>  arch/arm64/include/asm/bitrev.h | 28 ++++++++++++++++++++++++++++
>  include/linux/bitrev.h          |  9 +++++++++
>  lib/Kconfig                     |  9 +++++++++
>  lib/bitrev.c                    |  2 ++
>  7 files changed, 78 insertions(+)
>  create mode 100644 arch/arm/include/asm/bitrev.h
>  create mode 100644 arch/arm64/include/asm/bitrev.h
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89c4b5c..426cbcc 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -16,6 +16,7 @@ config ARM
>  	select DCACHE_WORD_ACCESS if HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	select GENERIC_ALLOCATOR
>  	select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)
> +	select HAVE_ARCH_BITREVERSE if (CPU_V7M || CPU_V7)
>  	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
>  	select GENERIC_IDLE_POLL_SETUP
>  	select GENERIC_IRQ_PROBE
> diff --git a/arch/arm/include/asm/bitrev.h b/arch/arm/include/asm/bitrev.h
> new file mode 100644
> index 0000000..c21a5f4
> --- /dev/null
> +++ b/arch/arm/include/asm/bitrev.h
> @@ -0,0 +1,28 @@
> +#ifndef __ASM_ARM_BITREV_H
> +#define __ASM_ARM_BITREV_H
> +
> +static __always_inline __attribute_const__ u32 __arch_bitrev32(u32 x)
> +{
> +	if (__builtin_constant_p(x)) {
> +		x = (x >> 16) | (x << 16);
> +		x = ((x & 0xFF00FF00) >> 8) | ((x & 0x00FF00FF) << 8);
> +		x = ((x & 0xF0F0F0F0) >> 4) | ((x & 0x0F0F0F0F) << 4);
> +		x = ((x & 0xCCCCCCCC) >> 2) | ((x & 0x33333333) << 2);
> +		return ((x & 0xAAAAAAAA) >> 1) | ((x & 0x55555555) << 1);
> +	}
> +	__asm__ ("rbit %0, %1" : "=r" (x) : "r" (x));

I think you need to use %w0 and %w1 here, otherwise you bit-reverse the
64-bit register.

Will
