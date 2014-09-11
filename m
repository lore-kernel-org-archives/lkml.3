Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaIKNGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:06:18 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41763 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbaIKNGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:06:10 -0400
Date: Thu, 11 Sep 2014 15:06:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Jackson <ajax@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH RFC 4/4] drm: link connectors to backlight devices
Message-ID: <20140911130624.GJ15520@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Dave Airlie <airlied@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
	Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	Adam Jackson <ajax@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
 <1410364463-12692-5-git-send-email-dh.herrmann@gmail.com>
 <20140911064834.GA15520@phenom.ffwll.local>
 <CANq1E4Q1RJCPACB0Cg7A79BB7Ly-zEUDik7PKyQ9oNuEizFPxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4Q1RJCPACB0Cg7A79BB7Ly-zEUDik7PKyQ9oNuEizFPxA@mail.gmail.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:22:55PM +0200, David Herrmann wrote:
> Hi
> 
> On Thu, Sep 11, 2014 at 8:48 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > Nice you skid around all the pitfalls and trapdoors, I guess we've all
> > been rather blind ;-)
> >
> > Two high-level comments:
> > - We also want to forward "bl_power". cros was totally not happy when we
> >   stopped treating brightness == 0 as completely off (it upsets some
> >   panels terminally, so there's a vbt lower limit). Instead we expose this
> >   now through the bl_power knob.
> >
> >   While at it I think we should expose all the other backlight properties
> >   too (read-only ofc for actual/max_brightness).
> 
> bl_power is easy to add. I guess v2 will have:
>   "BACKLIGHT-POWER" (range 0-4)
> 
> actual-brightness is a bit more tricky. Currently, DRM caches property
> values, so there is no read_property() hook. We'd have to add this.
> But it'll be quite nasty as we have to call into the backlight driver.
> So I think we want to run an async-interruptible worker on the
> backlight, drop the locks in the ioctl and wait for the job to finish.
> Not sure whether it's worth it.. maybe we can add this later.

See Jani's reply - we probably don't need it, at least not in version 1.
> 
> > - How does udev match on the drm connector name? They are not terribly
> >   stable atm, and if you reload your drm driver, or much more likely, have
> >   two gpus with two drm drivers they change. We probably should change the
> >   name allocation scheme to be per device instance instead of global
> >   first. Within a driver probe order is hopefully deterministic on a given
> >   platform, since even with super dynamic setups (based on dt/acpi) the
> >   firmware tables should change really.
> 
> You can match on EDID attributes. Ok, so far this is pretty ugly as
> the EDID property is binary. But we can add rather trivial udev
> extensions to make EDID binary against text matching possible.

Why EDID? This is purely about the drm connector name, e.g. if I have 2
gpus, both with an eDP connector (optimus, so just one panel) then the
first driver gets eDP-1 as the name of it and the 2nd one eDP-2. Which is
ok if both should control backlight brightness through the same driver,
but a total mess if not just gpus get switched, but also backlight
controllers.

And if you reload you get then eDP-2 and eDP-3. Well at least in the past,
that hilarity at least was fixed in

commit b21e3afe2357c0f49348a5fb61247012bf8262ec
Author: Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Wed Aug 7 22:34:48 2013 -0400

    drm: use ida to allocate connector id

What I think we need to do is to make these ida allocators per-device, so
that both drivers have an eDP-1 connector. Otherwise you need to either
match both or do funny tricks like "the first eDP connector, no matter
which one on this gpu". After all we can now support more than one eDP
(and more than one LVDS since a long time actually).

Or how exactly is the udev hw db supposed to match this stuff for special
cases. In general we need to duplicate the existing logic from
libbacklight, like Matthew suggested.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
