Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3GYJop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:44:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58941 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GYJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:44:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control its IRQ domain ?
Date: Thu, 25 Jul 2013 11:45:33 +0200
Message-ID: <1408178.cxAUTUGJc5@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdazPX3EbVbLvXQZh0oRBpHoWPK+EkFO75v9zfAXSPCkHA@mail.gmail.com>
References: <1624911.6TtmtVmU1T@avalon> <CACRpkdazPX3EbVbLvXQZh0oRBpHoWPK+EkFO75v9zfAXSPCkHA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Thank you for your answer.

On Thursday 25 July 2013 11:20:54 Linus Walleij wrote:
> On Wed, Jul 24, 2013 at 1:21 AM, Laurent Pinchart wrote:
> > Has anyone run into a similar issue ? My gut feeling is that the
> > architecture isn't right somewhere, but I can't really pinpoint where.
> 
> We had a similar situation with the MFDs, where Mark, Lee and Sam came up
> with the solution to include an irqdomain in the MFD cell spawn function:
> 
> extern int mfd_add_devices(struct device *parent, int id,
>                            struct mfd_cell *cells, int n_devs,
>                            struct resource *mem_base,
>                            int irq_base, struct irq_domain *irq_domain);
> 
> When each cell (i.e. a platform device) is created, the irq for that cell
> will be translated with irq_create_mapping() so the cell/platform device
> just get a Linux IRQ it can use and do not need to worry about translating
> it.
> 
> Prior to this we had all sorts of exported translator functions for the IRQs
> exported from each hub driver ---what a mess.
> 
> Can you think about a parent/child relationship making it possible to pass
> the irqs readily translated in this case?

The two devices are independent, so there's no real parent/child relationship. 
However, as Grant proposed, I could list all the interrupts associated with 
GPIOs in the GPIO controller DT node. I would then just call 
irq_of_parse_and_map() in the .to_irq() handler to magically translate the 
GPIO number to a mapped IRQ number.

The number of interrupts can be pretty high (up to 58 in the worst case so 
far), so an alternative would be to specify the interrupt-parent only, and 
call irq_create_of_mapping() directly. What solution would you prefer ?

-- 
Regards,

Laurent Pinchart

