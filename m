Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbaGAQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:45:40 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50247 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758013AbaGAQpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:45:39 -0400
Date: Tue, 1 Jul 2014 17:45:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701164527.GY32514@n2100.arm.linux.org.uk>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com> <20140701131026.GO32514@n2100.arm.linux.org.uk> <53B2B5E5.50502@gmail.com> <20140701133627.GP32514@n2100.arm.linux.org.uk> <20140701180426.54a79a0b@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701180426.54a79a0b@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 06:04:26PM +0200, Jean-Francois Moine wrote:
> On Tue, 1 Jul 2014 14:36:27 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > The Armada DRM stuff shouldn't be a problem, but the TDA998x may end up
> > being so /if/ Jean-Francois decides to object to my approach there to
> > allow tilcdc to continue working with the driver... but then as I now
> > maintain that as well, that's not much of an issue because I can make
> > the decision to overrule that point.
> 
> I proposed a patch to move the tda998x from a slave_encoder to a simple
> encoder/connector. This patch included the associated changes to the
> tilcdc. It has been violently refused. So, I will keep out of tree my
> tda998x and Dove DRM drivers.

Let's tell the full story rather than just presenting half of it.

You indeed wanted to do what you said above, but you also wanted to
completely change the component helpers in a way that I was not happy
with.  You wanted to add all sorts of DT specific gunk into the
helpers, which would have tied it to DT.

While DT is the current thing on ARM, it is /not/ the current thing
everywhere - a point which you failed to grasp.

You wanted to make the component operations optional, which I pointed
out makes no sense (because then components have no way to know what
happens to their master device - which is /really/ important for DRM.)

You refused to listen to those concerns, and refused to look at the
patch which I proposed, which did exactly the same as your patch,
while keeping the DRM slave interfaces for tilcdc to use, until they
have a chance to convert over.

You kept telling me that I had "opened the door" to your changes.  I
claimed that your changes abused the code which I had written - a point
which I still maintain to this day.

You also claimed that deferred probing didn't work.  Since the component
helpers were designed with the deferred probing problem in mind at the
time, and include the solution to that problem - which has been well
tested hundreds if not thousands of times by now - and you did not
provide the technical details as to why you thought it didn't work,
there was nothing that could be done to progress that point.

Moreover, your abuse of the component layer would have made it more
difficult to maintain it into the future - which is a fundamental
point which has to be considered when accepting any patch into the
kernel.  If a patch makes some code unable to be maintained, then an
alternative approach has to be found.  Since you were not willing to
compromise on finding or considering alternative approaches such as
the one I presented.

Since the component layer had had various comments which were in
progress, and your abuse of the component layer would have also
prevented those changes taking place (which are - in part - the set
of component patches which are on the list now) there is no way that
your uncompromising set of patches would be merged - at least not
until you start accepting some of the comments being given to you.

> Now, the last thing for me is to put the TDA998x codec in the kernel
> (it is also working in an other machine with 2 tda998x's).

Yes, supporting the I2S connection is something that is need, but we
/also/ need to support SPDIF, and SPDIF is the preferred method on
the Cubox.  SPDIF should be used to talk to the TDA998x whenever
possible because it opens up the possibility for sending out
compressed MPEG2 and AC-3 audio streams, thus offloading the decode
of these formats to external hardware.

This works today, and is a feature that people have been using with
platforms such as xbmc and various other installations on the Cubox.

Limiting to I2S means that you can't send out these compressed audio
streams.  In fact, the Dove manual tells you that you must disable
the I2S playback stream if you're sending non-PCM - non-PCM is only
supported via SPDIF.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
