Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3GaFvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:51:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46660 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3GaFv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:51:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51F8A5C2.1030805@jp.fujitsu.com>
Date: Wed, 31 Jul 2013 14:50:58 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: alex.williamson@redhat.com
CC: bhelgaas@google.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, ishii.hironobu@jp.fujitsu.com,
        ddutile@redhat.com, bill.sumner@hp.com, hbabu@us.ibm.com
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>  <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>  <51B19DF3.2070009@jp.fujitsu.com>  <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>  <51B6BEDB.3000509@jp.fujitsu.com>  <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>  <51B93221.2040505@jp.fujitsu.com>  <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>  <51BA7BB6.1080104@jp.fujitsu.com> <51EF7466.20703@jp.fujitsu.com>  <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>  <51F5B966.9080405@jp.fujitsu.com>  <CAErSpo4JtG5qVJb-nCywe3vkft=-cDeRDKn_V92RCZ-sGXpwbg@mail.gmail.com>  <51F758B6.9090204@jp.fujitsu.com>  <CAErSpo7TNhQO0dx_xZvF=dU2fSWTFf8x=xUJcEsbadJkv8ktuQ@mail.gmail.com>  <51F85BCC.2070103@jp.fujitsu.com> <1375240269.31262.92.camel@ul30vt.home>
In-Reply-To: <1375240269.31262.92.camel@ul30vt.home>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/31 12:11), Alex Williamson wrote:
> On Wed, 2013-07-31 at 09:35 +0900, Takao Indoh wrote:
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index e37fea6..c595997 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3392,6 +3392,59 @@ int pci_reset_function(struct pci_dev *dev)
>>   EXPORT_SYMBOL_GPL(pci_reset_function);
>>   
>>   /**
>> + * pci_reset_bus - reset a PCI bus
>> + * @bus: PCI bus to reset
>> + *
>> + * Returns 0 if the bus was successfully reset or negative if failed.
>> + */
>> +int pci_reset_bus(struct pci_bus *bus)
>> +{
>> +	struct pci_dev *pdev;
>> +	u16 ctrl;
>> +
>> +	if (!bus->self)
>> +		return -ENOTTY;
>> +
>> +	list_for_each_entry(pdev, &bus->devices, bus_list)
>> +		if (pdev->subordinate)
>> +			return -ENOTTY;
>> +
>> +	/* Save config registers of children */
>> +	list_for_each_entry(pdev, &bus->devices, bus_list) {
>> +		dev_info(&pdev->dev, "Save state\n");
>> +		pci_save_state(pdev);
>> +	}
>> +
>> +	dev_info(&bus->self->dev, "Reset Secondary bus\n");
>> +
>> +	/* Assert Secondary Bus Reset */
>> +	pci_read_config_word(bus->self, PCI_BRIDGE_CONTROL, &ctrl);
>> +	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>> +	pci_write_config_word(bus->self, PCI_BRIDGE_CONTROL, ctrl);
>> +
>> +	/* Read config again to flush previous write */
>> +	pci_read_config_word(bus->self, PCI_BRIDGE_CONTROL, &ctrl);
>> +
>> +	msleep(2);
>> +
>> +	/* De-assert Secondary Bus Reset */
>> +	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
>> +	pci_write_config_word(bus->self, PCI_BRIDGE_CONTROL, ctrl);
>> +
>> +	/* Wait for completion */
>> +	msleep(1000);
> 
> 
> We already have secondary bus reset code in this file, why are we
> duplicating it here?  Also, why are these delays different from the
> existing code?  I'm also in need of a bus reset interface for when we
> assign all of the devices on a bus to userspace and do not have working
> function level resets per device.  I'll post my patch series and perhaps
> we can collaborate on a pci bus reset interface.  Thanks,

Good point. Yes, we have already similar functions.

pci_parent_bus_reset()
1. Assert secondary bus reset
2. msleep(100)
3. De-assert secondary bus reset
4. msleep(100)

aer_do_secondary_bus_reset()
1. Assert secondary bus reset
2. msleep(2)
3. De-assert secondary bus reset,
4. msleep(200)

To be honest, I wrote my reset code almost one years ago, so I forgot
the reason why I separated them.

Basically my reset code is based on aer_do_secondary_bus_reset(). The
different is waiting time after reset. My patch has 1000msec waiting
time.

At first my reset code is almost same as aer_do_secondary_bus_reset().
But when I tested the reset code, I found that on certain machine
restoring config registers failed after reset. It failed because 200msec
waiting time was too short. And I found the following description in
PCIe spec. According to this, I thought we should wait at least 1000msec.

6.6.1. Conventional Reset

* The Root Complex and/or system software must allow at least 1.0s
  after a Conventional Reset of a device, before it may determine that a
  device which fails to return a Successful Completion status for a
  valid Configuration Request is a broken device. This period is
  independent of how quickly Link training completes.

  Note: This delay is analogous to the Trhfa parameter specified for
  PCI/PCI-X, and is intended to allow an adequate amount of time for
  devices which require self initialization.

* When attempting a Configuration access to devices on a PCI or PCI-X
  bus segment behind a PCI Express/PCI(-X) Bridge, the timing parameter
  Trhfa must be respected.

And I saw patches you posted today, yes, your patch looks helpful for
my purpose:-)

Thanks,
Takao Indoh

