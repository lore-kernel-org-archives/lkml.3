Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaHIBV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 21:21:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37118 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755992AbaHIBVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 21:21:22 -0400
Date: Fri, 8 Aug 2014 21:21:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Daniel Vetter <daniel@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
        <oscar.mateo@intel.com>, <intel-gfx@lists.freedesktop.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH 45/53] drm/i915/bdw: Do not call
 intel_runtime_pm_get() in an interrupt
In-Reply-To: <100550251.L4NDXYU9Wh@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1408082111240.17430-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2014, Rafael J. Wysocki wrote:

> > > > Well it works currently. So where do you see the problem?
> > > 
> > > Sampling registers from an timer - in particular, we really do not want
> > > to disable runtime pm whilst trying to monitor the impact of runtime pm.
> > 
> > In that case you can grab a runtime pm reference iff the device is powered
> > on already. Which won't call anything scary, just amounts to an
> > atomic_add_unless or so, and then drop it again. 
> > 
> > Unfortunately there doesn't seem to be such a thing around already, so
> > need to add it first. Greg, how much would you freak out if we add
> > something like
> > 
> > /**
> >  * pm_runtime_get_unless_suspended - grab a rpm ref if the device is on
> >  * 
> >  * Returns true if an rpm ref has been acquire, false otherwise. Can be
> >  * called from atomic context to e.g. sample perfomance counters (where we
> >  * obviously don't want to disturb system state if everything is off atm).
> >  */
> > static inline bool pm_runtime_get_unless_suspended(struct device *dev)
> > {
> > 	return atomic_add_unless(&dev->power.usage_count, 1, 0);
> > }
> 
> I don't think it'll work universally.
> 
> That'd need to be synchronized with other stuff done under the spinlock
> and in fact, what you're interested in is runtime_status (and that being
> RPM_ACTIVE) and not just the usage count.

That's right.  You'd need to acquire the spinlock, test runtime_status, 
do the register sampling if the status is RPM_ACTIVE, and then drop the 
spinlock.

I suppose wrapper routines for acquiring and releasing the spinlock
could be added to the runtime-PM API.  Something like this:

#define pm_runtime_lock(dev, flags)			\
		spin_lock_irqsave(&(dev)->power.lock, flags)
#define pm_runtime_unlock(dev, flags)			\
		spin_unlock_irqrestore(&(dev)->power.lock, flags)

It looks a little silly but it would work.

Alan Stern

