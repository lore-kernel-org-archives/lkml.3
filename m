Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3LSSVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:21:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:21335 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3LSSVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:21:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,514,1384329600"; 
   d="scan'208";a="455015660"
Date: Thu, 19 Dec 2013 10:21:10 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis.turischev@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown
Message-ID: <20131219182110.GC3573@xanatos>
References: <52B31EDA.60908@compulab.co.il>
 <52B327D5.3080805@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B327D5.3080805@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is actually v2.

On Thu, Dec 19, 2013 at 07:07:33PM +0200, Denis Turischev wrote:
> The same issue like with Panther Point chipsets. If the USB ports are
> switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
> which will wake the system. Some BIOS have work around for this, but not all.
> 
> The bug can be avoided if the USB ports are switched back to EHCI on
> shutdown.
> 
> v1: add new device id locally, not in <linux/pci_ids.h>

This line shouldn't go in the patch description.

> Signed-off-by: Denis Turischev <denis@compulab.co.il>

Instead, it should go after the --- line, which should be here, but
isn't.  How did you generate this patch?  `git format-patch` is
recommended, or `git send-email`.

Also, which kernel are you experiencing this issue on?  In 3.12, I
queued a separate patch to deal with spurious reboot issues on Lynx
Point:

commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Sep 12 08:11:06 2013 +0200

    xhci: Fix spurious wakeups after S5 on Haswell
    
    Haswell LynxPoint and LynxPoint-LP with the recent Intel BIOS show
    mysterious wakeups after shutdown occasionally.  After discussing with
    BIOS engineers, they explained that the new BIOS expects that the
    wakeup sources are cleared and set to D3 for all wakeup devices when
    the system is going to sleep or power off, but the current xhci driver
    doesn't do this properly (partly intentionally).
    
    This patch introduces a new quirk, XHCI_SPURIOUS_WAKEUP, for
    fixing the spurious wakeups at S5 by calling xhci_reset() in the xhci
    shutdown ops as done in xhci_stop(), and setting the device to PCI D3
    at shutdown and remove ops.
    
    The PCI D3 call is based on the initial fix patch by Oliver Neukum.
    
    [Note: Sarah changed the quirk name from XHCI_HSW_SPURIOUS_WAKEUP to
    XHCI_SPURIOUS_WAKEUP, since none of the other quirks have system names
    in them.  Sarah also fixed a collision with a quirk submitted around the
    same time, by changing the xhci->quirks bit from 17 to 18.]
    
    This patch should be backported to kernels as old as 3.0, that
    contain the commit 1c12443ab8eba71a658fae4572147e56d1f84f66 "xhci: Add
    Lynx Point to list of Intel switchable hosts."
    
    Cc: Oliver Neukum <oneukum@suse.de>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Cc: stable@vger.kernel.org

This patch is in 3.12, but a patch to narrow the quirk to only apply HP systems
will hit 3.13 shortly:

commit 6962d914f317b119e0db7189199b21ec77a4b3e0
Author: Takashi Iwai <tiwai@suse.de>
Date:   Mon Dec 9 14:53:36 2013 +0100

    xhci: Limit the spurious wakeup fix only to HP machines
    
    We've got regression reports that my previous fix for spurious wakeups
    after S5 on HP Haswell machines leads to the automatic reboot at
    shutdown on some machines.  It turned out that the fix for one side
    triggers another BIOS bug in other side.  So, it's exclusive.
    
    Since the original S5 wakeups have been confirmed only on HP machines,
    it'd be safer to apply it only to limited machines.  As a wild guess,
    limiting to machines with HP PCI SSID should suffice.
    
    This patch should be backported to kernels as old as 3.12, that
    contain the commit 638298dc66ea36623dbc2757a24fc2c4ab41b016 "xhci: Fix
    spurious wakeups after S5 on Haswell".
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66171
    Cc: stable@vger.kernel.org
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Tested-by: <dashing.meng@gmail.com>
    Reported-by: Niklas Schnelle <niklas@komani.de>
    Reported-by: Giorgos <ganastasiouGR@gmail.com>
    Reported-by: <art1@vhex.net>

So, do you experience the spurious reboots on 3.11?  Do they go away in
3.12 with the first patch applied?

Sarah Sharp

> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> --- a/drivers/usb/host/xhci-pci.c	2013-12-19 11:36:12.049589400 +0200
> +++ b/drivers/usb/host/xhci-pci.c	2013-12-19 11:37:27.261590385 +0200
> @@ -34,6 +34,8 @@
>  #define PCI_VENDOR_ID_ETRON		0x1b6f
>  #define PCI_DEVICE_ID_ASROCK_P67	0x7023
> 
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x9c31
> +
>  static const char hcd_name[] = "xhci_hcd";
> 
>  /* called after powerup, by probe or system-pm "wakeup" */
> @@ -91,8 +93,9 @@
>  		xhci->quirks |= XHCI_LPM_SUPPORT;
>  		xhci->quirks |= XHCI_INTEL_HOST;
>  	}
> -	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
> -			pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
> +	if (pdev->vendor == PCI_VENDOR_ID_INTEL && (
> +			(pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) ||
> +			(pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI))) {
>  		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
>  		xhci->limit_active_eps = 64;
>  		xhci->quirks |= XHCI_SW_BW_CHECKING;
