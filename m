Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaLDOOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:14:37 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:39104 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaLDOOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:14:36 -0500
Date: Thu, 4 Dec 2014 15:14:32 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <19110649790.20141204151432@eikelenboom.it>
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, bhelgaas@google.com,
        <linux-pci@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v5 9/9] xen/pciback: Implement PCI reset slot or bus with 'do_flr' SysFS attribute
In-Reply-To: <308719815.20141204150909@eikelenboom.it>
References: <201412041206.sB4C6XVQ009497@userz7022.oracle.com> <5480528F.8010106@citrix.com> <1107877503.20141204141054@eikelenboom.it> <548064EA.8090905@citrix.com> <308719815.20141204150909@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sander,

Thursday, December 4, 2014, 3:09:09 PM, you wrote:


> Thursday, December 4, 2014, 2:43:06 PM, you wrote:

>> On 04/12/14 13:10, Sander Eikelenboom wrote:
>>> 
>>> Thursday, December 4, 2014, 1:24:47 PM, you wrote:
>>> 
>>>> On 04/12/14 12:06, Konrad Rzeszutek Wilk wrote:
>>>>>
>>>>> On Dec 4, 2014 6:30 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>>>>>>
>>>>>> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote: 
>>>>>>>
>>>>>>> Instead of doing all this complex dance, we depend on the toolstack 
>>>>>>> doing the right thing. As such implement the 'do_flr' SysFS attribute 
>>>>>>> which 'xl' uses when a device is detached or attached from/to a guest. 
>>>>>>> It bypasses the need to worry about the PCI lock. 
>>>>>>
>>>>>> No.  Get pciback to add its own "reset" sysfs file (as I have repeatedly 
>>>>>> proposed). 
>>>>>>
>>>>>
>>>>> Which does not work as the kobj will complain (as there is already an 'reset' associated with the PCI device).
>>> 
>>>> It is only needed if the core won't provide one.
>>> 
>>>> +static int pcistub_try_create_reset_file(struct pci_dev *pci)
>>>> +{
>>>> +       struct xen_pcibk_dev_data *dev_data = pci_get_drvdata(pci);
>>>> +       struct device *dev = &pci->dev;
>>>> +       int ret;
>>>> +
>>>> +       /* Already have a per-function reset? */
>>>> +       if (pci_probe_reset_function(pci) == 0)
>>>> +               return 0;
>>>> +
>>>> +       ret = device_create_file(dev, &dev_attr_reset);
>>>> +       if (ret < 0)
>>>> +               return ret;
>>> +       dev_data->>created_reset_file = true;
>>>> +       return 0;
>>>> +}
>>> 
>>> Wouldn't the "core-reset-sysfs-file" be still wired to the end up calling 
>>> "pci.c:__pci_dev_reset" ?
>>> 
>>> The problem with that function is that from my testing it seems that the 
>>> first option "pci_dev_specific_reset" always seems to return succes, so all the
>>> other options are skipped (flr, pm, slot, bus). However the device it self is 
>>> not properly reset enough (perhaps the pci_dev_specific_reset is good enough for 
>>> none virtualization purposes and it's probably the least intrusive. For 
>>> virtualization however it would be nice to be sure it resets properly, or have a 
>>> way to force a specific reset routine.)

>> Then you need work with the maintainer for those specific devices or
>> drivers to fix their specific reset function.

>> I'm not adding stuff to pciback to workaround broken quirks.

> OK that's a pretty clear message there, so if one wants to use pci and vga
> passthrough one should better use KVM and vfio-pci. 

> vfio-pci has:
> - logic to do the try-slot-bus-reset logic
> - it has quirks specific to vga passthrough
Hrmm have to correct my self because the vga-pt quirks are part of the vfio-pci 
part in qemu.

The try-slot-bus-reset logic is part of the kernel vfio-pci driver though and they faced the same locking issue it 
seems:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=61cf16d8bd38c3dc52033ea75d5b1f8368514a17
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=890ed578df82f5b7b5a874f9f2fa4f117305df5f

> implemented in from the looks of it a quite clean driver.
> (the main issue with it so far was you could only seize devices based on 
> vendor and device id, which can be a problem when you have multiple devices.
> However that was resolved recently if i am correct.)

> And neither of those will be supported by xen-pciback if i get your message 
> right ?

> --
> Sander

>> David


