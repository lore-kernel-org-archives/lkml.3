Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaIKMW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:22:57 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46138 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaIKMW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140911064834.GA15520@phenom.ffwll.local>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
	<1410364463-12692-5-git-send-email-dh.herrmann@gmail.com>
	<20140911064834.GA15520@phenom.ffwll.local>
Date: Thu, 11 Sep 2014 14:22:55 +0200
Message-ID: <CANq1E4Q1RJCPACB0Cg7A79BB7Ly-zEUDik7PKyQ9oNuEizFPxA@mail.gmail.com>
Subject: Re: [PATCH RFC 4/4] drm: link connectors to backlight devices
From: David Herrmann <dh.herrmann@gmail.com>
To: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Jackson <ajax@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Sep 11, 2014 at 8:48 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> Nice you skid around all the pitfalls and trapdoors, I guess we've all
> been rather blind ;-)
>
> Two high-level comments:
> - We also want to forward "bl_power". cros was totally not happy when we
>   stopped treating brightness == 0 as completely off (it upsets some
>   panels terminally, so there's a vbt lower limit). Instead we expose this
>   now through the bl_power knob.
>
>   While at it I think we should expose all the other backlight properties
>   too (read-only ofc for actual/max_brightness).

bl_power is easy to add. I guess v2 will have:
  "BACKLIGHT-POWER" (range 0-4)

actual-brightness is a bit more tricky. Currently, DRM caches property
values, so there is no read_property() hook. We'd have to add this.
But it'll be quite nasty as we have to call into the backlight driver.
So I think we want to run an async-interruptible worker on the
backlight, drop the locks in the ioctl and wait for the job to finish.
Not sure whether it's worth it.. maybe we can add this later.

> - How does udev match on the drm connector name? They are not terribly
>   stable atm, and if you reload your drm driver, or much more likely, have
>   two gpus with two drm drivers they change. We probably should change the
>   name allocation scheme to be per device instance instead of global
>   first. Within a driver probe order is hopefully deterministic on a given
>   platform, since even with super dynamic setups (based on dt/acpi) the
>   firmware tables should change really.

You can match on EDID attributes. Ok, so far this is pretty ugly as
the EDID property is binary. But we can add rather trivial udev
extensions to make EDID binary against text matching possible.

While we're at it, I don't really like the brightness-value
re-scaling. I currently expose BRIGHTNESS as rang 0-65535 and scale it
to the backlight range. This works perfectly well as the backlight is
usually a really small range, but it would be much simpler if we could
expose the real range. However, this would require DRM property
hotplugging. This is currently not supported by DRM.. and it would
require multiple different properties for each connector as each might
have a different range. But then, we have to suffix the name as we
cannot have multiple properties with the same name..
Eh.. re-scaling doesn't sound that bad, does it?

Ok, we could expose a separate property called MAX-BRIGHTNESS and
drivers simply ignore the range-bounds of the BRIGHTNESS value and use
MAX-BRIGHTNESS instead? Sounds ok'ish.

Thanks
David
