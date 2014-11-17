Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaKQGge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:36:34 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:48149 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaKQGgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:36:32 -0500
MIME-Version: 1.0
In-Reply-To: <545393CE.8070102@cogentembedded.com>
References: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com>
	<1414761989-21088-2-git-send-email-gautam.vivek@samsung.com>
	<545393CE.8070102@cogentembedded.com>
Date: Mon, 17 Nov 2014 12:06:31 +0530
Message-ID: <CAFp+6iG37uE1uB5Z8B-hM3nKyBeR6Vxb-YKegd7MrRB3wuA9xw@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] usb: host: xhci-plat: Get PHYs for xhci's hcds
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Julius Werner <jwerner@google.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Oct 31, 2014 at 7:21 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
> On 10/31/2014 4:26 PM, Vivek Gautam wrote:
>
>> The host controller by itself may sometimes need to handle PHY
>> and re-initialize it to re-configure some of the PHY parameters
>> to get full support out of the PHY controller.
>> Therefore, facilitate getting the two possible PHYs, viz.
>> USB 2.0 type (UTMI+) and USB 3.0 type (PIPE3), and initialize them.
>
>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>   drivers/usb/host/xhci-plat.c |   74
>> ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 74 insertions(+)
>
>
>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>> index 3d78b0c..5207d5b 100644
>> --- a/drivers/usb/host/xhci-plat.c
>> +++ b/drivers/usb/host/xhci-plat.c
>
> [...]
>>
>> @@ -129,10 +130,41 @@ static int xhci_plat_probe(struct platform_device
>> *pdev)
>>                         goto put_hcd;
>>         }
>>
>> +       /* Get possile USB 2.0 type PHY (UTMI+) available with xhci */
>> +       hcd->phy = devm_phy_get(&pdev->dev, "usb2-phy");
>> +       if (IS_ERR(hcd->phy)) {
>> +               ret = PTR_ERR(hcd->phy);
>> +               if (ret == -EPROBE_DEFER) {
>> +                       goto disable_clk;
>> +               } else if (ret != -ENOSYS && ret != -ENODEV) {
>
>
>    Asking to be a *switch* statement instead...

Sure, will change this to *switch* statement. That will improve the
readability.

>
>> +                       hcd->phy = NULL;
>> +                       dev_warn(&pdev->dev,
>> +                                "Error retrieving usb2 phy: %d\n", ret);
>> +               }
>> +       }
>> +
>
> [...]
>>
>> @@ -158,12 +190,41 @@ static int xhci_plat_probe(struct platform_device
>> *pdev)
>>         if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
>>                 xhci->shared_hcd->can_do_streams = 1;
>>
>> +       /* Get possile USB 3.0 type PHY (PIPE3) available with xhci */
>> +       xhci->shared_hcd->phy = devm_phy_get(&pdev->dev, "usb3-phy");
>> +       if (IS_ERR(xhci->shared_hcd->phy)) {
>> +               ret = PTR_ERR(xhci->shared_hcd->phy);
>> +               if (ret == -EPROBE_DEFER) {
>> +                       goto put_usb3_hcd;
>> +               } else if (ret != -ENOSYS && ret != -ENODEV) {
>
>
>    Likewise...

ok

>
>> +                       xhci->shared_hcd->phy = NULL;
>> +                       dev_warn(&pdev->dev,
>> +                                "Error retrieving usb3 phy: %d\n", ret);
>> +               }
>> +       }
>> +
>
> [...]
>>
>> @@ -204,6 +271,8 @@ static int xhci_plat_suspend(struct device *dev)
>>         struct usb_hcd  *hcd = dev_get_drvdata(dev);
>>         struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>>
>> +       phy_exit(hcd->phy);
>
>
>    Hm, in the suspend() method?

phy_exit() should eventually be suspending the PHY and put it to
low power state.
phy_init() in resume() will then take up the task of activating the
PHY again.

phy_power_on() and phy_power_off() are called at xhci_probe() and remove() time.

Does this makes sense ?



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
