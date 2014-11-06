Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaKFCSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:18:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:62333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaKFCSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:18:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,323,1413270000"; 
   d="scan'208";a="627384823"
Message-ID: <545ADA1D.1000800@linux.intel.com>
Date: Thu, 06 Nov 2014 10:17:01 +0800
From: "Lu, Baolu" <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
References: <Pine.LNX.4.44L0.1411051621280.1531-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1411051621280.1531-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/6/2014 5:24 AM, Alan Stern wrote:
> On Wed, 5 Nov 2014, Lu Baolu wrote:
>
>> xhci: clear root port wake on bits if controller isn't allowed to do wakeup
>>
>> When system is being suspended, if host device is not allowed to do wakeup,
>> xhci_suspend() needs to clear all root port wake on bits. Otherwise, some
>> platforms may generate spurious wakeup, even if PCI PME# is disabled.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> This looks pretty good now.
>
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
> Why not just do:
>
> 		t1 = readl(port_array[port_index]);
> 		t1 = xhci_port_state_to_neutral(t1);
> 		t2 = t1 & ~PORT_WAKE_BITS;
> 		if (t1 != t2) ...
Right, this looks better. I will test and resend the patches with this 
change.

>
> Apart from that minor point,
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

