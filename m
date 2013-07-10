Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3GJTEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:04:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41010 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754482Ab3GJTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:04:09 -0400
Date: Wed, 10 Jul 2013 15:04:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] USB: ehci-omap: Implement suspend/resume
In-Reply-To: <1373473405-27589-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307101446270.1215-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Roger Quadros wrote:

> Call ehci_suspend/resume() during runtime suspend/resume
> as well as system suspend/resume.
> 
> Use a flag "bound" to indicate that the HCD structures are valid.
> This is only true between usb_add_hcd() and usb_remove_hcd() calls.
> 
> The flag can be used by omap_ehci_runtime_suspend/resume() handlers
> to avoid calling ehci_suspend/resume() when we are no longer bound
> to the HCD e.g. during probe() and remove();

> @@ -293,15 +301,67 @@ static const struct of_device_id omap_ehci_dt_ids[] = {
>  
>  MODULE_DEVICE_TABLE(of, omap_ehci_dt_ids);
>  
> +static int omap_ehci_suspend(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	return ehci_suspend(hcd, true);
> +}
> +
> +static int omap_ehci_resume(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	return ehci_resume(hcd, false);
> +}

There are three problems here.  The first is very simple: the wakeup 
settings are messed up.  Wakeup is supposed to be enabled always for
runtime suspend, whereas it is controlled by device_may_wakeup() for
system suspend.  You reversed them.

The other two problems are both related to the interaction between
system PM and runtime PM.  Suppose the controller is already runtime
suspended when the system goes to sleep.  Because it is runtime
suspended, it is enabled for wakeup.  But device_may_wakeup() could
return false; if this happens then you have to do a runtime-resume in
omap_ehci_suspend() before calling ehci_suspend(), so that the
controller can be suspended again with wakeups disabled.  (Or you could
choose an alternative method for accomplishing the same result, such as
disabling the wakeup signal from the pad without going through a whole
EHCI resume/suspend cycle.)  Conversely, if device_may_wakeup() returns
true then you shouldn't do anything at all, because the controller is
already suspended with the correct wakeup setting.

For the third problem, suppose the controller was runtime suspended
when the system went to sleep.  When the system wakes up, the
controller will become active, so you have to inform the runtime PM
core about its change of state.  Basically, if omap_ehci_resume() sees
that ehci_resume() returned 0 then it must do:

	pm_runtime_disable(dev);
	pm_runtime_set_active(dev);
	pm_runtime_enable(dev);

All of these issues are discussed (among lots of other material) in 
Documentation/power/runtime_pm.txt.

Alan Stern

