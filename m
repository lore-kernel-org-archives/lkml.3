Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaLPOvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:51:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:35817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaLPOvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:51:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,587,1413270000"; 
   d="scan'208";a="624617213"
Message-ID: <1418740692.7338.33.camel@intelbox>
Subject: Re: [PATCH v4 3/3] vt: fix console lock vs. kernfs s_active lock
 order
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2014 16:38:12 +0200
In-Reply-To: <54902AA1.7080301@hurleysoftware.com>
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
		 <1418681761-3709-3-git-send-email-imre.deak@intel.com>
		 <20141216075300.GI2711@phenom.ffwll.local>
	 <1418725405.3185.31.camel@ideak-mobl> <54902AA1.7080301@hurleysoftware.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 07:50 -0500, Peter Hurley wrote:
> On 12/16/2014 05:23 AM, Imre Deak wrote:
> > On Tue, 2014-12-16 at 08:53 +0100, Daniel Vetter wrote:
> >> On Tue, Dec 16, 2014 at 12:16:01AM +0200, Imre Deak wrote:
> >>> Currently there is a lock order problem between the console lock and the
> >>> kernfs s_active lock of the console driver's bind sysfs entry. When
> >>> writing to the sysfs entry the lock order is first s_active then console
> >>> lock, when unregistering the console driver via
> >>> do_unregister_con_driver() the order is the opposite. See the below
> >>> bugzilla reference for one instance of a lockdep backtrace.
> >>>
> >>> Fix this by unregistering the console driver from a deferred work, where
> >>> we can safely drop the console lock while unregistering the device and
> >>> corresponding sysfs entries (which in turn acquire s_active). Note that
> >>> we have to keep the console driver slot in the registered_con_driver
> >>> array reserved for the driver that's being unregistered until it's fully
> >>> removed. Otherwise a concurrent call to do_register_con_driver could
> >>> try to reuse the same slot and fail when registering the corresponding
> >>> device with a minor index that's still in use.
> >>>
> >>> Note that the referenced bug report contains two dmesg logs with two
> >>> distinct lockdep reports: [1] is about a locking scenario involving
> >>> s_active, console_lock and the fb_notifier list lock, while [2] is
> >>> about a locking scenario involving only s_active and console_lock.
> >>> In [1] locking fb_notifier triggers the lockdep warning only because
> >>> of its dependence on console_lock, otherwise case [1] is the same
> >>> s_active<->console_lock dependency problem fixed by this patch.
> >>> Before this change we have the following locking scenarios involving
> >>> the 3 locks:
> >>>
> >>> a) via do_unregister_framebuffer()->...->do_unregister_con_driver():
> >>>    1. console lock 2. fb_notifier lock 3. s_active lock
> >>> b) for example via give_up_console()->do_unregister_con_driver():
> >>>    1. console lock 2. s_active lock
> >>> c) via vt_bind()/vt_unbind():
> >>>    1. s_active lock 2. console lock
> >>>
> >>> Since c) is the console bind sysfs entry's write code path we can't
> >>> change the locking order there. We can only fix this issue by removing
> >>> s_active's dependence on the other two locks in a) and b). We can do
> >>> this only in the vt code which owns the corresponding sysfs entry, so
> >>> that after the change we have:
> >>>
> >>> a) 1. console lock 2. fb_notifier lock
> >>> b) 1. console lock
> >>> c) 1. s_active lock 2. console lock
> >>> d) in the new con_driver_unregister_callback():
> >>>    1. s_active lock
> >>>
> >>> [1] https://bugs.freedesktop.org/attachment.cgi?id=87716
> >>> [2] https://bugs.freedesktop.org/attachment.cgi?id=107602
> >>>
> >>> v2:
> >>> - get console_lock earlier in con_driver_unregister_callback(), so we
> >>>   protect the following console driver field assignments there
> >>> - add code coment explaining the reason for deferring the sysfs entry
> >>>   removal
> >>> - add a third paragraph to the commit message explaining why there are
> >>>   two distinct lockdep reports and that this issue is independent of
> >>>   fb/fbcon. (Peter Hurley)
> >>> v3:
> >>> - clarify further the third paragraph
> >>> v4:
> >>> - rebased on v4 of patch 1/3
> >>>
> >>> Reference: https://bugs.freedesktop.org/show_bug.cgi?id=70523
> >>> Signed-off-by: Imre Deak <imre.deak@intel.com>
> >>
> >> So the normal/simple solution would be to remove the con driver from the
> >> registration while holding required locks, but destroy sysfs stuff after
> >> the critical section.
> >>
> >> The problem is that console unbind/bind/reg/unreg are all done with the
> >> locks held already, and the reason for that is the fbcon/fbdev notifier
> >> chain. You can read up on the story by chasing the commits that added the
> >> various locked do_* functions over the past years.
> >>
> >> Short story is that the notifier chain has it's own mutex and any call
> >> mediated through it introces that lock into the chain, which creates a
> >> massive pile of additional depencies. The only solution is to grab _all_
> >> required locks outside of that notifier chain, which means we've spent a
> >> lot of patches growing the scope of console_lock. Which is bad, since
> >> anything holding console_lock can't get dmesg lines out when it dies.
> > 
> > These are independent issues from what this patch fixes. It doesn't try
> > to grow the scope of console_lock either, it makes the sysfs s_active
> > lock independent of console_lock.
> > 
> >> This patch here is another step into the wrong direction imo. It's also
> >> for a feature that mere users should never use (even though it's in
> >> sysfs). Heck it's a regression which has been introduced by pulling
> >> console_lock out&up, before that effort sysfs files worked correctly and
> >> implemented locking as described.
> > 
> > It doesn't matter where you take console_lock, since it's fixed where
> > s_active is taken (in the vfs code before the sysfs entry's write hook
> > is called). So again this issue is not related to the growing scope of
> > console_lock. This fix makes the s_active lock independent of
> > console_lock, so I don't see why it's a step in the wrong direction.
> > 
> >> The right solution imo here is to at least cut up the fbdev notifier into
> >> the different uses so that the locking artificial locking inversions go
> >> away. Most of the calls are used to go from fbdev core (fbmem.c) to the
> >> fbcon.c. Apparently someone though it would be great to allow fb.ko and
> >> fbcon.ko to be able to load in any order whatsoever. Then there's various
> >> other calls that go the other direction (e.g. fbcon calling into backlight
> >> logic) and those introduce the locking inversion. So if we split things
> >> into 2 notifier chais, one to exclusively call into fbcon and the other
> >> for everything else we could revert all the patche that move console_lock
> >> out and fix this bug here properly.
> >>
> >> So NACK from me for this.
> > 
> > I think I proved it in the commit message that this issue is independent
> > of fbcon/fbdev, so refactoring these will not solve it. This patch fixes
> > an issue in vt and while your points may be valid, they are not really
> > about this issue or how the patch fixes it.
> 
> I think you may have missed Daniel's point. Which is what I was trying to
> point out earlier but in an overly terse manner.

I did get what Daniel said and they are valid points. They require more
work though and since things are broken in the vt code right now we
should try to fix it there, instead of waiting for those planned changes
elsewhere to take place.

The fix will be anyway the same in principal even after Daniel's planned
rework for fbcon/fbdev: not holding the console_lock while freeing the
sysfs entries. The only difference is that this happens in a deferred
work in my patch vs. the same thread after the planned refactoring.

> If you start by just moving the sysfs teardown outside the console_lock
> (but still in the same thread of execution), then the direct lock inversion
> between console_lock and the sysfs lock goes away.
>
> However, you'll now realize that you can't move the sysfs teardown outside
> the console lock because fbcon is doing teardown from inside its notifier,
> which means that there would be a lock inversion between the console lock
> and the notifier lock.
> 
> Which is why we're pointing out that the real problem here is the
> fb notifier call chain lock.

Right, I agree that the ideal solution would be to not have a deferred
work for this, but I don't know how much refactoring that requires
elsewhere. The fix is technically correct as Daniel pointed out and imo
it's simple enough to apply it while the bigger refactoring takes place.
That way we can have a working way to reload modules, which is broken
atm.

--Imre

