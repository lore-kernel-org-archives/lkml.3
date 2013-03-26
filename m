Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3CZLbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:31:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18119 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab3CZLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:31:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Mar 2013 04:31:20 -0700
Message-ID: <51518671.7050901@nvidia.com>
Date: Tue, 26 Mar 2013 16:58:49 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
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
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1364203926-24488-1-git-send-email-kishon@ti.com> <51501CFB.4020905@nvidia.com> <51513A40.7080905@ti.com> <515163F6.3010400@slimlogic.co.uk> <51516695.8020808@nvidia.com> <51516A10.40704@slimlogic.co.uk> <51516BC3.7030707@nvidia.com> <51516FB5.3050504@slimlogic.co.uk>
In-Reply-To: <51516FB5.3050504@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013 03:21 PM, Graeme Gregory wrote:
> On 26/03/13 09:34, Laxman Dewangan wrote:
>>>>
>>>> Kishon,
>>>> I think it is very much possible. You can pass the interrupt throough
>>>> IRQ_RESOURCE and populate it from DT. If you provide proper interrupt
>>>> parent and irq number then irq framework take care of every thing.
>>>> already tested this with RTC interrupt of plama and it worked very
>>>> well.
>>>>
>>> If we are tightly coupling as above then using platform_irq is an extra
>>> inefficiency. You both have to populate this then parse it afterwards.
>>> Why not just use the regmap helper? Ill admit this code is like this as
>>> there was a period where platform irqs in DT just was not working right!
>>>
>>> We should really agree now if we are going for loose or tight coupling
>>> now rather than keep switching?
>> Here we are hardcoding for PALMAS_ID_OTG_IRQ and so on. If we take
>> data from platform then it need not and it will be completely
>> independent of palma atleast on this front.
>> We need to populate just as:
>> palmas: palmas {
>> :::::::
>>      palams_usb_phy {
>>          compatile = ...
>>          interrupt-parent = <& palmas>;
>>          interrupt = < 10, 0,
>>                                  21, 0,
>>                              22, 0,
>>                              23, 0>;
>> }
>>
>>
>> and in code, we just need to do
>> irq1 = platform_get_irq(pdev, 0);
>> irq2 = platform_get_irq(pdev, 1);
>> etc..
>>
>>
>> So here, actually we do not need to use palmas one and it is
>> completely independent.
>>
>> Also the way you define the DT od palmas, the above one looks more
>> appropriate.
>>
> Ok that makes sense if you are actually planning to feed non palmas IRQs
> to the usb via either palmas GPIO or even directly! I did not know there
> was such a use case!
>
> Graeme
>

Hi Graeme,
There is multiple reqson for requesting this change:
- When we register the device through non-dt, the irq number come as 
IRQ_RESOURCE when we add mfd sub devices. We added the same irq number 
on mfd/palma.c
- So if that is true then irq should get from platform_irq_get() for 
having proper transfer of infomration.
- Same thing can be populated through dt. If any change then change will 
be on the driver which si registerung in place of on driver which is 
implementing.

Another important point is: we have tps80036 (called palams-charger in 
some of places) which support extended gpios and interrupts. The 
extended interrupt register is not properly offsetted and in current 
regmp-irq framework, it can ot be accomodate. For that the palma need to 
implement the local irq implementation.
In this case, really regmap will not help much as the registration will 
not be through regmap-irq as irq domain will be created locally.


