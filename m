Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaLDLMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:12:44 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43516 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaLDLMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:12:42 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1820241.GUleD5gbzs@vostro.rjw.lan>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
	<2127240.rWRTDu6LHQ@vostro.rjw.lan> <20141129115209.GD7712@sirena.org.uk>
	<1820241.GUleD5gbzs@vostro.rjw.lan>
Date: Thu, 04 Dec 2014 11:12:34 +0000
Message-Id: <20141204111234.44C0FC40874@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2014 23:27:52 +0100
, "Rafael J. Wysocki" <rjw@rjwysocki.net>
 wrote:
> On Saturday, November 29, 2014 11:52:09 AM Mark Brown wrote:
> > 
> > --9GYGtdBumnmR69ER
> > Content-Type: text/plain; charset=us-ascii
> > Content-Disposition: inline
> > Content-Transfer-Encoding: quoted-printable
> > 
> > On Sat, Nov 29, 2014 at 12:51:59AM +0100, Rafael J. Wysocki wrote:
> > > On Friday, November 28, 2014 04:00:36 PM Mark Brown wrote:
> > 
> > > > OK, we probably should have one to aid discoverability since as far as I
> > > > can tell what's happening is that people (hi Intel!) are allocating
> > > > their own identifiers for devices produced by other vendors that turn up
> > > > on their boards.  If people can find the set of IDs in use there's more
> > > > chance they'll use the same ones as other people.
> > 
> > > There's the PRP0001 ID that can be use to in combination with the
> > > "compatible" property which then works the same way as for DT.
> > 
> > > That should be sufficient if the properties are going to be the
> > > same for ACPI (_DSD) and DT.
> > 
> > We've got people making BIOSs right now for systems you can actually buy=20
> > that are intended to run Windows which we need to support; right now the
> > pressing problem I'm seeing is that we've got BIOS vendors not using
> > properties at all and we're going to be ending up with configuration
> > coming from big DMI tables instead which is miserable, Windows is
> > perfectly happy to have custom drivers installed per machine.  Do we
> > know if Windows supports PRP0001 as it currently stands?
> 
> No, it doesn't.
> 
> Separate device IDs are necessary for Windows compatibility AFAICS.
> 
> But that also means any device ID registered by us won't be suitable in that
> case, because Windows won't use it.
> 
> There are two different problems here, though.  The first one is a way to
> provide the existing Linux drivers with the information expected by them via
> ACPI and that's what _DSD (plus PRP0001 optionally) is.  The second one is
> to be able to handle systems with ACPI tables from a random vendor who only
> cares about Windows and that's more difficult to address, because our
> ecosystem is different from theirs.

It is a problem if the expected binding method is different between
Linux and Windows. This is a problem we've hit before where the platform
/may/ try to get both right, but in reality only one works, or even
implemented.

I predict that PRP0001 is only going to be practical when the hardware
is only ever going to be driven by Linux or other PRP0001 aware OS. ie.
A Minnowboard Max with a custom expansion board attached. When the
hardware is supported under both Windows and Linux then it will probably
be best for Linux to attempt to bind using the device id before
attempting to use PRP0001.

> There basically are two ways around that.  The first one is to have all
> knowledge related to device IDs in drivers (which effectively is what
> Windows does and which implies "board files" of sorts) and the second one is
> to make it possible to use overlays on top of the existing ACPI tables that
> will allow people to provide the properties expected by a more generic driver
> (this way, if the vendor didn't care to provide _DSD, for example, in the
> original ACPI tables, the system integrator would be able to use an overlay
> in an initramfs or boot partition to amend them).

Either approach amounts to pretty much the same thing. The
kernel/distribution needs to carry around device specific driver data
which is exactly how we've supported x86 hardware. Whether the data is
in-kernel or in-userspace is kind of an implementation detail. :-)


_DSD support is a different situation though. Even if Windows doesn't
care to directly support _DSD, drivers are free to use _DSD properties.
This is the scenario where the shared binding repository will be
important.

g.
