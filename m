Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaGRWBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:01:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60540 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752591AbaGRWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:01:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dtor@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Patrik Fimml <patrikf@chromium.org>,
        Bastien Nocera <hadess@hadess.net>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in time
Date: Sat, 19 Jul 2014 00:19:39 +0200
Message-ID: <2443949.K0iePsg3Aa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <17819865.W1zWUlPo9n@dtor-glaptop>
References: <Pine.LNX.4.44L0.1407181557020.979-100000@iolanthe.rowland.org> <1539989.Y0kuKjTTVX@vostro.rjw.lan> <17819865.W1zWUlPo9n@dtor-glaptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 18, 2014 02:45:40 PM Dmitry Torokhov wrote:
> On Friday, July 18, 2014 11:59:18 PM Rafael J. Wysocki wrote:
> > On Friday, July 18, 2014 02:26:21 PM Dmitry Torokhov wrote:
> > > On Friday, July 18, 2014 04:09:46 PM Alan Stern wrote:
> > > > On Fri, 18 Jul 2014, Patrik Fimml wrote:
> > > > > On Fri, Jul 18, 2014 at 03:00:46PM -0400, Alan Stern wrote:
> > [cut]
> > 
> > > > > I'm not sure what the appropriate action for a video camera is anyway.
> > > > > Should it go away completely, including its device? Should it be
> > > > > there,
> > > > > but certainly not be the default choice when there is an external
> > > > > camera? I'm thinking along the lines of some application's settings
> > > > > dialog here, where it might be desirable to still be able to select
> > > > > the
> > > > > internal camera for future recordings.
> > > > > 
> > > > > Of course, userspace could still decide simply not to
> > > > > quiesce|deactivate|inhibit the device if that was desired.
> > > > 
> > > > There's some question about how much of userspace needs to get
> > > > involved.  Just the daemon that manages these configuration changes, or
> > > > other programs as well?  I guess that's not really our problem...
> > > 
> > > We need to provide means of implementing policy; the policy itself is not
> > > really our concern ;)
> > > 
> > > > In the end, it sounds like you're suggesting a new pair of PM
> > > > callbacks: ->deactivate() and ->reactivate(), or ->inhibit() and
> > > > ->uninhibit().  Plus an optional (?) sysfs interface for invoking the
> > > > callbacks.
> > > 
> > > We do need sysfs interface so that userspace can talk to the devices in
> > > question; and we also need to make sure that PM core is aware of the new
> > > callbacks and provides guarantees about their interactions with system-
> > > and
> > > runtime-PM callbacks so that individual drivers do not have to sort it out
> > > on their own.
> > 
> > A step back, please.
> > 
> > I have no idea why those need to be PM callbacks.
> > 
> > What you need really seems to be a way to tell a driver "ignore input from
> > this device from now on as it is most likely bogus".  A natural reaction of
> > the driver to that might be to stop processing input from the device and
> > then runtime suspend it (and prevent it from generating remote wakeup as
> > that may be bogus as well), but I don't see why the PM core needs to be
> > involved in that at all.
> 
> So that we do not need to handle cases like:
> 
> - I am already in idle state and request comes to inhibit, what do I do (in 
> driver) or:

I'm not sure why being "suspended" or not matters here.  The PM core doesn't
know what physical state the device is in anyway and the driver or subsystem
(or another layer such as ACPI) has to track that.

Also it seems that it should be perfectly fine to ignore input from the device
without suspending it as well as it is perfectly fine to be suspended while
you are generally not ignoring the input (just because there is no input at
the moment, for example).

Yes, it make sense to suspend the device when you know you'll ignore input going
forward, but then if the real goal is to prevent bogus input from reaching
applications, then this isn't a power management problem even.

> - I inhibited the device, now system suspend comes, what do I do? Also what do 
> I do at resume? I'd rather not have driver checks host of flags to figure out 
> the end state if PM core could spell it out for me.

Well, how will the new PM callbacks help here, exactly?

> We already have to sort 
> out open/close and suspend/resume iteractions (i.e what one needs to do to 
> suspend or resume device that has not been opened, and if it is different from 
> devices that have been opened).

I guess it would help if you gave an example.

Rafael

