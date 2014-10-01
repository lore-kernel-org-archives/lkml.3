Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaJANw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:52:59 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54325 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJANw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:52:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
Date: Wed, 01 Oct 2014 15:52:42 +0200
Message-ID: <2043842.LxdgdYRbIF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141001115901.GD1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <5364565.aEcZqpzdLW@wuerfel> <20141001115901.GD1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zid/FtvKOFq0AnU3aHPjVO3QQZxHDj34LNZYQG/SGGY
 N+k1gfpTwka8tAuAfu1kYCVJottpkFl4GDa3BrzVNFzF8uPHLC
 PkVlP+z1ELDP2Rr40ANfQARQ1AqRXAhNY0pGP43+aGDW5BeOKE
 /vT9dU3ChxV4YEeTBEJFUAfWlN/Zx3zaW1yOBAbs3hSf4vb7k9
 ucCCUgYAeL6ADdKcSKC+//fW9duscEXkpINfuqzg5yfie/w8Uu
 wu74eiDRMmze4+8/CT5HaizL93aekyytIbS4rW4F4rgYvz5YX9
 ZhMyKLlk2TvhsmLHJs6xVGdWjfn9Je9jT4PSTOtcaVQza9Sbmp
 bNGOJ0QOcLNZ5FLbUWTM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 14:59:01 Mika Westerberg wrote:
> On Wed, Oct 01, 2014 at 12:01:34PM +0200, Arnd Bergmann wrote:
> > On Wednesday 01 October 2014 12:13:09 Mika Westerberg wrote:
> > > 
> > > > Regarding the MODULE_DEVICE_TABLE, I suspect the above won't work the
> > > > way you are hoping for, because once you get to dozens or hundreds of
> > > > drivers doing this, each device will show up with the same string,
> > > > so udev will try to load all the modules that list "PRP0001". That
> > > > doesn't look right. With the code from patch 3, you can probably drop
> > > > the acpi MODULE_DEVICE_TABLE() entirely and get the correct behavior.
> > > 
> > > It actually works like this now:
> > > 
> > >  # cd /sys/bus/platform/devices/PRP0001\:00/
> > >  DRIVER=leds-gpio
> > >  MODALIAS=of:Nprp0001TacpiCgpio-leds
> > > 
> > >  # cat modalias 
> > >  of:Nprp0001TacpiCgpio-leds
> > > 
> > > In other words the modalias changes to be of:Nprp0001Tacpi, e.g
> > > name=prp0001, type=acpi and then list of compatible values.
> > > 
> > > Udev then loads only module that matches the modalias so it should not
> > > load everything listing PRP0001 in their MODULE_DEVICE_TABLE().
> > 
> > I'm not completely following yet. I can see how this works now, but
> > how is this better than just using the existing modalias for OF?
> 
> You mean using just what of_device_get_modalias() would create? In that
> case, what do we put to name and type fields?

Sorry, I think we're still both misunderstanding one another. You were
talking about the modalias created by the device scanning above, while
I meant the one in the MODULE_DEVICE_TABLE. 

With the entry you create in create_modalias(), you will only ever
match against the MODULE_DEVICE_TABLE(of, of_gpio_leds_match)
line, not against the MODULE_DEVICE_TABLE(acpi, acpi_gpio_leds_match),
so I think you can just drop the latter.

On the question what to put into the name and type fields, that is
unrelated. The type is supposed to be for the 'device_type' property
in DT, which we should never rely on in a driver that supports both
APCI and DT. In Linux we only use that for "pci", "cpu" and "memory",
all of which have their own way of getting probed in ACPI.
The "name" is normally ignored in DT as well, except for backwards
compatibility with old bindings, but I would argue that you should not
just put "prp0001" in there. Either leave it empty like type, or use
the name of the device as it appears in the ACPI tables, such as "DEV0"
or "PWM".

	Arnd
