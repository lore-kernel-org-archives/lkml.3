Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaFXPUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:20:34 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:64505 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbaFXPUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <53A94DA1.50703@collabora.co.uk>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
	<1403486483-4063-5-git-send-email-afaerber@suse.de>
	<CAD=FV=WHAqASC+bp8mGVnhfr79F5LapJCTLtSfgUG8XuRUSCqw@mail.gmail.com>
	<53A8AE4C.6080702@suse.de>
	<CAD=FV=W96QpDhh1NSaVwrXYjL6Jr-v4sq1-eRSfT=tErw_KCOQ@mail.gmail.com>
	<53A94DA1.50703@collabora.co.uk>
Date: Tue, 24 Jun 2014 08:20:30 -0700
X-Google-Sender-Auth: QvjQAXgHiMHQ2OviNBM07wtm6IE
Message-ID: <CAD=FV=VEVwPzW4hdR1kSdZS741Hn6VnDr+yXetTPsN4hEym2xA@mail.gmail.com>
Subject: Re: [RFC 4/4] ARM: dts: exynos5250: Add Spring device tree
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        Todd Broch <tbroch@chromium.org>, Tomasz Figa <t.figa@samsung.com>,
        jwerner@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Tue, Jun 24, 2014 at 3:06 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Hello Doug,
>
> On 06/24/2014 06:05 AM, Doug Anderson wrote:
> Another option is to identify DTS fragments that are common across boards and
> create .dtsi files for these specific chunks instead of trying to group all set
> of common things on a single .dtsi file.
>
> For example, a quite common design for OMAP2+ based boards is to use a SMSC LAN
> chip connected to OMAP's General-Purpose Memory Controller (GPMC). So the
> following files were created to reduce DTS duplication:
>
> arch/arm/boot/dts/omap-gpmc-smsc911x.dtsi
> arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
>
> Now that I think about it, is the same that what you did for
> arm/boot/dts/cros-ec-keyboard.dtsi.
>
> Maybe splitting exynos5250-cros-common.dtsi in a set of .dtsi files will make it
> more flexible/reusable?

Yes, I think the config fragments can be cleaner but I think we have
to be judicious about using them.  There are definitely tradeoffs
involved.  The keyboard was such an excessively large thing and
totally duplicated, so moving it out made sense.  Other bits are less
obvious (to me) because there are so many interactions / combinations
and you end up with a bit of spaghetti in terms of which labels are
used by and provided by each fragment.  I guess possibly you could
codify that better...

A few thoughts looking at exynos5420-peach-pit:

* backlight: seems (?) too board specific
* samsung,exynos5420-oscclk: could totally be a fragment, but very small.
* power key: could be a fragment for all boards that happen to use
gpx1-2 for this
* sound: could be a fragment for all devices using
"google,snow-audio-max98090", possibly.


> Personally I think that "status = [enabled | disabled]" only makes sense for IP
> blocks that are part of the SoC but may or may not be used by a board (e.g: i2c
> and spi buses, sdhci and usb host controllers, etc).
>
> DTS should be a description of the hardware so I agree that having a disabled
> node for a device that is not present in the board is not right.

Right.  We'll take a look again in v2 when cros-common isn't used.  I
think this could go in steps:
1. Don't use cros-common for spring
2. Don't use cros-common for snow (fold stuff in)
3. Introduce some fragments.
