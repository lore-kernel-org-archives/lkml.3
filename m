Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3IWVHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:07:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48793 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3IWVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:07:00 -0400
Message-ID: <5240AD6E.4090905@wwwdotorg.org>
Date: Mon, 23 Sep 2013 15:06:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maxime COQUELIN <maxime.coquelin@st.com>
CC: Wolfram Sang <wsa@the-dreams.de>, srinivas.kandagatla@st.com,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        stephen.gallimore@st.com, stuart.menefy@st.com,
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com,
        olivier.clergeaud@st.com
Subject: Re: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com> <1379498483-4236-2-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1379498483-4236-2-git-send-email-maxime.coquelin@st.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 04:01 AM, Maxime COQUELIN wrote:
> This patch adds support to SSC (Synchronous Serial Controller)
> I2C driver. This IP also supports SPI protocol, but this is not
> the aim of this driver.
> 
> This IP is embedded in all ST SoCs for Set-top box platorms, and
> supports I2C Standard and Fast modes.

> diff --git a/Documentation/devicetree/bindings/i2c/i2c-st.txt b/Documentation/devicetree/bindings/i2c/i2c-st.txt

> +I2C for ST platforms

If the HW block supports both I2C and SPI, the DT binding ought to
support that too. It's be best to create a single DT binding that
represents the IP block, and include a property that indicates whether
the device should operate in I2C or SPI mode.

I suppose you could reasonably define different compatible values for
those two cases. However, the binding should be titled something more
like "ST SSC binding, for I2C mode operation" and "ST SSC binding, for
SPI mode operation", rather than "I2C for ST platforms", since the HW
includes an SSC block, not an I2C block.

> +Required properties :
> +- compatible : Must be "st,comms-i2c"
> +- reg : Offset and length of the register set for the device
> +- interrupts : the interrupt number

It's an interrupt specifier, not an interrupt number. The format is
defined by the interrupt controller, not this binding.

> +- clocks : phandle to the I2C clock source

What about clock-names?

> +Recommended (non-standard) properties :

Usually you'd just say "Optional properties:", or perhaps "Recommended
properties:". I don't think adding "(non-standard)" serves any purpose.

> +- clock-frequency : Desired I2C bus clock frequency in Hz. Otherwise
> +  the default 100 kHz frequency will be used. As only Normal and Fast modes
> +  are supported, possible values are 100000 and 400000.
> +
> +Optional (non-standard) properties:

Same here.

> +- st,glitches : Enable timing glitch suppression support.

That property name doesn't really convey the "enables" that appears in
the property description to me...

> +- st,glitch-clk : SCL line timinig glitch suppression value in ns.
> +- st,glitch-dat : SDA line timinig glitch suppression value in ns.

s/timinig/timing/

> +- st,hw-glitches : Enable filter glitch suppression support.
> +- st,hw-glitch-clk : SCL line filter glitch suppression value in us.
> +- st,hw-glitch-dat : SDA line filter glitch suppression value in us.

Those sound more like runtime configuration rather than HW description.
Can you rephrase the descriptions (and property names) more along the
lines of HW properties? Perhaps e.g.:

st,needs-glitch-suppression: The board design needs timing glitch
suppression enabled to operate reliably.

st,min-scl-pulse-width: The minimum valid SCL pulse width that is
allowed through the deglitch circuit. In units of ns.

(I just made up those descriptions to give a feel for the flavor of
description that I expect. They likely need some adjustment to reflect
whatever they're actually intended to represent in HW).

What is the difference between "glitch" and "hw-glitch"?

