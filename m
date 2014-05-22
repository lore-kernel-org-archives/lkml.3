Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaEVRj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:39:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50686 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbaEVRj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:39:56 -0400
Date: Thu, 22 May 2014 18:39:51 +0100
From: Will Deacon <will.deacon@arm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: Runtime PM workqueue killing system performance with USB
Message-ID: <20140522173951.GD14641@arm.com>
References: <20140522102747.GB14641@arm.com>
 <Pine.LNX.4.44L0.1405221043010.1269-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405221043010.1269-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, May 22, 2014 at 04:02:06PM +0100, Alan Stern wrote:
> On Thu, 22 May 2014, Will Deacon wrote:
> > Consequently, I see a kworker thread on each CPU consuming a significant
> > amount of the system resources. Worse, if I enable something like kmemleak
> > (which adds more work to the failed suspend operation), I end up failing
> > to boot entirely (NFS bombs out).
> > 
> > Reverting db7c7c0aeef5 ("usb: Always return 0 or -EBUSY to the runtime
> > PM core.") fixes this for me, but the commit log suggests that will break
> > lsusb. That patch has also been in for three and a half years...
> > 
> > Any ideas on how to fix this properly? In what ways does the PM core react
> > badly to -ENOENT?
> 
> Okay, this is a bad problem.
> 
> The PM core takes any error response other than -EBUSY or -EAGAIN as an 
> indication that the device is in a runtime-PM error state.  While that 
> is appropriate for a USB device, perhaps it's not so appropriate for a 
> USB host controller.
> 
> Anyway, there are two possible ways of handling this.  One is to avoid 
> changing the error code to -EBUSY when the device in question is a root 
> hub.  Just let it go into a runtime-PM error state; it won't matter 
> since the controller doesn't support runtime PM anyway.  You can test 
> this by changing the "if (status != 0)" line in usb_runtime_suspend to
> 
> 	if (status != 0 && udev->parent)

I'd tried something like this already, but I prefer your patch below. Plus,
this hack results in a failure being logged to dmesg on the initial suspend
attempt.

> The other approach is to disable runtime PM for the root hub when the 
> host controller driver doesn't have a bus_suspend or bus_resume method.
> This seems like a cleaner approach; the patch below implements it.

Thanks for this! I can confirm that your patch below fixes the issue for me,
so:

  Reported-by: Will Deacon <will.deacon@arm.com>
  Tested-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will

> Index: usb-3.15/drivers/usb/core/hub.c
> ===================================================================
> --- usb-3.15.orig/drivers/usb/core/hub.c
> +++ usb-3.15/drivers/usb/core/hub.c
> @@ -1703,8 +1703,19 @@ static int hub_probe(struct usb_interfac
>  	 */
>  	pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
>  
> -	/* Hubs have proper suspend/resume support. */
> -	usb_enable_autosuspend(hdev);
> +	/*
> +	 * Hubs have proper suspend/resume support, except for root hubs
> +	 * where the controller driver doesn't have bus_suspend and
> +	 * bus_resume methods.
> +	 */
> +	if (hdev->parent) {		/* normal device */
> +		usb_enable_autosuspend(hdev);
> +	} else {			/* root hub */
> +		const struct hc_driver *drv = bus_to_hcd(hdev->bus)->driver;
> +
> +		if (drv->bus_suspend && drv->bus_resume)
> +			usb_enable_autosuspend(hdev);
> +	}
>  
>  	if (hdev->level == MAX_TOPO_LEVEL) {
>  		dev_err(&intf->dev,
> 
> 
