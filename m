Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaDVLwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:52:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43680 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753204AbaDVLwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:52:38 -0400
Date: Tue, 22 Apr 2014 12:51:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for
	components tracking
Message-ID: <20140422115145.GU24070@n2100.arm.linux.org.uk>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com> <1397734130-21019-4-git-send-email-a.hajda@samsung.com> <20140417220412.GZ24070@n2100.arm.linux.org.uk> <5351145D.8070207@samsung.com> <20140418124652.GE24070@n2100.arm.linux.org.uk> <535652B2.7000607@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535652B2.7000607@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:29:54PM +0200, Andrzej Hajda wrote:
> On 04/18/2014 02:46 PM, Russell King - ARM Linux wrote:
> > On Fri, Apr 18, 2014 at 02:02:37PM +0200, Andrzej Hajda wrote:
> >> Separation of the interfaces exposed by the device from the device itself
> >> seems to me a good thing. I would even consider it as a biggest
> >> advantage of this solution :)
> >>
> >> The problem of re-initialization does not seems to be relevant here, it
> >> is classic
> >> problem of coding correctness nothing more, it can appear here and in
> >> many different
> >> places.
> > It may be a problem of coding correctless, but it's also a maintainability
> > problem too - it makes it _much_ more difficult to ensure that everything
> > is correct.
> 
> But forcibly re-initializing all component devices instead of fixing bugs
> in specific drivers seems to be 'absolutely absurd' as classic says.

They're *unnecessary* bugs that wouldn't even exist if it weren't for
the forced-splitup of the initialisation into two separate parts that
your approach mandates.

Yes, I know that you're desperate to play that down, but you can't get
away from this fact: your approach _forces_ a split up of the
initialisation into dependent two stages and that fact _alone_ adds
additional complexity, and along with that additional complexity comes
more opportunity for bugs.  Also with that additional complexity comes
the need to perform more tests to find those bugs, and given that most
people just say "okay, it boots and seems to work, that's good enough
for me" there is a high possibility that these kinds of bugs will take
a long time to find.

> As I wrote already, this framework was proposed for drivers which
> are tied together anyway, and this is case of many drivers, not
> only exynos.

Please name them.

> Standalone drivers were not at my sight but I have also described in
> other mail how the framework can be 'improved' to support standalone
> drivers also.

At the moment, I don't see a justification for your "simplified"
and restrictive solution, which if used will lock drivers into that
simplisitic method, and which can't ever be extended without lots of
ifdeffery to having other components (such as TDA998x) attached.

My objections are entirely based on where imx-drm and armada DRM are
going, neither of which could ever use your implementation.

Before you say that it isn't meant to deal with stuff like the TDA998x,
take a moment to think about this - the Dove video subsystem was
designed to support OLPC.  It was primerly designed to drive a LCD
screen plus an on-board VGA DAC.  Everything for that is on-SoC.  With
that, the hardware is well known, and your solution could be used.

However, then SolidRun came along and dropped a TDA998x on the LCD output
pins.  Suddenly, things aren't that simple, and your solution falls
apart, because it can't cope with a generic component that has no knowledge
of the rest of its "master".

This kind of scenario can happen /any/ time, and any time it does happen,
your simple solution falls apart.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
