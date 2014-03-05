Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaCEGLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:11:39 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:18871
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbaCEGLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:11:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 5 Mar 2014 14:11:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: vf610: add UART choice for low-level debug
Message-ID: <20140305061129.GH8784@S2101-09.ap.freescale.net>
References: <6cdb1444950fae035bb447f11519040c0a88992d.1393888981.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6cdb1444950fae035bb447f11519040c0a88992d.1393888981.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 12:27:09AM +0100, Stefan Agner wrote:
> Add choice for low-level debug UART. Similar to i.MX6, there is a
> numeric configuration, valid choices are 0 to 3.
> Not that the kernel assumes that the boot loader initialized clock
> properly.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/Kconfig.debug      |  9 +++++++++
>  arch/arm/include/debug/vf.S | 16 ++++++++++++++--
>  2 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 0531da8..c2005a7 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -946,6 +946,15 @@ config DEBUG_IMX_UART_PORT
>  	  Choose UART port on which kernel low-level debug messages
>  	  should be output.
>  
> +config DEBUG_VF_UART_PORT
> +	int "Vybrid Debug UART Port Selection" if DEBUG_VF_UART
> +	default 1
> +	range 0 3
> +	depends on SOC_VF610
> +	help
> +	  Choose UART port on which kernel low-level debug messages
> +	  should be output.
> +
>  config DEBUG_TEGRA_UART
>  	bool
>  	depends on ARCH_TEGRA
> diff --git a/arch/arm/include/debug/vf.S b/arch/arm/include/debug/vf.S
> index ba12cc4..4683b7c 100644
> --- a/arch/arm/include/debug/vf.S
> +++ b/arch/arm/include/debug/vf.S
> @@ -7,9 +7,21 @@
>   *
>   */
>  
> +#define VF_UART0_BASE_ADDR	0x40027000
> +#define VF_UART1_BASE_ADDR	0x40028000
> +#define VF_UART2_BASE_ADDR	0x40029000
> +#define VF_UART3_BASE_ADDR	0x4002a000
> +#define VF_UART_BASE_ADDR(n)	VF_UART##n##_BASE_ADDR
> +#define VF_UART_BASE(n)		VF_UART_BASE_ADDR(n)
> +#define VF_UART_PHYSICAL_BASE	VF_UART_BASE(CONFIG_DEBUG_VF_UART_PORT)
> +
> +#define VF_UART_VIRTUAL_BASE	0xfe000000
> +
> +

One new line is good enough.

>  	.macro	addruart, rp, rv, tmp
> -	ldr	\rp, =0x40028000	@ physical
> -	ldr	\rv, =0xfe028000	@ virtual
> +	ldr	\rp, =(VF_UART_PHYSICAL_BASE) 	@ physical

The parentheses is unnecessary.

Shawn

> +	and	\rv, \rp, #0xffffff		@ offset within 16MB section
> +	add	\rv, \rv, #VF_UART_VIRTUAL_BASE
>  	.endm
>  
>  	.macro	senduart, rd, rx
> -- 
> 1.9.0
> 

