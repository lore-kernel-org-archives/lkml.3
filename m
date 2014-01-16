Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaAPL6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:58:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:59268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaAPL6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:58:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="439773447"
Date: Thu, 16 Jan 2014 13:58:10 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/5] arm: omap3: twl: use the new lookup method with usb
 phy
Message-ID: <20140116115810.GC11732@xps8300>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com>
 <52AEDE43.8030005@ti.com>
 <20131216144314.GB22944@xps8300>
 <52CBFAC0.9040103@ti.com>
 <20140114143849.GB21169@xps8300>
 <52D6972B.2030704@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D6972B.2030704@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:41:55PM +0530, Kishon Vijay Abraham I wrote:
> The point I'm trying to make is that we won't 'always' know the device names in
> advance.

In which cases do we not know the device names, and please note, cases
where we would need to use the lookup? The normal cases we would use
it are..

1) A driver creating a child device, like dwc3 when it creates the
xhci. There the parent just delivers the phys it has to the child, so
both the device name and the phys are known.

2) Platform code. Hopefully we can get rid of the platform code one
day, but in any case, when we use it, we always know at least how many
users a phy has, and if there is only a singe user, we can rely con_id
to do the matching. Though I still don't really see much risk in using
the controller device name also there. The lookup table should in any
case be made in the place where the phy devices are created, so the
phy name is definitely always known.

3) Phys part of something like mfd. This is in practice the same as
the platform code case. For example, with twl we always know there is
only one user for the phy, which is musb. So we can just use musb's
con_id if it's to scary to use "musb-hdrc.0".

In any other case, you get the phy from DT, and there is no need to
use the lookup when linking the phys and the users.

> Btw how are you planning to differentiate between multiple controllers of the
> same type with con_id?

You don't rely on the con_id alone in those cases. You then use the
device name. The con_id is just one parameter you can use to do the
matching.

> Maybe I'm missing the actual intention of this patch. Do you face problem if
> the PHY's have to know about it's consumers in ACPI?

<snip>

> >> I would rather leave the way it is modelled now.
> > 
> > Do you mean, leave it in the platform code? Why? We would reduce the
> > platform code by moving it to the mfd driver. Or did I misunderstood
> > something?
> 
> In this case, the lookup table will be used only for non-dt boot so don't see
> much use in moving to mfd driver.
> I meant if the new method is not solving any problem then I would prefer the
> way it is modelled now where the PHY's know about it's consumers.

OK, so that's what you meant. Things like that init_data promotes use
of platform data in the drivers, something that we really should get
rid of. Is that not a problem to you?

The phy drivers simply should not need to care about the consumers.
They should not need to care about anything DT, ACPI, platform
specific if it's possible, and here there is nothing preventing it.
Let me clarify..

The plan is that ultimately the drivers (meaning all the drivers, not
just phy) don't need to care about things like DT properties, ACPI
properties or anything DT, ACPI, platform specific. We will have
generic driver properties and capabilities and the upper layers will
take care of delivering the correct values from the source at hand.
The drivers can be made truly platform agnostic.

That is the goal, and we should make everything new by keeping that in
mind. Many existing frameworks are being converted to that direction,
like the gpio framework and DMA Engine API. The way you force the phy
drivers the deliver the consumers is taking a step backwards.

> Btw where does device gets created in ACPI boot?

drivers/acpi/acpi_platform.c

Thanks,

-- 
heikki
