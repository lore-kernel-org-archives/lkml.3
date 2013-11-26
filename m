Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3KZQli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:41:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23198 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3KZQle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:41:34 -0500
Message-ID: <5294CF1A.6080707@oracle.com>
Date: Tue, 26 Nov 2013 09:40:58 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Chang Liu <cl91tp@gmail.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, Jility <jility09@gmail.com>,
        Florian Otti <f.otti@gmx.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: add a quirk for keeping Bus Master bit on shutdown
References: <1384285203-642-1-git-send-email-cl91tp@gmail.com> <CAErSpo5E4584zgTt4ySPSEFhtwdHDOyrrowirp=SmtmJjDyHgg@mail.gmail.com>
In-Reply-To: <CAErSpo5E4584zgTt4ySPSEFhtwdHDOyrrowirp=SmtmJjDyHgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 08:33 PM, Bjorn Helgaas wrote:
> [+cc Lan, Khalid, Konstantin, Alan, Takao, Jility, Florian, linux-kernel]
>
> On Tue, Nov 12, 2013 at 07:40:03PM +0000, Chang Liu wrote:
>> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=63861
>>
>> Commit b566a22c2 and 7897e60227 made pci_device_shutdown()
>> unconditionally clear Bus Master bit for every pci devices.
>> While this works for most hardware, certain devices are not
>> compatible with this. Intel Lynx Point-LP SATA Controller,
>> for example, will hang the system if its Bus Master bit is
>> cleared during device shutdown. This patch adds a pci quirk
>> so that device drivers can instruct pci_device_shutdown()
>> to keep Bus Master from being cleared, and then implements
>> this mechanism for the Intel Lynx Point-LP AHCI driver.
>>
>> Signed-off-by: Chang Liu <cl91tp@gmail.com>
>
> I'm not 100% comfortable with disabling bus mastering in general;
> see [1] for more details.

Disabling Bus Master bit is effectively a brute force and not an elegant 
way to stop unwanted DMA. It can have side effects as Alan and others 
pointed out in the original discussion, and we are now seeing one with 
Lynx Point on Acer. Eric had pointed out in original discussion - 
<http://marc.info/?l=linux-pci&m=133901193430829&w=2> that this code 
change moves failure from a random point in the kexec'd kernel to a 
predictable point on shutdown path where it becomes lot easier to debug 
than a random memory overwrite. For kexec and kdump to be successful, 
all devices need to be shut down cleanly and be in a state where they 
can be reinitialized by the kexec'd kernel. Either device drivers do it 
or we forcibly stop all DMAs by clearing Bus Master bit. If we stop 
clearing Bus Master bit on shutdown, we will resurrect the old issue of 
random memory corruption on kexec.

Regular shutdown being affected by Bus Master bit being cleared is not a 
comfortable situation. Would it be better if we clear Bus Master bit 
only if devices are being shut down in preparation for kexec?

Patch proposed by Chang Liu is similar to the approach I had suggested 
in discussions last year - 
<http://marc.info/?l=linux-pci&m=133900414027717&w=2> where driver tells 
the PCI subsystem if it is not ok with Bus Master bit being cleared and 
I can accept this approach. Every time we come across a broken 
driver/device that implodes on Bus Master bit being cleared, we add 
"pdev->keep_busmaster_on_shutdown = 1;" to the driver. This will be an 
ongoing process.

--
Khalid

>
> But given that we have been doing it for quite a while (b566a22c2 appeared
> in v3.5 on Jul 21, 2012), and Lynx Point should be in lots of machines, I'm
> surprised that we don't see more reports of this problem if it really
> affects all Lynx Point parts.
>
> Jility reported the same problem [2], and I did find one other similar
> report [3] from Florian.  All three reports (Chang, Jility, Florian) are on
> the same exact machine (Acer V5-573G), which seems sort of suspicious.
>
> Lan, do you have access to any Lynx Point boxes?  Can you test and see
> whether they hang on power-off also?  I suspect this might be something
> specific to the Acer box, not a generic Lynx Point issue.
>
> Bjorn
>
> [1] http://lkml.kernel.org/r/20120427190033.GA17588@ldl.usa.hp.com
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=63861#c21
> [3] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1249329
>
>> ---
>> As per Takao's suggestion, add a new member into struct pci_dev
>> and add a quirk in the ahci driver. I tested this on my
>> machine (Acer V5-573G) and it works fine.
>>
>>   drivers/ata/ahci.c       |  8 ++++++++
>>   drivers/pci/pci-driver.c | 11 ++++++++---
>>   include/linux/pci.h      |  1 +
>>   3 files changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index 8e28f92..de6efcb 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -1385,6 +1385,14 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>
>>    pci_set_master(pdev);
>>
>> + /* We normally clear Bus Master on pci device shutdown. However,
>> + * doing so for Intel Lynx Point-LP SATA Controller [AHCI mode]
>> + * hangs the system. Therefore keep it.
>> + * See bug report: https://bugzilla.kernel.org/show_bug.cgi?id=63861
>> + */
>> + if (pdev->vendor == PCI_VENDOR_ID_INTEL && pdev->device == 0x9c03)
>> + pdev->keep_busmaster_on_shutdown = 1;
>> +
>>    if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
>>    return ahci_host_activate(host, pdev->irq, n_msis);
>>
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> index 38f3c01..ff15b0c 100644
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -392,10 +392,15 @@ static void pci_device_shutdown(struct device *dev)
>>    pci_msix_shutdown(pci_dev);
>>
>>    /*
>> - * Turn off Bus Master bit on the device to tell it to not
>> - * continue to do DMA. Don't touch devices in D3cold or unknown states.
>> + * If the hardware is okay with it, turn off Bus Master bit
>> + * on the device to tell it not to continue doing DMA.
>> + * Don't touch devices in D3cold or unknown states.
>> + * On certain hardware clearing Bus Master bit on shutdown
>> + * may hang the entire system. In these cases the driver of
>> + * these devices should set keep_busmaster_on_shutdown to 1.
>>    */
>> - if (pci_dev->current_state <= PCI_D3hot)
>> + if (!pci_dev->keep_busmaster_on_shutdown
>> +    && pci_dev->current_state <= PCI_D3hot)
>>    pci_clear_master(pci_dev);
>>   }
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index da172f9..63db735 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -322,6 +322,7 @@ struct pci_dev {
>>    /* keep track of device state */
>>    unsigned int is_added:1;
>>    unsigned int is_busmaster:1; /* device is busmaster */
>> + unsigned int keep_busmaster_on_shutdown:1; /* do not clear busmaster on shutdown */
>>    unsigned int no_msi:1; /* device may not use msi */
>>    unsigned int block_cfg_access:1; /* config space access is blocked */
>>    unsigned int broken_parity_status:1; /* Device generates false positive parity */
>> --
>> 1.8.4.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

