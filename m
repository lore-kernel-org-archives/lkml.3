Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab3JIUdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:33:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:11023 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab3JIUdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:33:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1066,1371106800"; 
   d="scan'208";a="390725881"
Date: Wed, 9 Oct 2013 13:33:38 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Xiao Jin <jin.xiao@intel.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, sboyd@codeaurora.org, jslaby@suse.cz
Subject: Re: [PATCH] xhci: correct the usage of USB_CTRL_SET_TIMEOUT
Message-ID: <20131009203338.GB8222@xanatos>
References: <1381281919.9531.12.camel@xiaojin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381281919.9531.12.camel@xiaojin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiao,

On Wed, Oct 09, 2013 at 09:25:19AM +0800, Xiao Jin wrote:
> From: xiao jin <jin.xiao@intel.com>
> Date: Wed, 9 Oct 2013 09:09:46 +0800
> Subject: [PATCH] xhci: correct the usage of USB_CTRL_SET_TIMEOUT

As I mentioned in another email, you need to use `git send-email` to
avoid putting these extra lines in your patches.  They won't apply
otherwise.

> The usage of USB_CTRL_SET_TIMEOUT is incorrect. The
> definition of USB_CTRL_SET_TIMEOUT is 5000ms. The
> input timeout to wait_for_completion_interruptible_timeout
> is jiffies. That makes the timeout be longer than what
> we want, such as 50s in some platform.
> 
> The patch is to convert USB_CTRL_SET_TIMEOUT to jiffies as
> command completion event timeout.

Good catch!  I agree this should be fixed.  However, can you fix this by
changing the code to use XHCI_CMD_DEFAULT_TIMEOUT instead of
USB_CTRL_SET_TIMEOUT?  That's properly defined as five seconds:

xhci.h:#define XHCI_CMD_DEFAULT_TIMEOUT (5 * HZ)

Can you fix this and use `git send-email` to send a v2 patch?

Also, are there any really bad effects of this bug, other than possibly
taking a really long time to suspend a system?  I'm also concerned about
*why* your host controller is taking so long to respond to the Stop
Endpoint command.  Was it because of the bug fixed by the other patch
you sent?

Thanks,
Sarah Sharp

> Signed-off-by: xiao jin <jin.xiao@intel.com>
> ---
>  drivers/usb/host/xhci-hub.c |    2 +-
>  drivers/usb/host/xhci.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index 1d35459..78cf294 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -295,7 +295,7 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
>  	/* Wait for last stop endpoint command to finish */
>  	timeleft = wait_for_completion_interruptible_timeout(
>  			cmd->completion,
> -			USB_CTRL_SET_TIMEOUT);
> +			msecs_to_jiffies(USB_CTRL_SET_TIMEOUT));
>  	if (timeleft <= 0) {
>  		xhci_warn(xhci, "%s while waiting for stop endpoint command\n",
>  				timeleft == 0 ? "Timeout" : "Signal");
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 9478caa..f9ebc72 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -3486,7 +3486,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>  	/* Wait for the Reset Device command to finish */
>  	timeleft = wait_for_completion_interruptible_timeout(
>  			reset_device_cmd->completion,
> -			USB_CTRL_SET_TIMEOUT);
> +			msecs_to_jiffies(USB_CTRL_SET_TIMEOUT));
>  	if (timeleft <= 0) {
>  		xhci_warn(xhci, "%s while waiting for reset device command\n",
>  				timeleft == 0 ? "Timeout" : "Signal");
> -- 
> 1.7.1
> 
> 
> 
