Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbaFLKtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:49:47 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55714 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932952AbaFLKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:49:46 -0400
Date: Thu, 12 Jun 2014 11:49:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Brown <broonie@linaro.org>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig fails: big select-based circular dependency
Message-ID: <20140612104936.GE23430@n2100.arm.linux.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk> <20140612094745.GD23430@n2100.arm.linux.org.uk> <1402568578.10273.16.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402568578.10273.16.camel@x220>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 12:22:58PM +0200, Paul Bolle wrote:
> [Cc-ing Yann and linux-kbuild.]
> 
> On Thu, 2014-06-12 at 10:47 +0100, Russell King - ARM Linux wrote:
> > If no one responds, I'll assume that no one is interested, and I'll
> > just create a pile of patches removing a bunch of these idiotic select
> > statements at random to break this loop.
> 
> I looked into a much, much easier "recursive dependency" warning
> recently. That triggered me to post
> http://article.gmane.org/gmane.linux.kernel/1678946 . In summary: select
> statements are treated as "reverse dependencies", but that is actually
> rather odd.
> 
> See, for example, DMADEVICES in this warning: the kconfig code treats it
> as if it's depending on SAMSUNG_DMADEV. But I would be very surprised if
> that was what was intended when that select statement was added. Please
> note that I have not yet really looked into the mess you reported. But
> for now I'll state that a recursive dependency warning involving select
> statements is probably bogus. Perhaps Yann e.a. can prove me wrong.
> 
> I might have an ugly hack to the kconfig code disabling the "recursive
> dependency" stuff stashed away somewhere. Not sure, as it's been two
> months...

Well, let's take a look - rearranging this:

    symbol MX3_IPU depends on DMADEVICES
    symbol FB_MX3 depends on MX3_IPU

So, for FB_MX3 to be enabled, we need MX3_IPU enabled and DMADEVICES also
enabled.

    symbol BACKLIGHT_CLASS_DEVICE is selected by FB_MX3

When FB_MX3 is enabled, BACKLIGHT_CLASS_DEVICE is force-enabled.

    symbol BACKLIGHT_ADP8860 depends on BACKLIGHT_CLASS_DEVICE

This then means that BACKLIGHT_ADP8860 can be enabled by the user, and
when that is enabled by the user:

    symbol NEW_LEDS is selected by BACKLIGHT_ADP8860

NEW_LEDS is force-enabled.  This allows HID_SONY to be enabled by the
user:

    symbol HID_SONY depends on NEW_LEDS

which in turn force-selects POWER_SUPPLY:

    symbol POWER_SUPPLY is selected by HID_SONY

This then allows POWER_RESET_KEYSTONE to be enabled by the user:

    symbol POWER_RESET_KEYSTONE depends on POWER_SUPPLY

which then force-selects MFD_SYSCON:

    symbol MFD_SYSCON is selected by POWER_RESET_KEYSTONE

DRM_IMX_LDB can then be selected by the user:

    symbol DRM_IMX_LDB depends on MFD_SYSCON

which in turn force-enables DRM_PANEL:

    symbol DRM_PANEL is selected by DRM_IMX_LDB

allowing DRM_PANEL_LD9040 to be enabled by the user:

    symbol DRM_PANEL_LD9040 depends on DRM_PANEL

which force-enables SPI

    symbol SPI is selected by DRM_PANEL_LD9040

This then allows SPI_S3C64XX to be enabled:

    symbol SPI_S3C64XX depends on SPI

which then force-enables all these symbols, resulting in the original
symbol to be enabled.

    symbol S3C64XX_PL080 is selected by SPI_S3C64XX
    symbol SAMSUNG_DMADEV is selected by S3C64XX_PL080
    symbol DMADEVICES is selected by SAMSUNG_DMADEV

Now, the question that Kconfig has to answer when presenting the user
with the DMADEVICES option is: what are the possible legal values that
this option has which the user can select?

With the above loop, that can not be answered, because when DMADEVICES
is 'n', the result of the above chain is that DMADEVICES is not selected,
and therefore it could have values of 'y' or 'n'.  However, if it were
'y' and the other options are enabled, then the only legal value of it
is 'y'.

So, I don't think the answer to this is to get rid of the reverse
dependencies - they're very much needed to resolve what values are
legal for a symbol.  What this comes down to is the same old evilness -
the over-use of the "select" statement on user visible symbols.

For example, DMA engine is supposed to be a generic infrastructure which
abstracts the DMA provider from the DMA client.  That means a client
driver properly converted to DMA engine does not depend on any particular
DMA provider.  The only dependency there is that we have a SoC where these
two devices have been placed on the same silicon wafer - it is entirely
possible that the SPI hardware could be placed with a different DMA engine.
So, that makes SPI_S3C64XX selecting S3C64XX_PL080 wrong.

I see nothing in the S3C64XX SPI driver which is specific to the S3C64XX
PL080 implementation.  So, that makes this select purely a "convenience"
thing - something that we should /not/ be doing.

That's one select statement which should be killed, and that alone will
break this dependency loop.  I'm sure there's other stupid select
statements which do not correspond with some kind of hard dependency
in the above loop which can also be killed off for the same reason.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
