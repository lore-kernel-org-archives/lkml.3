Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbaFQPoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:44:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:18638 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989AbaFQPoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,494,1400050800"; 
   d="scan'208";a="556855651"
Message-ID: <53A06546.3090001@intel.com>
Date: Tue, 17 Jun 2014 18:56:54 +0300
From: Mathias Nyman <mathias.nyman@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xhci: clear root port wake on bits if controller
 isn't wake-up capable
References: <1402617975-34702-1-git-send-email-baolu.lu@linux.intel.com>
In-Reply-To: <1402617975-34702-1-git-send-email-baolu.lu@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 03:06 AM, Lu Baolu wrote:
> When xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
> xhci_bus_suspend needs to clear all root port wake on bits. Otherwise some Intel
> platforms may get a spurious wakeup, even if PCI PME# is disabled.
> 
> This patch should be back-ported to kernels as old as 2.6.37, that
> contains the commit 9777e3ce907d4cb5a513902a87ecd03b52499569
> "USB: xHCI: bus power management implementation". 
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/usb/host/xhci-hub.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index 6231ce6..fb771bd 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -22,6 +22,7 @@
>  
>  
>  #include <linux/slab.h>
> +#include <linux/device.h>
>  #include <asm/unaligned.h>
>  
>  #include "xhci.h"
> @@ -1139,7 +1140,9 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
>  		 * including the USB 3.0 roothub, but only if CONFIG_PM_RUNTIME
>  		 * is enabled, so also enable remote wake here.
>  		 */
> -		if (hcd->self.root_hub->do_remote_wakeup) {
> +		if (hcd->self.root_hub->do_remote_wakeup
> +				&& device_may_wakeup(hcd->self.controller)) {
> +
>  			if (t1 & PORT_CONNECT) {
>  				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
>  				t2 &= ~PORT_WKCONN_E;
> 

Looks good to me, thanks for fixing.
I can take it, add the "cc: stable" tag and send it forward to Greg once his trees get updated to 3.16 release candidates

-Mathias
