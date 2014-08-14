Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaHNFDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:03:47 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33270 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752460AbaHNFDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:03:44 -0400
Date: Thu, 14 Aug 2014 08:03:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com
Subject: Re: [PATCH/RFC v4 00/21] LED / flash API integration
Message-ID: <20140814050338.GO16460@valkosipuli.retiisi.org.uk>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <20140806065358.GC16460@valkosipuli.retiisi.org.uk>
 <53E336FA.2050306@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E336FA.2050306@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Thu, Aug 07, 2014 at 10:21:14AM +0200, Jacek Anaszewski wrote:
> On 08/06/2014 08:53 AM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Fri, Jul 11, 2014 at 04:04:03PM +0200, Jacek Anaszewski wrote:
> >...
> >>1) Who should register V4L2 Flash sub-device?
> >>
> >>LED Flash Class devices, after introduction of the Flash Manager,
> >>are not tightly coupled with any media controller. They are maintained
> >>by the Flash Manager and made available for dynamic assignment to
> >>any media system they are connected to through multiplexing devices.
> >>
> >>In the proposed rough solution, when support for V4L2 Flash sub-devices
> >>is enabled, there is a v4l2_device created for them to register in.
> >>This however implies that V4L2 Flash device will not be available
> >>in any media controller, which calls its existence into question.
> >>
> >>Therefore I'd like to consult possible ways of solving this issue.
> >>The option I see is implementing a mechanism for moving V4L2 Flash
> >>sub-devices between media controllers. A V4L2 Flash sub-device
> >>would initially be assigned to one media system in the relevant
> >>device tree binding, but it could be dynamically reassigned to
> >>the other one. However I'm not sure if media controller design
> >>is prepared for dynamic modifications of its graph and how many
> >>modifications in the existing drivers this solution would require.
> >
> >Do you have a use case where you would need to strobe a flash from multiple
> >media devices at different times, or is this entirely theoretical? Typically
> >flash controllers are connected to a single source of hardware strobe (if
> >there's one) since the flash LEDs are in fact mounted next to a specific
> >camera sensor.
> 
> I took into account such arrangements in response to your message
> [1], where you were considering configurations like "one flash but
> two
> cameras", "one camera and two flashes". And you also called for
> proposing generic solution.
> 
> One flash and two (or more) cameras case is easily conceivable -
> You even mentioned stereo cameras. One camera and many flashes
> arrangement might be useful in case of some professional devices which
> might be designed so that they would be able to apply different scene
> lighting. I haven't heard about such devices, but as you said
> such a configuration isn't unthinkable.
> 
> >If this is a real issue the way to solve it would be to have a single media
> >device instead of many.
> 
> I was considering adding media device, that would be a representation
> of a flash manager, gathering all the registered flashes. Nonetheless,
> finally I came to conclusion that a v4l2-device alone should suffice,
> just to provide a Flash Manager representation allowing for
> v4l2-flash sub-devices to register in.
> All the features provided by the media device are useless in case
> of a set of V4L2 Flash sub-devices. They couldn't have any linkage
> in such a device. The only benefit from having media device gathering
> V4L2 Flash devices would be possibility of listing them.

Not quite so. The flash is associated to the sensor (and lens) using the
group ID in the Media controller. The user space doesn't need to "know" this
association.

More complex use cases such as the above may need extensions to the Media
controller API.

> >>2) Consequences of locking the Flash Manager during flash strobe
> >>
> >>In case a LED Flash Class device depends on muxes involved in
> >>routing the other LED Flash Class device's strobe signals,
> >>the Flash Manager must be locked for the time of strobing
> >>to prevent reconfiguration of the strobe signal routing
> >>by the other device.
> >
> >I wouldn't be concerned of this in particular. It's more important we do
> >actully have V4L2 flash API supported by LED flash drivers and that they do
> >implement the API correctly.
> >
> >It's at least debatable whether you should try to prevent user space from
> >doing silly things or not. With complex devices it may relatively easily
> >lead to wrecking havoc with actual use cases which we certainly do not want.
> >
> >In this case, if you just prevent changing the routing (do you have a use
> >case for it?) while strobing, someone else could still change the routing
> >just before you strobe.
> 
> Originally I started to implementing this so that strobe signal routing
> was altered upon setting strobe source. With such an implementation
> the use case would be as follows:
> 
> 1. Process 1 sets strobe source to external
> 2. Process 2 sets strobe source to software
> 3. Process 1 strobes the flash, unaware that strobe source setting has
>    been changed
> 
> To avoid such problems I changed the implementation so that the
> routing is set in the led_flash_manager_setup_strobe function called
> from led_set_flash_strobe and led_set_external_strobe functions.
> led_flash_manager_setup_strobe sets strobe signal routing
> and strobes the flash under lock and holds it for the flash timeout
> period, which prevents spurious reconfiguration.
> 
> Nonetheless, I agree that trying to handle this problem is troublesome,
> and would affect current V4L2 Flash SPI semantics. If you don't share
> my concerns I am happy to leave this locking solution out :)

I do propose leaving it out. If we should have such a thing we should think
it in a larger scope than just flash strobing.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
