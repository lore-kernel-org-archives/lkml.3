Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaDRV66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:58:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42370 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaDRV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:58:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/3Rp9oRzbq2rPE4DK93duD
Date: Fri, 18 Apr 2014 14:58:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
Message-ID: <20140418215848.GD21823@atomide.com>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
 <1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
 <1395413185-29763-3-git-send-email-jjhiblot@traphandler.com>
 <CAL_Jsq+aU+rs28gV=Gesb_-Dy6Ht7zuKrRA6_hmqp94Uun23Yg@mail.gmail.com>
 <20140418205213.GA21823@atomide.com>
 <CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rob Herring <robherring2@gmail.com> [140418 14:39]:
> On Fri, Apr 18, 2014 at 3:52 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Rob Herring <robherring2@gmail.com> [140411 10:33]:
> >> On Fri, Mar 21, 2014 at 9:46 AM, Jean-Jacques Hiblot
> >> <jjhiblot@traphandler.com> wrote:
> >> > The goal of this patch is to allow drivers to be probed even if at the time of
> >> > the DT parsing some of their IRQ ressources are not available yet.
> >> >
> >> > In the current situation, the IRQ resources of a platform device are filled from
> >> > the DT at the time the device is created (of_device_alloc()). The drawback of
> >> > this is that a device sitting close to the top of the DT (ahb for example) but
> >> > depending on ressources that are initialized later (IRQ domain dynamically
> >> > created for example) will fail to probe because the ressources don't exist
> >> > at this time.
> >>
> >> s/ressources/resources/
> >
> > While I've tested these two patches and they fix the issue for me. I have
> > some serious doubts again about this whole ------ up string parsing
> > pile of ---- called device tree.
> >
> > Do we really need to sprinkle more of_* hacks to the irq subsystem?
> >
> > There's nothing wrong with with the irq subsystem. Platform bus is just
> > calling the irq subsystem at the wrong time with uninitialized data.
> 
> This patch doesn't even touch the irq subsystem.

Heh, it depends on the previous patch in this series adding another
of_blah_blah function to drivers/of/irq.c.
 
> > It seems that we're again papering over the fact that there's nothing
> > coordinating the setting up of various resources with device tree.
> > That seems to be the repeating never ending pattern as we've already
> > seen with GPIOs, pinctrl, and IRQchips. We end up adding all kinds of
> > cross subsystem calls that were never needed earlier.
> 
> This problem may be made worse with DT, but this problem has existed
> for as long as I have worked on the kernel. It is worse with DT since
> platforms have less control over the init ordering and loose some
> ability to do tricks like changing the initcall levels. We didn't even
> try to do pinctrl in any generic way before DT.

Oh come on, let's stop pretending it's not broken. And it's way worse with
device tree as there's nothing making sure the resources for a driver
are set up before the driver probes. And we've been unable to fix just
this issue alone for about six months now. It's also broken beyond that.
It's called of_platform_bus yet it won't even pass the platform_data
as auxdata to the devices on a sub-bus instantatiated like I2C.

Regards,

Tony


