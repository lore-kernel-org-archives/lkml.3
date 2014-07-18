Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030454AbaGRPTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:19:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54838 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756009AbaGRPTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:19:08 -0400
Date: Fri, 18 Jul 2014 11:19:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Dmitry Torokhov <dtor@google.com>, Bastien Nocera <hadess@hadess.net>,
        Patrik Fimml <patrikf@chromium.org>, <linux-pm@vger.kernel.org>,
        Benson Leung <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
In-Reply-To: <2674541.jV2qHCZlHf@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1407181107450.979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Rafael J. Wysocki wrote:

> > > the problem really seems to be that drivers are not
> > > aggressive enough with starting PM transitions (using runtime PM) when they
> > > see no activity.  Thus it seems that when the lid is closed, it'll be good
> > > to switch the drivers into a "more aggressive runtime PM mode" in which
> > > they will use any opportunity to start a power transition without worrying
> > > about extra latencies resulting from that.  In that mode they should also
> > > disable remote wakeup.  I think this should be sufficient to address the
> > > use case at hand.
> > 
> > OK, so how do we let the drivers know that they should start being aggressive 
> > with PM and that they should disable remote wakeup? I'd rather not add 
> > subsystem-specific interface for this, that is why we are reaching out in the 
> > first place.
> 
> For disabling remote wakeup we have a PM QoS flag that I'm not entirely happy
> with, so I guess we can replace it with something saner (I talked about that
> with Alan during the last year's LinuxCon, but then didn't have the time to
> get to that).

Right.  We discussed changing .../power/wakeup so that it could contain
"enabled", "disabled", or "off", where "off" would mean remote wakeup
should be disabled even during runtime suspend.

> For the whole thing I guess we can add a sysfs attribute under devices/.../power
> that will need to be exposed by drivers supporting that feature.  I'm not sure
> how to call it, though.

"runtime_mode"?

Will this really be capable of doing what Dmitry wants?  I don't know
how the drivers in question work.  But if a driver increments the
runtime usage count each time the device file is opened, forcibly
setting the usage count back to 0 won't be easy.

Also, would putting the camera into runtime suspend prevent it from
showing up on a list of available video devices?  I doubt it.  More
likely, the video driver would have to unregister the class device
while remaining bound to the physical device.  Probably other drivers
would have to do the same sort of thing.  (I don't know whether doing
this would retain the settings as Oliver wants, though.)

Alan Stern

