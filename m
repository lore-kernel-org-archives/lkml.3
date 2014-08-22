Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaHVD2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 23:28:51 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43225 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaHVD2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 23:28:49 -0400
Date: Fri, 22 Aug 2014 12:28:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sh: intc: Confine SH_INTC to platforms that need it
Message-ID: <20140822032845.GK9099@verge.net.au>
References: <1408541963-20736-1-git-send-email-geert+renesas@glider.be>
 <1408541963-20736-2-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408541963-20736-2-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 03:39:22PM +0200, Geert Uytterhoeven wrote:
> Currently the sh-intc driver is compiled on all SuperH and
> non-multiplatform SH-Mobile platforms, while it's only used on a limited
> number of platforms:
>   - SuperH: SH2(A), SH3(A), SH4(A)(L) (all but SH5)
>   - ARM: sh7372, sh73a0
> 
> Drop the "default y" on SH_INTC, make all CPU platforms that use it
> select it, and protect all sub-options by "if SH_INTC" to fix this.

Thanks, I have queued this up with Magnus's Ack.

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  arch/arm/mach-shmobile/Kconfig | 2 ++
>  arch/sh/Kconfig                | 3 +++
>  drivers/sh/Makefile            | 3 +--
>  drivers/sh/intc/Kconfig        | 6 +++++-
>  4 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
> index 5814754c1240..dae4c73a5f00 100644
> --- a/arch/arm/mach-shmobile/Kconfig
> +++ b/arch/arm/mach-shmobile/Kconfig
> @@ -71,6 +71,7 @@ config ARCH_SH7372
>  	select ARM_CPU_SUSPEND if PM || CPU_IDLE
>  	select CPU_V7
>  	select SH_CLK_CPG
> +	select SH_INTC
>  	select SYS_SUPPORTS_SH_CMT
>  	select SYS_SUPPORTS_SH_TMU
>  
> @@ -81,6 +82,7 @@ config ARCH_SH73A0
>  	select CPU_V7
>  	select I2C
>  	select SH_CLK_CPG
> +	select SH_INTC
>  	select RENESAS_INTC_IRQPIN
>  	select SYS_SUPPORTS_SH_CMT
>  	select SYS_SUPPORTS_SH_TMU
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 453fa5c09550..b319846ad97f 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -172,6 +172,7 @@ menu "System type"
>  #
>  config CPU_SH2
>  	bool
> +	select SH_INTC
>  
>  config CPU_SH2A
>  	bool
> @@ -182,6 +183,7 @@ config CPU_SH3
>  	bool
>  	select CPU_HAS_INTEVT
>  	select CPU_HAS_SR_RB
> +	select SH_INTC
>  	select SYS_SUPPORTS_SH_TMU
>  
>  config CPU_SH4
> @@ -189,6 +191,7 @@ config CPU_SH4
>  	select CPU_HAS_INTEVT
>  	select CPU_HAS_SR_RB
>  	select CPU_HAS_FPU if !CPU_SH4AL_DSP
> +	select SH_INTC
>  	select SYS_SUPPORTS_SH_TMU
>  	select SYS_SUPPORTS_HUGETLBFS if MMU
>  
> diff --git a/drivers/sh/Makefile b/drivers/sh/Makefile
> index 788ed9b59b4e..114203f32843 100644
> --- a/drivers/sh/Makefile
> +++ b/drivers/sh/Makefile
> @@ -1,8 +1,7 @@
>  #
>  # Makefile for the SuperH specific drivers.
>  #
> -obj-$(CONFIG_SUPERH)			+= intc/
> -obj-$(CONFIG_ARCH_SHMOBILE_LEGACY)	+= intc/
> +obj-$(CONFIG_SH_INTC)			+= intc/
>  ifneq ($(CONFIG_COMMON_CLK),y)
>  obj-$(CONFIG_HAVE_CLK)			+= clk/
>  endif
> diff --git a/drivers/sh/intc/Kconfig b/drivers/sh/intc/Kconfig
> index 60228fae943f..6a1b05ddc8c9 100644
> --- a/drivers/sh/intc/Kconfig
> +++ b/drivers/sh/intc/Kconfig
> @@ -1,7 +1,9 @@
>  config SH_INTC
> -	def_bool y
> +	bool
>  	select IRQ_DOMAIN
>  
> +if SH_INTC
> +
>  comment "Interrupt controller options"
>  
>  config INTC_USERIMASK
> @@ -37,3 +39,5 @@ config INTC_MAPPING_DEBUG
>  	  between system IRQs and the per-controller id tables.
>  
>  	  If in doubt, say N.
> +
> +endif
> -- 
> 1.9.1
> 
