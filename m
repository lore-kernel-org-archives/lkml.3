Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaDOMyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:54:18 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:47324 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaDOMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:54:12 -0400
MIME-Version: 1.0
In-Reply-To: <20131210135548.GA28456@xps8300>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
	<1386672926-26885-4-git-send-email-gautam.vivek@samsung.com>
	<20131210135548.GA28456@xps8300>
Date: Tue, 15 Apr 2014 18:24:11 +0530
X-Google-Sender-Auth: pUfhsHp82VRngUZrePbCI6_kz2Q
Message-ID: <CAFp+6iGAdDgC=21VjCUjx3u_ZohhCyj2nG8qzvz3CHTZzoXWJQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/4] xhci: Tune PHY for the DWC3-Exynos host controller
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,


On Tue, Dec 10, 2013 at 7:25 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:

Giving life to this thread after long time.

> Hi,
>
> On Tue, Dec 10, 2013 at 04:25:25PM +0530, Vivek Gautam wrote:
>> @@ -170,6 +189,15 @@ static int xhci_plat_probe(struct platform_device *pdev)
>>       }
>>
>>       /*
>> +      * The parent of the xhci-plat device may pass in a PHY via
>> +      * platform data.  If it exists, store it in our struct usb_hcd
>> +      * so that we can use it later.
>> +      */
>> +     phy_generic = dev_get_platdata(&pdev->dev);
>> +     if (phy_generic)
>> +             xhci->shared_hcd->phy_generic = *phy_generic;
>
> Getting the handle to the phy from platform data like this is not
> going to work for long. It should be possible to get it normally with
> phy_get(). It's not going to be possible to get the handle from the
> platform data like this if the xhci-hcd platform device is created
> from ACPI or DT. You are also not considering case where you have two
> phys.
>
> Vivek, I have made a patch set for the phy framework allowing
> associations between the phys and their users to be made in same way
> gpios and clk make them. With those you should be able to create a
> lookup entry to the phy framework in drivers/usb/dwc3/host.c. Then we
> could use phy_get() here already. Please check them. Subject of the
> thread:
>
> "phy: remove the need for the phys to know about their users"

I had seen your patches in the mailing list, but i don't see any
updated version of these patches.
Are you planning to work on this above mentioned patch-series any time soon ?

Or, should i try to find a different approach for handling the phy
from the host controller (child of DWC3 in this case, which has the
phys).

>
> The lookup table can then be added in drivers/usb/dwc3/host.c with
> something like this:
>
> int dwc3_host_init(struct dwc3 *dwc)
> {
>         struct platform_device  *xhci;
>         struct phy_lookup_table *table;
>         ...
>         table->dev_id = dev_name(&xhci->dev);
>         if (dwc->usb2_generic_phy)
>                 table->table[0].phy_name = dev_name(&dwc->usb2_generic_phy->dev);
>         if (dwc->usb3_generic_phy)
>                 table->table[1].phy_name = dev_name(&dwc->usb3_generic_phy->dev);
>         phy_add_lookup_table(table);
>         ...
