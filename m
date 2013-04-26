Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab3DZED7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 00:03:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:59492 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3DZED5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 00:03:57 -0400
Message-ID: <5179FC4A.4080000@huawei.com>
Date: Fri, 26 Apr 2013 12:02:18 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        David Bulkow <David.Bulkow@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
References: <1366940820-15302-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1366940820-15302-1-git-send-email-yinghai@kernel.org>
Content-Type: multipart/mixed;
	boundary="------------000306040106020104060202"
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000306040106020104060202
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hi Yinghai,
   We should not remove this additional pci_disable_device().
Because we enable pcie port device twice before. The first is pci_enable_brides(),
in x86, it was called in pci_assign_unassigned_resources(). The second in pcie_port_device_register().
So we should call pci_disable_device() twice for pci_dev->enable_cnt balance.

But there is still a problem here. If we unbind a pcie port device pcie port driver, we can not
use its child devices again, because this pcie port device was disabled absolutely.

So I think we should move the second pci_disable_device() to remove.c.

I sent this patch to Bjorn and following is Bjorn reply
"And it's not clear to me whether unbinding the
pcie port driver should disable the bridge at all.  I think one could
argue that the bridge should remain functional even if the driver is
unloaded, because the PCI core *enables* the bridge even if the driver
is never loaded."

Yinghai, how do you think about this issue?



On 2013/4/26 9:47, Yinghai Lu wrote:
> During chasing one PCI xHCI hotplug problem, David Bulkow found
> 
> 	static void pcie_portdrv_remove(struct pci_dev *dev)
> 	{
>         	pcie_port_device_remove(dev);
> 	        pci_disable_device(dev);
> 	}
> and
> 	void pcie_port_device_remove(struct pci_dev *dev)
> 	{
>         	device_for_each_child(&dev->dev, NULL, remove_iter);
> 	        cleanup_service_irqs(dev);
> 	        pci_disable_device(dev);
> 	}
> 
> that extra pci_disable_device in pcie_port_device_remove() was added by
> | commit dc5351784eb36f1fec4efa88e01581be72c0b711
> | Author: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> | Date:   Wed Nov 25 21:04:00 2009 +0900
> |
> |    PCI: portdrv: cleanup service irqs initialization
> 
> so pci_dsiable_device is called two times.
> 
> We should remove extra one in pcie_portdrv_remove.
> 
> Reported-by: David Bulkow <David.Bulkow@stratus.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/pcie/portdrv_pci.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
> +++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
> @@ -223,7 +223,6 @@ static int pcie_portdrv_probe(struct pci
>  static void pcie_portdrv_remove(struct pci_dev *dev)
>  {
>  	pcie_port_device_remove(dev);
> -	pci_disable_device(dev);
>  }
>  
>  static int error_detected_iter(struct device *device, void *data)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


-- 
Thanks!
Yijing

--------------000306040106020104060202
Content-Type: text/x-patch;
	name="0001-PCI-move-second-pci_disable_device-into-pci_stop_bus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-PCI-move-second-pci_disable_device-into-pci_stop_bus.pa";
	filename*1="tch"

>From 44914e0e39dbe51e1a932492d6b4909d5967308e Mon Sep 17 00:00:00 2001
From: Yijing Wang <wangyijing@huawei.com>
Date: Tue, 16 Apr 2013 11:41:47 +0800
Subject: [PATCH] PCI: move second pci_disable_device into pci_stop_bus_device() for symmetry

Currently, we enable and disable pcie port device is not symmetrical. If
we unbind the pcie port driver for pcie port device, we will call pci_disable_device()
twice. Then the pcie port device is disabled, if there are some child devices
under it, the child device maybe cannot transmit data anymore. This patch move the
second pci_disable_device() int pci_stop_bus_device() to avoid this bug.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/portdrv_pci.c |    1 -
 drivers/pci/remove.c           |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index ed4d094..2ca1a0b 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -223,7 +223,6 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	pci_disable_device(dev);
 }
 
 static int error_detected_iter(struct device *device, void *data)
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index cc875e6..e8f7c3c 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -73,6 +73,7 @@ static void pci_stop_bus_device(struct pci_dev *dev)
 		list_for_each_entry_safe_reverse(child, tmp,
 						 &bus->devices, bus_list)
 			pci_stop_bus_device(child);
+			pci_disable_device(dev);
 	}
 
 	pci_stop_dev(dev);
-- 
1.7.1


--------------000306040106020104060202--
