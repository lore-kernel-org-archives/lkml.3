Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaKEVXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:23:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58331 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751115AbaKEVXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:23:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, Chao Zhou <chao.zhou@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] PCI: fix sriov enabling with virtual bus
Date: Wed, 05 Nov 2014 22:44:25 +0100
Message-ID: <1808324.GlBOqbYcPz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141105202252.GB6168@google.com>
References: <1414621570-20777-1-git-send-email-yinghai@kernel.org> <20141030170913.GA6982@google.com> <20141105202252.GB6168@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 01:22:52 PM Bjorn Helgaas wrote:
> [+cc Chao, Joerg]
> 
> On Thu, Oct 30, 2014 at 11:09:13AM -0600, Bjorn Helgaas wrote:
> > [+cc Rafael, linux-acpi]
> > 
> > On Wed, Oct 29, 2014 at 03:26:10PM -0700, Yinghai Lu wrote:
> > > While enabling sriov for intel igb device got:
> > > 
> > > sca05-0a81fda5:~ # echo 7 > /sys/bus/pci/devices/0000\:09\:00.0/sriov_numvfs 
> > > [  729.612191] pci 0000:0a:10.0: [8086:1520] type 00 class 0x020000
> > > [  729.619002] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e8
> > > [  729.627767] IP: [<ffffffff815901cb>] pci_get_hp_params+0x5b/0x640
> > > [  729.634593] PGD 0 
> > > [  729.636844] Oops: 0000 [#1] SMP 
> > > [  729.640466] Modules linked in:
> > > ...
> > > [  729.795268] Call Trace:
> > > [  729.798007]  [<ffffffff81ea0843>] ? pci_mmcfg_read+0x123/0x140
> > > [  729.804519]  [<ffffffff81ea0770>] ? pci_mmcfg_read+0x50/0x140
> > > [  729.810942]  [<ffffffff815692a3>] pci_configure_device+0x33/0x350
> > > [  729.817744]  [<ffffffff8156aba4>] pci_device_add+0x24/0x160
> > > [  729.823965]  [<ffffffff8158f3bb>] pci_enable_sriov+0x4db/0x7d0
> > > [  729.830486]  [<ffffffff81b63f54>] ? igb_pci_enable_sriov+0xe4/0x200
> > > [  729.837481]  [<ffffffff81b63f7f>] igb_pci_enable_sriov+0x10f/0x200
> > > [  729.844386]  [<ffffffff8155129c>] ? _kstrtoull+0x2c/0x80
> > > [  729.850315]  [<ffffffff81b640a5>] igb_pci_sriov_configure+0x35/0x40
> > > [  729.857318]  [<ffffffff815752b5>] sriov_numvfs_store+0xe5/0x140
> > > [  729.863934]  [<ffffffff817e1f88>] dev_attr_store+0x18/0x30
> > > [  729.870063]  [<ffffffff812624d8>] sysfs_kf_write+0x48/0x60
> > > [  729.876186]  [<ffffffff812617ef>] ? kernfs_fop_write+0xaf/0x170
> > > [  729.882797]  [<ffffffff81261827>] kernfs_fop_write+0xe7/0x170
> > > [  729.889222]  [<ffffffff811ef66b>] vfs_write+0xcb/0x1c0
> > > [  729.894958]  [<ffffffff811f0019>] SyS_write+0x49/0xb0
> > > ...
> > > [  729.943531] ---[ end trace 7cf0cdb66637665a ]---
> > > 
> > > and pci_get_hp_params+0x5b point to
> > > 0xffffffff815901cb is in pci_get_hp_params (include/linux/device.h:815).
> > > 810	#include <linux/pm_wakeup.h>
> > > 811	
> > > 812	static inline const char *dev_name(const struct device *dev)
> > > 813	{
> > > 814		/* Use the init name until the kobject becomes available */
> > > 815		if (dev->init_name)
> > > 816			return dev->init_name;
> > > 817	
> > > 818		return kobject_name(&dev->kobj);
> > > 
> > > The root cause:
> > > Now pci_configure_device/pci_get_hp_params will be called for every pci_dev,
> > > including VF that is under virtual bus. But virtual bus does not have bridge
> > > set. So we can not refer pbus->self->dev directly.
> > 
> > This raises the question of what the correct behavior should be.  Your
> > patch certainly avoids the NULL pointer dereference.  It does so by making
> > acpi_pci_get_bridge_handle() fail gracefully, which means we will not look
> > for _HPP/_HPX for VF devices.
> 
> I think I was mistaken about this.  A VF device might be on a virtual bus.
>  And a virtual bus never has a bridge leading to it, i.e., its bus->self
> pointer is NULL.  But I think a virtual bus always has a *parent* bus,
> i.e., for a VF, dev->bus->parent is always valid.  This is because when
> virtfn_add_bus() creates the virtual bus with "pci_add_new_bus(bus, NULL,
> busnr)", the "bus" parameter (which becomes the parent bus of the virtual
> bus) is a valid bus.
> 
> So with your patch, I think we *will* actually look for _HPP and _HPX for
> VF devices, because we'll look for the handle of the bridge leading to the
> virtual bus (which will return NULL), then for the handle of the bridge
> leading to the virtual bus' parent bus, etc.
> 
> If you agree, Yinghai, I'll apply the patch below (same as what you posted,
> with different changelog and a comment in the code).
> 
> The acpi_pci_get_bridge_handle(struct pci_bus *) interface niggles at me a
> little because I don't think there's any concept of an ACPI device for a
> PCI *bus*, so it doesn't seem like a very good fit to say "find the handle
> for this bus".  But that's for later.

To me it does what it says: Get me the handle of the bridge leading to this bus.

> commit 32f638fc11db0526c706454d9ab4339d55ac89f3
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Thu Oct 30 10:17:25 2014 -0600
> 
>     PCI: Don't oops on virtual buses in acpi_pci_get_bridge_handle()
>     
>     acpi_pci_get_bridge_handle() returns the ACPI handle for the bridge device
>     (either a host bridge or a PCI-to-PCI bridge) leading to a PCI bus.  But
>     SR-IOV virtual functions can be on a virtual bus with no bridge leading to
>     it.  Return a NULL acpi_handle in this case instead of trying to
>     dereference the NULL pointer to the bridge.
>     
>     This fixes a NULL pointer dereference oops in pci_get_hp_params() when
>     adding SR-IOV VF devices on virtual buses.
>     
>     [bhelgaas: changelog, add comment in code]
>     Fixes: 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=87591
>     Reported-by: Chao Zhou <chao.zhou@intel.com>
>     Reported-by: Joerg Roedel <joro@8bytes.org>
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
> index 64dacb7288a6..24c7728ca681 100644
> --- a/include/linux/pci-acpi.h
> +++ b/include/linux/pci-acpi.h
> @@ -41,8 +41,13 @@ static inline acpi_handle acpi_pci_get_bridge_handle(struct pci_bus *pbus)
>  
>  	if (pci_is_root_bus(pbus))
>  		dev = pbus->bridge;
> -	else
> +	else {
> +		/* If pbus is a virtual bus, there is no bridge to it */
> +		if (!pbus->self)
> +			return NULL;
> +
>  		dev = &pbus->self->dev;
> +	}
>  
>  	return ACPI_HANDLE(dev);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
