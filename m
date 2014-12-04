Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaLDNQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:16:51 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:38685 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaLDNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:16:49 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2014 08:16:49 EST
Date: Thu, 4 Dec 2014 14:10:54 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1107877503.20141204141054@eikelenboom.it>
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, bhelgaas@google.com,
        <linux-pci@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v5 9/9] xen/pciback: Implement PCI reset slot or bus with 'do_flr' SysFS attribute
In-Reply-To: <5480528F.8010106@citrix.com>
References: <201412041206.sB4C6XVQ009497@userz7022.oracle.com> <5480528F.8010106@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thursday, December 4, 2014, 1:24:47 PM, you wrote:

> On 04/12/14 12:06, Konrad Rzeszutek Wilk wrote:
>> 
>> On Dec 4, 2014 6:30 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>>>
>>> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote: 
>>>>
>>>> Instead of doing all this complex dance, we depend on the toolstack 
>>>> doing the right thing. As such implement the 'do_flr' SysFS attribute 
>>>> which 'xl' uses when a device is detached or attached from/to a guest. 
>>>> It bypasses the need to worry about the PCI lock. 
>>>
>>> No.  Get pciback to add its own "reset" sysfs file (as I have repeatedly 
>>> proposed). 
>>>
>> 
>> Which does not work as the kobj will complain (as there is already an 'reset' associated with the PCI device).

> It is only needed if the core won't provide one.

> +static int pcistub_try_create_reset_file(struct pci_dev *pci)
> +{
> +       struct xen_pcibk_dev_data *dev_data = pci_get_drvdata(pci);
> +       struct device *dev = &pci->dev;
> +       int ret;
> +
> +       /* Already have a per-function reset? */
> +       if (pci_probe_reset_function(pci) == 0)
> +               return 0;
> +
> +       ret = device_create_file(dev, &dev_attr_reset);
> +       if (ret < 0)
> +               return ret;
+       dev_data->>created_reset_file = true;
> +       return 0;
> +}

Wouldn't the "core-reset-sysfs-file" be still wired to the end up calling 
"pci.c:__pci_dev_reset" ?

The problem with that function is that from my testing it seems that the 
first option "pci_dev_specific_reset" always seems to return succes, so all the
other options are skipped (flr, pm, slot, bus). However the device it self is 
not properly reset enough (perhaps the pci_dev_specific_reset is good enough for 
none virtualization purposes and it's probably the least intrusive. For 
virtualization however it would be nice to be sure it resets properly, or have a 
way to force a specific reset routine.) 

So it's the ordering and skipping of the other resets that seems to make
this workaround necessary in the first place.

> David





