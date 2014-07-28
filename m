Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaG1Ij6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:39:58 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42298 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaG1Ij4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:39:56 -0400
Message-ID: <1406536774.2475.36.camel@iivanov-dev>
Subject: Re: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Mon, 28 Jul 2014 11:39:34 +0300
In-Reply-To: <53D307BB.1020208@codeaurora.org>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
	 <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
	 <53D307BB.1020208@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 18:43 -0700, David Collins wrote:
> On 07/17/2014 08:25 AM, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> > Qualcomm GPIO and MPP sub-function blocks found in the PMIC chips.
> > QPNP_REG_STATUS1_GPIO_EN_REV0_MASK
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> (...)
> > +static int qpnp_conv_to_pin(struct qpnp_pinctrl *qctrl,
> > +			   struct qpnp_padinfo *pad, unsigned param,
> > +			   unsigned val)
> (...)
> > +	switch (param) {
> (...)
> > +	case PIN_CONFIG_OUTPUT:
> > +		nattrs = 3;
> > +		attr[0].addr  = QPNP_REG_MODE_CTL;
> > +		attr[0].shift = QPNP_REG_OUT_SRC_SEL_SHIFT;
> > +		attr[0].mask  = QPNP_REG_OUT_SRC_SEL_MASK;
> > +		attr[0].val   = !!val;
> 
> It seems that this patch provides no means to configure the output source
> select bits to be anything besides 0 (constant low) or 1 (constant high).
>  Some non-generic property is needed to configure this for both GPIOs and
> MPPs.  Passing the value in via the output-high property does not seem
> like a good approach since that is a generic pin config property that is
> defined to take no value. 

True.

>  The special functions available for GPIOs (e.g.
> PWM/LPG, clock, keypad, etc.) which are configured via this register are
> used by many boards.

I was not sure what those features are and how to connect the numbers to
the function, which is why I have restricted the values ​​of 0 and 1.

> 
> Something else to consider is that QPNP_REG_OUT_SRC_SEL_MASK is being
> defined as 0xf which would imply that there are 16 possible output source
> select options.  While technically true, this makes the situation more
> complicated since half of those options are the inverted version of the
> other half.  In the GPIO hardware this corresponds to an 8-way mux
> followed by an XOR gate to conditionally invert the mux output.  If output
> source select is handled this way, then the following values would need to
> be supported in device tree for GPIOs:
> 	* 0:  constant low (already supported via output-low;)
> 	* 1:  constant high (already supported via output-high;)
> 	* 2:  paired GPIO
> 	* 3:  inverted paired GPIO
> 	* 4:  special function 1
> 	* 5:  inverted special function 1
> 	* 6:  special function 2
> 	* 7:  inverted special function 2
> 	* 8:  dtest1
> 	* 9:  inverted dtest1
> 	* 10: dtest2
> 	* 11: inverted dtest2
> 	* 12: dtest3
> 	* 13: inverted dtest3
> 	* 14: dtest4
> 	* 15: inverted dtest4
> The same options are supported by MPPs except for special function 1,
> inverted special function 1, special function 2, and inverted special
> function 2.

<snip>

I am working on proposal from Stephen Boyd to encode GPIO/MPP mode and 
source select into combined function. Something like this one:

#define PM8XXX_DIGITAL_IN		0
#define PM8XXX_DIGITAL_OUT		1
#define PM8XXX_DIGITAL_IN_OUT		2

...

/* mode and source select */
#define PM8XXX_FUNCTION(m,s)		((m) << 16 | (s))

#define PM8921_GPIO1_14_KYPD_SNS	PM8XXX_FUNCTION(PM8XXX_DIGITAL_IN, 1)
#define PM8921_GPIO9_14_KYPD_DRV	PM8XXX_FUNCTION(PM8XXX_DIGITAL_OUT, 1)
#define PM8921_GPIO33_35_PWM		PM8XXX_FUNCTION(PM8XXX_DIGITAL_OUT, 3)

..

<snip>

> There is an off-by-one issue with the indexing between the hardware GPIO
> numbers (1-based) and the gpiolib gpio offsets (0-based).  Do you agree
> that the indexing used within the device tree gpiospecs should match the
> hardware numbering scheme?  I feel like this would be much less confusing
> for users to work with.  


Yep, will fix it. Thank you for review.

Regards,
Ivan


