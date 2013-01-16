Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3APV4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:56:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52814 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab3APV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:56:17 -0500
Message-ID: <50F721F7.2030907@wwwdotorg.org>
Date: Wed, 16 Jan 2013 14:56:07 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: Add APIs to access host registers from Tegra
 PHY
References: <Pine.LNX.4.44L0.1301161004380.1704-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301161004380.1704-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 08:08 AM, Alan Stern wrote:
> On Wed, 16 Jan 2013, Venu Byravarasu wrote:
> 
>> As Tegra PHY driver needs to access one of the Host registers,
>> added few APIs.

>> --- a/drivers/usb/host/ehci-tegra.c
>> +++ b/drivers/usb/host/ehci-tegra.c

>> +void tegra_ehci_set_wakeon_events(struct usb_phy *x, bool enable)
>> +{
>> +	unsigned long val;
>> +	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
>> +	void __iomem *base = hcd->regs;
>> +	u32 wake = USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN;
>> +
>> +	val = readl(base + USB_PORTSC1);
>> +	if (enable)
>> +		val |= wake;
>> +	else
>> +		val &= ~wake;
>> +	writel(val, base + USB_PORTSC1);
>> +}
> 
> Here and below, this sort of code is highly questionable.  You
> evidently don't realize that some of the bits in the PORTSC registers
> are R/WC.  This means writing a 1 to these bits will clear them.  
> 
> Consequently it is almost always wrong to read a PORTSC register and
> then write back the same (or a slightly modified) value.

Sorry I'm not familiar with USB... Are the bits being manipulated here
(i.e. USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN)
standardized USBisms, or some custom Tegra stuff?

Anyway, is the solution here to do:

val = readl(addr)

// i.e. add the following line:
val &= ~(all write-to-clear bits);

if (enable) val |= wake; else val &= ~wake;

writel(val, addr)

... or is there more broken than just that?

Also note that the driver is already doing exactly what is in these new
functions; the code is just being split out so that only the EHCI driver
touches EHCI registers, and the PHY driver only touches PHY registers.
Still, I'll admit it's a good time to fix any mistakes in this part of
the code.
