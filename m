Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3HEKd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:33:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14015 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3HEKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:33:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 05 Aug 2013 03:32:16 -0700
Message-ID: <1375698743.20259.9.camel@bilhuang-vm1>
Subject: Re: [PATCH v2 1/1] mfd: palmas: Add power off control
From: Bill Huang <bilhuang@nvidia.com>
To: Nishanth Menon <nm@ti.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Date: Mon, 5 Aug 2013 03:32:23 -0700
In-Reply-To: <51FBC49F.3060201@ti.com>
References: <1375255037-10024-1-git-send-email-bilhuang@nvidia.com>
	 <51F8FBC4.1040009@ti.com> <1375355332.32701.13.camel@bilhuang-vm1>
	 <20130801130857.GA3413@kahuna> <1375422317.32701.19.camel@bilhuang-vm1>
	 <51FBC49F.3060201@ti.com>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 22:39 +0800, Nishanth Menon wrote:
> On 08/02/2013 12:45 AM, Bill Huang wrote:
> > On Thu, 2013-08-01 at 21:08 +0800, Nishanth Menon wrote:
> >> On 04:08-20130801, Bill Huang wrote:
> >>> On Wed, 2013-07-31 at 19:57 +0800, Nishanth Menon wrote:
> >>>>
> >>>> If you notice the reference code I send, atleast on TWL6035/37 variants
> >>>> of Palmas, USB IRQ unmask is mandatory for power on with USB cable -
> >>>> example usage scenario: extremely low battery, device powered off, plug
> >>>> in usb cable to restart charging - you'd like to initiate charging logic
> >>>> in bootloader, but that wont work if the device does not do OFF-ON
> >>>> transition with usb cable plugged in for vbus.
> >>>>
> >>> Why do we need to add Palmas USB_IRQ unmask logic in shutdown? Does that
> >>> mean for all platform using Palmas has to unmask USB IRQ (including
> >>> those do not power vbus through Palmas)? Can't we just have a simple
> >>> shutdown function but have the VBus programming been done in USB driver
> >>> or maybe platform driver since it is platform specific control?
> >> we dont have a irq cleanup, irq handling is done in palmas-mfd. Further,
> >>
> >> Why would USB driver care about vbus supply needs in complete power off
> >> - it is the job of palmas driver? Further, palmas-mfd shutdown
> >> handler(currently missing) if probably cleansup things:
> >>
> >>   mfd_remove_devices(palmas->dev);
> >>    palmas_irq_exit(palmas);
> >>
> >> shutdown sequence becomes complicated further esp if things are
> >> cleanedup in shutdown (Dummy patch[1]).
> >>
> >>
> >> All I am saying is this: shutdown should allow powerup functionality to
> >> work as well, how we do that is upto us - I personally found it a little
> >> easier to keep the IRQ unmask in shutdown easier to deal with, but other
> >> options might be possible as well.
> >
> > I'm not sure if I understand your comments completely (maybe due to I'm
> > not familiar with the mechanism of unmasking USB IRQ in Palmas driver)
> 
> This is IMHO an weird configuration I saw on TWL6035/6037 Palmas device 
> - so I suspect should be the case in probably other palmas devices as 
> well. I hit power off, and I can start up the device again by supplying 
> vbus -(usecase was, at that point in time, battery charging)
> 
> anyways, I was working with busybox and no usb driver even enabled, but 
> I am told by the twl6035/7 support folks that due to design USB IRQ 
> needs to be unmasked at shutdown/poweroff to allow OFF->ON transition 
> sequence to start inside Palmas when vbus is supplied.
> 
> 
> > but doing cleanup in each driver shutdown handler makes sense to me, if
> > those clean up can be done in shutdown then we can make power off
> > function as simple as possible and being part of Palmas mfd driver?
> 
> not really, mfd shutdown does not guarantee rest of the drivers' 
> shutdown functions are safely called, pm_power_off unfortunately is the 
> only "official point" where we can safely and cleanly shutdown the system.
> 
It looks to me whether or not adding those extra control in a generic
Palmas driver is still in doubt, will you send your patch for this in
the near future? If not, any objection on making it as a basic and
simple power off control (that said, any further processing which has to
be in power off routine can be added on top of that, or can be moved to
be under drivers/reset if needed) using the existing mechanism?


