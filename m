Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaFYIow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:44:52 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:48666 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaFYIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <53A9FCDB.6060805@cogentembedded.com>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
	<1402056736-12674-3-git-send-email-gautam.vivek@samsung.com>
	<CAODwPW-2tbDht8P=KsTyTyeBivFtFMiyCpxd0QFa-cUSRTpJjQ@mail.gmail.com>
	<53A9FCDB.6060805@cogentembedded.com>
Date: Wed, 25 Jun 2014 14:14:42 +0530
X-Google-Sender-Auth: Z0zTG5nVXN_roWrPSJbiPQXmuW8
Message-ID: <CAFp+6iGYZdRL17UqPhskyDDhfD++His3mO2v7uzG5OF1Hd3TrQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] usb: host: xhci-plat: Add support to get PHYs
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Julius Werner <jwerner@chromium.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kishon <kishon@ti.com>, Mathias Nyman <mathias.nyman@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Jun 25, 2014 at 4:04 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 06/10/2014 12:22 AM, Julius Werner wrote:
>
>>> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
>>> index 9ffecd5..453d89e 100644
>>> --- a/drivers/usb/host/xhci.h
>>> +++ b/drivers/usb/host/xhci.h
>>> @@ -1582,6 +1582,9 @@ struct xhci_hcd {
>>>          u32                     port_status_u0;
>>>   /* Compliance Mode Timer Triggered every 2 seconds */
>>>   #define COMP_MODE_RCVRY_MSECS 2000
>>> +       /* phys for the controller */
>>> +       struct phy              *phy2_gen;
>>> +       struct phy              *phy3_gen;
>>>   };
>
>
>> I don't think adding new variables here and restricting most of this
>> logic to xhci-plat.c (in the next patch) is the best way to do it.
>
>
>    Indeed.
>
>
>> There's no conceptual reason why other host controllers (e.g. xhci-pci
>> or even EHCI) could not have a similar need to tune their PHY after
>> reset. PHYs are universal to all host controllers.
>
>
>> There is already a 'phy' member in struct usb_hcd which I think is
>> mostly unused right now. I think it would be much less
>> confusing/redundant to reuse that member for this purpose (you could
>> still set it up from xhci_plat_probe(), and then call it from
>> hcd_bus_resume() or something like that).
>
>
>    That member has type 'struct usb_phy *' while here we have 'struct phy *'
> -- feel the difference.
>    I have already tried adding 'struct phy *gen_phy' to 'struct usb_hcd',

So the 'struct phy *' available in the usb_hcd is requested in usb_add_hcd().
This is requested with the constant string 'usb' :
           struct phy *phy = phy_get(hcd->self.controller, "usb");

This can get the phy with string 'usb' only if, either the host
controller has a device node wherein the phys are given.
Even in this case one can't give same constant string for two
different phys, UTMI+ and PIPE3 phy, isn't it ?

Or, the other way can be when host gets a lookup table to look into to
find the relevant phys, something like
Heikki has suggested:
usb: dwc3: host: convey the PHYs to xhci
(https://lkml.org/lkml/2014/6/5/585) and related patch series.

So if we use this second approach, we would need to override the
'phy_get()' that has been done in usb_add_hcd()
in xhci_plat_probe(), and then use them in later operations.

am i getting the things correctly ?



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
