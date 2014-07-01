Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270AbaGAWA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:00:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50487 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030255AbaGAWAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:00:24 -0400
Date: Tue, 1 Jul 2014 23:00:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701220011.GB32514@n2100.arm.linux.org.uk>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com> <20140701131026.GO32514@n2100.arm.linux.org.uk> <53B2B5E5.50502@gmail.com> <20140701133627.GP32514@n2100.arm.linux.org.uk> <20140701180426.54a79a0b@armhf> <20140701164527.GY32514@n2100.arm.linux.org.uk> <20140701194953.78a0c5cf@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701194953.78a0c5cf@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:49:53PM +0200, Jean-Francois Moine wrote:
> On Tue, 1 Jul 2014 17:45:27 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > Let's tell the full story rather than just presenting half of it.
> > 
> > You indeed wanted to do what you said above, but you also wanted to
> > completely change the component helpers in a way that I was not happy
> > with.  You wanted to add all sorts of DT specific gunk into the
> > helpers, which would have tied it to DT.
> > 
> > While DT is the current thing on ARM, it is /not/ the current thing
> > everywhere - a point which you failed to grasp.
> 
> I don't think that there will ever be a x86 DT.

x86 is ACPI, which is a completely different firmware interface.
Now, we are starting to see ARM peripherals (even some rather old
ones) being used on some x86 platforms.

You can't assume that just because something is used on ARM, it's never
going to be used on any other architecture.  IP which gets used with one
host CPU, even where it's integrated into a SoC, can find its way to
other CPU architectures very easily, and this really does happen.

So don't be surprised one day to find (eg) that the Dove/Kirkwood I2S
audio interface ends up being connected to an x86 CPU at some point.
Or the TDA998x ends up being used on x86 in a set top box.

You really can't think that just because something seems to be ARM
specific that it's absolutely fine to assume that it will always be
specific to ARM - /especially/ when adding core kernel facilities.
Core kernel facilities have to be completely independent of any CPU
architecture.  If they aren't, by definition they aren't core kernel
facilities.

> > You wanted to make the component operations optional, which I pointed
> > out makes no sense (because then components have no way to know what
> > happens to their master device - which is /really/ important for DRM.)
> 
> You did not explain too much that you wanted to keep it for DRM only.

It /isn't/ just for DRM, I've no idea what gave you that idea.  I've
said that I want to keep DT out of the core component helpers (see above
why.)  I also want to keep subsystem specifics out of it as well.

> > You refused to listen to those concerns, and refused to look at the
> > patch which I proposed, which did exactly the same as your patch,
> > while keeping the DRM slave interfaces for tilcdc to use, until they
> > have a chance to convert over.
> 
> The change in tilcdc was easy and the code was greatly simplified.

The same applies to mine once tilcdc is converted to the component
helpers - provided there are no other users of TDA998x, then the
non-component code can all be dropped and the driver reduced down -
and at that point it becomes purely a drm encoder with an associated
drm connector with just one setup methodology.

> > You kept telling me that I had "opened the door" to your changes.  I
> > claimed that your changes abused the code which I had written - a point
> > which I still maintain to this day.
> 
> Your code was offering a simple way to synchronize the system
> initialization without this lot of 'probe defer's. It could have been
> used so.

My code does /today/ offer a simple way to sort out the initialisation
without lots of deferred probes.  This is what happens:

1. There are zero deferred probes until all components for the master
   are present.

2. You will only get a deferred probe once all components are present
   _unless_ the master bind function returns a deferred probe, which
   _may_ come from a component driver.

So, the deferred probes are reduced to an absolute minimum.  Again, this
is by intention and design.

When resources are not available, we have to rely on the deferred probe
mechanism, because the deferred probe mechanism knows when other non-
component drivers are probed - and thus when resources may become
available.  This is not really any different from a single driver
trying to claim resources, finding one that isn't available, and
returning -EPROBE_DEFER - in fact, only the last driver to be probed
in a set of components which satisfies the master will suffer deferred
probes.

I'm now pushing changes to the component helper which change the way
the matching works, so that master doesn't have to keep scanning
whatever it needs to in order to work out which components are
required.  Masters will be required to gather that information
before registering themselves and supply it when registering into the
component helper.  This is beneficial for two reasons - not only does
it avoid wasting time rescanning (eg) the device tree multiple times,
but it also means that we can eventually allow partial subsystem
bring-up which is something the v4l2 people would like.

So, there's quite some work planned here which will require a number of
changes to the visible API.  So, it's really important that all users
make use of the component layer as it is intended to be used, so that
changes can be made.

Right now, that hasn't happened with Exynos, and that is right now giving
problems pushing this work forward - and that's the /exact/ problem when
stuff starts getting abused.  It means that it can't be maintained and it
blocks other work.  As the person who created this problem isn't
responding to my emails, it's pretty hard to see how to retire the old
interfaces - except maybe by forcing the issue which I really don't want
to do.

> > You also claimed that deferred probing didn't work.  Since the component
> > helpers were designed with the deferred probing problem in mind at the
> > time, and include the solution to that problem - which has been well
> > tested hundreds if not thousands of times by now - and you did not
> > provide the technical details as to why you thought it didn't work,
> > there was nothing that could be done to progress that point.
> 
> AFAIR, you also said that the probe defer was not working. But, thanks
> again for your component layer: all my init problems are gone, even if
> there are still some prove defer's...

That's really strange, because imx-drm relies upon it since day one,
and I even sent you the kernel boot log which provided evidence of it
working correctly.  Yes, there have been a few corner cases where the
devm resources were not handled quite correctly, but those have been
corrected.

> > Moreover, your abuse of the component layer would have made it more
> > difficult to maintain it into the future - which is a fundamental
> > point which has to be considered when accepting any patch into the
> > kernel.  If a patch makes some code unable to be maintained, then an
> > alternative approach has to be found.  Since you were not willing to
> > compromise on finding or considering alternative approaches such as
> > the one I presented.
> 
> I don't see what you are talking about.

See my explanation of the upcoming changes above - some of those
changes are required for Armada DRM (required in the sense that I
want Armada DRM to use the new way right now rather than have to
rework yet another DRM driver for those changes, pushing the
component changes even later - allowing more users to come along
potentially blocking the work.)

> > Since the component layer had had various comments which were in
> > progress, and your abuse of the component layer would have also
> > prevented those changes taking place (which are - in part - the set
> > of component patches which are on the list now) there is no way that
> > your uncompromising set of patches would be merged - at least not
> > until you start accepting some of the comments being given to you.
> > 
> > > Now, the last thing for me is to put the TDA998x codec in the kernel
> > > (it is also working in an other machine with 2 tda998x's).  
> > 
> > Yes, supporting the I2S connection is something that is need, but we
> > /also/ need to support SPDIF, and SPDIF is the preferred method on
> > the Cubox.  SPDIF should be used to talk to the TDA998x whenever
> > possible because it opens up the possibility for sending out
> > compressed MPEG2 and AC-3 audio streams, thus offloading the decode
> > of these formats to external hardware.
> > 
> > This works today, and is a feature that people have been using with
> > platforms such as xbmc and various other installations on the Cubox.
> > 
> > Limiting to I2S means that you can't send out these compressed audio
> > streams.  In fact, the Dove manual tells you that you must disable
> > the I2S playback stream if you're sending non-PCM - non-PCM is only
> > supported via SPDIF.
> 
> I don't understand: both I2S and S/PDIF may work in the kirkwood audio
> subsystem as it is (yes, actually not at the same time, and this is a
> choice because DPCM does not work for the Cubox). I have the 3 ways in
> my system:
> 
> $ cat /proc/asound/pcm 
> 00-00: i2s-i2s-hifi i2s-hifi-0 :  : playback 1
> 00-01: spdif-spdif-hifi spdif-hifi-1 :  : playback 1
> 00-02: spdif-dit-hifi dit-hifi-2 :  : playback 1
> 
> So, S/PDIF should work, but I don't know it: I have no optical connector.

How does that even work - I mean, pulseaudio will try and open all three
at startup and it sends samples through each...  Have you tested this
with pulseaudio?  Have you tested it with other programs such as an
audio player going direct to the ALSA interfaces (as would happen with
a compressed audio stream) - and checked what happens if pulse wants to
use it?  You don't need an actual compressed audio stream to test that
- you can just send audio direct to one of your other devices.

Second point - if you have the TDA998x only using i2s, then (as you say)
you can't use spdif, so simultaneous output via both HDMI and optical
is impossible with your driver on the Cubox.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
