Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3IWQOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:14:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33712 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3IWQOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:14:18 -0400
Message-ID: <524068D4.5040909@wwwdotorg.org>
Date: Mon, 23 Sep 2013 10:14:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 08:40 AM, Javier Martinez Canillas wrote:
> To use a GPIO pin as an interrupt line, two previous configurations
> have to be made:
> 
> a) Map the GPIO pin as an interrupt line into the Linux irq space
> b) Enable the GPIO bank and configure the GPIO direction as input
> 
> Most GPIO/IRQ chip drivers just create a mapping for every single
> GPIO pin with irq_create_mapping() on .probe so users usually can
> assume a) and only have to do b) by using the following sequence:
> 
> gpio_request(gpio, "foo IRQ");
> gpio_direction_input(gpio);
> 
> and then request a IRQ with:
> 
> irq = gpio_to_irq(gpio);
> request_irq(irq, ...);
> 
> Some drivers know that their IRQ line is being driven by a GPIO
> and use a similar sequence as the described above but others are
> not aware or don't care wether their IRQ is a real line from an
> interrupt controller or a GPIO pin acting as an IRQ.
> ...

I think that explanation is a bit like retro-actively implying that
drivers /should/ be aware of whether their IRQ is a GPIO or not, and
should be acting differently. However, they should not.

I would much rather see a simpler patch description along the lines of:

The OMAP GPIO controller HW requires that a pin be configured in GPIO
mode in order to operate as an interrupt input. Since drivers should not
be aware of whether an interrupt pin is also a GPIO or not, the HW
should be fully configured/enabled as an IRQ if a driver solely uses IRQ
APIs such as request_irq, and never calls any GPIO-related APIs. As
such, add the missing HW setup to the OMAP GPIO controller's irq_chip
driver.

The code change looks like it does what I would expect though.
