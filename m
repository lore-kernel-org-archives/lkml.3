Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965677AbaFUC5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:57:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51495 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757991AbaFUC5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:57:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19VuTlt6sXsCGiZWZ32Y0dvNS9O1jwXwmk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2F6BE59516E
Date: Fri, 20 Jun 2014 22:57:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, joe@perches.com
Subject: Re: [PATCH V3 16/16] irqchip: crossbar: allow for quirky hardware
 with direct hardwiring of GIC
Message-ID: <20140621025723.GF21711@titan.lakedaemon.net>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
 <1402917796-31574-17-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402917796-31574-17-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:53:16PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10, 131,
> 132, 133 are direct wired to hardware blocks bypassing crossbar.
> This quirky implementation is *NOT* supposed to be the expectation
> of crossbar hardware usage. However, these are already marked in our
> description of the hardware with SKIP and RESERVED where appropriate.
> 
> Unfortunately, we need to be able to refer to these hardwired IRQs.
> So, to request these, crossbar driver can use the existing information
> from it's table that these SKIP/RESERVED maps are direct wired sources
> and generic allocation/programming of crossbar should be avoided.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
>  .../devicetree/bindings/arm/omap/crossbar.txt      |   12 ++++++++++--
>  drivers/irqchip/irq-crossbar.c                     |   20 ++++++++++++++++++--
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> index 8210ea4..438ccab 100644
> --- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> @@ -42,8 +42,10 @@ Documentation/devicetree/bindings/arm/gic.txt for further details.
>  
>  An interrupt consumer on an SoC using crossbar will use:
>  	interrupts = <GIC_SPI request_number interrupt_level>
> -request number shall be between 0 to that described by
> -"ti,max-crossbar-sources"
> +When the request number is between 0 to that described by
> +"ti,max-crossbar-sources", it is assumed to be a crossbar mapping. If the
> +request_number is greater than "ti,max-crossbar-sources", then it is mapped as a
> +quirky hardware mapping direct to GIC.
>  
>  Example:
>  	device_x@0x4a023000 {
> @@ -51,3 +53,9 @@ Example:
>  		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
>  		...
>  	};
> +
> +	device_y@0x4a033000 {
> +		/* Direct mapped GIC SPI 1 used */
> +		interrupts = <GIC_SPI 401 IRQ_TYPE_LEVEL_HIGH>;

Ideally, I'd like to see a macro here so that it's clear that we crossed
a magic threshold. eg:

#define MAX_SOURCES     400
#define DIRECT_IRQ(irq) (MAX_SOURCES + irq)
...
		interrupts = <GIC_SPI DIRECT_IRQ(1) IRQ_TYPE_LEVEL_HIGH>;

and, then:

		ti,max-crossbar-sources = <MAX_SOURCES>;

> +		...
> +	};
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index ef613c4..fff6218 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -86,8 +86,13 @@ static inline int allocate_free_irq(int cb_no)
>  
>  static inline bool needs_crossbar_write(irq_hw_number_t hw)
>  {
> -	if (hw > GIC_IRQ_START)
> -		return true;
> +	int cb_no;
> +
> +	if (hw > GIC_IRQ_START) {
> +		cb_no = cb->irq_map[hw - GIC_IRQ_START];
> +		if (cb_no != IRQ_RESERVED && cb_no != IRQ_SKIP)
> +			return true;
> +	}
>  
>  	return false;
>  }
> @@ -130,8 +135,19 @@ static int crossbar_domain_xlate(struct irq_domain *d,
>  {
>  	int ret;
>  	int req_num = intspec[1];
> +	int direct_map_num;
>  
>  	if (req_num >= cb->max_crossbar_sources) {
> +		direct_map_num = req_num - cb->max_crossbar_sources;
> +		if (direct_map_num < cb->int_max) {
> +			ret = cb->irq_map[direct_map_num];
> +			if (ret == IRQ_RESERVED || ret == IRQ_SKIP) {
> +				/* We use the interrupt num as h/w irq num */
> +				ret = direct_map_num;
> +				goto found;
> +			}
> +		}
> +
>  		pr_err("%s: requested crossbar number %d > max %d\n",
>  		       __func__, req_num, cb->max_crossbar_sources);
>  		return -EINVAL;

thx,

Jason.
