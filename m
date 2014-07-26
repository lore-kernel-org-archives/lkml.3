Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbaGZBn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 21:43:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57921 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaGZBn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 21:43:27 -0400
Message-ID: <53D307BB.1020208@codeaurora.org>
Date: Fri, 25 Jul 2014 18:43:23 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller driver
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com> <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 08:25 AM, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> Qualcomm GPIO and MPP sub-function blocks found in the PMIC chips.
> QPNP_REG_STATUS1_GPIO_EN_REV0_MASK
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

(...)
> +static int qpnp_conv_to_pin(struct qpnp_pinctrl *qctrl,
> +			   struct qpnp_padinfo *pad, unsigned param,
> +			   unsigned val)
(...)
> +	switch (param) {
(...)
> +	case PIN_CONFIG_OUTPUT:
> +		nattrs = 3;
> +		attr[0].addr  = QPNP_REG_MODE_CTL;
> +		attr[0].shift = QPNP_REG_OUT_SRC_SEL_SHIFT;
> +		attr[0].mask  = QPNP_REG_OUT_SRC_SEL_MASK;
> +		attr[0].val   = !!val;

It seems that this patch provides no means to configure the output source
select bits to be anything besides 0 (constant low) or 1 (constant high).
 Some non-generic property is needed to configure this for both GPIOs and
MPPs.  Passing the value in via the output-high property does not seem
like a good approach since that is a generic pin config property that is
defined to take no value.  The special functions available for GPIOs (e.g.
PWM/LPG, clock, keypad, etc.) which are configured via this register are
used by many boards.

Something else to consider is that QPNP_REG_OUT_SRC_SEL_MASK is being
defined as 0xf which would imply that there are 16 possible output source
select options.  While technically true, this makes the situation more
complicated since half of those options are the inverted version of the
other half.  In the GPIO hardware this corresponds to an 8-way mux
followed by an XOR gate to conditionally invert the mux output.  If output
source select is handled this way, then the following values would need to
be supported in device tree for GPIOs:
	* 0:  constant low (already supported via output-low;)
	* 1:  constant high (already supported via output-high;)
	* 2:  paired GPIO
	* 3:  inverted paired GPIO
	* 4:  special function 1
	* 5:  inverted special function 1
	* 6:  special function 2
	* 7:  inverted special function 2
	* 8:  dtest1
	* 9:  inverted dtest1
	* 10: dtest2
	* 11: inverted dtest2
	* 12: dtest3
	* 13: inverted dtest3
	* 14: dtest4
	* 15: inverted dtest4
The same options are supported by MPPs except for special function 1,
inverted special function 1, special function 2, and inverted special
function 2.

If the output source select register parameter is instead treated as a
3-bit value along with an inversion bit, then the list of output selection
options that needs to be supported in device tree is cut in half:
	* 0:  constant (already supported)
	* 1:  paired GPIO
	* 2:  special function 1
	* 3:  special function 2
	* 4:  dtest1
	* 5:  dtest2
	* 6:  dtest3
	* 7:  dtest4
Another DT pin configuration property would then need to be used to
specify if the signal should be inverted or not.

> +		attr[1].addr  = QPNP_REG_MODE_CTL;
> +		attr[1].shift = QPNP_REG_MODE_SEL_SHIFT;
> +		attr[1].mask  = QPNP_REG_MODE_SEL_MASK;
> +		attr[1].val   = QPNP_PIN_MODE_DIG_OUT;
> +		attr[2].addr  = QPNP_REG_EN_CTL;
> +		attr[2].shift = QPNP_REG_MASTER_EN_SHIFT;
> +		attr[2].mask  = QPNP_REG_MASTER_EN_MASK;
> +		attr[2].val   = 1;
> +		break;

(...)

> +static int qpnp_of_xlate(struct gpio_chip *chip,
> +		       const struct of_phandle_args *gpio_desc, u32 *flags)
> +{
> +	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
> +	struct qpnp_padinfo *pad;
> +
> +	if (chip->of_gpio_n_cells < 2) {
> +		dev_err(qctrl->dev, "of_gpio_n_cells < 2\n");
> +		return -EINVAL;
> +	}
> +
> +	pad = qpnp_get_desc(qctrl, gpio_desc->args[0]);
> +	if (!pad)
> +		return -EINVAL;
> +
> +	if (flags)
> +		*flags = gpio_desc->args[1];
> +
> +	return gpio_desc->args[0];
> +}

This of_xlate callback function will result in the following situation:
If for example, a device tree consumer node wishes to use PM8941 GPIO 7
within gpiolib, then it would need to specify a gpiospec like this:
	<&pm8941_gpio 6 0>
There is an off-by-one issue with the indexing between the hardware GPIO
numbers (1-based) and the gpiolib gpio offsets (0-based).  Do you agree
that the indexing used within the device tree gpiospecs should match the
hardware numbering scheme?  I feel like this would be much less confusing
for users to work with.  If so, I think that a change to qpnp_of_xlate
like this would achieve it:

+#define QPNP_PIN_PHYSICAL_OFFSET	1

 static int qpnp_of_xlate(struct gpio_chip *chip,
 		     const struct of_phandle_args *gpio_desc, u32 *flags)
 {
 	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
 	struct qpnp_padinfo *pad;
+	unsigned pin = gpio_desc->args[0] - QPNP_PIN_PHYSICAL_OFFSET;

 	if (chip->of_gpio_n_cells < 2) {
 		dev_err(qctrl->dev, "of_gpio_n_cells < 2\n");
 		return -EINVAL;
 	}

-	pad = qpnp_get_desc(qctrl, gpio_desc->args[0]);
+	pad = qpnp_get_desc(qctrl, pin);
 	if (!pad)
 		return -EINVAL;

 	if (flags)
 		*flags = gpio_desc->args[1];

-	return gpio_desc->args[0];
+	return pin;
 }

Take care,
David Collins

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
