Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbaGRBRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:17:43 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49683 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752760AbaGRBRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:17:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dtor@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Bastien Nocera <hadess@hadess.net>,
        Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in time
Date: Fri, 18 Jul 2014 03:35:58 +0200
Message-ID: <15990629.Z6g24UroS8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2674541.jV2qHCZlHf@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1407171029210.1517-100000@iolanthe.rowland.org> <4468130.Uu9vndH3sC@dtor-glaptop> <2674541.jV2qHCZlHf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 18, 2014 03:30:31 AM Rafael J. Wysocki wrote:
> On Thursday, July 17, 2014 05:43:42 PM Dmitry Torokhov wrote:
> > On Friday, July 18, 2014 02:43:02 AM Rafael J. Wysocki wrote:
> > > On Thursday, July 17, 2014 09:59:19 AM Dmitry Torokhov wrote:
> > > > On Thursday, July 17, 2014 10:39:16 AM Alan Stern wrote:
> > > > > On Wed, 16 Jul 2014, Dmitry Torokhov wrote:
> > > > > > We are not planning on implementing the policy in kernel, that's
> > > > > > indeed task for userspace; but unless we bring in the heavy hammer of
> > > > > > forcibly unbinding drivers, we do not currently have universal
> > > > > > mechanism of quiescing devices.
> > > > > 
> > > > > We sort of do: the ->freeze() callback.  But it wasn't intended for
> > > > > this kind of use; drivers may very well expect that userspace will
> > > > > already be frozen when the callback runs.  Besides, ->freeze() is
> > > > > supposed to quiesce devices without powering them down, whereas you
> > > > > want to do both.
> > > > 
> > > > Right.
> > > > 
> > > > > What you're asking for is different from anything the PM subsystem has
> > > > > done before.
> > > > 
> > > > Right.
> > > > 
> > > > > Given this fact, I don't see any alternatives to adding a
> > > > > new API or repurposing an existing API.  Either one would be somewhat
> > > > > painful.
> > > > > 
> > > > > For example, we could arrange to invoke ->suspend().  However, since
> > > > > the circumstances would be unusual (userspace is still running,
> > > > > ->prepare() was not called beforehand, ->suspend_irq() won't be called
> > > > > afterward), subsystems and drivers may very well react inappropriately.
> > > > 
> > > > I do not think anybody expects that drivers would not have to be modified
> > > > to support this functionality; I expect drivers would have to declare
> > > > themselves "queiscable" and therefore would assert that they will act
> > > > according to whatever rules we set up. I only want to make sure that this
> > > > new state is added to existing list of PM states rather than creating
> > > > completely new facility, so that driver authors have a chance to
> > > > understand PM state transitions that involve their driver.
> > > 
> > > If you're referring to runtime PM, it doesn't use "states".  It uses status
> > > values (you can think of them as metastates) which are "active", "suspended"
> > > or in-transit from one to the other.  There's no room for more of these in
> > > the design, I'm afraid.
> > > 
> > > Moreover, .runtime_suspend() can only be called when the device is quiescent
> > > already.  [That also applies to .suspend_late() and .suspend_irq() for
> > > system suspend and the freezing of tasks is requisite for the .prepare()
> > > and .suspend() callbacks (and the corresponding hibernation-related ones).]
> > > 
> > > From past discussions on similar topics it followed that there really was
> > > no generic way for individual drivers to quiesce devices on demand as long
> > > as user space was running.  Everything we could come up with was racy, this
> > > way or another.  That is the reason for using the freezer during system
> > > suspend.  In other words, if you want drivers to quiesce devices by force,
> > > you need to quiesce user space by force to start with - for example by
> > > freezing it.
> > > 
> > > For runtime PM, on the other hand, the underlying observation is that
> > > drivers should be able to detect when devices are already quiescent and
> > > initialize power transitions at those points.  It's role is to help with
> > > that, but not with quiescing things.
> > > 
> > > That said, in the "laptop lid closed" scenario (assuming that the system is
> > > not supposed to suspend in response to that, which in my opinion is the
> > > best approach)
> > 
> > This is default approach that works for many, but not necessarily all  use 
> > cases. I believe docked with lid closed scenario was mentioned already.
> > 
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
> 
> For the whole thing I guess we can add a sysfs attribute under devices/.../power
> that will need to be exposed by drivers supporting that feature.  I'm not sure
> how to call it, though.

Or we could add an "aggressive" value to the devices/.../power/control attribute,
but then it will be difficult for user space to verify whether or not it is
supported for the given device.

Rafael

