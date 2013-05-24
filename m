Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3EXVFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 17:05:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:57928 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3EXVFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 17:05:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,737,1363158000"; 
   d="scan'208";a="319164159"
Date: Fri, 24 May 2013 14:05:03 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Shawn Nematbakhsh <shawnn@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
Message-ID: <20130524210503.GC15788@xanatos>
References: <1369419177-23281-1-git-send-email-shawnn@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369419177-23281-1-git-send-email-shawnn@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 11:12:57AM -0700, Shawn Nematbakhsh wrote:
> If a USB controller with XHCI_RESET_ON_RESUME goes to runtime suspend,
> a reset will be performed upon runtime resume. Any previously suspended
> devices attached to the controller will be re-enumerated at this time.
> This will cause problems, for example, if an open system call on the
> device triggered the resume (the open call will fail).

That's ugly, but disabling runtime PM is going to have a big impact on
the power consumption of those systems.

Alan, do you think this is really the right thing to be doing here?  It
feels like userspace should just be able to deal with devices
disconnecting on resume.  After all, there are lots of USB devices that
can't handle USB device suspend at all.

Shouldn't userspace just disable runtime PM for the USB device classes
that don't have a reset resume callback?

> Note that this change is only relevant when persist_enabled is not set
> for USB devices.

Could we at least wrap the call in an ifdef CONFIG_USB_DEFAULT_PERSIST?
That way if people have USB persist turned off in their configuration,
their host will still be able to suspend.

Sarah Sharp

> 
> Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
> ---
>  drivers/usb/host/xhci.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index b4aa79d..7455156 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4687,6 +4687,12 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>  
>  	get_quirks(dev, xhci);
>  
> +	/* If we are resetting upon resume, we must disable runtime PM.
> +	 * Otherwise, an open() syscall to a device on our runtime suspended
> +	 * controller will trigger controller reset and device re-enumeration */
> +	if (xhci->quirks & XHCI_RESET_ON_RESUME)
> +		pm_runtime_get_noresume(dev);
> +
>  	/* Make sure the HC is halted. */
>  	retval = xhci_halt(xhci);
>  	if (retval)
> -- 
> 1.7.12.4
> 
