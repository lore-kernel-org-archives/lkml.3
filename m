Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3FDWAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:00:04 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:19855
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab3FDWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:00:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zcb8kz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Tue, 4 Jun 2013 16:59:46 -0500
From: Scott Wood <scottwood@freescale.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Handling of IRQ in MPC8xx GPIO
Message-ID: <20130604215946.GA21467@home.buserror.net>
References: <201302211632.r1LGWaRr025445@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201302211632.r1LGWaRr025445@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 06:32:36AM -0000, LEROY Christophe wrote:
> This patch allows the use IRQ to notify the change of GPIO status on the MPC8xx
> CPM IO ports. This then allows to associate IRQs to GPIOs in the Device Tree. Ex:
> 	CPM1_PIO_C: gpio-controller@960 {
> 		#gpio-cells = <2>;
> 		compatible = "fsl,cpm1-pario-bank-c";
> 		reg = <0x960 0x10>;
> 		interrupts = <255 255 255 255 1 2 6 9 10 11 14 15 23 24 26 31>;
> 		interrupt-parent = <&CPM_PIC>;
> 		gpio-controller;
> 	};
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
[snip]
> @@ -581,6 +588,30 @@
>  	spin_unlock_irqrestore(&cpm1_gc->lock, flags);
>  }
>  
> +static int __cpm1_gpio16_to_irq(struct of_mm_gpio_chip *mm_gc,
> +		unsigned int gpio)
> +{
> +	struct cpm1_gpio16_chip *cpm1_gc = to_cpm1_gpio16_chip(mm_gc);
> +
> +	return cpm1_gc->irq[gpio] ? cpm1_gc->irq[gpio] : -ENXIO;
> +}

If it's an internal function, why not just pass in cpm1_gc?

Or just open-code it, as it's a one-liner and you don't use it anywhere
else.

Or fix the gpio layer to use 0 to mean "no irq" rather than -ENXIO... :-)

> diff -ur linux-3.7.9/kernel/irq/irqdomain.c linux/kernel/irq/irqdomain.c
> --- linux-3.7.9/kernel/irq/irqdomain.c	2013-02-17 19:53:32.000000000 +0100
> +++ linux/kernel/irq/irqdomain.c	2012-12-13 19:52:38.000000000 +0100
> @@ -763,7 +763,8 @@
>  	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
>  
>  	/* Check revmap bounds; complain if exceeded */
> -	if (WARN_ON(hwirq >= domain->revmap_data.linear.size))
> +	/* 255 is a trick to allow UNDEF value in DTS */
> +	if (hwirq == 255 || WARN_ON(hwirq >= domain->revmap_data.linear.size))
>  		return 0;

NACK.  Besides the hackishness of it, 255 is valid for some interrupt
controllers.

If you need for a way to leave holes in an "interrupts" property, propose
something non-hacky on devicetree-discuss@lists.ozlabs.org.

Or, do what some other devices do, and have a different property that
indicates which pins are connected, and only include those in the
"interrupts" property.  See
Documentation/devicetree/bindings/powerpc/fsl/mpic-msgr.txt and
mpic-msgr-receive-mask as an example.

-Scott

