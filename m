Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaKDTed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:34:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:36404 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbaKDTeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:34:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411371414"
Date: Tue, 4 Nov 2014 21:34:24 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, mathias.nyman@linux.intel.com
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141104193424.GT1618@lahna.fi.intel.com>
References: <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
 <20141103154207.GC1618@lahna.fi.intel.com>
 <20141103155011.GH27425@saruman>
 <20141103184247.GD1618@lahna.fi.intel.com>
 <20141103221903.GA20305@psi-dev26.jf.intel.com>
 <20141104075936.GF1618@lahna.fi.intel.com>
 <20141104180526.GB2224@psi-dev26.jf.intel.com>
 <20141104185702.GR1618@lahna.fi.intel.com>
 <20141104191115.GC2224@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104191115.GC2224@psi-dev26.jf.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:11:16AM -0800, David Cohen wrote:
> > It is not implicit at all.
> > 
> > The user of the GPIO in ACPI DSDT table says something like:
> > 
> > 	Name (_DEP, Package () { \_SB.GPO2 })
> > 
> > or similar. That is *explicit* dependency. Here \_SB.GPO2 is one of the
> > GPIO banks.
> 
> Either kernel knows on-the-fly or statically the required dependency.
> The static dependency is well described by Kconfig. An on-the-fly
> dependency could be a probe execution failing because it couldn't access
> part of required resources. If the dependency is temporarily not
> described this way, it would still be acceptable a documentation
> somewhere explaining that we do have this hidden thing going on.

The only thing kernel knows about this is when it finds that the
device in question has _DEP object. Once that happens and it evaluates
to a list of devices we depend on, we can defer this particular driver
going further in probe until all the dependencies listed in _DEP are
resolved.

The documentation you are after is ACPI 5.1 specification downloadable
freely at uefi.org/acpi.

> > > But IMHO all dependency to a driver should be explicitly described
> > > (e.g. on Kconfigs, or maybe failing probe). With current situation if we
> > > do not select pinctrl_baytrail, instead of affecting just the drivers
> > > that explicitly depend on that, it affects others which we are unable to
> > > easily identify.
> > 
> > So how do you propose we describe the dependency? It is completely in
> > firmware. Should we make i2c-hid.c dependent on pinctrl-baytrail.c just
> > because some underlying firmware method (_PSx for example) needs the
> > GPIO but the driver itself does not?
> 
> i2c-hid.c should fail, WARN, yell, scream or whatever :)
> This way one could say: hey, we needed GPIO.

But i2c-hid.c does not know anything about GPIOS in the first place.
Like I said the dependency is in the firmware level. It may need GPIOs
to do something or not but the driver never sees those GPIOs.
