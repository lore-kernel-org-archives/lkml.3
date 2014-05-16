Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbaEPRmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:42:40 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55136 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbaEPRmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140516132451.GK967@e106497-lin.cambridge.arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
	<CA+sq2Ccok5wtKjCZUkBhhj3WsiqFAoMgHK7LY210aBtMku+8SA@mail.gmail.com>
	<20140516132451.GK967@e106497-lin.cambridge.arm.com>
Date: Fri, 16 May 2014 23:12:36 +0530
Message-ID: <CA+sq2CejJFg--0rS1arr4Sactp-ssENB8Y3g4b61JPGPBCms=A@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] Add support for PCI in AArch64
From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
To: Sunil Kovvuri <sunil.kovvuri@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "kdb@lurndal.org" <kdb@lurndal.org>,
        "yu.zhao@intel.com" <yu.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liviu,

Issue may not be only with SR-IOV resources.

I am not an expert with Linux PCI core. But i am trying to understand
how even for a non SR-IOV capable device's resource, gets a parent
associated with it.

When a PCI device driver calls pci_enable_device() which inturn calls
'arch/arm64/kernel/pci.c' pcibios_enable_device() which uses Linux PCI core
API 'pci_enable_resources'. This API checks 'res->parent' for all
valid resources
before enabling them, otherwise it fails.
                if (!r->parent) {
                        dev_err(&dev->dev, "device not available "
                                "(can't reserve %pR)\n", r);
                        return -EINVAL;
                }

Can you please let me know where this hierarchy is being set for
'pcibios_enable_resources' to work.

I could only find request_resource() API which sets the parent and
pci_claim_resource() uses this.

Thanks,
Sunil.

On Fri, May 16, 2014 at 6:54 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> Hi Sunil,
>
> On Fri, May 16, 2014 at 11:33:04AM +0100, Sunil Kovvuri wrote:
>> Hi Liviu,
>>
>> I am using your ARM64 PCIe patches to write a PCIe host controller
>> driver for our SOC. I am facing an issue with SR-IOV capable device.
>>
>> Consider an PCI Express endpoint connected to a PCI Express
>> Root Port.  The PCI Express endpoint provides PCI-SIG SR-IOV
>> capabilities with a single physical function and a large number
>> of virtual functions.  The Root Port contains a pci-pci bridge in
>> between it and the SR-IOV device.
>>
>> When the SR-IOV capable device's driver tries to enable sriov
>> (pci_enable_sriov()) it fails to create/add PCI device for each
>> virtual function reporting  "not enough MMIO resources for SR-IOV".
>>
>> In sriov_enable() (drivers/pci/iov.c)
>>
>>  296        for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
>>  297                 bars |= (1 << (i + PCI_IOV_RESOURCES));
>>  298                 res = dev->resource + PCI_IOV_RESOURCES + i;
>>  299                 if (res->parent)
>>  300                         nres++;
>>  301         }
>>  302         if (nres != iov->nres) {
>>  303                 dev_err(&dev->dev, "not enough MMIO resources for
>>  SR-IOV\n");
>>  304                 return -ENOMEM;
>>  305         }
>>
>> Here its checking if physical function's IOV resource has a parent or not.
>> Which is pci-pci bridge in this case. Otherwise it doesn't consider
>> that resource.
>>
>> Added below api to your patch.
>> This will try to claim a resource while creating a PCI device which
>> inturn sets 'res->parent'.
>>
>> Let me know if this is okay.
>>
>> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
>> index 9f29c9a..fbfb48f 100644
>> --- a/arch/arm64/kernel/pci.c
>> +++ b/arch/arm64/kernel/pci.c
>> @@ -125,6 +125,21 @@ resource_size_t pcibios_align_resource(void
>> *data, const struct resource *res,
>>         return res->start;
>>  }
>>
>> +int pcibios_add_device(struct pci_dev *pdev)
>> +{
>> +        unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
>> +        struct resource *res;
>> +
>> +        for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>> +                res = &pdev->resource[i];
>> +                if (res->parent || !(res->flags & type_mask))
>> +                        continue;
>> +                pci_claim_resource(pdev, i);
>> +        }
>> +
>>
>
> I would like not to have to add your patch in this file as I am trying to
> remove it entirely. I don't have an SR-IOV capable device in my setup so
> I am not able to debug your problem, but could you have a go and try to
> figure out why the SR-IOV resources do not get a parent associated with
> when they get created?
>
> Many thanks,
> Liviu
>
>
> --
> ====================
> | I would like to |
> | fix the world,  |
> | but they're not |
> | giving me the   |
>  \ source code!  /
>   ---------------
>     ¯\_(ツ)_/¯
>
