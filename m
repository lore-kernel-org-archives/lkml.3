Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaDQWFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:05:00 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39022 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983AbaDQWE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:04:58 -0400
Date: Thu, 17 Apr 2014 23:04:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for
	components tracking
Message-ID: <20140417220412.GZ24070@n2100.arm.linux.org.uk>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com> <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:28:50PM +0200, Andrzej Hajda wrote:
> +static int exynos_drm_add_blocker(struct device *dev, void *data)
> +{
> +	struct device_driver *drv = data;
> +
> +	if (!platform_bus_type.match(dev, drv))
> +		return 0;
> +
> +	device_lock(dev);
> +	if (!dev->driver)
> +		exynos_drm_dev_busy(dev);
> +	device_unlock(dev);
> +
> +	return 0;
> +}
> +
> +static void exynos_drm_init_blockers(struct device_driver *drv)
> +{
> +	bus_for_each_dev(&platform_bus_type, NULL, drv, exynos_drm_add_blocker);
> +}

This feels very wrong to be dumping the above code into every driver which
wants to make use of some kind of componentised support.

You also appear to need to know the struct device_driver's for every
component.  While that may work for exynos, it doesn't work elsewhere
where the various components of the system are very real separate
kernel modules - for example, a separate I2C driver such as the TDA998x
case I mentioned in my first reply.

I can't see how your solution would be usable in that circumstance.

The third issue I have is that you're still needing to have internal
exynos sub-device management - you're having to add the individual
devices to some kind of list, array or static data, and during DRM
probe you're having to then walk these lists/arrays/static data to
locate these sub-devices and finish each of their individual
initialisations.  So you're ending up with a two-tier initialisation.

That's not particularly good because it means you're exposed to
problems where the state is different between two initialisations -
when the device is recreated, your component attempts to re-finalise
the initialisation a second time.  It wouldn't take much for a field
to be assumed to be zero at init time somewhere for a bug to creep
in.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
