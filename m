Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3JQOne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:43:34 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41754 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab3JQOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:43:32 -0400
Date: Thu, 17 Oct 2013 16:41:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>
Subject: Backlight enabled by default
Message-ID: <20131017144112.GD32734@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

While working on integrating backlight functionality with the DRM sub-
system, I came across an oddity of sorts. The backlight subsystem seems
to have an implicit policy of enabling the backlight device when it's
registered. Pretty much every driver seems to do something like this in
.probe():

	bl->props.brightness = default_brightness;
	bl->props.fb_blank = FB_BLANK_UNBLANK;
	backlight_update_status(bl);

There are variations of this theme, but the tendency is certainly to
enable the backlight once it has been registered. Some don't even set
the .fb_blank field, so it will usually stay initialized to zero, which
happens to be FB_BLANK_UNBLANK, so the result will be the same.

I understand that this is actually useful when using something such as
fbdev where the backlight isn't necessarily bound to a display device,
but when used in conjunction with a higher-level API such as DRM, then
this default behaviour becomes somewhat annoying.

The problem is that backlight devices are usually instantiated
separately from the display driver, so with the current default the
backlight will be enabled at some random point in time during boot.
However, DRM for example provides for a display to control very
precisely when the backlight should be enabled, which in turn makes it
easy to light it up right after the display has initialized. If the
backlight is turned on right after it has been probed this could mean
that the display hasn't been initialized yet and therefore there's no
meaningful content yet, and worse, the display might show garbage during
initialization of the display controller.

So I wonder if perhaps a better default would be to not enable the
backlight on boot. If so, this will actually cause a regression of some
sort on non-DRM systems because suddenly the backlight is no longer
enabled by default on boot.

Does anyone have any comments or ideas?

My first reaction was to add a property to the DT so that the driver
could skip enabling the backlight, but I don't think that will be
accepted because it encodes software policy in DT rather than purely
a description of hardware.

Thierry

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX/cIAAoJEN0jrNd/PrOhc9gQAJwYC3AzlGGWmo1jhfXo/04H
eSBELtrIR9069QWQ0dqgZmRRe5kcj5yfEsDeaS7emPNwTblGWwQzMIIXA5DOXCrB
nSXZtTYmb6fhJHWehFFznTXnDQnKkaEHbDCsJxjh2MHT+5iZ6wU2sPq0SzwNTiUN
ImhQsRelCrGF5CCpp5jGCpzw1Vh1LplL/T8gq1BrIv2wOcLdmRPYwz13+aOuLbMT
T2dqwdsMRnfeHo6fX0lpKokuwuwn0DGq/ZYUxt8oZplqndGq8FGCs0OJ4/4J0nMt
UfZlc67AXsBUcKALo6mqTkxwqn9VKVOwnPG/6H1zMsaG2M1q3Drg8XBlba5h39bR
nZuC9w6ky0uHIBPP3mIagU5ArZZJeM1GILB3XoxUmnNwj0GrTKrKGaWvtIi09VDw
EdG5d5Wg6I6e0UEpu2aSCKbyQDMgHAKaUpdyThy7d2CT4KpfpzE5J9OHNPhPUCHK
fCTUl+KUiDpSm93N+yFp74EZrZ6yM4fu42iSMkhmrJ8UgHHVYr+igupvyBrmYSEX
65/UEcJQk16yrhbRjA9lZ92l7gkvCaac8JCLs5ZLsqXXAKNZX7ADRq7zGEQOsTH2
iDNffdFCtR2JvGkbheDSAWwSvyem2ImDZEpE7+KSk0iY9LeIj7PT62E3S1Dy1WvJ
QZxkE+tcPDml2SVTgoLs
=rKfx
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
