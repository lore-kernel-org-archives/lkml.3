Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaDZPbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:31:11 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52858 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751661AbaDZPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:31:06 -0400
Date: Sat, 26 Apr 2014 16:30:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for
	components tracking
Message-ID: <20140426153001.GY26756@n2100.arm.linux.org.uk>
References: <1397734130-21019-4-git-send-email-a.hajda@samsung.com> <20140417220412.GZ24070@n2100.arm.linux.org.uk> <5351145D.8070207@samsung.com> <20140418124652.GE24070@n2100.arm.linux.org.uk> <535652B2.7000607@samsung.com> <20140422115145.GU24070@n2100.arm.linux.org.uk> <5357D68E.8060605@samsung.com> <20140423164328.GG24070@n2100.arm.linux.org.uk> <20140423171351.GH24070@n2100.arm.linux.org.uk> <535A72D1.1060207@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A72D1.1060207@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:36:01PM +0200, Andrzej Hajda wrote:
> On 04/23/2014 07:13 PM, Russell King - ARM Linux wrote:
> > Let me be absolutely clear *why* I'm very interested in this - and that
> > is because I'm presently converting TDA998x and Armada DRM to use the
> > component helpers.  If your solution is better, then I'd want to convert
> > to that instead, and let's retire the component helpers.
> > 
> > At the moment, my belief is that your solution is *very* substandard and
> > suboptimal precisely for the reasons I've outlined, especially when it
> > comes to sharing a component between several drivers.
> > 
> > So, if you *really* care, you'll stop fobbing me off on this point and
> > provide some real technical input how you'd see your solution being used
> > in exactly the scenario that I've been outlining several times in this
> > thread.
> > 
> > For example, you could show what kind of modifications you expect would
> > be required to the _existing_ TDA998x driver to allow it to participate
> > as a device declared in DT as an entirely separate entity, probed via the
> > standard I2C probing methods, and then hook itself into the appropriate
> > DRM driver.  Remembering, of course, that the TDA998x device is used by
> > more than _just_ Armada DRM.
> > 
> > I don't care if you show it via pseudo-code or by real patch.  I just
> > want to know _how_ your solution could be used.  And I won't want some
> > silly remark like "trivially" or "I've already answered that."  I want
> > _you_ to _show_ _how_ it can be done.
> > 
> 
> Thats good, constructive discussion is better.

Well, the above is the _same_ fscking question I've been asking you
all along and that you have failed to answer properly until now.
Unfortunately, your reply still doesn't answer my concerns.

> I have no experience with tda998x, armada and drm_encoder_slave, so
> please be kind if I make some mistakes regarding them.
> I will try to show the complete solution starting from the current state
> of tda998x and armada in linux-next. I will present solution for DT as
> it is more standardized than board files. I hope it should not be a
> problem to port it back to board files if necessary.
> 
> First I will try to show how to get rid of ifdefs in armada_drv.c, it is
> not a part of my proposition but you have emphasized it.
> 
> 1. tda998x have already minimal DT support, so we can create proper i2c
> client device node with "nxp,tda998x" compatible.
> 
> 2. There are tda998x_encoder_params defined in armada_drv.c they should
> be removed from armada and added to tda998x node, its parsing to tda
> driver should be added as well.
> 
> 3. In armada_drv.c there is armada_drm_slave_config specific for tda. I
> am not sure of all its content but it seems it could be mapped to DT
> video interface.
> So if in armada_drm node there will be port node it means there
> is something connected to the output and it uses drm_encoder_slave
> interface, if there is no port node there is no encoder.
> Sample bindings:
> 
> armada_drm {
> 	...
> 	port {
> 		drm_ep: endpoint {
> 			remote-endpoint = <&tda_ep>;
> 			crtcs = <1>;
> 			poll_connect;
> 			poll_disconnect;
> 			interlace_allowed;
> 		};
> 	};
> };
> 
> ...
> 
> i2c_x {
> 	tda@70 {
> 		reg = <0x70>;
> 		compatible = "nxp,tda998x";
> 		swap_a = ...;
> 		swap_b = ...;
> 		...
> 		port {
> 			endpoint {
> 				remote-endpoint = <&drm_ep>;
> 			};
> 		};
> 	};
> };
> 
> 4. In armada_drm call of drm_i2c_encoder_init should be replaced
> by sth like:
> 	client = of_find_i2c_device_by_node(dev node containing drm_ep phandle);
> 	device_lock(&client->dev);
> 	if (!client->dev.driver) {
> 		ret = -EPROBE_DEFER;
> 		goto unlock;
> 	}
> 	module_get(client->dev.driver->owner);
> 	encoder_drv = to_drm_i2c_encoder_driver(to_i2c_driver(client->dev.driver));
> 	encoder_drv->encoder_init(client, dev, encoder);
> unlock:
> 	device_unlock(&client->dev);
> 
> Similar change should be done to destroy code.
> Of course please consider this code as a draft.

This looks reasonable - and I'm sure we can easily work around the
situation when there's no i2c encoder.  There is one thing which concerns
me about the above - that module_get() call.  module_get() only saves you
from the module being unloaded, which really isn't an issue if the
problem with the device going away is solved.

If you think about this for a moment, you'll understand why - in order for
the module to be unloaded, the device driver must be first unbound from
any devices.  So:

(a) you need to prevent the device driver being unbound while the DRM device
is being brought up, and
(b) you need to bring the DRM device down if the device driver is unbound.

Those are the two difficult problems which need solving.

The other thing which I notice from what you've illustrated above is that
you're not using your framework for this.

> All the above is just for removing ifdefs from armada_drv.c, it
> is not really connected with my proposition.

In any case, these aren't the ifdefs I was talking about.  Let me try
yet again.

In the exynos component drivers, you have this in each of their probe
functions:

	exynos_drm_dev_ready(&pdev->dev);

This is implemented by the core exynos driver, and this ties each
component to the core exynos driver.  The reason you do this is because
you need to get the handle to the "blockers" specific to the "master"
device:

+int exynos_drm_dev_ready(struct device *dev)
+{
+       return pending_components_delete(&exynos_drm_blockers, dev);
+}

Now, let's translate this to the TDA998x/Armada DRM setup.  We first
need a list of blockers for Armada DRM, let's call it armada_drm_blockers.
We then need to provide a similar function to the above:

int armada_drm_dev_ready(struct device *dev)
{
       return pending_components_delete(&armada_drm_blockers, dev);
}

And now we need TDA998x to call that to indicate that it's ready.  So
in the TDA998x probe function, we would end up with a call to:

	armada_drm_dev_ready(&client->dev);

And this is where my concerns about this approach start - by doing so,
the driver is now tied directly to Armada DRM, where it wasn't hard-tied
before.  This is a problem, because it's used by more drivers than just
Armada DRM - tilcdc as an example.

So, the above then needs to become:

#ifdef CONFIG_DRM_ARMADA
	armada_drm_dev_ready(&client->dev);
#endif

Now, if/when tilcdc starts to take on a similar structure, it too grows
one of these "dev_ready" calls, let's call it tilcdc_dev_ready().  Now
we need tda998x to do this:

#ifdef CONFIG_DRM_ARMADA
	armada_drm_dev_ready(&client->dev);
#endif
#ifdef CONFIG_DRM_TILCDC
	tilcdc_dev_ready(&client->dev);
#endif

And these are the ifdef's I've been talking about all along.  This presents
two problems:

1) these ifdefs should not be necessary,
2) each ifdef, when enabled, adds a hard reference between tda998x and
   it's host driver.

Now consider the effect that this has if we build a multi-platform kernel
which includes both tilcdc and Armada DRM as modules.  The first issue
here is that if _either_ of these are built as modules, tda998x must
also be built as modules.  So we need to come up with some kind of
Kconfig language to express this dependency.

The second problem is that in order to load the tda998x module, we must
have both Armada DRM and tilcdc both loaded in this situation (because of
the direct references to those modules.)  Many people would find that
unacceptable (I find it unacceptable that drivers for hardware that do
not exist would need to be loaded.)

> Over time my idea evolved.
> My proposition is still in the form of adding one call to component
> probe for reporting device readiness and one symmetrical call to remove.
> 
> It seems I can simply reuse notification framework which I am working
> on. I will send RFC next week and I will accompany it with its usage for
> solving drmdev problem.

So... how do you know which "master" a component belongs to in order to
report its readiness?  How do you get the "master" to be re-probed when
that component becomes ready?

Bear in mind that while the component device's probe function is running,
the device is locked, which means the device will be locked when your
call reporting device readiness will be made.  If you trigger a call
at that point to try and bind the master, you'll deadlock when the driver
code (such as you've shown above) also tries to take the device lock.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
