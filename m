Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab3EWOrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:47:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45353 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab3EWOrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:47:01 -0400
Message-ID: <519E2BD4.9020906@ti.com>
Date: Thu, 23 May 2013 17:46:44 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/1] USB: ehci-omap: Reset dma_mask pointer on probe
References: <Pine.LNX.4.44L0.1305231009230.1459-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1305231009230.1459-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 05:11 PM, Alan Stern wrote:
> On Thu, 23 May 2013, Roger Quadros wrote:
> 
>> Device tree probed devices don't get dma_mask set. Previously
>> we were setting the dma_mask pointer only if it was NULL.
>> However, the address of 'omap_ehci_dma_mask' would change
>> each time the module is unloaded and loaded back thus causing
>> the devices dma_mask pointer to be invalid on the next load.
>>
>> This will cause page faults if any driver tries to access the
>> old dma_mask pointer.
>>
>> Unconditionally re-setting the dma_mask pointer fixes this problem.
> 
>> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
>> index 3d1491b..b33e306 100644
>> --- a/drivers/usb/host/ehci-omap.c
>> +++ b/drivers/usb/host/ehci-omap.c
>> @@ -146,8 +146,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>>  	 * Since shared usb code relies on it, set it here for now.
>>  	 * Once we have dma capability bindings this can go away.
>>  	 */
>> -	if (!pdev->dev.dma_mask)
>> -		pdev->dev.dma_mask = &omap_ehci_dma_mask;
>> +	pdev->dev.dma_mask = &omap_ehci_dma_mask;
> 
> Is this the solution that people have agreed on?  There has been a lot 
> of discussion on this topic.  In particular, there has been talk about 
> fixing it in the DT core.

Fixing it in DT core would be best.
> 
> This particular approach doesn't seem very robust.  What if 
> pdev->dev.dma_mask is already set to a different value for some good 
> reason?
> 

Then it breaks. But for OMAP, that situation seems unlikely.

cheers,
-roger
