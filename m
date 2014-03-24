Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaCXJuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:50:35 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13732 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752241AbaCXJue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:50:34 -0400
Date: Mon, 24 Mar 2014 09:50:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] ARM: Use 64-bit DMA addresses for LPAE+VirtIO-MMIO
Message-ID: <20140324095003.GA3850@arm.com>
References: <1395250522-30031-1-git-send-email-cov@codeaurora.org>
 <532C96B9.4090805@codeaurora.org>
 <90DB5198-051A-48EC-B577-5342BD706713@arm.com>
 <4272242.L9VmujUH59@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4272242.L9VmujUH59@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 11:52:33PM +0000, Arnd Bergmann wrote:
> On Friday 21 March 2014 23:27:24 Catalin Marinas wrote:
> > On 21 Mar 2014, at 19:44, Christopher Covington <cov@codeaurora.org> wrote:
> > > On 03/21/2014 12:27 PM, Catalin Marinas wrote:
> > >>> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> > >>> index 1f8fed9..a62bcc9 100644
> > >>> --- a/arch/arm/mm/Kconfig
> > >>> +++ b/arch/arm/mm/Kconfig
> > >>> @@ -617,6 +617,7 @@ config ARM_LPAE
> > >>>     bool "Support for the Large Physical Address Extension"
> > >>>     depends on MMU && CPU_32v7 && !CPU_32v6 && !CPU_32v5 && \
> > >>>             !CPU_32v4 && !CPU_32v3
> > >>> +   select ARCH_DMA_ADDR_T_64BIT if VIRTIO_MMIO
> > >> 
> > >> That's the wrong place to enable ARCH_DMA_ADDR_T_64BIT. Do you have a
> > >> platform with >32-bit physical address space? If yes, it should be
> > >> selected there.
> > > 
> > > The platforms I'm currently using are models like the Versatile Express
> > > RTSM/FVP. I can respin with changes to ARCH_VEXPRESS and ARCH_VIRT instead.
> > 
> > But do you use RAM beyond 32-bit on such models?
> 
> I think the more important question here is what the normal behavior is
> for these platforms. I believe in most cases you don't have RAM above
> the boundary, so we should not enable the option by default as it can
> have noticeable overhead (we'd turn it on all the time if it didn't).
> 
> How about one of these two 
> 
> a)
> 
> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 9ea4b7b..6e3b6db 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -628,7 +628,9 @@ config ARCH_PHYS_ADDR_T_64BIT
>  	def_bool ARM_LPAE
>  
>  config ARCH_DMA_ADDR_T_64BIT
> -	bool
> +	def_bool "Allow DMA to high (>4GB) addresses"
> +	depends on ARCH_PHYS_ADDR_T_64BIT
> +	default y
>  	help

We should probably call this "Allow DMA to high (>4GB) _bus_ addresses"
to distinguish it from the actual CPU physical address.

> b)
> 
> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 9ea4b7b..4a21b1e 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
[...]
>  config ARCH_PHYS_ADDR_T_64BIT
> -	def_bool ARM_LPAE
> +	bool "Support more than 4GB of physical address space" if EXPERT
> +	depends on ARM_LPAE
> +	default y

I don't think I ever tested LPAE with ARCH_PHYS_ADDR_T_64BIT off. Even
if you enable EXPERT, it's a risk that some bit shifting of phys_addr_t
would break (the pte expects 64-bit entries).

>  config ARCH_DMA_ADDR_T_64BIT
> -	bool
> +	def_bool ARCH_PHYS_ADDR_T_64BIT

I recall Russell objecting to this when we reviewed the LPAE patches
because the CPU address is different from the bus address. I assume
those arguments still stand.

I would go for (a) but with individual SoCs still selecting
ARCH_DMA_ADDR_T_64BIT explicitly if they expect bus addresses over
32-bit.

-- 
Catalin
