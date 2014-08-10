Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaHJBgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 21:36:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58752 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751548AbaHJBgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 21:36:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "Mateo Lozano, Oscar" <oscar.mateo@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH 45/53] drm/i915/bdw: Do not call intel_runtime_pm_get() in an interrupt
Date: Sun, 10 Aug 2014 03:55:34 +0200
Message-ID: <1766626.v17BJSfQ4M@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKMK7uH8MU5awyVDLNi8h-+yrrSRW8JjV20aMZwXZ9Yw9XDZgA@mail.gmail.com>
References: <100550251.L4NDXYU9Wh@vostro.rjw.lan> <Pine.LNX.4.44L0.1408082111240.17430-100000@netrider.rowland.org> <CAKMK7uH8MU5awyVDLNi8h-+yrrSRW8JjV20aMZwXZ9Yw9XDZgA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 09, 2014 10:53:03 AM Daniel Vetter wrote:
> On Sat, Aug 9, 2014 at 3:21 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sat, 9 Aug 2014, Rafael J. Wysocki wrote:
> >
> >> > > > Well it works currently. So where do you see the problem?
> >> > >
> >> > > Sampling registers from an timer - in particular, we really do not want
> >> > > to disable runtime pm whilst trying to monitor the impact of runtime pm.
> >> >
> >> > In that case you can grab a runtime pm reference iff the device is powered
> >> > on already. Which won't call anything scary, just amounts to an
> >> > atomic_add_unless or so, and then drop it again.
> >> >
> >> > Unfortunately there doesn't seem to be such a thing around already, so
> >> > need to add it first. Greg, how much would you freak out if we add
> >> > something like
> >> >
> >> > /**
> >> >  * pm_runtime_get_unless_suspended - grab a rpm ref if the device is on
> >> >  *
> >> >  * Returns true if an rpm ref has been acquire, false otherwise. Can be
> >> >  * called from atomic context to e.g. sample perfomance counters (where we
> >> >  * obviously don't want to disturb system state if everything is off atm).
> >> >  */
> >> > static inline bool pm_runtime_get_unless_suspended(struct device *dev)
> >> > {
> >> >     return atomic_add_unless(&dev->power.usage_count, 1, 0);
> >> > }
> >>
> >> I don't think it'll work universally.
> >>
> >> That'd need to be synchronized with other stuff done under the spinlock
> >> and in fact, what you're interested in is runtime_status (and that being
> >> RPM_ACTIVE) and not just the usage count.
> >
> > That's right.  You'd need to acquire the spinlock, test runtime_status,
> > do the register sampling if the status is RPM_ACTIVE, and then drop the
> > spinlock.
> >
> > I suppose wrapper routines for acquiring and releasing the spinlock
> > could be added to the runtime-PM API.  Something like this:
> >
> > #define pm_runtime_lock(dev, flags)                     \
> >                 spin_lock_irqsave(&(dev)->power.lock, flags)
> > #define pm_runtime_unlock(dev, flags)                   \
> >                 spin_unlock_irqrestore(&(dev)->power.lock, flags)
> >
> > It looks a little silly but it would work.
> 
> Oh right, I've totally ignored all the async resuming/suspending
> stuff. Anyway what we want to do is sample a perf monitoring unit on
> the gpu from an hrtimer and then expose that as a perf pmu. But we
> don't want to wake up the gpu for the sampling or hold a special
> reference, since that disturbs the sampling and also tends to upset
> the gpu.

The way to go is as Alan said: take the spinlock, check the runtime status,
do stuff and release the spinlock.

Rafael

