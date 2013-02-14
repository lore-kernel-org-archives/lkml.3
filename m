Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072Ab3BNXSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:18:17 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:58991 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759670Ab3BNXSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:18:16 -0500
Message-ID: <511D70B4.3090505@fold.natur.cuni.cz>
Date: Fri, 15 Feb 2013 00:18:12 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Disable slot presence detection around bus reset
References: <20130214183640.16220.33060.stgit@bling.home> <1360880270.25865.36.camel@ul30vt.home>
In-Reply-To: <1360880270.25865.36.camel@ul30vt.home>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,
  I was just going to ask you whether your patch would "explain" why pciehp has
in my experience broken presence detection while acpiphp has not (on 3.7 kernel)
and whether the patch will fix it.
  Some testing I have done in the past on 3.2 kernel and on 3.7.1, with no fixes.
Maybe you are interested in these threads? Actually, another user confirmed that
pciehp is broken on 3.7 while luckily, he also could have shifted to acpiphp.
Still, it is weird the behavior is different for different express cards
(USB3 vs. SATA vs. RS232 vs. firewire).

Four thread subjects on card presence detection:

Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
Re: linux-3.4-rc5: eSATA Sil3132 ExpressCard removal results in warn_slowpath_common
Re: Dell Vostro 3550: pci_hotplug+acpiphp require 'pcie_aspm=force' on kernel command-line for hotplug to work
Re: [PATCH v3 3/6] ACPI/pci_slot: update PCI slot information when PCI hotplug event happens
Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner

Maybe you will crack it? ;-)
Thanks,
Martin

Alex Williamson wrote:
> On Thu, 2013-02-14 at 11:37 -0700, Alex Williamson wrote:
>> A bus reset can trigger a presence detection change and result in a
>> suprise hotplug.  This is generally not what we want to happen when
>> trying to reset a device.  Disable the presence detection control on
>> on bridges around bus reset.
>>
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> ---
>>  drivers/pci/pci.c |   29 ++++++++++++++++++++++++-----
>>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> 
> Hmm, this doesn't seem to be sufficient, still seeing it
> occasionally :-\
> 
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 5cb5820..c1f7d77 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3229,8 +3229,8 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
>>  
>>  static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
>>  {
>> -	u16 ctrl;
>> -	struct pci_dev *pdev;
>> +	u16 ctrl, flags, sltctl = 0;
>> +	struct pci_dev *pdev, *bridge;
>>  
>>  	if (pci_is_root_bus(dev->bus) || dev->subordinate || !dev->bus->self)
>>  		return -ENOTTY;
>> @@ -3242,15 +3242,34 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
>>  	if (probe)
>>  		return 0;
>>  
>> -	pci_read_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, &ctrl);
>> +	bridge = dev->bus->self;
>> +
>> +	/*
>> +	 * If the parent device supports a slot with presence detection
>> +	 * change enabled, holding the bus in reset can trigger that and
>> +	 * cause an unwanted surprise removal.  Disable presence detection
>> +	 * around the bus reset.
>> +	 */
>> +	pcie_capability_read_word(bridge, PCI_EXP_FLAGS, &flags);
>> +	if (flags & PCI_EXP_FLAGS_SLOT) {
>> +		pcie_capability_read_word(bridge, PCI_EXP_SLTCTL, &sltctl);
>> +		if (sltctl & PCI_EXP_SLTCTL_PDCE)
>> +			pcie_capability_write_word(bridge, PCI_EXP_SLTCTL,
>> +						sltctl & ~PCI_EXP_SLTCTL_PDCE);
>> +	}
>> +
>> +	pci_read_config_word(bridge, PCI_BRIDGE_CONTROL, &ctrl);
>>  	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>> -	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
>> +	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, ctrl);
>>  	msleep(100);
>>  
>>  	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
>> -	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
>> +	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, ctrl);
>>  	msleep(100);
>>  
>> +	if (sltctl & PCI_EXP_SLTCTL_PDCE)
>> +		pcie_capability_write_word(bridge, PCI_EXP_SLTCTL, sltctl);
>> +
>>  	return 0;
>>  }
>>  
>>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
