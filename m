Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3FZC66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:58:58 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55028 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3FZC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <51C32B64.1010608@gmail.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
 <1369583597-3801-2-git-send-email-jiang.liu@huawei.com> <20130617200639.GA7877@google.com>
 <51C32B64.1010608@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Jun 2013 20:58:36 -0600
Message-ID: <CAErSpo7ZhVaj3OY-Eiw=bh+1fve_ZinP-rT_qN6h7OC=u=_RGQ@mail.gmail.com>
Subject: Re: [PATCH v3, part2 01/20] PCI: introduce hotplug-safe PCI bus iterators
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:18 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 06/18/2013 04:06 AM, Bjorn Helgaas wrote:
>> On Sun, May 26, 2013 at 11:52:58PM +0800, Jiang Liu wrote:
>>> Introduce hotplug-safe PCI bus iterators as below, which hold a
>>> reference on the returned PCI bus object.
>>> bool pci_bus_exists(int domain, int busnr);
>>> struct pci_bus *pci_get_bus(int domain, int busnr);
>>> struct pci_bus *pci_get_next_bus(struct pci_bus *from);
>>> struct pci_bus *pci_get_next_root_bus(struct pci_bus *from);
>>> #define for_each_pci_bus(b) for (b = NULL; (b = pci_get_next_bus(b)); )
>>> #define for_each_pci_root_bus(b)  \
>>>              for (b = NULL; (b = pci_get_next_root_bus(b)); )
>>>
>>> The long-term goal is to remove hotplug-unsafe pci_find_bus(),
>>> pci_find_next_bus() and the global pci_root_buses list.
>>
>> I think you should mark the unsafe interfaces as __deprecated so
>> users will get compile-time warnings.
>>
>> I don't think pci_bus_exists() is a safe interface, because the value
>> it returns may be incorrect before the caller can look at it.  The
>> only safe thing would be to make it so we try to create the bus
>> and return failure if it already exists.  Then the mutex can be in
>> the code that creates the bus.
>>
>> I don't see any uses of for_each_pci_bus(), so please remove that.
>>
>> It sounds like we don't have a consensus on how to iterate over
>> PCI root buses.  If you separate that from the pci_get_bus()
>> changes, maybe we can at least move forward on the pci_get_bus()
>> stuff.
> Hi Bjorn and Yinghai,
>     I have thought about the way to implement pci_for_each_root_bus()
> again. And there are several possible ways here:
> 1) Yinghai has a patch set implementing an iterator for PCI host
> bridges, but we can't safely refer the PCI root bus associated with a
> host bridge device because the host bridge doesn't hold a reference to
> associated PCI root bus. So we need to find a safe way to refer the PCI
> root bus associated with a PCI host bridge.
> 2) Unexport pci_root_buses and convert it to klist, then we could walk
> all root buses effectively. This solution is straight-forward, but it
> may break out of tree drivers.
> 3) Keep current implementation, which does waste some computation cycles:(
>
> So what's your thoughts about above solutions? Or any other suggestions?
> Regards!
> Gerry

Iteration is generally the wrong approach because it doesn't fit well
with hot plug.  I recognize that it may be impossible to fix all the
places that currently iterate over root buses, so we may have to
accept iteration at least in the short term.

Sometimes when we fix the things we *know* how to fix, it makes it
easier to see how to fix the hard problem.  Your pci_bus ref counting
fixes seem like a clear step forward, and I'd like to get them in
ASAP, even if the root bus iteration isn't figured out yet.

So my advice is, let's do the simple stuff we know how to do now, then
worry about the harder stuff later.

Bjorn
