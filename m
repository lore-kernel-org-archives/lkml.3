Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaDWQo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:44:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46180 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755232AbaDWQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:44:26 -0400
Date: Wed, 23 Apr 2014 17:43:28 +0100
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
Message-ID: <20140423164328.GG24070@n2100.arm.linux.org.uk>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com> <1397734130-21019-4-git-send-email-a.hajda@samsung.com> <20140417220412.GZ24070@n2100.arm.linux.org.uk> <5351145D.8070207@samsung.com> <20140418124652.GE24070@n2100.arm.linux.org.uk> <535652B2.7000607@samsung.com> <20140422115145.GU24070@n2100.arm.linux.org.uk> <5357D68E.8060605@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357D68E.8060605@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 05:04:46PM +0200, Andrzej Hajda wrote:
> On 04/22/2014 01:51 PM, Russell King - ARM Linux wrote:
> > Yes, I know that you're desperate to play that down, but you can't get
> 
> Not true. I only try to find the best solution and the approach with
> multiple re-probing just to avoid potential bugs in drivers does not
> look to me correct.
> 
> > away from this fact: your approach _forces_ a split up of the
> > initialisation into dependent two stages and that fact _alone_ adds
> > additional complexity, and along with that additional complexity comes
> > more opportunity for bugs. 
> 
> This sound so funny, just look at componentize patches - every patch
> adds two stage initialization for every component and the master,
> with forced unwinding and two levels of devres management.

*Sigh*.  Why am I bothering discussing this with you.

*NO* it does not, for the VERY SIMPLE reason that NOTHING is done before
the BIND.  NO structures are allocated.  NOTHING is setup.  The *only*
thing that is done is the driver registers with the component helper.

That's not two stage initialisation.  That's *single* stage.

> 'My approach' adds only one call to probe and one call to remove of
> components, and very simple and straightforward interface to the master.

You're talking utter garbage there.

> 'My approach' is very standard - during probe driver probes hardware,
> and registers interfaces which can be used by other drivers, for example
> by drm master. The only addition is reporting its readiness. Comparing to
> 'your approach' it is bloody simple.

More unbelievable crap.

> >  Also with that additional complexity comes
> > the need to perform more tests to find those bugs, and given that most
> > people just say "okay, it boots and seems to work, that's good enough
> > for me" there is a high possibility that these kinds of bugs will take
> > a long time to find.
> 
> Volume of changes for each component and drm device management
> dispersed on all components makes your argument very valid for
> component subsystem.
> 
> Btw have you observed component framework when one of the components
> during bind returns -EPROBE_DEFER ? In my tests it resulted in
> deferred probing of master and unbind/bind of other components.
> So lets say you have N components and the last component will be deferred
> K times, it results in:
> - K times deferring of the last component and the master,
> - (N - 1) * K - unbinds and binds of other components.

True, and you can't get away from that with proper behaviour.

> >> As I wrote already, this framework was proposed for drivers which
> >> are tied together anyway, and this is case of many drivers, not
> >> only exynos.
> > Please name them.

You ignored this.  Therefore, I assume that you *can't* name them because
there *aren't* any.  I called your bluff, I win.

> > At the moment, I don't see a justification for your "simplified"
> > and restrictive solution, which if used will lock drivers into that
> > simplisitic method, and which can't ever be extended without lots of
> > ifdeffery to having other components (such as TDA998x) attached.
> >
> > My objections are entirely based on where imx-drm and armada DRM are
> > going, neither of which could ever use your implementation.
> >
> > Before you say that it isn't meant to deal with stuff like the TDA998x,
> > take a moment to think about this - the Dove video subsystem was
> > designed to support OLPC.  It was primerly designed to drive a LCD
> > screen plus an on-board VGA DAC.  Everything for that is on-SoC.  With
> > that, the hardware is well known, and your solution could be used.
> >
> > However, then SolidRun came along and dropped a TDA998x on the LCD output
> > pins.  Suddenly, things aren't that simple, and your solution falls
> > apart, because it can't cope with a generic component that has no knowledge
> > of the rest of its "master".
> >
> > This kind of scenario can happen /any/ time, and any time it does happen,
> > your simple solution falls apart.
> 
> I think I have answered you two or three times that it is not a problem
> to remove
> 'glued drivers' restriction. I desperately try to avoid accusing you for
> 'desperately
> playing down' on this subject, so I will not comment this anymore.

Right, so what I draw from this is that *you* again refuse to answer this
point because despite your assertions that your solution can do it, you
have no clue as to *how* it can be done.  I've looked at your solution
with respect to this, and I *can't* see how it can be done either.  That's
why I've been asking *you* the question, so that *you* can provide some
technical input to it.

> On the other hand you have not answered quite important question - how
> do you plan to componentize drivers shared by different drms when
> one of drms is not componentized???

Read this, from a message I sent at the beginning of February:
| Here's my changes to the TDA998x driver to add support for the component
| helper.  The TDA998x driver retains support for the old way so that
| drivers can be transitioned.  For any one DRM "card" the transition to
| using the component layer must be all-in or all-out - partial transitions
| are not permitted with the simple locking implementation currently in
| the component helper due to the possibility of deadlock.  (Master
| binds, holding the component lock, master declares i2c device, i2c
| device is bound to tda998x, which tries to register with the component
| layer, trying to take the held lock.)
| 
| http://ftp.arm.linux.org.uk/cgit/linux-cubox.git/log/?h=unstable/tda998x-devel

It would appear that I've already converted a driver there into a
structure where it can exist as either a componentised device, _or_
it can exist as a DRM slave device.

Ergo, your claim that I haven't answered this question is... interesting
because I seem to have an implementation dated over two months ago.

So, maybe you would like to finally address *my* point about TDA998x
and your solution in a way that provides a satisfactory answer.  *Show*
how it can be done, or *outline* how it can be done.

If you can't or won't do either of those, I shall continue to regard your
solution as highly sub-optimal and only suitable for exynos, and continue
to request that it should live in drivers/gpu/drm/exynos and not
drivers/base.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
