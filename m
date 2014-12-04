Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaLDNnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:43:12 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:18525 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaLDNnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:43:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,515,1413244800"; 
   d="scan'208";a="200070164"
Message-ID: <548064EA.8090905@citrix.com>
Date: Thu, 4 Dec 2014 13:43:06 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v5 9/9] xen/pciback: Implement PCI reset slot
 or bus with 'do_flr' SysFS attribute
References: <201412041206.sB4C6XVQ009497@userz7022.oracle.com> <5480528F.8010106@citrix.com> <1107877503.20141204141054@eikelenboom.it>
In-Reply-To: <1107877503.20141204141054@eikelenboom.it>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/14 13:10, Sander Eikelenboom wrote:
> 
> Thursday, December 4, 2014, 1:24:47 PM, you wrote:
> 
>> On 04/12/14 12:06, Konrad Rzeszutek Wilk wrote:
>>>
>>> On Dec 4, 2014 6:30 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>>>>
>>>> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote: 
>>>>>
>>>>> Instead of doing all this complex dance, we depend on the toolstack 
>>>>> doing the right thing. As such implement the 'do_flr' SysFS attribute 
>>>>> which 'xl' uses when a device is detached or attached from/to a guest. 
>>>>> It bypasses the need to worry about the PCI lock. 
>>>>
>>>> No.  Get pciback to add its own "reset" sysfs file (as I have repeatedly 
>>>> proposed). 
>>>>
>>>
>>> Which does not work as the kobj will complain (as there is already an 'reset' associated with the PCI device).
> 
>> It is only needed if the core won't provide one.
> 
>> +static int pcistub_try_create_reset_file(struct pci_dev *pci)
>> +{
>> +       struct xen_pcibk_dev_data *dev_data = pci_get_drvdata(pci);
>> +       struct device *dev = &pci->dev;
>> +       int ret;
>> +
>> +       /* Already have a per-function reset? */
>> +       if (pci_probe_reset_function(pci) == 0)
>> +               return 0;
>> +
>> +       ret = device_create_file(dev, &dev_attr_reset);
>> +       if (ret < 0)
>> +               return ret;
> +       dev_data->>created_reset_file = true;
>> +       return 0;
>> +}
> 
> Wouldn't the "core-reset-sysfs-file" be still wired to the end up calling 
> "pci.c:__pci_dev_reset" ?
> 
> The problem with that function is that from my testing it seems that the 
> first option "pci_dev_specific_reset" always seems to return succes, so all the
> other options are skipped (flr, pm, slot, bus). However the device it self is 
> not properly reset enough (perhaps the pci_dev_specific_reset is good enough for 
> none virtualization purposes and it's probably the least intrusive. For 
> virtualization however it would be nice to be sure it resets properly, or have a 
> way to force a specific reset routine.)

Then you need work with the maintainer for those specific devices or
drivers to fix their specific reset function.

I'm not adding stuff to pciback to workaround broken quirks.

David
