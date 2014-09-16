Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaIPFKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 01:10:23 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55170 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaIPFKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 01:10:21 -0400
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <20140909053808.GQ8080@google.com>
References: <53FFA54D.9000907@gmail.com>
	<CAErSpo5_WMUmnTHpPZt+j04VZoiW1pthQoGV90A5BDQpQgjwOQ@mail.gmail.com>
	<54065208.3080309@gmail.com>
	<20140909053808.GQ8080@google.com>
Date: Mon, 15 Sep 2014 22:10:20 -0700
Message-ID: <CAA93t1rHu+bfJNKfCws=-ezxAOuRJsLQb4n=eVhZha0iW+oSYA@mail.gmail.com>
Subject: Re: [PATCH v2] pci/probe: Enable CRS for root port if it is supported
From: Rajat Jain <rajatxjain@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Yang <weiyang@linux.vnet.ibm.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Josh Logan <joshtlogan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Mon, Sep 8, 2014 at 10:38 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Sep 02, 2014 at 04:26:00PM -0700, Rajat Jain wrote:
>>
>> As per the PCIe spec, an endpoint may return the configuration cycles
>> with CRS if it is not yet fully ready to be accessed. If the CRS visibility
>> is not enabled at the root port, the spec leaves the retry behaviour open
>> to implementation in such a case. The Intel root ports have chosen to retry
>> endlessly in this situation. Thus, the root controller may "hang" (repeatedly
>> retrying the configuration requests until it gets a status other than CRS) if
>> a device returns CRS for a long time. This can cause a broken endpoint to bring
>> down the whole PCI hierarchy.
>>
>> This was recently known to cause problems on Intel systems and
>> was discussed here:
>> http://marc.info/?t=140926298500002&r=1&w=2
>>
>> Ref1:
>> https://www.pcisig.com/specifications/pciexpress/ECN_CRS_Software_Visibility_No27.pdf
>>
>> Ref2:
>> PCIe spec V3.0, pg119, pg127 for "Configuration Request Retry Status"
>>
>> Thus enable the CRS visibility for the root ports that support it. This
>> patch reverts the following commit, but enables CRS visibility only
>> when the root port supports it:
>>
>> ad7edfe04908 ("[PCI] Do not enable CRS Software Visibility by default")
>>
>> (Linus' response: http://marc.info/?l=linux-pci&m=140968622520192&w=2)
>>
>> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
>> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
>> Signed-off-by: Guenter Roeck <groeck@juniper.net>
>
> I put this and the "only look at Vendor ID" patch on a pci/enumeration
> branch [1].  I rewrote the changelogs to reflect my understanding of what's
> going on, so probably the real truth is somewhere between your original and
> mine.  Let me know what should be fixed.
>
> We should figure out an easy way for Josh to test these.  Ideally, he could
> test the second patch by itself first, then both together.

OK, Josh and I tested this over the last week on his HW (the HW that
had originally reported the problem). Somehow his hardware does not
show the problem in ANY case. I tried the following, and the original
issue (vendor id = 1) was never seen:

1) 3.17-rc2 (has CRS disabled)
2) 3.17-rc2 + Enable CRS
3) 3.17-rc2 + Enable CRS + Ignore Device ID

The Device always returned the correct Vendor ID and Device ID in all
cases. Thus even enabling CRS does not make his system fail in anyway.

Thanks,

Rajat


>
> [1] https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/enumeration
>
>> ---
>> v2: Remove the white list, that was enabling the CRS for certain known Intel systems.
>>     Rather now enable it for all systems that support this capability.
>> v1: Enable CRS for only some given Intel systems (maintain a whitelist)
>>
>>  drivers/pci/probe.c           |   13 +++++++++++++
>>  include/uapi/linux/pci_regs.h |    1 +
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index e3cf8a2..3c4c35c 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -740,6 +740,17 @@ struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
>>  }
>>  EXPORT_SYMBOL(pci_add_new_bus);
>>
>> +static void pci_enable_crs(struct pci_dev *pdev)
>> +{
>> +     u16 root_cap = 0;
>> +
>> +     /* Enable CRS Software visibility if supported */
>> +     pcie_capability_read_word(pdev, PCI_EXP_RTCAP, &root_cap);
>> +     if (root_cap & PCI_EXP_RTCAP_CRSVIS)
>> +             pcie_capability_set_word(pdev, PCI_EXP_RTCTL,
>> +                                      PCI_EXP_RTCTL_CRSSVE);
>> +}
>> +
>>  /*
>>   * If it's a bridge, configure it and scan the bus behind it.
>>   * For CardBus bridges, we don't scan behind as the devices will
>> @@ -787,6 +798,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>>       pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
>>                             bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
>>
>> +     pci_enable_crs(dev);
>> +
>>       if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
>>           !is_cardbus && !broken) {
>>               unsigned int cmax;
>> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
>> index 30db069..a75106d 100644
>> --- a/include/uapi/linux/pci_regs.h
>> +++ b/include/uapi/linux/pci_regs.h
>> @@ -552,6 +552,7 @@
>>  #define  PCI_EXP_RTCTL_PMEIE 0x0008  /* PME Interrupt Enable */
>>  #define  PCI_EXP_RTCTL_CRSSVE        0x0010  /* CRS Software Visibility Enable */
>>  #define PCI_EXP_RTCAP                30      /* Root Capabilities */
>> +#define  PCI_EXP_RTCAP_CRSVIS        0x0001  /* CRS software visibility capability */
>>  #define PCI_EXP_RTSTA                32      /* Root Status */
>>  #define PCI_EXP_RTSTA_PME    0x00010000 /* PME status */
>>  #define PCI_EXP_RTSTA_PENDING        0x00020000 /* PME pending */
>> --
>> 1.7.9.5
