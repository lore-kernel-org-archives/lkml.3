Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaHHNlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:41:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaHHNln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:41:43 -0400
Date: Fri, 8 Aug 2014 06:41:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Chris Wilson <chris@chris-wilson.co.uk>, oscar.mateo@intel.com,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH 45/53] drm/i915/bdw: Do not call
 intel_runtime_pm_get() in an interrupt
Message-ID: <20140808134110.GB4427@kroah.com>
References: <1402673891-14618-1-git-send-email-oscar.mateo@intel.com>
 <1402673891-14618-46-git-send-email-oscar.mateo@intel.com>
 <20140618205413.GH5821@phenom.ffwll.local>
 <20140726102738.GA21056@nuc-i3427.alporthouse.com>
 <20140728085406.GX4747@phenom.ffwll.local>
 <20140729073748.GD21570@nuc-i3427.alporthouse.com>
 <20140729102636.GK4747@phenom.ffwll.local>
 <20140808092040.GD3021@nuc-i3427.alporthouse.com>
 <20140808093701.GO8727@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808093701.GO8727@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 11:37:01AM +0200, Daniel Vetter wrote:
> On Fri, Aug 08, 2014 at 10:20:40AM +0100, Chris Wilson wrote:
> > On Tue, Jul 29, 2014 at 12:26:36PM +0200, Daniel Vetter wrote:
> > > On Tue, Jul 29, 2014 at 08:37:48AM +0100, Chris Wilson wrote:
> > > > On Mon, Jul 28, 2014 at 10:54:06AM +0200, Daniel Vetter wrote:
> > > > > On Sat, Jul 26, 2014 at 11:27:38AM +0100, Chris Wilson wrote:
> > > > > > On Wed, Jun 18, 2014 at 10:54:13PM +0200, Daniel Vetter wrote:
> > > > > > > On Fri, Jun 13, 2014 at 04:38:03PM +0100, oscar.mateo@intel.com wrote:
> > > > > > > > From: Oscar Mateo <oscar.mateo@intel.com>
> > > > > > > > 
> > > > > > > > Or with a spinlock grabbed, because it might sleep, which is not
> > > > > > > > a nice thing to do. Instead, do the runtime_pm get/put together
> > > > > > > > with the create/destroy request, and handle the forcewake get/put
> > > > > > > > directly.
> > > > > > > > 
> > > > > > > > Signed-off-by: Oscar Mateo <oscar.mateo@intel.com>
> > > > > > > 
> > > > > > > Looks like a fixup that should be squashed into relevant earlier patches.
> > > > > > 
> > > > > > The whole gen6_gt_force_wake_get() calling intel_runtime_pm_get() is
> > > > > > broken due to this - we must be able to read registers in atomic
> > > > > > context!
> > > > > > 
> > > > > > Please revert c8c8fb33b37766acf6474784b0d5245dab9a1690
> > > > > 
> > > > > force_wake_get can't call runtime_pm_get becuase pm_get can sleep. So if
> > > > > you want to read registers from atomic context you have to have a runtime
> > > > > pm reference from someone else.
> > > > 
> > > > Nope. That cannot work.
> > > 
> > > Well it works currently. So where do you see the problem?
> > 
> > Sampling registers from an timer - in particular, we really do not want
> > to disable runtime pm whilst trying to monitor the impact of runtime pm.
> 
> In that case you can grab a runtime pm reference iff the device is powered
> on already. Which won't call anything scary, just amounts to an
> atomic_add_unless or so, and then drop it again. 
> 
> Unfortunately there doesn't seem to be such a thing around already, so
> need to add it first. Greg, how much would you freak out if we add
> something like
> 
> /**
>  * pm_runtime_get_unless_suspended - grab a rpm ref if the device is on
>  * 
>  * Returns true if an rpm ref has been acquire, false otherwise. Can be
>  * called from atomic context to e.g. sample perfomance counters (where we
>  * obviously don't want to disturb system state if everything is off atm).
>  */
> static inline bool pm_runtime_get_unless_suspended(struct device *dev)
> {
> 	return atomic_add_unless(&dev->power.usage_count, 1, 0);
> }

I'd freak out a lot :)

Rafael, isn't there some other better way to resolve this issue without
resorting to something as "horrid" as the above?

thanks,

greg k-h
