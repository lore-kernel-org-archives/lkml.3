Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3HVNk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:40:59 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:36305 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752470Ab3HVNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:40:57 -0400
Message-ID: <52160F22.2080701@gaisler.com>
Date: Thu, 22 Aug 2013 15:16:18 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
CC: poeschel@lemonage.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        ian.campbell@citrix.com, galak@codeaurora.org, pawel.moll@arm.com,
        tomasz.figa@gmail.com, swarren@wwwdotorg.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de>
In-Reply-To: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-21 15:38, Lars Poeschel wrote:
> +static void of_gpio_scan_irq_lines(const struct device_node *const node,
> +				   struct device_node *const gcn,
> +				   struct irq_domain *const irq_domain,
> +				   const u32 intsize,
> +				   const struct gpio_chip * const gc,
> +				   bool request)
> +{
> +	struct device_node *child;
> +	struct device_node *irq_parent;
> +	const __be32 *intspec;
> +	u32 intlen;
> +	int ret;
> +	int i;
> +	irq_hw_number_t hwirq;
> +	unsigned int type;
> +
> +	if (node == NULL)
> +		return;
> +
> +	for_each_child_of_node(node, child) {
> +		of_gpio_scan_irq_lines(child, gcn, irq_domain, intsize, gc,
> +				       request);
> +		/* Check if we have an IRQ parent, else continue */
> +		irq_parent = of_irq_find_parent(child);

Hi!

This call to of_irq_find_parent breaks gpiolib-of for SPARC due to the 
fact that the function is undefined when !defined(CONFIG_OF_IRQ) && 
defined(CONFIG_OF).

Defining the empty of_irq_find_parent in include/linux/of_irq.h when 
!defined(CONFIG_OF_IRQ) instead of the current case when 
!defined(CONFIG_OF) would solve the immediate compilation problem.

However, when !defined(CONFIG_OF_IRQ) (i.e. SPARC in this case) the 
whole tree walking will never accomplish anything, so it would be good 
if of_gpiochip_reserve_irq_lines is just an empty dummy or something 
like that when !defined(CONFIG_OF_IRQ).

Cheers,
Andreas Larsson

