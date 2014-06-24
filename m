Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaFXNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:09:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40277 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752596AbaFXNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:09:55 -0400
Date: Tue, 24 Jun 2014 14:09:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] drm/ttm: introduce dma cache sync helpers
Message-ID: <20140624130930.GN32514@n2100.arm.linux.org.uk>
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com> <1403603667-11302-3-git-send-email-acourbot@nvidia.com> <20140624100220.GK32514@n2100.arm.linux.org.uk> <53A953E6.2030503@nvidia.com> <53A95910.20104@nvidia.com> <CAAVeFu+rbCViC87kYCLfxGV18iYq=Pa0ABb+L=iNiYPLn+mR8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFu+rbCViC87kYCLfxGV18iYq=Pa0ABb+L=iNiYPLn+mR8Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 09:23:05PM +0900, Alexandre Courbot wrote:
> On Tue, Jun 24, 2014 at 7:55 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> > The only alternative I see here is to flush the CPU caches when syncing for
> > the device, and invalidate them for the other direction. Of course if the
> > device has caches on its side as well the opposite operation must also be
> > done for it. Guess the only way is to handle it all by ourselves here. :/
> 
> ... and it really sucks. Basically if we cannot use the DMA API here
> we will lose the convenience of having a portable API that does just
> the right thing for the underlying platform. Without it we would have
> to duplicate arm_iommu_sync_single_for_cpu/device() and we would only
> have support for ARM.
> 
> The usage of the DMA API that we are doing might be illegal, but in
> essence it does exactly what we need - at least for ARM. What are the
> alternatives?

It may seem /to you/ as a driver developer to be the easiest thing in
the world to abuse an API in a way that it's not supposed to be used,
and it is easy to do that.

However, what you're actually saying is that you don't respect your
fellow kernel developers who have to maintain the other side of that
interface.  When they need to change the implementation of that
interface, what if those changes then screw your abuse of that
interface.

The reason we define the behaviours and properties of APIs is to give
both the user and the implementer of the API some degree of latitude
in how that interface works, so that it can be maintained into the
future.  If abuses (such as these) are allowed, then we've lost,
because the interface can no longer be sanely maintained - especially
if driver authors eventually end up not caring about their pile of
abuse they've created after they've moved on to new wonderful hardware.

With an API such as the DMA API, where we have hundreds, if not a
thousand users of it, this /really/ matters.

We've been here before with the DMA API on older ARM platforms, where
we've had people abusing the API or going beneath the API because "it
does what they need it to", which then makes stuff much harder to change
at architecture level.

Last time it happened, it was when ARMv6 came along and ARM moved away
from VIVT caches.  The options were either to break the crap drivers
and support ARMv6+ CPUs, or keep the crap drivers working and not
support DMA in any shape or form on ARMv6+.

Obviously, this was too important to for one or two abusive drivers to
block, so I changed the architecture level /anyway/ and just said screw
the drivers which end up being broken by their short-sightedness, they
can either rot or someone else can fix them.

I have no beef for intentionally breaking stuff when people abuse well
defined interfaces and/or refuse to discuss their requirements when
interfaces don't quite do what they want - or worse, refuse to listen
to objections.

As I say, it's disrespectful to your fellow kernel developers to abuse
well defined interfaces.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
