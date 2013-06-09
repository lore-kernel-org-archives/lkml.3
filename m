Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab3FIQu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:50:59 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44553 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FIQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:50:57 -0400
Message-ID: <51B4B266.5010100@gmail.com>
Date: Mon, 10 Jun 2013 00:50:46 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH v2, part3 07/11] PCI, xen-pcifront: use new PCI interfaces
 to simplify implementation
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com> <1368719459-24800-8-git-send-email-jiang.liu@huawei.com> <20130607145024.GA16631@phenom.dumpdata.com> <20130607153822.GA24882@phenom.dumpdata.com> <51B20F57.7050100@gmail.com> <20130607170706.GB3730@phenom.dumpdata.com>
In-Reply-To: <20130607170706.GB3730@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 08 Jun 2013 01:07:06 AM CST, Konrad Rzeszutek Wilk wrote:
> On Sat, Jun 08, 2013 at 12:50:31AM +0800, Jiang Liu wrote:
>> On 06/07/2013 11:38 PM, Konrad Rzeszutek Wilk wrote:
>>> On Fri, Jun 07, 2013 at 10:50:24AM -0400, Konrad Rzeszutek Wilk wrote:
>>>> On Thu, May 16, 2013 at 11:50:55PM +0800, Jiang Liu wrote:
>>>>> Use new PCI interfaces to simplify xen-pcifront implementation:
>>>>> 1) Use pci_create_root_bus() instead of pci_scan_bus_parented()
>>>>>    because pci_scan_bus_parented() is marked as __deprecated.This
>>>>>    also gets rid of a duplicated call of pci_bus_start_devices().
>>>>> 2) Use pci_stop_root_bus() and pci_remove_root_bus() instead of
>>>>>    open-coded private implementation.
>>>>> 3) Use pci_set_host_bridge_release() to release data structures
>>>>>    associated with PCI root buses.
>>>>> 4) Use pci_bus_get()/pci_bus_put() to manage PCI root bus reference
>>>>>    count.
>>>>>
>>>>> This is also a preparation for coming PCI bus lock enhancement.
>>>
>>> With this patch from :
>>>
>>>  Merge branch 'pci_lock_v3' of https://github.com/jiangliu/linux into testing
>>>
>>>
>>> it blows up when detaching the device.
>> Hi Konrad,
>>    Thanks for testing! According to the log messages, this issue should
>> be related to pci bus reference counter management. Seems we have done
>> an extra(unbalanced) release of pci bus device.
>>    Will investigate it tomorrow!
>
> That is quite commendable that you are willing to look over this on
> the weekend but I am not going to be able to rerun this test until
> some time in the week. You could enjoy the weekend and just look at
> this during the week.

Hi Konrad,
     We should have root-caused this bug, which is caused by 
for_each_pci_root_bus().
Current implementation doesn't support root bus deletion when walking 
PCI root
buses by for_each_pci_root_bus(). The reference counter 
(pci_bus->dev.knode_class.n_ref)
becomes zero after returning from pci_remove_root_bus(), so it triggers 
kref warnings
and double-free of klist_node object when we call 
pci_get_next_root_bus() to get the
next PCI root bus.
     So we will first revert to  list_for_each_entry_safe(bus, temp, 
&pci_root_buses, node)
and solve this issue in next version of for_each_pci_root_bus().

Regards!
Gerry

---
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 6aa2c0f..6e577db 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -553,11 +553,11 @@ static int pcifront_rescan_root(struct 
pcifront_device *pdev,
 static void pcifront_free_roots(struct pcifront_device *pdev)
 {
        struct pcifront_sd *sd;
-       struct pci_bus *bus;
+       struct pci_bus *bus, *temp;

        dev_dbg(&pdev->xdev->dev, "cleaning up root buses\n");

-       for_each_pci_root_bus(bus) {
+       list_for_each_entry_safe(bus, temp, &pci_root_buses, node) {
                sd = bus->sysdata;
                if (sd->pdev == pdev) {
                        pci_stop_root_bus(bus);
---

