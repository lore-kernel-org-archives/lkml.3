Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab3ENO7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:59:14 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:55758 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3ENO7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:59:12 -0400
Message-ID: <51925136.5050302@gmail.com>
Date: Tue, 14 May 2013 22:59:02 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Linux-Scsi <linux-scsi@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)
 instead
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com> <1368461313-4371-4-git-send-email-jiang.liu@huawei.com> <CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com> <5191F53E.4000305@cn.fujitsu.com>
In-Reply-To: <5191F53E.4000305@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 04:26 PM, Gu Zheng wrote:
> On 05/14/2013 01:23 AM, Yinghai Lu wrote:
>
>> On Mon, May 13, 2013 at 9:08 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
>>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>>> index 4f0bc0a..bc075a3 100644
>>> --- a/drivers/pci/probe.c
>>> +++ b/drivers/pci/probe.c
>>> @@ -1131,6 +1131,7 @@ static void pci_release_dev(struct device *dev)
>>>          struct pci_dev *pci_dev;
>>>
>>>          pci_dev = to_pci_dev(dev);
>>> +       pci_bus_put(pci_dev->bus);
>>>          pci_release_capabilities(pci_dev);
>>>          pci_release_of_node(pci_dev);
>>>          kfree(pci_dev);
>>> @@ -1269,11 +1270,10 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
>>>          if (!pci_bus_read_dev_vendor_id(bus, devfn, &l, 60*1000))
>>>                  return NULL;
>>>
>>> -       dev = alloc_pci_dev();
>>> +       dev = pci_alloc_dev(bus);
>>>          if (!dev)
>>>                  return NULL;
>>>
>>> -       dev->bus = bus;
>>>          dev->devfn = devfn;
>>>          dev->vendor = l & 0xffff;
>>>          dev->device = (l >> 16) & 0xffff;
>> in pci_setup_device() fail path, it release the ref to that bus.
> Yes, you're right, we need to release the bus' ref if pci_setup_device() failed.
Hi Zheng,
     I suggest to use pci_release_dev() instead because it also needs to 
release OF related resources.
I will update it in next version.

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bc075a3..2ac6338 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1281,7 +1281,7 @@ static struct pci_dev *pci_scan_device(struct 
pci_bus *bus
         pci_set_of_node(dev);

         if (pci_setup_device(dev)) {
-               kfree(dev);
+               pci_release_dev(&dev->dev);
                 return NULL;
         }


> hanks for your correction.:)
>
> Best regards,
> Gu
>
>> Yinghai
>>
>

