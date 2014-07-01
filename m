Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbaGARGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:06:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50294 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758477AbaGARGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:06:49 -0400
Date: Tue, 1 Jul 2014 18:06:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701170643.GA32514@n2100.arm.linux.org.uk>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com> <20140701131026.GO32514@n2100.arm.linux.org.uk> <20140701165319.GH23978@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701165319.GH23978@titan.lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 12:53:19PM -0400, Jason Cooper wrote:
> Russell,
> 
> On Tue, Jul 01, 2014 at 02:10:26PM +0100, Russell King - ARM Linux wrote:
> > On Tue, Jul 01, 2014 at 03:04:31PM +0200, Sebastian Hesselbarth wrote:
> > > +	pdev = platform_device_register_full(&armada_drm_dev_info);
> > > +	/* assign last found lcd node to drm device for clk lookup */
> > > +	pdev->dev.of_node = clknp;
> > 
> > NAK.  This really isn't a good way to deal with this, even in a
> > temporary basis.  While assigning a DT node to a manually created
> > platform device does solve that problem, it also introduces the
> > problem that this platform device will now match any platform driver
> > which recognises the "marvell,dove-lcd" compatible type, which may
> > occur _before_ we find the driver to match using the legacy strings.
> > 
> > There really isn't an easy solution to this other than doing the thing
> > properly.
> 
> And this creates our current deadlock.

Right, and what it does is it creates /another/ deadlock.  Let's say
that we get those changes in place in the mvebu tree.

I'm pushing to get the component stuff in place right now.  Once it's
in place, I'll be pushing the Armada DRM stuff forward.  Let's say
that gets in.

We now have a problem.  The mvebu stuff now creates a platform device
which will bind with the CRTC part of Armada DRM, rather than the
master part and everything now breaks.

So, rather than having a component / DRM problem, it ends up becoming
a component / DRM / mvebu problem - rather than just two subsystems
needing coordination, we end up with /another/ subsystem to contend
with as well.

> > The other problem in this series is that while you introduce some
> > bindings which may work today, they're not going to work tomorrow, and
> > that's a problem.  Don't do DT piecemeal like this and end up having to
> > break the bindings (which we will have to do to add the endpoints.)
> 
> Seriously, we've got to do something to get off of the X.  Why not just
> declare the binding Sebastian just sent as unstable?  Then we change it
> as needed until we get all the pieces in place.

As I've already pointed out, why not add the complete binding right now
and be done with it?  That would sort out my concern about DT, and -
as I've already said (again) - we know exactly how this should look
because we have the of_graph stuff in drivers/of as standard helpers,
and we have imx-drm and v4l2 media stuff using it already.  It's
well established, and I've demonstrated that Armada DRM _will_ also
conform.

In fact, I have plans to consolidate the code between Armada DRM and
imx-drm into some standard DRM helpers (if you read through the patches
I linked to on cgit, you will notice that has already started.)

But... the DT issue is relatively minor compared to the one which I
raise above, which adds to the problems of moving forward.  It
effectively means I need to then carry a patch which undoes that,
and that patch would need to go through the DRM tree along with the
rest of the Armada DRM updates, which means more people need to be
involved, which then makes the process even slower than it already
is.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
