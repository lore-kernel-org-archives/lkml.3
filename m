Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbaCDKeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:34:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:60366 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbaCDKeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:34:15 -0500
Date: Tue, 4 Mar 2014 11:34:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 1/5] genirq: define flag IRQ_SRC_DST_INVERTED, and
 accessors
In-Reply-To: <alpine.DEB.2.02.1403041018370.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1403041130280.18573@ionos.tec.linutronix.de>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org> <alpine.DEB.2.02.1403041018370.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Thomas Gleixner wrote:

> On Mon, 3 Mar 2014, Stephen Warren wrote:
> 
> > From: Stephen Warren <swarren@nvidia.com>
> > 
> > Some devices have configurable IRQ output polarities. Software might
> > use IRQ_TYPE_* to determine how to configure such a device's IRQ
> > output polarity in order to match how the IRQ controller input is
> > configured. If the board or SoC inverts the signal between the
> > device's IRQ output and controller's IRQ output, software must be
> > aware of this fact, in order to program the IRQ output to the correct
> > (i.e. opposite) polarity. This flag provides that information.
> 
> So what you're saying is:
> 
> Device IRQ output --> [Optional Inverter Logic] --> IRQ controller input.
> 
> And you're storing the information about the presence of the inverter
> logic in the irq itself, but the core does not make any use of it and
> you let the device driver deal with the outcome.
> 
> This sucks as all affected drivers have to implement the same sanity
> logic for this.
> 
> Why don't you implement a core function which tells the driver which
> polarity to select? That requires a few more changes, but I think it's
> worth it for other reasons.
> 
> Right now the set_type logic requires the irq chip drivers to
> implement sanity checking and default selections for TYPE_NONE. We can
> be more clever about that and add this information to the irq chip
> flags.
> 
> enum {
>      IRQ_CHIP_TYPES_MASK	= 0x0f,
>      IRQ_CHIP_DEFAULT_MASK	= 0xf0,
>      IRQ_CHIP_EXISTING_FLAGS	....
> }

We need to extend the mask to indicate whether the chip supports
BOTH_EDGES. A chip can support FALLING and RISING, but not both at the
same time. For the set_type side the current BOTH = FALLING | RISING
is fine, but for checking the supported type it's not sufficient.

Thanks,

	tglx


