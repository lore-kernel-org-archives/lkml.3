Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbaJ3RJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:09:20 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:49031 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889AbaJ3RJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:09:18 -0400
Date: Thu, 30 Oct 2014 11:09:13 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] PCI: fix sriov enabling with virtual bus
Message-ID: <20141030170913.GA6982@google.com>
References: <1414621570-20777-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414621570-20777-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, linux-acpi]

On Wed, Oct 29, 2014 at 03:26:10PM -0700, Yinghai Lu wrote:
> While enabling sriov for intel igb device got:
> 
> sca05-0a81fda5:~ # echo 7 > /sys/bus/pci/devices/0000\:09\:00.0/sriov_numvfs 
> [  729.612191] pci 0000:0a:10.0: [8086:1520] type 00 class 0x020000
> [  729.619002] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e8
> [  729.627767] IP: [<ffffffff815901cb>] pci_get_hp_params+0x5b/0x640
> [  729.634593] PGD 0 
> [  729.636844] Oops: 0000 [#1] SMP 
> [  729.640466] Modules linked in:
> ...
> [  729.795268] Call Trace:
> [  729.798007]  [<ffffffff81ea0843>] ? pci_mmcfg_read+0x123/0x140
> [  729.804519]  [<ffffffff81ea0770>] ? pci_mmcfg_read+0x50/0x140
> [  729.810942]  [<ffffffff815692a3>] pci_configure_device+0x33/0x350
> [  729.817744]  [<ffffffff8156aba4>] pci_device_add+0x24/0x160
> [  729.823965]  [<ffffffff8158f3bb>] pci_enable_sriov+0x4db/0x7d0
> [  729.830486]  [<ffffffff81b63f54>] ? igb_pci_enable_sriov+0xe4/0x200
> [  729.837481]  [<ffffffff81b63f7f>] igb_pci_enable_sriov+0x10f/0x200
> [  729.844386]  [<ffffffff8155129c>] ? _kstrtoull+0x2c/0x80
> [  729.850315]  [<ffffffff81b640a5>] igb_pci_sriov_configure+0x35/0x40
> [  729.857318]  [<ffffffff815752b5>] sriov_numvfs_store+0xe5/0x140
> [  729.863934]  [<ffffffff817e1f88>] dev_attr_store+0x18/0x30
> [  729.870063]  [<ffffffff812624d8>] sysfs_kf_write+0x48/0x60
> [  729.876186]  [<ffffffff812617ef>] ? kernfs_fop_write+0xaf/0x170
> [  729.882797]  [<ffffffff81261827>] kernfs_fop_write+0xe7/0x170
> [  729.889222]  [<ffffffff811ef66b>] vfs_write+0xcb/0x1c0
> [  729.894958]  [<ffffffff811f0019>] SyS_write+0x49/0xb0
> ...
> [  729.943531] ---[ end trace 7cf0cdb66637665a ]---
> 
> and pci_get_hp_params+0x5b point to
> 0xffffffff815901cb is in pci_get_hp_params (include/linux/device.h:815).
> 810	#include <linux/pm_wakeup.h>
> 811	
> 812	static inline const char *dev_name(const struct device *dev)
> 813	{
> 814		/* Use the init name until the kobject becomes available */
> 815		if (dev->init_name)
> 816			return dev->init_name;
> 817	
> 818		return kobject_name(&dev->kobj);
> 
> The root cause:
> Now pci_configure_device/pci_get_hp_params will be called for every pci_dev,
> including VF that is under virtual bus. But virtual bus does not have bridge
> set. So we can not refer pbus->self->dev directly.

This raises the question of what the correct behavior should be.  Your
patch certainly avoids the NULL pointer dereference.  It does so by making
acpi_pci_get_bridge_handle() fail gracefully, which means we will not look
for _HPP/_HPX for VF devices.  Is that what we want?

Most of the fields included in _HPX are read-only or not applicable for
VFs, but we need to at least ask the question of whether we want to
completely ignore _HPX for VFs.  If we do, I think maybe we should make
that more explicit in the code, e.g., by adding an explicit test of
dev->is_virtfn, instead of relying on this special case behavior of
acpi_pci_get_bridge_handle() that in turn depends on the obscure property
of a VF not having a bridge device.

Personally, I think that since the _HPX spec doesn't mention VFs at all, we
might want to assume that _HPX should apply to VFs, just like it applies to
PFs.  I can imagine future _HPX record formats, or non-ACPI firmware
configuration hints, that *would* apply to VFs, so it seems like it would
be pretty arbitrary to say "we won't configure VF devices at all."

> Add checking with pbus->slef and bail out early.
> 
> Fixing: commit 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")

Thanks for including this, but why not use the same format everybody else
does:

Fixes: 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  include/linux/pci-acpi.h |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/include/linux/pci-acpi.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci-acpi.h
> +++ linux-2.6/include/linux/pci-acpi.h
> @@ -44,8 +44,12 @@ static inline acpi_handle acpi_pci_get_b
>  
>  	if (pci_is_root_bus(pbus))
>  		dev = pbus->bridge;
> -	else
> +	else {
> +		if (!pbus->self)
> +			return NULL;
> +
>  		dev = &pbus->self->dev;
> +	}
>  
>  	dev_printk(KERN_DEBUG, &pbus->dev, "  bridge ACPI_HANDLE %p : %s\n",
>  			 ACPI_HANDLE(dev), dev_name(dev));
