Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaCDP5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:57:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35046 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaCDP5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:57:19 -0500
Message-ID: <5315F7DB.6000700@wwwdotorg.org>
Date: Tue, 04 Mar 2014 08:57:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 1/5] genirq: define flag IRQ_SRC_DST_INVERTED, and
 accessors
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org> <alpine.DEB.2.02.1403041018370.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403041018370.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 03:04 AM, Thomas Gleixner wrote:
> On Mon, 3 Mar 2014, Stephen Warren wrote:
> 
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Some devices have configurable IRQ output polarities. Software might
>> use IRQ_TYPE_* to determine how to configure such a device's IRQ
>> output polarity in order to match how the IRQ controller input is
>> configured. If the board or SoC inverts the signal between the
>> device's IRQ output and controller's IRQ output, software must be
>> aware of this fact, in order to program the IRQ output to the correct
>> (i.e. opposite) polarity. This flag provides that information.
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

I don't see any such checking in drivers/irqchip/irq-gic.c; it rejects
any type other than IRQ_TYPE_LEVEL_HIGH or IRQ_TYPE_EDGE_RISING, and I
don't see any mention of TYPE_NONE in that file. Is the driver incomplete?

Instead of adding all this extra logic to the core, what do you think of
simply telling each driver that has a configurable interrupt output
polarity exactly which polarity to use. This information would come from
device tree or platform data. This is what I implemented in V1/V2 of
this series:

http://www.spinics.net/lists/devicetree/msg23648.html

Is that any better, or do you definitely want the IRQ core to manage this?
