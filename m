Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3GXQIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:08:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57646 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab3GXQIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:08:45 -0400
Message-ID: <51EFFBE1.4090505@ti.com>
Date: Wed, 24 Jul 2013 11:08:01 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Sricharan R <r.sricharan@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com> <1374165830-6367-2-git-send-email-r.sricharan@ti.com> <51E83A4F.5080904@ti.com> <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com> <51ED2385.60108@ti.com> <51ED5C66.1010407@ti.com>
In-Reply-To: <51ED5C66.1010407@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 11:23 AM, Santosh Shilimkar wrote:
> To summaries it again, what I understood from Sricharan's proposal,
>
> - Setup all the routing at cross-bar probe so that kernel continue to
> work like normal IRQ controller with cross-bar scope vanishes once
> the routing is done. Cross-bar does this before any of the devices
> are created.
> - Something similar needs to happen for DMA lines as well or for any
> other event routing in future.
> - Cross-bar callbacks for device drivers for error paths.
> (Sricharan, you have to drop these because it doesn't bring any
> functionality and rather can create a side effects of drivers
> getting polluted.)
Ack.

>
> The concern raised on above was instead of fixing the routing at DT
> statically, doing at the driver probes where the loop-up for IRQ or DMA
> lines should happen in background transparently on drivers call of
> request_irq/request_dma_channel etc with cross-bar number as
> an input to it. Though it will be nice to have
> such feature, it doesn't bring anything special and brings the
> notion of these APIs which expect that you know what IRQ and DMA
> lines you want while calling these.
Unfortunately, we do have a constraint without allocating dynamic IRQs - 
what IP instances should hwmod and dts contain?

If we go with current series of patches[1] [2] for DRA7 dts which 
assumes default mapping, hence, uart7-10, GPTimers12-16 dont have 
default irq - hence they dont exist in dts etc.

How would we like to support those with pinctrl approach?

>
> Note that mux inputs are pretty much fixed. Its his connection
> to IRQ controller or DMA controller is what needs to be programmed.
> So scope is pretty much limited. I felt this requirement is pretty
> similar to pin-mux and hence thought of it as a viable option.
>
> Having said all of above, if there is a better alternative than
> enhanced pin-mux we surely can do that.
We could look at it as a signal mux problem as this thread suggests OR 
look at it as interrupt distribution problem (which is how it looks like 
at the face of it). That said, maybe a intermediate pinctrl approach 
might be more pragmatic and less theoretically flexible.
an option might be to "statically allocate" default number of interrupts 
to a domain - example:
* GIC IRQ 72->78 allotted to UARTs
* pinctrl mapping provided for those but only 6 can be used (rest are 
marked status="disabled" as default) at any given time (choice of 
pinctrl option determines GIC interrupt line to use)
* All modules will have a pinctrl definition to have a mapping - to 
avoid bootloader overriding default cross bar setting in ways 
un-expected by kernel.

Does that sound fair trade off?

[1] http://marc.info/?l=linux-omap&m=137335524702155&w=2
[2] http://marc.info/?l=linux-omap&m=137335522802144&w=2
-- 
Regards,
Nishanth Menon
