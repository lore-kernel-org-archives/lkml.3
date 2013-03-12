Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3CLKyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:54:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37391 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab3CLKyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:54:09 -0400
Message-ID: <513F0946.7020507@ti.com>
Date: Tue, 12 Mar 2013 12:53:58 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: kishon <kishon@ti.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <b-cousson@ti.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 12/12] USB: ehci-omap: Fix detection in HSIC mode
References: <1363085090-24676-1-git-send-email-rogerq@ti.com> <1363085090-24676-13-git-send-email-rogerq@ti.com> <513F089B.5080004@ti.com>
In-Reply-To: <513F089B.5080004@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 12:51 PM, kishon wrote:
> Hi,
> 
> On Tuesday 12 March 2013 04:14 PM, Roger Quadros wrote:
>> The HSIC devices need to be kept in reset while the EHCI controller
>> is being initialized and only brought out of reset after the
>> initialization is complete, else HSIC devices will not be detected.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>> ---
>>   drivers/usb/host/ehci-omap.c |   28 +++++++++++-----------------
>>   1 files changed, 11 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
>> index 1ba1df8..52a2d46 100644
>> --- a/drivers/usb/host/ehci-omap.c
>> +++ b/drivers/usb/host/ehci-omap.c
>> @@ -50,6 +50,7 @@
>>   #include <linux/usb/hcd.h>
>>   #include <linux/of.h>
>>   #include <linux/dma-mapping.h>
>> +#include <linux/delay.h>
> 
> not needed here I guess.

Right. will remove.

>>
>>   #include "ehci.h"
>>
>> @@ -90,26 +91,13 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
>>   static int omap_ehci_init(struct usb_hcd *hcd)
>>   {
>>       struct ehci_hcd    *ehci = hcd_to_ehci(hcd);
>> -    struct omap_hcd    *omap = (struct omap_hcd *)ehci->priv;
>> -    int rc, i;
>> -
>> -    /* Hold PHYs in reset while initializing EHCI controller */
>> -    for (i = 0; i < omap->nports; i++) {
>> -        if (omap->phy[i])
>> -            usb_phy_shutdown(omap->phy[i]);
>> -    }
>> +    int rc;
>>
>>       /* we know this is the memory we want, no need to ioremap again */
>>       ehci->caps = hcd->regs;
>>
>>       rc = ehci_setup(hcd);
>>
>> -    /* Bring PHYs out of reset */
>> -    for (i = 0; i < omap->nports; i++) {
>> -        if (omap->phy[i])
>> -            usb_phy_init(omap->phy[i]);
>> -    }
>> -
>>       return rc;
>>   }
>>
>> @@ -219,9 +207,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>>           }
>>
>>           omap->phy[i] = phy;
>> -        usb_phy_init(omap->phy[i]);
>> -        /* bring PHY out of suspend */
>> -        usb_phy_set_suspend(omap->phy[i], 0);
>>       }
>>
>>       pm_runtime_enable(dev);
>> @@ -245,6 +230,15 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>>           goto err_pm_runtime;
>>       }
>>
>> +    /* Bring PHYs out of reset */
>> +    for (i = 0; i < omap->nports; i++) {
>> +        if (!omap->phy[i])
>> +            continue;
>> +
>> +        usb_phy_init(omap->phy[i]);
>> +        /* bring PHY out of suspend */
>> +        usb_phy_set_suspend(omap->phy[i], 0);
>> +    }
> 
> But isn't HSIC supposed to be PHYless devices. Maybe a comment explaining it might be helpful.
> 

Yes HSIC is PHYless but they do have reset line between the chips.
I'll put a comment.

cheers,
-roger
