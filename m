Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642AbaFQP6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:58:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36668 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575AbaFQP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:58:19 -0400
Date: Tue, 17 Jun 2014 16:57:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: George Cherian <george.cherian@ti.com>
Cc: "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] extcon: gpio: Add dt support for the driver.
Message-ID: <20140617155719.GC8930@leverpostej>
References: <1402977500-19987-1-git-send-email-george.cherian@ti.com>
 <1402977500-19987-3-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402977500-19987-3-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 04:58:20AM +0100, George Cherian wrote:
> Add device tree support to extcon-gpio driver.
> Add devicetree binding documentation
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  .../devicetree/bindings/extcon/extcon-gpio.txt     | 34 ++++++++++++++++++++++
>  drivers/extcon/extcon-gpio.c                       | 29 ++++++++++++++++++
>  2 files changed, 63 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> new file mode 100644
> index 0000000..80b791b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> @@ -0,0 +1,34 @@
> +GPIO based EXTCON
> +
> +EXTCON GPIO
> +-----------
> +
> +Required Properties:
> + - compatible: should be:
> +   * "ti,extcon-gpio"
> + - gpios: specifies the gpio pin used.
> + - debounce: Debounce time for GPIO IRQ in ms
> + - irq-flags: IRQ flag to be used ( eg: IRQ_TYPE_EDGE_FALLING)

This looks distinctly odd. Why do you need this here?

> +Optional Properties:
> + - gpio-active-low: Property describing whether gpio active state is 1 or 0
> +		    If defined , low state of gpio means active.

Surely this is defined in the gpio flags?

> + - check-on-resume: Property describing whether to check the gpio state
> +		    while resuming from SLEEP.

Does this need to be in DT? Surely we could jsut always check this?

> + - state-on: print_state is overriden with state_on string if provided.
> +	     If NULL, default method of extcon class is used.
> + - state_off: print_state is overriden with state_off string  if provided.
> +	      If NUll, default method of extcon class is used.

This means nothing from a HW perspective. This describes linux internal
details.

[...]

> +		of_property_read_u32(np, "debounce", (u32 *)&pdata->debounce);
> +		of_property_read_u32(np, "irq-flags", (u32 *)&pdata->irq_flags);

If you need theses casts, the code is broken.

These functions can only read into a u32. If you pass a smaller type
you'll trash aribtrary memory locations, and if you pass a larger type
this is broken for BE.

Mark.
