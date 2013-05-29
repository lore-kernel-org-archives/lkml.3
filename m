Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935289Ab3E2WJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:09:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54367 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935228Ab3E2WJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:09:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH RFC] PM / Runtime: Rework the "runtime idle" helper routine
Date: Thu, 30 May 2013 00:18:16 +0200
Message-ID: <1645401.1grgttHPMR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1305291023170.1473-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1305291023170.1473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 10:51:11 AM Alan Stern wrote:
> On Wed, 29 May 2013, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The "runtime idle" helper routine, rpm_idle(), currently ignores
> > return values from .runtime_idle() callbacks executed by it.
> > 
> > However, it turns out that many subsystems use the generic idle
> > callback routine pm_generic_runtime_idle() which checks the return
> > value of the driver's callback and executes pm_runtime_suspend() for
> > the device unless that value is different from 0.  If that logic is
> > moved to rpm_idle() instead, pm_generic_runtime_idle() can be dropped
> > and its users will not need any .runtime_idle() callbacks any more.
> 
> Since you're making this change, wouldn't it be a good idea to adopt
> Mika's original suggestion and turn on the RPM_AUTO bit in rpmflags
> when the use_autosuspend flag is set?

I'm not actually sure.  It can be done, but I'd prefer to do that as a separate
change in any case.

> > Moreover, the PCI subsystem's .runtime_idle() routine,
> > pci_pm_runtime_idle(), works in analogy with the generic one and if
> > rpm_idle() calls rpm_suspend() after 0 has been returned by the
> > .runtime_idle() callback executed by it, that routine will not be
> > necessary any more and may be dropped.
> 
> See below.
> 
> What about cases where the runtime-idle callback does
> rpm_schedule_suspend or rpm_request_suspend?  You'd have to make sure
> that it returns -EBUSY in such cases.  Did you audit for this?

As far as I could.

I'm not worried about the subsystems modified by this patch, because the
functionality there won't change (except for PCI, that is).

> > Index: linux-pm/Documentation/power/runtime_pm.txt
> > ===================================================================
> > --- linux-pm.orig/Documentation/power/runtime_pm.txt
> > +++ linux-pm/Documentation/power/runtime_pm.txt
> > @@ -660,11 +660,6 @@ Subsystems may wish to conserve code spa
> >  management callbacks provided by the PM core, defined in
> >  driver/base/power/generic_ops.c:
> >  
> > -  int pm_generic_runtime_idle(struct device *dev);
> > -    - invoke the ->runtime_idle() callback provided by the driver of this
> > -      device, if defined, and call pm_runtime_suspend() for this device if the
> > -      return value is 0 or the callback is not defined
> > -
> 
> The documentation for the runtime-idle callback needs to be updated too.

Well, I actually couldn't find the part of it that would need to be updated. :-)

> > Index: linux-pm/drivers/pci/pci-driver.c
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/pci-driver.c
> > +++ linux-pm/drivers/pci/pci-driver.c
> > @@ -1046,32 +1046,6 @@ static int pci_pm_runtime_resume(struct
> >  	return rc;
> >  }
> >  
> > -static int pci_pm_runtime_idle(struct device *dev)
> > -{
> > -	struct pci_dev *pci_dev = to_pci_dev(dev);
> > -	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > -
> > -	/*
> > -	 * If pci_dev->driver is not set (unbound), the device should
> > -	 * always remain in D0 regardless of the runtime PM status
> > -	 */
> > -	if (!pci_dev->driver)
> > -		goto out;
> > -
> > -	if (!pm)
> > -		return -ENOSYS;
> > -
> > -	if (pm->runtime_idle) {
> > -		int ret = pm->runtime_idle(dev);
> > -		if (ret)
> > -			return ret;
> > -	}
> > -
> > -out:
> > -	pm_runtime_suspend(dev);
> > -	return 0;
> > -}
> 
> This may not be a safe change, because now the behavior is different
> in the case where dev->driver is set but pci_dev->driver isn't.

That's a good point.  I think I'll drop the PCI change, then.
Or rather, I'll just remove the pm_runtime_suspend() call from
pci_pm_runtime_idle(). :-)

> The difference is that you will now call the driver's runtime-idle
> handler, whereas the existing code doesn't.
> 
> In fact, this may turn out to be a more widespread problem.  
> dev->driver gets set before the probe routine is called, and it gets
> cleared after the remove routine is called.  A runtime PM callback to
> the driver during these windows isn't a good idea.  Erasing subsystems'
> runtime_idle handlers, as this patch does, makes it impossible for the
> subsystems to protect against this.

Except for PCI it only removes the ones that point to
pm_generic_runtime_idle(), which obviously doesn't check that.

> The patch also needs to update
> drivers/usb/core/driver.c:usb_runtime_idle().

Yes, it does.

> If you include Mika's suggestion, the routine can be removed entirely.

Later. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
