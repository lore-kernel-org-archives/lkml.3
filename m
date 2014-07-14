Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaGNR3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:29:43 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:49612 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbaGNR31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:29:27 -0400
Date: Mon, 14 Jul 2014 19:29:23 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <652296445.20140714192923@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: konrad@kernel.org, xen-devel@lists.xenproject.org,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] PCI back fixes for 3.17.
In-Reply-To: <20140714172225.GA10497@laptop.dumpdata.com>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org> <768165707.20140714183755@eikelenboom.it> <20140714172225.GA10497@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Monday, July 14, 2014, 7:22:25 PM, you wrote:

> On Mon, Jul 14, 2014 at 06:37:55PM +0200, Sander Eikelenboom wrote:
>> 
>> Friday, July 11, 2014, 10:08:47 PM, you wrote:
>> 
>> > Please see this set of patches which are fixes to Xen pciback
>> > for 3.17. They are also located at:
>> 
>> >  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pciback-3.17.v4 
>> 
>> > These patches do not include the PCI bus reset/slot code as we are still
>> > discussing that.
>> 
>> > Konrad Rzeszutek Wilk (5):
>> >       xen-pciback: Document the various parameters and attributes in SysFS
>> >       xen/pciback: Don't deadlock when unbinding.
>> >       xen/pciback: Include the domain id if removing the device whilst still in use
>> >       xen/pciback: Print out the domain owning the device.
>> >       xen/pciback: Remove tons of dereferences
>> 
>> >  Documentation/ABI/testing/sysfs-driver-pciback |   25 +++++++++++++++
>> >  drivers/xen/xen-pciback/passthrough.c          |    9 ++++-
>> >  drivers/xen/xen-pciback/pci_stub.c             |   41 +++++++++++++------------
>> >  drivers/xen/xen-pciback/pciback.h              |    7 ++--
>> >  drivers/xen/xen-pciback/vpci.c                 |    9 ++++-
>> >  drivers/xen/xen-pciback/xenbus.c               |    4 +-
>> >  6 files changed, 67 insertions(+), 28 deletions(-)
>> 
>> Hi Konrad / David,
>> 
>> Thanks for the fixes in this series, i just tested this series and noticed (as 
>> somewhat expected :-) ) it's still lacking a fix for the bug that pciback 
>> doesn't properly free / disown a device from a HVM guest.
>> 
>> This only happens when using "xl pci-detach domain BDF"
>>   AND
>> when the guest has more than one pci device attached and you remove only ONE of 
>> them.
>> 
>> The pci-detach doesn't show an error, the device is removed from the guest, but 
>> it seems it is not internally freed in pciback.
>> 
>> Below is the sequence and outcome (with some added printk's) for two situations:
>> A) Guest has only one pci-device passed through which is then removed, as you can see 
>> it's freed in pciback as well.
>> 
>> B) Guest has two pci-devices passed through from which one is then removed. 
>> After that the second is removed as well.
>> 
>> >From what i recall Konrad thought it could be due to the guest being a HVM and thus the signaling is different from a
>> PV-Guest (no pci-front confirming the removal via xenbus). But since it does get freed when it is the last device attached to the guest
>> i don't know if that's completely true.
>> It's now semi-fixed when doing the 'xl pci-assignable-remove', that seems to force unregistring the device owner, however something still doesn't seem
>> right see the second "xl pci-detach" removing the last device from (A), it takes about a minute instead of not more than a second.
>> 
>> Also note that when on calling "xl pci-assignable-remove" for the last (or only) passed through device for a guest, you don't get the warning messages about
>> the device being 'in-use'
>> 
>> Completely below an diff of the added printk's.
>> 
>> --
>> 
>> Sander
>> 
>> 
>> Ad A)
>> 
>> root@dom0:~# xl pci-list router
>> Vdev Device
>> 05.0 0000:02:00.0
>> 06.0 0000:00:1b.0
>> 
>> root@dom0:~# xl pci-assignable-list
>> 
>> root@dom0:~# xl pci-detach router 00:1b.0
>> 
>> dmesg shows:
>> [  434.839156] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> [  434.841745] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> [  434.844205] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> 
>> xl dmesg shows:
>> (XEN) [2014-07-14 16:02:27] memory_map:remove: dom1 gfn=f3070 mfn=f7d30 nr=4
>> (XEN) [2014-07-14 16:02:27] io.c:322: d1: unbind: m_gsi=22 g_gsi=40 dev=00:00.6 intx=0
>> (XEN) [2014-07-14 16:02:27] io.c:390: d1 unmap: m_irq=22 dev=00:00.6 intx=0
>> (XEN) [2014-07-14 16:02:27] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:00:1b.0
>> (XEN) [2014-07-14 16:02:27] [VT-D]iommu.c:1440: d0:PCIe: map 0000:00:1b.0
>> 
>> root@dom0:~# xl pci-assignable-list
>> 0000:00:1b.0
>> 
>> root@dom0:~# xl pci-assignable-remove 00:1b.0
>> dmesg shows:
>> [  609.246406] xen_pciback: ****** removing device 0000:00:1b.0 while still in-use by domain 1! ******
>> [  609.248985] xen_pciback: ****** driver domain may still access this device's i/o resources!
>> [  609.251344] xen_pciback: ****** shutdown driver domain before binding device
>> [  609.253291] xen_pciback: ****** to other drivers or domains
>> [  609.355083] xen: xen_unregister_device_domain_owner
>> [  609.356448] xen: xen_unregister_device_domain_owner
>> [  609.357789] xen: xen_unregister_device_domain_owner: ENODEV
>> [  609.463125] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> [  609.465692] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> [  609.468137] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> 
>> root@dom0:~# xl pci-list router
>> Vdev Device
>> 05.0 0000:02:00.0
>> 
>> root@dom0:~# xl pci-detach router 02:00.0
>> dmesg shows:
>> [  930.571300] pciback 0000:02:00.0: restoring config space at offset 0x3c (was 0x100, writing 0x104)
>> [  930.574140] pciback 0000:02:00.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7c00004)
>> [  930.576859] pciback 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> [  930.614554] xen-pciback pci-1-0: xen_pcibk_xenbus_remove freeing pdev @ 0xffff880058fcb480
>> [  930.615606] xen-pciback pci-1-0: xen_pcibk_disconnect pdev @ 0xffff880058fcb480
>> [  930.719110] xen: xen_unregister_device_domain_owner
>> 
>> xl dmesg shows:
>> (XEN) [2014-07-14 16:10:43] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:02:00.0
>> (XEN) [2014-07-14 16:10:43] [VT-D]iommu.c:1440: d0:PCIe: map 0000:02:00.0
>> (XEN) [2014-07-14 16:11:46] memory_map:remove: dom1 gfn=f3074 mfn=f7c00 nr=2
>> (XEN) [2014-07-14 16:11:46] io.c:322: d1: unbind: m_gsi=18 g_gsi=36 dev=00:00.5 intx=0
>> (XEN) [2014-07-14 16:11:46] io.c:390: d1 unmap: m_irq=18 dev=00:00.5 intx=0
>> 
>> root@dom0:~# xl pci-assignable-list
>> 0000:02:00.0
>> 
>> root@dom0:~# xl pci-assignable-remove 02:00.0
>> dmesg shows:
>> [ 1468.561071] xen: xen_unregister_device_domain_owner
>> [ 1468.562431] xen: xen_unregister_device_domain_owner: ENODEV
>> [ 1468.667271] pciback 0000:02:00.0: restoring config space at offset 0x3c (was 0x100, writing 0x104)
>> [ 1468.670119] pciback 0000:02:00.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7c00004)
>> [ 1468.672857] pciback 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> 
>>

> At this point if you do:


> #xl pci-assignable-list

> I presume you don't see anything

(nods)
  
>> Ad B)
>> 
>> root@dom0:~# xl pci-list router
>> Vdev Device
>> 05.0 0000:00:1b.0
>> 
>> root@dom0:~# xl pci-assignable-list
>> 0000:02:00.0
>> 
>> root@dom0:~# xl pci-detach router 00:1b.0
>> dmesg shows:
>> [  199.742668] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> [  199.743527] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> [  199.744321] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> [  199.757184] xen-pciback pci-1-0: xen_pcibk_xenbus_remove freeing pdev @ 0xffff8800589fce40
>> [  199.758139] xen-pciback pci-1-0: xen_pcibk_disconnect pdev @ 0xffff8800589fce40
>> [  199.862595] xen: xen_unregister_device_domain_owner
>> 
>> xl dmesg shows:
>> (XEN) [2014-07-14 16:28:29] memory_map:remove: dom1 gfn=f3070 mfn=f7d30 nr=4
>> (XEN) [2014-07-14 16:28:29] io.c:322: d1: unbind: m_gsi=22 g_gsi=36 dev=00:00.5 intx=0
>> (XEN) [2014-07-14 16:28:29] io.c:390: d1 unmap: m_irq=22 dev=00:00.5 intx=0
>> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:00:1b.0
>> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1440: d0:PCIe: map 0000:00:1b.0
>> 
>> root@dom0:~# xl pci-list router
>> root@dom0:~# xl pci-assignable-list
>> 0000:00:1b.0
>> 0000:02:00.0
>> 
>> root@dom0:~# xl pci-assignable-remove 00:1b.0
>> dmesg shows:
>> [  318.827415] xen: xen_unregister_device_domain_owner
>> [  318.828771] xen: xen_unregister_device_domain_owner: ENODEV
>> [  318.930869] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> [  318.933435] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> [  318.935877] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> 
>> root@dom0:~# xl pci-list router
>> root@dom0:~# xl pci-assignable-list
>> 0000:02:00.0
>> 
>> 

> And if you do:

> # xl pci-detach router 02:00.0

> Do you see it being cleared from pciback? And what do you
> see in /sys/bus/pci/drivers/pciback ?

Hmm good point .. i also had the plan to look into xenstore what was in there .. 
but forgot .. will post both right away :-) 

> Thanks!


