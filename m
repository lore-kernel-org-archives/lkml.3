Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab3E3RIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:08:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57676 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758481Ab3E3RIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:08:09 -0400
Date: Thu, 30 May 2013 13:08:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH RFC] PM / Runtime: Rework the "runtime idle" helper
 routine
In-Reply-To: <1645401.1grgttHPMR@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1305301247370.1137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Rafael J. Wysocki wrote:

> > Since you're making this change, wouldn't it be a good idea to adopt
> > Mika's original suggestion and turn on the RPM_AUTO bit in rpmflags
> > when the use_autosuspend flag is set?
> 
> I'm not actually sure.  It can be done, but I'd prefer to do that as a separate
> change in any case.

That makes sense.

> > What about cases where the runtime-idle callback does
> > rpm_schedule_suspend or rpm_request_suspend?  You'd have to make sure
> > that it returns -EBUSY in such cases.  Did you audit for this?
> 
> As far as I could.
> 
> I'm not worried about the subsystems modified by this patch, because the
> functionality there won't change (except for PCI, that is).

Right.  The subsystems that _aren't_ modified are the ones to worry 
about -- like the USB callback.  They are the ones where the behavior 
might change.

> > > Index: linux-pm/Documentation/power/runtime_pm.txt
> > > ===================================================================
> > > --- linux-pm.orig/Documentation/power/runtime_pm.txt
> > > +++ linux-pm/Documentation/power/runtime_pm.txt
> > > @@ -660,11 +660,6 @@ Subsystems may wish to conserve code spa
> > >  management callbacks provided by the PM core, defined in
> > >  driver/base/power/generic_ops.c:
> > >  
> > > -  int pm_generic_runtime_idle(struct device *dev);
> > > -    - invoke the ->runtime_idle() callback provided by the driver of this
> > > -      device, if defined, and call pm_runtime_suspend() for this device if the
> > > -      return value is 0 or the callback is not defined
> > > -
> > 
> > The documentation for the runtime-idle callback needs to be updated too.
> 
> Well, I actually couldn't find the part of it that would need to be updated. :-)

How about this?


Index: usb-3.10/Documentation/power/runtime_pm.txt
===================================================================
--- usb-3.10.orig/Documentation/power/runtime_pm.txt
+++ usb-3.10/Documentation/power/runtime_pm.txt
@@ -144,8 +144,12 @@ The action performed by the idle callbac
 (or driver) in question, but the expected and recommended action is to check
 if the device can be suspended (i.e. if all of the conditions necessary for
 suspending the device are satisfied) and to queue up a suspend request for the
-device in that case.  The value returned by this callback is ignored by the PM
-core.
+device in that case.  If there is no idle callback, or if the callback returns
+0, then the PM core will attempt to carry out a runtime suspend of the device;
+in essence, it will call pm_runtime_suspend() directly.  To prevent this (for
+example, if the callback routine has started a delayed suspend), the routine
+should return a non-zero value.  Negative error return codes are ignored by the
+PM core.
 
 The helper functions provided by the PM core, described in Section 4, guarantee
 that the following constraints are met with respect to runtime PM callbacks for
@@ -301,9 +305,10 @@ drivers/base/power/runtime.c and include
       removing the device from device hierarchy
 
   int pm_runtime_idle(struct device *dev);
-    - execute the subsystem-level idle callback for the device; returns 0 on
-      success or error code on failure, where -EINPROGRESS means that
-      ->runtime_idle() is already being executed
+    - execute the subsystem-level idle callback for the device; returns an
+      error code on failure, where -EINPROGRESS means that ->runtime_idle() is
+      already being executed; if there is no callback or the callback returns 0
+      then run pm_runtime_suspend(dev) and return its result
 
   int pm_runtime_suspend(struct device *dev);
     - execute the subsystem-level suspend callback for the device; returns 0 on


Alan Stern

