Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3GKPOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:14:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34157 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755976Ab3GKPOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:14:30 -0400
Date: Thu, 11 Jul 2013 11:14:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] USB: ehci-omap: Implement suspend/resume
In-Reply-To: <51DE71F3.1040101@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307111106090.1276-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Roger Quadros wrote:

> > The other two problems are both related to the interaction between
> > system PM and runtime PM.  Suppose the controller is already runtime
> > suspended when the system goes to sleep.  Because it is runtime
> > suspended, it is enabled for wakeup.  But device_may_wakeup() could
> > return false; if this happens then you have to do a runtime-resume in
> > omap_ehci_suspend() before calling ehci_suspend(), so that the
> > controller can be suspended again with wakeups disabled.  (Or you could
> > choose an alternative method for accomplishing the same result, such as
> > disabling the wakeup signal from the pad without going through a whole
> > EHCI resume/suspend cycle.)  Conversely, if device_may_wakeup() returns
> > true then you shouldn't do anything at all, because the controller is
> > already suspended with the correct wakeup setting.
> 
> I think this case is taken care of by the Runtime PM core at least for the OMAP
> platform according to the documentation
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/power/runtime_pm.txt#n647

No; that section refers only to races, not to wakeup settings.

> At the end of this mail is the log during system suspend/resume
> 
> You can notice the following sequence
> 
> -ehci runtime suspends
> -system suspend triggered
> -ehci runtime resumes
> -ehci suspends (uses new wakeup settings)
> -system wakeup triggered
> -ehci resumes
> -ehci runtime suspends

This is because the root hub was runtime suspended with the wrong
wakeup setting.  The USB core, which is careful about these things,
resumed and re-suspended it with the proper wakeup setting.  In the 
process, the controller had to be runtime resumed as well.

Try doing the test over again, but this time with the root hub enabled 
for wakeup and the controller disabled.  (I know this is a bizarre 
combination, but try it anyway.)  Also, after the system wakes up, see 
whether the root hub and controller get runtime suspended.

> > For the third problem, suppose the controller was runtime suspended
> > when the system went to sleep.  When the system wakes up, the
> > controller will become active, so you have to inform the runtime PM
> > core about its change of state.  Basically, if omap_ehci_resume() sees
> > that ehci_resume() returned 0 then it must do:
> > 
> > 	pm_runtime_disable(dev);
> > 	pm_runtime_set_active(dev);
> > 	pm_runtime_enable(dev);
> > 
> > All of these issues are discussed (among lots of other material) in 
> > Documentation/power/runtime_pm.txt.
> 
> Is this still applicable? Documentation claims
> 
>    "During system resume it calls pm_runtime_enable() and pm_runtime_put_sync()
>     for every device right after executing the subsystem-level .resume_early()
>     callback and right after executing the subsystem-level .resume() callback
>     for it, respectively."

Yes, this is applicable, but it is irrelevant to the problem I 
described.  You still have to tell the runtime PM core that the device 
is now active.

Alan Stern

