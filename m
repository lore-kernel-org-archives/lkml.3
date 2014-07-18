Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946077AbaGRV00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:26:26 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59995 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbaGRV0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:26:24 -0400
From: Dmitry Torokhov <dtor@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrik Fimml <patrikf@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bastien Nocera <hadess@hadess.net>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in time
Date: Fri, 18 Jul 2014 14:26:21 -0700
Message-ID: <1660498.3ZcWSfNcWh@dtor-glaptop>
Organization: Google, Inc.
User-Agent: KMail/4.13.2 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1407181557020.979-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1407181557020.979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 18, 2014 04:09:46 PM Alan Stern wrote:
> On Fri, 18 Jul 2014, Patrik Fimml wrote:
> > On Fri, Jul 18, 2014 at 03:00:46PM -0400, Alan Stern wrote:
> > > "Quiescing" is the wrong word.  "Quiescing a device" means stopping the
> > > device from doing anything, which isn't what you want.  You want to
> > > ignore any activity the device may generate and reduce the device's
> > > power consumption as much as possible.  A better word would be
> > > "deactivating".
> > 
> > Yeah, I agree that terminology is a bit tricky here, and we have some
> > words conveying a specific idea already ("suspend"). To me, deactivating
> > suggests a more permanent condition. FWIW, I've used "inhibit" in this
> > context before and think it captures the idea well, to add another
> > choice to the list.
> 
> Well, you can always reactivate a device after it has been deactivated.
> But "inhibit" is good too.
> 
> > > You mentioned that handles to the device would remain open.  So when
> > > the user opens the lid again, the old handles would start functioning,
> > > right?
> > 
> > That's the idea, yes, and I think this would be desirable for the input
> > device class at least.
> 
> For the input class, it may not matter.  For example, the X server
> should deal well with a touchpad that effectively gets hot-unplugged
> and then hot-plugged later.

I thin kit would be nice if we could differentiate between unplugged 
(physically gone) and disabled devices. If we shut off the touchpad does it 
mean that user can't use UI to activate edge scrolling vs. two-finger 
scrolling because our implementation made device to vanish?

> 
> > > This has the disadvantage that the class device could not be
> > > unregistered, because doing so would invalidate the open handles.
> > > Under such circumestances, how would a userspace video program know not
> > > to list a camera built into the lid among the possible video sources
> > > (an example given earlier in this discussion)?  The program would have
> > > to make an explicit test of the "deactivate" property -- it wouldn't
> > > automatically become aware that the camera wasn't available.
> > > 
> > > Would it sometimes be okay to unregister the class device and
> > > invalidate the old handles, forcing programs to open new handles when
> > > the lid is opened?  This would reduce the number of changes user
> > > programs would need.
> > 
> > I guess we could potentially leave this for the device class to decide.
> 
> Makes sense.
> 
> > I'm not sure what the appropriate action for a video camera is anyway.
> > Should it go away completely, including its device? Should it be there,
> > but certainly not be the default choice when there is an external
> > camera? I'm thinking along the lines of some application's settings
> > dialog here, where it might be desirable to still be able to select the
> > internal camera for future recordings.
> > 
> > Of course, userspace could still decide simply not to
> > quiesce|deactivate|inhibit the device if that was desired.
> 
> There's some question about how much of userspace needs to get
> involved.  Just the daemon that manages these configuration changes, or
> other programs as well?  I guess that's not really our problem...

We need to provide means of implementing policy; the policy itself is not 
really our concern ;)

> 
> In the end, it sounds like you're suggesting a new pair of PM
> callbacks: ->deactivate() and ->reactivate(), or ->inhibit() and
> ->uninhibit().  Plus an optional (?) sysfs interface for invoking the
> callbacks.

We do need sysfs interface so that userspace can talk to the devices in 
question; and we also need to make sure that PM core is aware of the new 
callbacks and provides guarantees about their interactions with system- and 
runtime-PM callbacks so that individual drivers do not have to sort it out on 
their own.

Thanks,
Dmitry

