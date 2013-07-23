Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab3GWOOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:14:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56444 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933068Ab3GWOOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:14:02 -0400
Date: Tue, 23 Jul 2013 10:14:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] USB: ehci-omap: Implement suspend/resume
In-Reply-To: <51EE4A7C.2020709@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307231009120.1304-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Roger Quadros wrote:

> >> +               pm_runtime_get_sync(dev);
> >> +               ehci_resume(hcd, false);
> >> +               ret = ehci_suspend(hcd, do_wakeup);
> >> +               pm_runtime_put_sync(dev);
> > 
> > It would be better to call pm_runtime_resume(dev) at the start instead
> > of pm_runtime_get_sync(), and eliminate the last two lines.  Then the
> > ehci_suspend() below could be moved outside the "if" statement.
> 
> Why do I find pm_runtime_* so confusing ;)

It tries to provide every service anyone might want, and ends up being 
confusingly large.

In this case, though, the reasoning is simple.  We know that after the 
system resumes, the device will be back in the active state.  Hence 
there's no point in calling pm_runtime_put_sync here, other than to 
balance the _get_sync above.  Since there's no danger of another thread 
trying to do a runtime suspend at this point, you don't need to 
increment the usage counter.  Therefore pm_runtime_resume is good 
enough.

> > Alternatively, if you are able to turn off the wakeup setting without
> > going through an entire resume/suspend cycle, that would be preferable.
> > 
> 
> As we don't rely on the EHCI controller's interrupt any more after we
> power it down, maybe ehci_resume/suspend cycle is not required at all on OMAP,
> even if the wakeup setting is disabled during system suspend.
> 
> As the wakeup is controlled entirely by pad wakeup, all we need to do is make sure
> the IO pad wakeup is configured correctly based on do_wakeup. How this is done
> is still in transition but it might be turn out to be as simple as irq_set_irq_wake()
> 
> So IMHO, for ehci-omap this should suffice
> 
> static int omap_ehci_suspend(struct device *dev)
> {
> 	struct usb_hcd *hcd = dev_get_drvdata(dev);
> 	bool do_wakeup = device_may_wakeup(dev);
> 	int ret = 0;
> 
> 	if (!pm_runtime_status_suspended(dev))
> 		ret = ehci_suspend(hcd, do_wakeup);
> 
> 	/* Not tested yet */
> 	irq_set_irq_wake(hcd->irq, do_wakeup);
> 
> 	return ret;
> }
> 
> What do you think?

Nice and simple.  It looks good.

> As the OMAP IO pad wakeup management code [1] is still in transition, I'll wait till
> that gets settled and then resend this series.

Okay.

Alan Stern

