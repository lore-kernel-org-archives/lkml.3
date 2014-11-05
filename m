Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaKEDKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:10:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:23387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaKEDKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:10:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411590402"
Message-ID: <545994EA.6070300@linux.intel.com>
Date: Wed, 05 Nov 2014 11:09:30 +0800
From: "Lu, Baolu" <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
References: <Pine.LNX.4.44L0.1411041149510.966-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1411041149510.966-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/5/2014 12:58 AM, Alan Stern wrote:
> On Tue, 4 Nov 2014, Lu Baolu wrote:
>
>> xhci: clear root port wake on bits if controller isn't wake-up capable
>>
>> When system is being suspended, if host device is not wakeup capable,
>> xhci_suspend() needs to clear all root port wake on bits.  Otherwise,
>> some platforms may generate spurious wakeup, even if PCI PME# is dis-
>> abled.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/usb/host/xhci.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>> index 2a5d45b..cd57aae 100644
>> --- a/drivers/usb/host/xhci.c
>> +++ b/drivers/usb/host/xhci.c
>> @@ -35,6 +35,8 @@
>>   #define DRIVER_AUTHOR "Sarah Sharp"
>>   #define DRIVER_DESC "'eXtensible' Host Controller (xHC) Driver"
>>   
>> +#define	PORT_WAKE_BITS	(PORT_WKOC_E | PORT_WKDISC_E | PORT_WKCONN_E)
>> +
>>   /* Some 0.95 hardware can't handle the chain bit on a Link TRB being cleared */
>>   static int link_quirk;
>>   module_param(link_quirk, int, S_IRUGO | S_IWUSR);
>> @@ -851,6 +853,42 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
>>   	xhci_set_cmd_ring_deq(xhci);
>>   }
>>   
>> +static void xhci_disable_port_wake_on_bits(struct xhci_hcd *xhci)
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
>>   /*
>>    * Stop HC (not bus-specific)
>>    *
>> @@ -868,6 +906,10 @@ int xhci_suspend(struct xhci_hcd *xhci)
>>   			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
>>   		return -EINVAL;
>>   
>> +	/* Clear root port wake on bits if not wakeup capable. */
>> +	if (!device_may_wakeup(hcd->self.controller))
>> +		xhci_disable_port_wake_on_bits(xhci);
>> +
>>   	/* Don't poll the roothubs on bus suspend. */
>>   	xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
>>   	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
> This is better but still wrong.  Remember, this same code gets called
> for system suspend _and_ for runtime suspend.  During runtime suspend,
> wakeup is always supposed to be turned on, even if device_may_wakeup()
> is false.  That's because device_may_wakeup() refers only to system
> suspend.  What you need to test is the do_wakeup flag, which should be
> passed into xhci_suspend() by xhci_pci_suspend() and
> xhci_plat_suspend().
Yes, it should cover runtime suspend as well. Thanks for the comments. I 
will resend the patch.

> Another problem is in the patch description and the comments.  If
> device_may_wakeup() returns false, it doesn't mean the controller isn't
> wakeup-capable -- it means the controller isn't _allowed_ to wake up
> the system.  Those are two different things.

Accept, I will change this in new patch version.
>
> Finally, the code in xhci_disable_port_wake_on_bits() looks a little
> peculiar -- I'm not sure about all those calls to
> xhci_port_state_to_neutral().  But I'm not an expert on that; Mathias
> will have to advise on it.
This part of code was written with reference to code in xhci-hub.c.

Comments of xhci_port_state_to_neutral():
/*
  * Given a port state, this function returns a value that would result 
in the
  * port being in the same state, if the value was written to the port 
status
  * control register.
  * Save Read Only (RO) bits and save read/write bits where
  * writing a 0 clears the bit and writing a 1 sets the bit (RWS).
  * For all other types (RW1S, RW1CS, RW, and RZ), writing a '0' has no 
effect.
  */

This calculation is used to avoid side effect of changing other bit fields.

Thanks,
-baolu

>
> Alan Stern
>

