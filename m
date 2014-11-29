Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaK2WGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 17:06:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50716 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751738AbaK2WGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 17:06:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Sat, 29 Nov 2014 23:27:52 +0100
Message-ID: <1820241.GUleD5gbzs@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141129115209.GD7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <2127240.rWRTDu6LHQ@vostro.rjw.lan> <20141129115209.GD7712@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 29, 2014 11:52:09 AM Mark Brown wrote:
> 
> --9GYGtdBumnmR69ER
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> On Sat, Nov 29, 2014 at 12:51:59AM +0100, Rafael J. Wysocki wrote:
> > On Friday, November 28, 2014 04:00:36 PM Mark Brown wrote:
> 
> > > OK, we probably should have one to aid discoverability since as far as I
> > > can tell what's happening is that people (hi Intel!) are allocating
> > > their own identifiers for devices produced by other vendors that turn up
> > > on their boards.  If people can find the set of IDs in use there's more
> > > chance they'll use the same ones as other people.
> 
> > There's the PRP0001 ID that can be use to in combination with the
> > "compatible" property which then works the same way as for DT.
> 
> > That should be sufficient if the properties are going to be the
> > same for ACPI (_DSD) and DT.
> 
> We've got people making BIOSs right now for systems you can actually buy=20
> that are intended to run Windows which we need to support; right now the
> pressing problem I'm seeing is that we've got BIOS vendors not using
> properties at all and we're going to be ending up with configuration
> coming from big DMI tables instead which is miserable, Windows is
> perfectly happy to have custom drivers installed per machine.  Do we
> know if Windows supports PRP0001 as it currently stands?

No, it doesn't.

Separate device IDs are necessary for Windows compatibility AFAICS.

But that also means any device ID registered by us won't be suitable in that
case, because Windows won't use it.

There are two different problems here, though.  The first one is a way to
provide the existing Linux drivers with the information expected by them via
ACPI and that's what _DSD (plus PRP0001 optionally) is.  The second one is
to be able to handle systems with ACPI tables from a random vendor who only
cares about Windows and that's more difficult to address, because our
ecosystem is different from theirs.

There basically are two ways around that.  The first one is to have all
knowledge related to device IDs in drivers (which effectively is what
Windows does and which implies "board files" of sorts) and the second one is
to make it possible to use overlays on top of the existing ACPI tables that
will allow people to provide the properties expected by a more generic driver
(this way, if the vendor didn't care to provide _DSD, for example, in the
original ACPI tables, the system integrator would be able to use an overlay
in an initramfs or boot partition to amend them).

There is a plan to do the latter, but that is going to take some time to
complete.

> > > If those are device IDs then what you're saying is what I'd expect to
> > > happen and it's part of the reason I'd expect us to be registering IDs
> > > along with registering properties - if people are defining device
> > > specific properties they really ought to be tied to the IDs that are in
> > > use especially if (as seems likely to be the case with the current state
> > > of the world) people are doing things without attempting to coordinate
> > > and we're ending up trying to document the deployed reality.
> 
> > The rule of thumb (in my view) should be that if the device object's _DSD=
>  is
> > going to return the same set of properties as for DT and no other special
> > handling determined by the ID is required (ie. nothing along the lines of
> > "if the device ID is X, the _ABC method works like that" which has to be =
> known
> > by the driver), "PRP0001" should be returned by _HID and then the value o=
> f the
> > "compatible" property should be the same as for DT.
> 
> This is a reasonable idea but we do need it to be compatible with
> Windows and we still need to make sure we have a process in place that
> BIOS authors and driver authors focused on Windows can reasonably be
> expected to work with.  That's not something we have right now for DT
> (our DT process involves contributing to Linux) so the problem remains
> effectively the same.

We can't make Windows use our stuff and they have a different model
(a custom driver per device ID vs a common driver per IP block possibly
matching multiple device IDs).

> We also need a way of getting the word out to people that they should be
> doing this (also a problem no matter if we use PRP0001 or something UEFI
> specific).

What do you mean by "something UEFI specific"?

> > Otherwise, a new device ID needs to be allocated for the device and _HID
> > should return that ID.  Also, if the device is compatible with another
> > device with an already allocated ID (for _HID), _CID may return the devic=
> e ID
> > of the compatible device.  [Of course, it's better if _HID is the same for
> > identical devices.]
> 
> I honestly don't see BIOS authors as being likely to care about adding
> things to the CID if their systems are working (I'm assuming that HID is
> the primary device ID and CID are further backup compatible IDs).

They will if they care to be compatible with old (binary) OSes that didn't
know about the new device ID, but shipped drivers that could handle the
device (although possibly in a "crippled" way).


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
