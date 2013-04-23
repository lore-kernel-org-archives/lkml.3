Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3DWOHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:07:38 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51641 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab3DWOHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:07:37 -0400
Date: Tue, 23 Apr 2013 07:07:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.vaden@hp.com
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
Message-ID: <20130423140734.GA30877@kroah.com>
References: <1366701301-16603-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366701301-16603-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 03:15:01PM +0800, Li, Zhen-Hua wrote:
> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> 
> This patch is trying to fix bug QXCR1001261767.

What is that bug number?  Where can it be referenced?  If you are going
to put it in a public place (like a kernel changelog), it needs to be
publicly accessible.

> On some HP platform, when usb driver inits the iLo Virtual USB Controller, there may be a warning "Controller not stopped yet!". It is because driver does not wait enough time.

What happened to your line endings?

> This patch adds more time waiting and retries.

Why not only do this for your device?

> 
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>  drivers/usb/host/uhci-hcd.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
> index 4a86b63..514e9d7 100644
> --- a/drivers/usb/host/uhci-hcd.c
> +++ b/drivers/usb/host/uhci-hcd.c
> @@ -277,6 +277,9 @@ static int global_suspend_mode_is_broken(struct uhci_hcd *uhci)
>  		uhci->global_suspend_mode_is_broken(uhci) : 0;
>  }
>  
> +#define UHCI_SUSPENDRH_RETRY_MAX      10
> +#define UHCI_SUSPENDRH_RETRY_DELAY    100
> +
>  static void suspend_rh(struct uhci_hcd *uhci, enum uhci_rh_state new_state)
>  __releases(uhci->lock)
>  __acquires(uhci->lock)
> @@ -284,6 +287,7 @@ __acquires(uhci->lock)
>  	int auto_stop;
>  	int int_enable, egsm_enable, wakeup_enable;
>  	struct usb_device *rhdev = uhci_to_hcd(uhci)->self.root_hub;
> +	u16 try, stopped;
>  
>  	auto_stop = (new_state == UHCI_RH_AUTO_STOPPED);
>  	dev_dbg(&rhdev->dev, "%s%s\n", __func__,
> @@ -355,7 +359,17 @@ __acquires(uhci->lock)
>  		if (uhci->dead)
>  			return;
>  	}
> -	if (!(uhci_readw(uhci, USBSTS) & USBSTS_HCH))
> +
> +	for (try = 0; try < UHCI_SUSPENDRH_RETRY_MAX; try++) {
> +		/*
> +		 * Sometimes we may need to wait more time and try again.
> +		 */

"Sometimes"?  Please be more specific.  Also, a multi-line comment isn't
needed, make it one line please.

thanks,

greg k-h
