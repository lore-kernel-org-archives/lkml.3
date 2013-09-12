Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3ILKLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:11:48 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39361 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab3ILKLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:11:46 -0400
Message-ID: <5231934D.4060706@collabora.co.uk>
Date: Thu, 12 Sep 2013 12:11:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com> <52308C91.2000105@ahsoftware.de> <523096FE.8080901@collabora.co.uk> <5230AB6E.1070807@ahsoftware.de> <5231817F.8000901@ahsoftware.de>
In-Reply-To: <5231817F.8000901@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:55 AM, Alexander Holler wrote:
> Am 11.09.2013 19:42, schrieb Alexander Holler:
>> Am 11.09.2013 18:14, schrieb Javier Martinez Canillas:
> 
>>> So for example in an OMAP board DT you can define something like this:
>>>
>>> ethernet@5,0 {
>>>          compatible = "smsc,lan9221", "smsc,lan9115";
>>>          interrupt-parent = <&gpio6>;
>>>          interrupts = <16 8>;
>>> };
>>>
>>> Since each OMAP GPIO bank has 32 GPIO pins, then what you are defining
>>> is that
>>> the GPIO 176 (5 * 32 + 16) will be mapped as the IRQ line for the
>>> ethernet
>>> controller.
> 
> By the way, how do you define two GPIOs/IRQs from different
> gpio-banks/irq-controllers wuth that scheme?
> 

That is indeed a very good question and I don't have a definite answer.

> Would that be like below?
> 
>  ethernet@5,0 {
>           compatible = "smsc,lan9221", "smsc,lan9115";
>           interrupt-parent = <&gpio6>;
>           interrupts = <16 8>;
>           interrupt-parent = <&gpio7>;
>           interrupts = <1 IRQF_TRIGGER_FALLING>; /* GPIO7_1 */
>  };
>

I just looked at
Documentation/devicetree/bindings/interrupt-controller/interrupts.txt and it
doesn't mention that use-case (same device using two different interrupts from
two different interrupt-controller).

So I went and look at the source in drivers/of/irq.c and noticed that the
"interrupts" property and its "interrupt-parent" is parsed by the
of_irq_map_one() function.

/**
 * of_irq_map_one - Resolve an interrupt for a device
 * @device: the device whose interrupt is to be resolved
 * @index: index of the interrupt to resolve
 * @out_irq: structure of_irq filled by this function
 *
 * This function resolves an interrupt, walking the tree, for a given
 * device-tree node. It's the high level pendant to of_irq_map_raw().
 */
int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq)
{
        struct device_node *p;
        ...
        /* Get the interrupts property */
        intspec = of_get_property(device, "interrupts", &intlen);
        ...
        /* Look for the interrupt parent. */
        p = of_irq_find_parent(device);
        ...
}

/**
 * of_irq_find_parent - Given a device node, find its interrupt parent node
 * @child: pointer to device node
 *
 * Returns a pointer to the interrupt parent node, or NULL if the interrupt
 * parent could not be determined.
 */
struct device_node *of_irq_find_parent(struct device_node *child)
{
	struct device_node *p;
	const __be32 *parp;

	if (!of_node_get(child))
		return NULL;

	do {
		parp = of_get_property(child, "interrupt-parent", NULL);
		if (parp == NULL)
			p = of_get_parent(child);
		else {
			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
				p = of_node_get(of_irq_dflt_pic);
			else
				p = of_find_node_by_phandle(be32_to_cpup(parp));
		}
		of_node_put(child);
		child = p;
	} while (p && of_get_property(p, "#interrupt-cells", NULL) == NULL);

	return p;
}

So, if I understood the code correctly the DT IRQ core doesn't expect a device
node to have more than one "interrupt-parent" property.

It *should* work though if you have multiple "interrupts" properties defined and
all of them have the same "interrupt-parent":

       interrupt-parent = <&gpio6>;
       interrupts = <1 IRQF_TRIGGER_HIGH>; /* GPIO6_1 */
       interrupts = <2 IRQF_TRIGGER_LOW>; /* GPIO6_2 */

since of_irq_map_one() will be called for each "interrupts" and the correct
"interrupt-parent" will get obtained by of_irq_find_parent().

> So multiple definitions of interrupt-parent are allowed and the order
> does matter? And such does work? Sorry for asking, but I'm relatively
> new to DT. ;)
>

No worries, I'm very new to DT too so let's wait for Grant, Stephen or Linus to
give us a definite answer :)

> Regards,
> 
> Alexander Holler
> 

Best regards,
Javier
