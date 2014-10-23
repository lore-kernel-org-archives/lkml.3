Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaJWUxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:53:52 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:44207 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaJWUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:53:50 -0400
Date: Thu, 23 Oct 2014 16:53:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: mathieu.poirier@linaro.org
cc: linux@arm.linux.org.uk, catalin.marinas@arm.com,
        stefano.stabellini@eu.citrix.com, ezequiel.garcia@free-electrons.com,
        Liviu.Dudau@arm.com, thomas.petazzoni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: supplementing IO accessors with 64 bit
 capability
In-Reply-To: <1414072315-18393-1-git-send-email-mathieu.poirier@linaro.org>
Message-ID: <alpine.LFD.2.11.1410231652100.6969@knanqh.ubzr>
References: <1414072315-18393-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, mathieu.poirier@linaro.org wrote:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Some drivers on ARMv7 need 64 bit read and writes.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

If you make __LINUX_ARM_ARCH__ >= 6 then you may add

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
> Changes for v2:
>  - Protecting [readq, writeq]_relaxed with architecture constraint.
> 
>  arch/arm/include/asm/io.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index 1805674..027832b 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -118,6 +118,24 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
>  	return val;
>  }
>  
> +#if __LINUX_ARM_ARCH__ >= 5
> +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
> +{
> +	asm volatile("strd %1, %0"
> +		     : "+Qo" (*(volatile u64 __force *)addr)
> +		     : "r" (val));
> +}
> +
> +static inline u64 __raw_readq(const volatile void __iomem *addr)
> +{
> +	u64 val;
> +	asm volatile("ldrd %1, %0"
> +		     : "+Qo" (*(volatile u64 __force *)addr),
> +		       "=r" (val));
> +	return val;
> +}
> +#endif
> +
>  /*
>   * Architecture ioremap implementation.
>   */
> @@ -306,10 +324,17 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
>  					__raw_readw(c)); __r; })
>  #define readl_relaxed(c) ({ u32 __r = le32_to_cpu((__force __le32) \
>  					__raw_readl(c)); __r; })
> +#if __LINUX_ARM_ARCH__ >= 5
> +#define readq_relaxed(c) ({ u64 __r = le64_to_cpu((__force __le64) \
> +					__raw_readq(c)); __r; })
> +#endif
>  
>  #define writeb_relaxed(v,c)	__raw_writeb(v,c)
>  #define writew_relaxed(v,c)	__raw_writew((__force u16) cpu_to_le16(v),c)
>  #define writel_relaxed(v,c)	__raw_writel((__force u32) cpu_to_le32(v),c)
> +#if __LINUX_ARM_ARCH__ >= 5
> +#define writeq_relaxed(v,c)	__raw_writeq((__force u64) cpu_to_le64(v),c)
> +#endif
>  
>  #define readb(c)		({ u8  __v = readb_relaxed(c); __iormb(); __v; })
>  #define readw(c)		({ u16 __v = readw_relaxed(c); __iormb(); __v; })
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
