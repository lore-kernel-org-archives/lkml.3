Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaBBSYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 13:24:00 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55316 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882AbaBBSX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 13:23:58 -0500
Date: Sun, 2 Feb 2014 18:23:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v5 00/23]
Message-ID: <20140202182349.GJ26684@n2100.arm.linux.org.uk>
References: <cover.1390986082.git.moinejf@free.fr> <20140202124358.GD26684@n2100.arm.linux.org.uk> <20140202190606.6fa193ce@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140202190606.6fa193ce@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 07:06:06PM +0100, Jean-Francois Moine wrote:
> On Sun, 2 Feb 2014 12:43:58 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Wed, Jan 29, 2014 at 10:01:22AM +0100, Jean-Francois Moine wrote:
> > > This patch set contains various extensions to the tda998x driver:
> > > 
> > > - simplify the i2c read/write
> > > - code cleanup and fix some small errors
> > > - use global constants
> > > - don't read write-only registers
> > > - add DT support
> > > - use IRQ for connection status and EDID read
> > 
> > I discussed these patches with Rob Clark recently, and the conclusion
> > we came to is that I'll merge them into a git tree, test them, and
> > once I'm happy I'll send a pull request as appropriate.
> > 
> > I'll go through them later today.  Those patches which have been re-
> > posted without any change for the last few times (the first few) I'll
> > take into my git tree today so you don't have to keep re-posting them
> > (more importantly, I won't have to keep on looking at them either.)
> 
> Thanks.
> 
> BTW, I found some problems with the patch 12 'add DT support' you
> already acked:
> 
> - the .of_match_table is not needed because the i2c client is created by
>   the i2c subsystem from the 'reg' in the DT,

Okay - may it be a good idea to have someone knowledgable of I2C give it
a review?

> - on encoder_destroy(), the function drm_i2c_encoder_destroy()
>   unregisters the i2c client, so, with a DT, a second encoder_init()
>   would crash.

I think this is one of the down-sides of trying to bolt DT into this:
the drm encoder slave support is not designed to cope with an i2c client
device pre-created.

In fact, I can't see how this stuff comes anywhere close to working in
a DT setup: in such a scenario, you declare that there's a tda998x
device in DT.  I2C parses this, and creates an i2c_client itself for
the tda998x.

When the TDA998x driver initialises, it finds this i2c client and
binds to it, calling tda998x_probe(), which does nothing.

However, the only way to attach a slave encoder to a DRM device is via
a call to drm_i2c_encoder_init(), which unconditionally calls
i2c_new_device().  This creates a _new_ i2c_client structure, again
unconditionally, for the tda998x.  This must be bound by the I2C
subsystem to a driver - hopefully the tda998x driver, which then
calls it's encoder_init function.

None of this will happen if DT has already created an i2c_client at
the appropriate address, because DRMs i2c_new_device() will fail.

My hypothesis is that you have other patches to I2C and/or DRM to
sort this out which you haven't been posting with this series.  So,
could you please provide some hints as to how this works?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
