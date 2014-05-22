Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaEVPCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:02:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43079 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751079AbaEVPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:02:07 -0400
Date: Thu, 22 May 2014 11:02:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Will Deacon <will.deacon@arm.com>
cc: sarah.a.sharp@linux.intel.com, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <khilman@linaro.org>
Subject: Re: Runtime PM workqueue killing system performance with USB
In-Reply-To: <20140522102747.GB14641@arm.com>
Message-ID: <Pine.LNX.4.44L0.1405221043010.1269-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Will Deacon wrote:

> Hi all,
> 
> Although I don't think this is a new issue, booting mainline on my vexpress
> a9x4 (Quad ARMv7 Cortex-A9 board) with USB and PM_RUNTIME results in each
> CPU being constantly 20-50% loaded. A bit of investigation shows that this
> is due to the runtime-pm callbacks trying to autosuspend USB, despite this
5B> being unsupported by the host-controller (isp1760, which doesn't 
have a
> ->bus_suspend callback). I've included a backtrace at the bottom of this mail.
> 
> Anyway, since ->bus_suspend is not implemented, hcd_bus_suspend returns
> -ENOENT, which propagates back up to usb_runtime_suspend via usb_suspend_both.
> At this point, we override the return value with -EBUSY:
> 
> drivers/usb/core/driver.c:usb_runtime_suspend:
> 
> 	/* The PM core reacts badly unless the return code is 0,
> 	 * -EAGAIN, or -EBUSY, so always return -EBUSY on an error.
> 	 */
> 	if (status != 0)
> 		return -EBUSY;
> 
> This then tells the runtime PM code to try again:
> 
> drivers/base/power/runtime.c
> 
> 	if (retval == -EAGAIN || retval == -EBUSY) {
> 		dev->power.runtime_error = 0;
> 
> 		/*
> 		 * If the callback routine failed an autosuspend, and
> 		 * if the last_busy time has been updated so that there
> 		 * is a new autosuspend expiration time, automatically
> 		 * reschedule another autosuspend.
> 		 */
> 		if ((rpmflags & RPM_AUTO) &&
> 		    pm_runtime_autosuspend_expiration(dev) != 0)
> 			goto repeat;
> 
> Consequently, I see a kworker thread on each CPU consuming a significant
> amount of the system resources. Worse, if I enable something like kmemleak
> (which adds more work to the failed suspend operation), I end up failing
> to boot entirely (NFS bombs out).
> 
> Reverting db7c7c0aeef5 ("usb: Always return 0 or -EBUSY to the runtime
> PM core.") fixes this for me, but the commit log suggests that will break
> lsusb. That patch has also been in for three and a half years...
> 
> Any ideas on how to fix this properly? In what ways does the PM core react
> badly to -ENOENT?

Okay, this is a bad problem.

The PM core takes any error response other than -EBUSY or -EAGAIN as an 
indication that the device is in a runtime-PM error state.  While that 
is appropriate for a USB device, perhaps it's not so appropriate for a 
USB host controller.

Anyway, there are two possible ways of handling this.  One is to avoid 
changing the error code to -EBUSY when the device in question is a root 
hub.  Just let it go into a runtime-PM error state; it won't matter 
since the controller doesn't support runtime PM anyway.  You can test 
this by changing the "if (status != 0)" line in usb_runtime_suspend to

	if (status != 0 && udev->parent)

The other approach is to disable runtime PM for the root hub when the 
host controller driver doesn't have a bus_suspend or bus_resume method.
This seems like a cleaner approach; the patch below implements it.

Alan Stern



Index: usb-3.15/drivers/usb/core/hub.c
===================================================================
--- usb-3.15.orig/drivers/usb/core/hub.c
+++ usb-3.15/drivers/usb/core/hub.c
@@ -1703,8 +1703,19 @@ static int hub_probe(struct usb_interfac
 	 */
 	pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
 
-	/* Hubs have proper suspend/resume support. */
-	usb_enable_autosuspend(hdev);
+	/*
+	 * Hubs have proper suspend/resume support, except for root hubs
+	 * where the controller driver doesn't have bus_suspend and
+	 * bus_resume methods.
+	 */
+	if (hdev->parent) {		/* normal device */
+		usb_enable_autosuspend(hdev);
+	} else {			/* root hub */
+		const struct hc_driver *drv = bus_to_hcd(hdev->bus)->driver;
+
+		if (drv->bus_suspend && drv->bus_resume)
+			usb_enable_autosuspend(hdev);
+	}
 
 	if (hdev->level == MAX_TOPO_LEVEL) {
 		dev_err(&intf->dev,

