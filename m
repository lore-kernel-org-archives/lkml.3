Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946287Ab3BHLHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:07:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:33012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946248Ab3BHLHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:07:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="200062948"
Date: Fri, 8 Feb 2013 12:07:16 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "lkml," <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: gpio-sch GPIO_SYSFS access
Message-ID: <20130208110716.GN5072@sortiz-mobl>
References: <5112FC44.2000303@linux.intel.com>
 <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com>
 <511481A2.7010100@linux.intel.com>
 <5114A453.8000408@linux.intel.com>
 <20130208084916.GM5072@sortiz-mobl>
 <5114D520.1080305@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5114D520.1080305@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 02:36:16AM -0800, Darren Hart wrote:
> On 02/08/2013 12:49 AM, Samuel Ortiz wrote:
> >> Well, this happens when the driver in question gets removed by another
> >> driver. 
> > removed by another driver ? I'm not sure I understand what that means.
> 
> In my case, the gpio-sch probe function runs and creates the gpiochip
> with 14 GPIO lines. Later lpc-sch probe runs, 
That's weird: The lpc-sch probe should run first. Then the gpio-sch probe
should be called when lpc-sch adds the MFD cells as platform devices, from
lpc_sch_probe().
So someone is adding gpio-sch as a platform device, and that is wrong.

> adds devices to the mfd
> device list, fails the WDT base address as described below, and then
> removes the devices in the mfd device list, which triggers the removal
> of the gpio-sch device.
> 
> If I just skip the WDT lookup and not abort, then things work as I had
> expected. Sooo... does it make sense to remove ALL the MFD device when
> the read of the WDTBA registers indicates "Disabled"? Seems extreme to me.
Yes, that's a bit rough. But I think you have a more fundamental problem where
you're probing both LPC and your GPIO driver.

> >> Samuel, does it make sense for CONFIG_GPIO_SCH to require
> >> CONFIG_LPC_SCH? I'm building for a Queensbay (Atom E6xx + EG20T PCH).
> >> There is no SCH as I understand things. Can these be decoupled?
> > They actually don't have code dependency, GPIO_SCH selects LPC_SCH beacause
> > the MFD parts actually creates the GPIO device.
> > So you're saying Queensbay use the same GPIO IP block without actually having
> > SCH ?
> 
> That is how I currently understand it. These drivers appear to have been
> originaly written for the Silverthorne (Z5xx) CPUs and the Intel SCH
> chipset.
If your lpc_sch_probe routine runs, you basically have an LPC on your PCI bus
here. As I said, PCI probes lpc_sch _and_ gpio_sch is probed as well (As a
platform device, probably coming from your SFI tables or so). Probing both is
problematic, especially since you do have an LPC sitting on your PCI bus.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
