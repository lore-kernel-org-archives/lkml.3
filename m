Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3FZQxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:53:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:33977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3FZQxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:53:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,945,1363158000"; 
   d="scan'208";a="359997626"
Date: Wed, 26 Jun 2013 09:53:34 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] usb: host: xhci-plat: Enable XHCI_SPURIOUS_SUCCESS quirk
 for xhci-plat
Message-ID: <20130626165334.GA19462@xanatos>
References: <1372237137-17351-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372237137-17351-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:28:57PM +0530, George Cherian wrote:
> Synopsis xhci controllers with hci_version > 0.96 gives spurious success
> events on short packet completion. During webcam capture the
> "ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
> The same application works fine with synopsis controllers hci_version 0.96.

It's a known issue.  The xHCI 1.0 spec changed how hardware handles
short packets.  The HW will notify SW of the TRB where the short packet,
and it will also give a successful status for the last TRB in a TD (the
one with the IOC flag set).  On the second successful status, that
warning will be triggered in the driver.

Software is now supposed to not assume the TD as done until it gets that
last successful status.  That means we have a slight race condition,
although it should have little practical impact.  This patch papers over
that issue.

I will take this patch, but will add the note that is on my long-term
to-do list to fix this issue.

Sarah Sharp

> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/host/xhci-plat.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 93ad67e..e63c6d3 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -25,6 +25,16 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>  	 * dev struct in order to setup MSI
>  	 */
>  	xhci->quirks |= XHCI_BROKEN_MSI;
> +
> +	/*
> +	 * In some xhci controllers which follows xhci 1.0 spec gives a spurious
> +	 * success event after a short transfer. This quirk will ignore such
> +	 * spurious event. Hit this issue in synopsis xhci controllers with
> +	 * hci_version > 0.96
> +	 */
> +
> +	if (xhci->hci_version > 0x96)
> +		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
>  }
>  
>  /* called during probe() after chip reset completes */
> -- 
> 1.8.1.4
> 
