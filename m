Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaKDHkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:40:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:48093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaKDHkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:40:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484313999"
Message-ID: <545882FE.70907@linux.intel.com>
Date: Tue, 04 Nov 2014 15:40:46 +0800
From: "Lu, Baolu" <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
References: <Pine.LNX.4.44L0.1410311023550.1833-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1410311023550.1833-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/31/2014 10:28 PM, Alan Stern wrote:
> On Fri, 31 Oct 2014, Lu Baolu wrote:
>
>> xhci: clear root port wake on bits if controller isn't wake-up capable
>>
>> When xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
>> xhci_pci_suspend needs to clear all root port wake on bits. Otherwise some Intel
>> platforms may get a spurious wakeup, even if PCI PME# is disabled.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/usb/host/xhci-pci.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   drivers/usb/host/xhci.h     |  6 ++++++
>>   2 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
>> index 280dde9..3e7441a 100644
>> --- a/drivers/usb/host/xhci-pci.c
>> +++ b/drivers/usb/host/xhci-pci.c
>> @@ -27,6 +27,8 @@
>>   #include "xhci.h"
>>   #include "xhci-trace.h"
>>   
>> +#define	PORT_WAKE_BITS	(PORT_WKOC_E | PORT_WKDISC_E | PORT_WKCONN_E)
>> +
>>   /* Device for a quirk */
>>   #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
>>   #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
>> @@ -126,6 +128,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
>>   		 */
>>   		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
>>   		xhci->quirks |= XHCI_AVOID_BEI;
>> +		xhci->quirks |= XHCI_DISABLE_PORT_WOB;
>>   	}
>>   	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
>>   	    (pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI ||
>> @@ -279,6 +282,42 @@ static void xhci_pci_remove(struct pci_dev *dev)
>>   }
>>   
>>   #ifdef CONFIG_PM
>> +static void xhci_disable_port_wake_bits(struct xhci_hcd *xhci)
>> +{
>> +	int port_index;
>> +	__le32 __iomem **port_array;
>> +	unsigned long flags;
>> +	u32 t1, t2;
>> +
>> +	spin_lock_irqsave(&xhci->lock, flags);
>> +
>> +	/* disble usb3 ports Wake bits*/
>> +	port_index = xhci->num_usb3_ports;
>> +	port_array = xhci->usb3_ports;
>> +	while (port_index--) {
>> +		t1 = readl(port_array[port_index]);
>> +		t2 = xhci_port_state_to_neutral(t1);
>> +		t2 &= ~PORT_WAKE_BITS;
>> +		t1 = xhci_port_state_to_neutral(t1);
>> +		if (t1 != t2)
>> +			writel(t2, port_array[port_index]);
>> +	}
>> +
>> +	/* disble usb2 ports Wake bits*/
>> +	port_index = xhci->num_usb2_ports;
>> +	port_array = xhci->usb2_ports;
>> +	while (port_index--) {
>> +		t1 = readl(port_array[port_index]);
>> +		t2 = xhci_port_state_to_neutral(t1);
>> +		t2 &= ~PORT_WAKE_BITS;
>> +		t1 = xhci_port_state_to_neutral(t1);
>> +		if (t1 != t2)
>> +			writel(t2, port_array[port_index]);
>> +	}
>> +
>> +	spin_unlock_irqrestore(&xhci->lock, flags);
>> +}
>> +
>>   static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
>>   {
>>   	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
>> @@ -291,6 +330,9 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
>>   	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
>>   		pdev->no_d3cold = true;
>>   
>> +	if (xhci->quirks & XHCI_DISABLE_PORT_WOB && !do_wakeup)
>> +		xhci_disable_port_wake_bits(xhci);
>> +
>>   	return xhci_suspend(xhci);
>>   }
> There are two things wrong here.  First, this should not be a quirk.
> The Wake-On bits should be disabled whenever they aren't needed, on
> every controller.
>
> Second, this code (or something like it) belongs in xhci.c or
> xhci-hub.c, not xhci-pci.c.  This is because it should apply to all
> xHCI controllers, not just the PCI-based ones.
Hi Alan,

I agree with you. I will resubmit my patches.

BR,
baolu

>
> (In fact, instead of disabling the Wake-On bits when the controller is
> suspended and do_wakeup is 0, it probably would be better to leave them
> disabled normally and then _enable_ them if do_wakeup is 1.)
>
> Alan Stern
>

