Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659Ab3CZJvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:51:53 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:51292 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab3CZJvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:51:51 -0400
Message-ID: <51516FB5.3050504@slimlogic.co.uk>
Date: Tue, 26 Mar 2013 09:51:49 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "s-guiriec@ti.com" <s-guiriec@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] USB: PHY: Palmas USB Transceiver Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1364203926-24488-1-git-send-email-kishon@ti.com> <51501CFB.4020905@nvidia.com> <51513A40.7080905@ti.com> <515163F6.3010400@slimlogic.co.uk> <51516695.8020808@nvidia.com> <51516A10.40704@slimlogic.co.uk> <51516BC3.7030707@nvidia.com>
In-Reply-To: <51516BC3.7030707@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/13 09:34, Laxman Dewangan wrote:
> On Tuesday 26 March 2013 02:57 PM, Graeme Gregory wrote:
>> On 26/03/13 09:12, Laxman Dewangan wrote:
>>> On Tuesday 26 March 2013 02:31 PM, Graeme Gregory wrote:
>>>
>>> But still you are using the PALMAS macro here and indirectly it is
>>> tied up. It is not completely independent.
>>> If need to be independent then regmap pointer with address need to be
>>> passed as independt header and no where on code whould refer the PALMA.
>>> I think as per current code, it is not possible although it is your
>>> big plan what I understand from some time back in one of patch
>>> discussion.
>>>
>> It is actually almost possible, but it is something I gave up looking
>> at. You can get the regmap of your parent i2c device without having
>> knowledge of the type of parent.
>
> There is multiple regmap of parent and hence getting correct regmap is
> really issue.  May be RTC require regmap[0] and gpio require regmap[1].
>
If you notice each regmap is connected to the correct dummy. Its
possible to create the correct children per dummy. The twl6030 driver
does this. But this is pointless now as I never intend to work on it so
we shall go with the tightly coupled.

>
>>
>>>>>>> +       palmas_usb->dev         = &pdev->dev;
>>>>>>> +
>>>>>>> +       palmas_usb->irq1 = regmap_irq_get_virq(palmas->irq_data,
>>>>>>> +                                               PALMAS_ID_OTG_IRQ);
>>>>>>> +       palmas_usb->irq2 = regmap_irq_get_virq(palmas->irq_data,
>>>>>>> +                                               PALMAS_ID_IRQ);
>>>>>>> +       palmas_usb->irq3 = regmap_irq_get_virq(palmas->irq_data,
>>>>>>> +                                              
>>>>>>> PALMAS_VBUS_OTG_IRQ);
>>>>>>> +       palmas_usb->irq4 = regmap_irq_get_virq(palmas->irq_data,
>>>>>>> +                                               PALMAS_VBUS_IRQ);
>>>>>> Should be come from platform_get_irq() through platform driver.
>>>>> No. It can be obtained from regmap too.
>>> Kishon,
>>> I think it is very much possible. You can pass the interrupt throough
>>> IRQ_RESOURCE and populate it from DT. If you provide proper interrupt
>>> parent and irq number then irq framework take care of every thing.
>>> already tested this with RTC interrupt of plama and it worked very
>>> well.
>>>
>> If we are tightly coupling as above then using platform_irq is an extra
>> inefficiency. You both have to populate this then parse it afterwards.
>> Why not just use the regmap helper? Ill admit this code is like this as
>> there was a period where platform irqs in DT just was not working right!
>>
>> We should really agree now if we are going for loose or tight coupling
>> now rather than keep switching?
>
> Here we are hardcoding for PALMAS_ID_OTG_IRQ and so on. If we take
> data from platform then it need not and it will be completely
> independent of palma atleast on this front.
> We need to populate just as:
> palmas: palmas {
> :::::::
>     palams_usb_phy {
>         compatile = ...
>         interrupt-parent = <& palmas>;
>         interrupt = < 10, 0,
>                                 21, 0,
>                             22, 0,
>                             23, 0>;
> }
>
>
> and in code, we just need to do
> irq1 = platform_get_irq(pdev, 0);
> irq2 = platform_get_irq(pdev, 1);
> etc..
>
>
> So here, actually we do not need to use palmas one and it is
> completely independent.
>
> Also the way you define the DT od palmas, the above one looks more
> appropriate.
>
Ok that makes sense if you are actually planning to feed non palmas IRQs
to the usb via either palmas GPIO or even directly! I did not know there
was such a use case!

Graeme

