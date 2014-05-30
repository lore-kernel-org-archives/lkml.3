Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaE3CMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:12:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:2903 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbaE3CMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:12:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,938,1392192000"; 
   d="scan'208";a="548680597"
Message-ID: <5387E915.4000008@linux.intel.com>
Date: Fri, 30 May 2014 10:12:37 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com>	<CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>	<538459E8.6010701@ti.com>	<20140527084615.GC1801@lahna.fi.intel.com>	<53847F39.2010503@ti.com> <CACRpkdbe1=Yt3UDm9f4ZmZ+K2ZB9nVL+RNr7eU_TbnK-CmNY+A@mail.gmail.com>
In-Reply-To: <CACRpkdbe1=Yt3UDm9f4ZmZ+K2ZB9nVL+RNr7eU_TbnK-CmNY+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 9:37 PM, Linus Walleij wrote:
> On Tue, May 27, 2014 at 2:04 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>> On 05/27/2014 11:46 AM, Mika Westerberg wrote:
(...)
> 
> My idea is that you should call gpiochip_add() *first* and then
> add the IRQs to the chip. In succession.
> 
> Rationale: with dynamic GPIO numbers, gpio_to_irq()
> cannot reasonably be working before the gpiochip is added,
> so it should be added first, then the irqchip. Since irq_to_gpio()
> is *NOT* to be used (rather obliterated), this is the sequence
> we mandate.
> 
> This is how the new irqchip helpers work by the way. As I
> introduce this to more and more drivers it will look more and
> more like this. And attack patches tagged RFT switching the
> semantics of drivers are appreciated.
> 
> Yours,
> Linus Walleij
> 

Thanks. I'll use this sequence during probe().

(...)
	cg->regmap = pmic->regmap;

	retval = gpiochip_add(&cg->chip);
	if (retval) {
		dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
		return ret;
	}

	gpiochip_irqchip_add(&cg->chip, &crystalcove_irqchip, 0,
			     handle_simple_irq, IRQ_TYPE_NONE);

	retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
				      IRQF_ONESHOT, KBUILD_MODNAME, cg);

	if (retval) {
		dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
		WARN_ON(gpiochip_remove(&cg->chip));
		return retval;
	}

	return 0;
}

Is the code above OK?

But this code will trigger a crash in gpiolib-acpi. Currently at the end
of gpiochip_add(), it calls:

gpiochip_add() -> acpi_gpiochip_add() -> acpi_gpiochip_request_interrupts()

acpi_gpiochip_request_interrupts() needs ->to_irq to work. Without having
called gpiochip_irqchip_add() already, this will be NULL:

        if (!chip->to_irq)
                return;    <-- It will return here.

        INIT_LIST_HEAD(&acpi_gpio->events);

In the tear down path, acpi_gpiochip_free_interrupts() will find to_irq is
no longer NULL, then it will walk an uninitialized list.

So, should this be fixed in gpiolib-acpi?

Best Regards
Lejun
