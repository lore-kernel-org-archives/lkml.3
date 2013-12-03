Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3LCP4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:56:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:13605 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab3LCP4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:56:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,818,1378882800"; 
   d="scan'208";a="443883090"
Message-ID: <529E008A.6030704@linux.intel.com>
Date: Tue, 03 Dec 2013 18:02:18 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Stephen Warren <swarren@nvidia.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2] pinctrl: baytrail: lock IRQs when starting them
References: <1386082822-20094-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1386082822-20094-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 05:00 PM, Linus Walleij wrote:
> This uses the new API for tagging GPIO lines as in use by
> IRQs. This enforces a few semantic checks on how the underlying
> GPIO line is used.
>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Actually make the change compile, doh.
> ---
>   drivers/pinctrl/pinctrl-baytrail.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index 1174ea86b6e9..998dbb0c4c93 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -372,11 +372,33 @@ static void byt_irq_mask(struct irq_data *d)
>   {
>   }
>
> +static unsigned int byt_irq_startup(struct irq_data *d)
> +{
> +	struct byt_gpio *vg = irq_data_get_irq_handler_data(d);

This should probably be:

struct byt_gpio *vg = irq_data_get_irq_chip_data(d);

As chip methods use irq_data->chip_data, not irq_data->handler_data
(Mika tested that it works on baytrail)

> +
> +	if (gpio_lock_as_irq(&vg->chip, irqd_to_hwirq(d)))
> +		dev_err(vg->chip.dev,
> +			"unable to lock HW IRQ %lu for IRQ\n",
> +			irqd_to_hwirq(d));
> +	byt_irq_unmask(d);
> +	return 0;
> +}
> +
> +static void byt_irq_shutdown(struct irq_data *d)
> +{
> +	struct byt_gpio *vg = irq_data_get_irq_handler_data(d);

Same here.

-Mathias
