Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaA1Pcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:32:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:18754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbaA1Pcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:32:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,736,1384329600"; 
   d="scan'208";a="473801205"
Date: Tue, 28 Jan 2014 17:32:30 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, george.cherian@ti.com,
        rogerq@ti.com, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
Message-ID: <20140128153230.GA20991@xps8300>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1390299099-14764-1-git-send-email-kishon@ti.com>
 <20140121144725.GF30451@saruman.home>
 <20140127150855.GA17928@xps8300>
 <20140127160458.GF13268@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127160458.GF13268@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 27, 2014 at 10:05:20AM -0600, Felipe Balbi wrote:
> > Why would you need to know if the PHY drivers are needed or not
> > explicitly in your controller driver?
> 
> because, one way or another, they all do need it. Except for quirky ones
> like AM437x where a USB3 IP was hardwired into USB2-only mode, so it
> really lacks a USB3 PHY.

The Baytrail board I deal with has completely autonomous PHYs. But my
question is, why would you need to care about the PHYs in your
controller driver? Why can't you leave the responsibility of them to
the upper layers and trust what they tell you?

If there is no USB3 PHY for dwc3 then, the driver gets something like
-ENODEV and just continues. There is no need to know about the
details.

For the controller drivers the PHYs are just a resource like any
other. The controller drivers can't have any responsibility of
them. They should not care if PHY drivers are available for them or
not, or even if the PHY framework is available or not.

> > > But I really want to see the argument against using no-op. As far as I
> > > could see, everybody needs a PHY driver one way or another, some
> > > platforms just haven't sent any PHY driver upstream and have their own
> > > hacked up solution to avoid using the PHY layer.
> > 
> > Not true in our case. Platforms using Intel's SoCs and chip sets may
> > or may not have controllable USB PHY. Quite often they don't. The
> > Baytrails have usually ULPI PHY for USB2, but that does not mean they
> > provide any vendor specific functions or any need for a driver in any
> > case.
> 
> that's different from what I heard.

I don't know where you got that impression, but it's not true. The
Baytrail SoCs for example don't have internal USB PHYs, which means
the manufacturers using it can select what they want. So we have
boards where PHY driver(s) is needed and boards where it isn't.

The problem is that we just don't always know all the details about
the platform. If the PHY is ULPI PHY, we can do runtime detection, but
we can't even rely on always having ULPI.

> > Are we talking about the old USB PHY library or the new PHY framework
> > with the no-op PHY driver?
> > 
> > Well, in any case, I don't understand what is the purpose of the no-op
> > PHY driver. What are you drying to achieve with that?
> 
> I'm trying to avoid supporting 500 different combinations for a single
> driver. We already support old USB PHY layer and generic PHY layer, now
> they both need to be made optional.

This is really good to get. We have some projects where we are dealing
with more embedded environments, like IVI, where the kernel should be
stripped of everything useless. Since the PHYs are autonomous, we
should be able to disable the PHY libraries/frameworks.

But I still don't understand what is the benefit in the no-op? You
really need to explain this. What you have now in dwc3 is expectations
regarding the PHY, which put a lot of pressure on upper layers to
satisfy the driver. The no-op is just an extra thing that you have to
provide when you fail to determine if the system requires a PHY driver
or not, or if you know that it doesn't, plus an additional check for
the case where the PHY lib/framework is not enabled. I don't see the
value in it.

> The old USB PHY layer also provides
> a no-op, now called phy-generic, which is actually pretty useful.
> 
> On top of all that, I'm sure you'll subscribe to the idea of preventing
> dwc3 from becoming another MUSB which supports several different
> configurations and none work correctly. I much prefer to take baby steps
> which are well thought-out and very well exercised, so I'll be very
> pedantic about proof of testing.

I think our goals are the same. I just want to also minimize the need
for any platform specific extra work from the upper layers regarding
the PHYs.


Thanks,

-- 
heikki
