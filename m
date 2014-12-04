Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaLDKKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:10:21 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37038 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753340AbaLDKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:10:18 -0500
Date: Thu, 4 Dec 2014 10:09:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Andy Yan <andy.yan@rock-chips.com>, airlied@linux.ie, heiko@sntech.de,
        fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        vladimir_zapolskiy@mentor.com, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v16 03/12] drm: imx: imx-hdmi: convert imx-hdmi to
 drm_bridge mode
Message-ID: <20141204100927.GL11285@n2100.arm.linux.org.uk>
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com>
 <1417620566-30496-1-git-send-email-andy.yan@rock-chips.com>
 <20141203153847.GC11285@n2100.arm.linux.org.uk>
 <547F3495.9070206@rock-chips.com>
 <1417623615.5124.19.camel@pengutronix.de>
 <20141203163009.GG11285@n2100.arm.linux.org.uk>
 <1417682410.3744.1.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417682410.3744.1.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 09:40:10AM +0100, Philipp Zabel wrote:
> You are right, no I don't want this. When I initially wrote this patch I
> was under the impression that the memory allocated by devm_kzalloc in
> bind() wouldn't be freed on unbind().

Resources claimed inside bind() will be freed in unbind().  Resources
claimed in the driver's probe() will be freed in driver's remove().

They nest, and each is properly dealt with at the appropriate time due
to...

> I remember I stopped pursuing this
> patch when I got aware of the devres_open/close/remove_group dance in
> the component framework code, but somehow forgot to drop it altogether
> locally.

... the use of devres grouping.

So, if you use devm_kzalloc() in the driver's probe() function, then
that memory will be freed after the driver's remove() function is
called.  That's fine.

The point I was making is:

probe()
  mem = devm_kzalloc();
  mem->mmio = ...;
...
bind()
  mem->mmio is set
  other members of mem are zero
...
unbind()
...
bind()
  mem->mmio is set
  other members of mem are indeterminant
...
unbind()
...
remove()
  mem will be freed automatically

That's where the problem happens - the second time the bind() function
gets called: you might as well not use devm_k*z*alloc() initially,
because having the structure initialised to zero _could_ very well
hide bugs.

When you consider that it's not just the driver code which you have
to audit, but also any code the driver calls (eg, because you've embedded
some subsystem's struct in your driver private data) it quickly becomes
very easy for a bug to creep in here.

If we want to go down the route of having the probe function deal with
resources etc, then I would recommend against using devm_kzalloc() to
allocate the private structure: use devm_kmalloc() instead, which will
leave the memory uninitialised.  That means you get the same condition
on each bind(), which means you have to think more about how to ensure
that the initial state of members is dealt with throughout your driver.

Alternatively, separate the struct into two sections: one which contains
everything initialised by the probe() function, and everything else, and
arrange for everything else to get memset() on entry to bind().

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
