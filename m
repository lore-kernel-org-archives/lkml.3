Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422738AbaGRRrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:47:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52724 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030534AbaGRRrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:47:15 -0400
Date: Fri, 18 Jul 2014 10:47:12 -0700
From: Patrik Fimml <patrikf@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dmitry Torokhov <dtor@google.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in
 time
Message-ID: <20140718174712.GA3156@google.com>
References: <Pine.LNX.4.44L0.1407171029210.1517-100000@iolanthe.rowland.org>
 <3088260.XkiUM6Vtxh@dtor-glaptop>
 <8587268.sIIBz6Y2QN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8587268.sIIBz6Y2QN@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 02:43:02AM +0200, Rafael J. Wysocki wrote:
> From past discussions on similar topics it followed that there really was
> no generic way for individual drivers to quiesce devices on demand as long as
> user space was running.  Everything we could come up with was racy, this way or
> another.  That is the reason for using the freezer during system suspend.  In
> other words, if you want drivers to quiesce devices by force, you need to quiesce
> user space by force to start with - for example by freezing it.

Can you give me some pointers?

> For runtime PM, on the other hand, the underlying observation is that drivers
> should be able to detect when devices are already quiescent and initialize power
> transitions at those points.  It's role is to help with that, but not with quiescing
> things.
> 
> That said, in the "laptop lid closed" scenario (assuming that the system is not
> supposed to suspend in response to that, which in my opinion is the best approach)
> the problem really seems to be that drivers are not aggressive enough with starting
> PM transitions (using runtime PM) when they see no activity.  Thus it seems that
> when the lid is closed, it'll be good to switch the drivers into a "more aggressive
> runtime PM mode" in which they will use any opportunity to start a power transition
> without worrying about extra latencies resulting from that.  In that mode they
> should also disable remote wakeup.  I think this should be sufficient to address
> the use case at hand.

Let me try to clear things up a little.

Of course, in most cases, a laptop would enter suspend after closing the
lid. But you can think of scenarios where the laptop would stay on:
- Your laptop is docked, and you use an external monitor, but you don't
  want to have your laptop open (maybe due to lack of space).
- You have your laptop in your backpack and use it as a music player.

In those scenarios, you wouldn't want to see bogus input (our worst-case
example is the mouse pointer being over the 1-Click Buy button on
Amazon - stray clicks that result from the laptop lid interfering with
the touchpad wouldn't be a good thing).

Now there are basically two approaches with pros and cons:

 1. Get userspace to close handles to all such devices while the lid is
    closed, and
1a. Have drivers with sufficiently aggressive PM so that devices are
    actually going to a low-power/off state when userspace doesn't have
    any handles open.

This can be done with the infrastructure that we have in the kernel
today, although drivers might have to be improved in order to actually
get devices to power off.

 2. Give userspace a way of quiescing a device. Handles to the device
    stay open, but the device will no longer perform its function and,
    if possible, power down.

For input devices, this makes a lot of sense in my opinion.

The notable difference to runtime PM as we have it today is that with
runtime PM, a device typically goes to a low-power state because it is
idle. In our scenario, we want to forcibly quiesce it even if it is not
idle (and if it continues to provide events in a low-power mode, we
want to ignore them instead of passing them on). So maybe integration
with runtime PM is not the best fit.

Perhaps the best way to go forward would be to add a new property for
all devices that support quiescing so userspace has a uniform way of
doing things, but have subsystems (and potentially the device driver)
decide what action is appropriate to quiesce a device. Some subsystems
might be able to provide a default implementation (e.g. input could just
skip all events that are reported from the device driver).

Regards,
Patrik
