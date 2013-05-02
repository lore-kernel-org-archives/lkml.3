Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3EBCjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:39:19 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:40898
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756891Ab3EBCjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:39:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 2 May 2013 10:39:00 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mxs: icoll: Add function to register an interrupt as FIQ
 source
Message-ID: <20130502023858.GD3442@S2101-09.ap.freescale.net>
References: <1367243917-5177-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367243917-5177-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 03:58:37PM +0200, Maxime Ripard wrote:
> MXS, unlike other ARM platforms,

How are other ARM platforms handling that?

> has no way to make a FIQ from an
> interrupt from a driver, without poking directly into the icoll.
> 
> Add an exported function to do this.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-mxs/icoll.c | 11 +++++++++++

This will become drivers/irqchip/irq-mxs.c after the merge window.

Shawn

>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/mach-mxs/icoll.c b/arch/arm/mach-mxs/icoll.c
> index 8fb23af..1bb16da 100644
> --- a/arch/arm/mach-mxs/icoll.c
> +++ b/arch/arm/mach-mxs/icoll.c
> @@ -16,6 +16,7 @@
>   * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>   */
>  
> +#include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/irq.h>
> @@ -34,6 +35,7 @@
>  #define HW_ICOLL_INTERRUPTn_SET(n)		(0x0124 + (n) * 0x10)
>  #define HW_ICOLL_INTERRUPTn_CLR(n)		(0x0128 + (n) * 0x10)
>  #define BM_ICOLL_INTERRUPTn_ENABLE		0x00000004
> +#define BM_ICOLL_INTERRUPTn_FIQ_ENABLE		0x00000010
>  #define BV_ICOLL_LEVELACK_IRQLEVELACK__LEVEL0	0x1
>  
>  #define ICOLL_NUM_IRQS		128
> @@ -41,6 +43,15 @@
>  static void __iomem *icoll_base = MXS_IO_ADDRESS(MXS_ICOLL_BASE_ADDR);
>  static struct irq_domain *icoll_domain;
>  
> +void mxs_icoll_set_irq_fiq(unsigned int irq)
> +{
> +	struct irq_data *d = irq_get_irq_data(irq);
> +
> +	__raw_writel(BM_ICOLL_INTERRUPTn_FIQ_ENABLE,
> +		     icoll_base + HW_ICOLL_INTERRUPTn_SET(d->hwirq));
> +}
> +EXPORT_SYMBOL(mxs_icoll_set_irq_fiq);
> +
>  static void icoll_ack_irq(struct irq_data *d)
>  {
>  	/*
> -- 
> 1.8.1.2
> 

