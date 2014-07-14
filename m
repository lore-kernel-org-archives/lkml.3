Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaGNQiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:38:09 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:49314 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbaGNQiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:38:01 -0400
Date: Mon, 14 Jul 2014 18:37:55 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <768165707.20140714183755@eikelenboom.it>
To: konrad@kernel.org
CC: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] PCI back fixes for 3.17.
In-Reply-To: <1405109332-31659-1-git-send-email-konrad@kernel.org>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Friday, July 11, 2014, 10:08:47 PM, you wrote:

> Please see this set of patches which are fixes to Xen pciback
> for 3.17. They are also located at:

>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pciback-3.17.v4 

> These patches do not include the PCI bus reset/slot code as we are still
> discussing that.

> Konrad Rzeszutek Wilk (5):
>       xen-pciback: Document the various parameters and attributes in SysFS
>       xen/pciback: Don't deadlock when unbinding.
>       xen/pciback: Include the domain id if removing the device whilst still in use
>       xen/pciback: Print out the domain owning the device.
>       xen/pciback: Remove tons of dereferences

>  Documentation/ABI/testing/sysfs-driver-pciback |   25 +++++++++++++++
>  drivers/xen/xen-pciback/passthrough.c          |    9 ++++-
>  drivers/xen/xen-pciback/pci_stub.c             |   41 +++++++++++++------------
>  drivers/xen/xen-pciback/pciback.h              |    7 ++--
>  drivers/xen/xen-pciback/vpci.c                 |    9 ++++-
>  drivers/xen/xen-pciback/xenbus.c               |    4 +-
>  6 files changed, 67 insertions(+), 28 deletions(-)

Hi Konrad / David,

Thanks for the fixes in this series, i just tested this series and noticed (as 
somewhat expected :-) ) it's still lacking a fix for the bug that pciback 
doesn't properly free / disown a device from a HVM guest.

This only happens when using "xl pci-detach domain BDF"
  AND
when the guest has more than one pci device attached and you remove only ONE of 
them.

The pci-detach doesn't show an error, the device is removed from the guest, but 
it seems it is not internally freed in pciback.

Below is the sequence and outcome (with some added printk's) for two situations:
A) Guest has only one pci-device passed through which is then removed, as you can see 
it's freed in pciback as well.

B) Guest has two pci-devices passed through from which one is then removed. 
After that the second is removed as well.

>From what i recall Konrad thought it could be due to the guest being a HVM and thus the signaling is different from a
PV-Guest (no pci-front confirming the removal via xenbus). But since it does get freed when it is the last device attached to the guest
i don't know if that's completely true.
It's now semi-fixed when doing the 'xl pci-assignable-remove', that seems to force unregistring the device owner, however something still doesn't seem
right see the second "xl pci-detach" removing the last device from (A), it takes about a minute instead of not more than a second.

Also note that when on calling "xl pci-assignable-remove" for the last (or only) passed through device for a guest, you don't get the warning messages about
the device being 'in-use'

Completely below an diff of the added printk's.

--

Sander


Ad A)

root@dom0:~# xl pci-list router
Vdev Device
05.0 0000:02:00.0
06.0 0000:00:1b.0

root@dom0:~# xl pci-assignable-list

root@dom0:~# xl pci-detach router 00:1b.0

dmesg shows:
[  434.839156] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
[  434.841745] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
[  434.844205] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)

xl dmesg shows:
(XEN) [2014-07-14 16:02:27] memory_map:remove: dom1 gfn=f3070 mfn=f7d30 nr=4
(XEN) [2014-07-14 16:02:27] io.c:322: d1: unbind: m_gsi=22 g_gsi=40 dev=00:00.6 intx=0
(XEN) [2014-07-14 16:02:27] io.c:390: d1 unmap: m_irq=22 dev=00:00.6 intx=0
(XEN) [2014-07-14 16:02:27] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:00:1b.0
(XEN) [2014-07-14 16:02:27] [VT-D]iommu.c:1440: d0:PCIe: map 0000:00:1b.0

root@dom0:~# xl pci-assignable-list
0000:00:1b.0

root@dom0:~# xl pci-assignable-remove 00:1b.0
dmesg shows:
[  609.246406] xen_pciback: ****** removing device 0000:00:1b.0 while still in-use by domain 1! ******
[  609.248985] xen_pciback: ****** driver domain may still access this device's i/o resources!
[  609.251344] xen_pciback: ****** shutdown driver domain before binding device
[  609.253291] xen_pciback: ****** to other drivers or domains
[  609.355083] xen: xen_unregister_device_domain_owner
[  609.356448] xen: xen_unregister_device_domain_owner
[  609.357789] xen: xen_unregister_device_domain_owner: ENODEV
[  609.463125] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
[  609.465692] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
[  609.468137] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)

root@dom0:~# xl pci-list router
Vdev Device
05.0 0000:02:00.0

root@dom0:~# xl pci-detach router 02:00.0
dmesg shows:
[  930.571300] pciback 0000:02:00.0: restoring config space at offset 0x3c (was 0x100, writing 0x104)
[  930.574140] pciback 0000:02:00.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7c00004)
[  930.576859] pciback 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
[  930.614554] xen-pciback pci-1-0: xen_pcibk_xenbus_remove freeing pdev @ 0xffff880058fcb480
[  930.615606] xen-pciback pci-1-0: xen_pcibk_disconnect pdev @ 0xffff880058fcb480
[  930.719110] xen: xen_unregister_device_domain_owner

xl dmesg shows:
(XEN) [2014-07-14 16:10:43] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:02:00.0
(XEN) [2014-07-14 16:10:43] [VT-D]iommu.c:1440: d0:PCIe: map 0000:02:00.0
(XEN) [2014-07-14 16:11:46] memory_map:remove: dom1 gfn=f3074 mfn=f7c00 nr=2
(XEN) [2014-07-14 16:11:46] io.c:322: d1: unbind: m_gsi=18 g_gsi=36 dev=00:00.5 intx=0
(XEN) [2014-07-14 16:11:46] io.c:390: d1 unmap: m_irq=18 dev=00:00.5 intx=0

root@dom0:~# xl pci-assignable-list
0000:02:00.0

root@dom0:~# xl pci-assignable-remove 02:00.0
dmesg shows:
[ 1468.561071] xen: xen_unregister_device_domain_owner
[ 1468.562431] xen: xen_unregister_device_domain_owner: ENODEV
[ 1468.667271] pciback 0000:02:00.0: restoring config space at offset 0x3c (was 0x100, writing 0x104)
[ 1468.670119] pciback 0000:02:00.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7c00004)
[ 1468.672857] pciback 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)


Ad B)

root@dom0:~# xl pci-list router
Vdev Device
05.0 0000:00:1b.0

root@dom0:~# xl pci-assignable-list
0000:02:00.0

root@dom0:~# xl pci-detach router 00:1b.0
dmesg shows:
[  199.742668] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
[  199.743527] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
[  199.744321] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
[  199.757184] xen-pciback pci-1-0: xen_pcibk_xenbus_remove freeing pdev @ 0xffff8800589fce40
[  199.758139] xen-pciback pci-1-0: xen_pcibk_disconnect pdev @ 0xffff8800589fce40
[  199.862595] xen: xen_unregister_device_domain_owner

xl dmesg shows:
(XEN) [2014-07-14 16:28:29] memory_map:remove: dom1 gfn=f3070 mfn=f7d30 nr=4
(XEN) [2014-07-14 16:28:29] io.c:322: d1: unbind: m_gsi=22 g_gsi=36 dev=00:00.5 intx=0
(XEN) [2014-07-14 16:28:29] io.c:390: d1 unmap: m_irq=22 dev=00:00.5 intx=0
(XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:00:1b.0
(XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1440: d0:PCIe: map 0000:00:1b.0

root@dom0:~# xl pci-list router
root@dom0:~# xl pci-assignable-list
0000:00:1b.0
0000:02:00.0

root@dom0:~# xl pci-assignable-remove 00:1b.0
dmesg shows:
[  318.827415] xen: xen_unregister_device_domain_owner
[  318.828771] xen: xen_unregister_device_domain_owner: ENODEV
[  318.930869] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
[  318.933435] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
[  318.935877] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)

root@dom0:~# xl pci-list router
root@dom0:~# xl pci-assignable-list
0000:02:00.0



diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 905956f..8145e93 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -587,17 +587,22 @@ EXPORT_SYMBOL_GPL(xen_register_device_domain_owner);
 int xen_unregister_device_domain_owner(struct pci_dev *dev)
 {
        struct xen_device_domain_owner *owner;
+        printk(KERN_WARNING "xen: xen_unregister_device_domain_owner\n");
+

        spin_lock(&dev_domain_list_spinlock);
        owner = find_device(dev);
        if (!owner) {
                spin_unlock(&dev_domain_list_spinlock);
+               printk(KERN_WARNING "xen: xen_unregister_device_domain_owner: ENODEV \n");
+
                return -ENODEV;
        }
        list_del(&owner->list);
        spin_unlock(&dev_domain_list_spinlock);
        kfree(owner);
        return 0;
+
 }
 EXPORT_SYMBOL_GPL(xen_unregister_device_domain_owner);
 #endif
diff --git a/drivers/xen/xen-pciback/pciback.h b/drivers/xen/xen-pciback/pciback.h
index 58e38d5..ef38f5b 100644
--- a/drivers/xen/xen-pciback/pciback.h
+++ b/drivers/xen/xen-pciback/pciback.h
@@ -17,6 +17,8 @@

 #define DRV_NAME       "xen-pciback"

+#define DEBUG
+
 struct pci_dev_entry {
        struct list_head list;
        struct pci_dev *dev;
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 0f80760..127725e 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -16,6 +16,8 @@
 #include <asm/xen/pci.h>
 #include "pciback.h"

+#define DEBUG
+
 #define INVALID_EVTCHN_IRQ  (-1)
 struct workqueue_struct *xen_pcibk_wq;

@@ -64,6 +66,8 @@ out:

 static void xen_pcibk_disconnect(struct xen_pcibk_device *pdev)
 {
+       dev_info(&pdev->xdev->dev, "xen_pcibk_disconnect pdev @ 0x%p\n", pdev);
+
        mutex_lock(&pdev->dev_lock);
        /* Ensure the guest can't trigger our handler before removing devices */
        if (pdev->evtchn_irq != INVALID_EVTCHN_IRQ) {
@@ -273,19 +277,19 @@ static int xen_pcibk_remove_device(struct xen_pcibk_device *pdev,
        int err = 0;
        struct pci_dev *dev;

-       dev_dbg(&pdev->xdev->dev, "removing dom %x bus %x slot %x func %x\n",
+       dev_info(&pdev->xdev->dev, "removing dom %x bus %x slot %x func %x\n",
                domain, bus, slot, func);

        dev = xen_pcibk_get_pci_dev(pdev, domain, bus, PCI_DEVFN(slot, func));
        if (!dev) {
                err = -EINVAL;
-               dev_dbg(&pdev->xdev->dev, "Couldn't locate PCI device "
+               dev_info(&pdev->xdev->dev, "Couldn't locate PCI device "
                        "(%04x:%02x:%02x.%d)! not owned by this domain\n",
                        domain, bus, slot, func);
                goto out;
        }

-       dev_dbg(&dev->dev, "unregistering for %d\n", pdev->xdev->otherend_id);
+       dev_info(&dev->dev, "unregistering for %d\n", pdev->xdev->otherend_id);
        xen_unregister_device_domain_owner(dev);

        /* N.B. This ends up calling pcistub_put_pci_dev which ends up
@@ -707,9 +711,13 @@ static int xen_pcibk_xenbus_remove(struct xenbus_device *dev)
 {
        struct xen_pcibk_device *pdev = dev_get_drvdata(&dev->dev);

-       if (pdev != NULL)
+       if (pdev != NULL){
+               dev_info(&dev->dev, "xen_pcibk_xenbus_remove freeing pdev @ 0x%p\n", pdev);
                free_pdev(pdev);
+       } else {
+               dev_info(&dev->dev, "xen_pcibk_xenbus_remove trying to free pdev==NULL\n");

+       }
        return 0;
 }




