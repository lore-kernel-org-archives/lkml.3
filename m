Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbbA1Up6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:45:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:5071 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761884AbbA1Up4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:45:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,481,1418112000"; 
   d="scan'208";a="677408915"
Date: Wed, 28 Jan 2015 16:20:25 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Message-ID: <20150128142024.GA2378@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
 <20150124235811.GA24665@psi-dev26.jf.intel.com>
 <20150126125503.GB28539@kuha.fi.intel.com>
 <20150126192337.GA13936@psi-dev26.jf.intel.com>
 <20150127092856.GD28539@kuha.fi.intel.com>
 <20150127173801.GA8441@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127173801.GA8441@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > Can you share how tusb1210 is connected on the platform you're using as
> > > test for this patch? I don't think this driver would work reliably with
> > > this device:
> > > http://liliputing.com/2014/11/trekstor-launches-first-android-tablet-based-intels-irda-reference-design.html
> > 
> > The only reason why that board doesn't work is because of very much
> > Baytrail-CR specific problems. These are are two issues, but the first
> 
> That's not BYT-CR specific problems. That's just dwc3 and tusb1210
> interacting as they're expecting to.
> 
> > one is critical for getting it working. Both will be handled, but
> > separately from this set:
> > 
> > 1) The firmware leaves the PHY in reset, forcing us to enable it
> > somehow in OS before accessing ulpi. Unless we can get a firmware fix
> > for that (it's starting to look like it's not going to happen; please
> > correct me if you know something else!), we need to add a quirk for
> > Baytrails (attached), which is probable still OK. But IMO this really
> > should be fixed in the firmware.
> 
> It seems you're expecting the PHY to be fully operational in order to
> probe it. That's wrong assumption. BYT-CR's BIOS is doing nothing wrong
> by leaving PHY on reset state.

But it is. If we want to use ULPI as a bus like we do, then the PHY
will be no different then devices attached to many other buses. We
have made firmware fixes like that before. All the devices need to be
in a state, operational enough after bootup, so we can probe them in
OS without the need for hacks where they are separately enabled before
it's possible.

> The real problem is what I stated above.
> With your current logic, you'll get stuck with checking/egg problem: you
> need phy probed to probe dwc3, but need dwc3 probed to power on phy.
> You need a logic to break this circular dependency.

The moment we register the ulpi interface with the ulpi bus in
dwc3_probe(), we know dwc3 has it's PHY interface in operational mode
and register access to ULPI PHY is possible. And that is all dwc3
needs to/can do.

I don't think you are seeing the whole "ulpi bus" in these patches,
but in any case; Like I said, this problem is purely BYT-CR specific,
which IMO really should be fixed in the firmware.

> > 2) Since the gpio resources are given to the controller device in ACPI
> > tables and there isn't separate device object for the PHY at all, we
> > need to deliver the gpios somehow separately to the phy driver. There
> > is a thread where we are talking about how to do that:
> > https://lkml.org/lkml/2014/12/18/82
> 
> How about just leave the logic the way it is:
> dwc3-pci.c registers platform_device with gpio as resource if the GPIOs
> are provided to dwc3. If not, then dwc3-pci.c will expect phy to have
> its own ACPI id.

I think you are now talking about the platform devices for the legacy
USB PHY framework created in dwc3-pci.c, which btw. were removed.
Please note that we are not using platform bus with the ULPI devices,
and those devices are created by the bus driver and not dwc3.

I'm pretty sure now that you are not seeing the whole point with this
set, which is to provide new bus type for ULPI. If so, then could you
please review the whole series.


Thanks,

-- 
heikki
