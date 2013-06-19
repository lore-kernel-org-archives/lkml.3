Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702Ab3FSK6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:58:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:8929 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011Ab3FSK6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,896,1363158000"; 
   d="scan'208";a="332069179"
Date: Wed, 19 Jun 2013 14:02:44 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
 runtime suspended
Message-ID: <20130619110244.GH11878@intel.com>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
 <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130618180948.GP1403@sirena.org.uk>
 <20130619092508.GJ2718@n2100.arm.linux.org.uk>
 <20130619093938.GT1403@sirena.org.uk>
 <20130619100515.GK2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619100515.GK2718@n2100.arm.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:05:15AM +0100, Russell King - ARM Linux wrote:
> On Wed, Jun 19, 2013 at 10:39:38AM +0100, Mark Brown wrote:
> > On Wed, Jun 19, 2013 at 10:25:08AM +0100, Russell King - ARM Linux wrote:
> > > On Tue, Jun 18, 2013 at 07:09:48PM +0100, Mark Brown wrote:
> > 
> > > > This sounds like a problem which will affect a lot of devices and hence
> > > > ought to be handled better by the PM core or at least frameworks in
> > > > general.  Is it really device specific?
> > 
> > > It's always been something that has been recommended to be dealt with
> > > by the driver.  If reading the interrupt status you read ~0, then it
> > > likely is because the device is powered down or removed from the system.
> > 
> > > PCMCIA drivers have done this for years.
> > 
> > I know, some PCI devices too.  It's not just an issue for memory mapped
> > devices, the same thing happens with devices on other buses - there's a
> > whole bunch of issues around moving out of the various suspend states
> > and getting interrupts (things like getting an interrupt controller
> > waking up and delivering interrupts before the control bus for a device
> > connected to it has woken up).  
> > 
> > The driver does need to be the one deciding what to do about being in
> > suspend but we really ought to be able to do something without having to
> > interact with the hardware partly just for neatness but more because on
> > general buses the error handling is too painful.
> 
> And that's why doing it by "read the ISR and check its value" is the
> best way, and not doing the "what state does the kernel think this
> device is in".

This sounds the simplest thing that solves the problem with the Lynxpoint
SPI controller driver. Then I don't need to add any new flags to the
private structure but just check that if reading the status register
returns ~0 and bail out in that case.
