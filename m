Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3HMHGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:06:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:42523 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3HMHGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:06:12 -0400
Message-ID: <5209DAF6.9020601@atmel.com>
Date: Tue, 13 Aug 2013 09:06:30 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] usb: gadget: at91_udc: add usb_clk for transition to
 common clk framework
References: <1375337885-2684-1-git-send-email-b.brezillon@overkiz.com> <5208E881.3030205@atmel.com> <520948C3.7060008@overkiz.com>
In-Reply-To: <520948C3.7060008@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 22:42, boris brezillon :
> Hello Nicolas,
>
> On 12/08/2013 15:52, Nicolas Ferre wrote:
>> On 01/08/2013 08:18, Boris BREZILLON :
>>> The AT91 PMC (Power Management Controller) provides an USB clock used by
>>> USB Full Speed host (ohci) and USB Full Speed device (udc).
>>> The usb drivers (ohci and udc) must configure this clock to 48Mhz.
>>> This configuration was formely done in mach-at91/clock.c, but this
>>> implementation will be removed when moving to common clk framework.
>>>
>>> This patch adds support for usb clock retrieval and configuration,
>>> and is
>>> backward compatible with the current at91 clk implementation (if usb clk
>>> is not found, it does not configure/enable it).
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
> Is there a reason you acked this version but not the 3rd one
> (https://lkml.org/lkml/2013/8/2/102).

No, only flow of emails while getting back online ;-)

Bye,

>>> ---
>>>    drivers/usb/gadget/at91_udc.c |   17 ++++++++++++++++-
>>>    drivers/usb/gadget/at91_udc.h |    2 +-
>>>    2 files changed, 17 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/usb/gadget/at91_udc.c
>>> b/drivers/usb/gadget/at91_udc.c
>>> index fce8e4e..ae06585 100644
>>> --- a/drivers/usb/gadget/at91_udc.c
>>> +++ b/drivers/usb/gadget/at91_udc.c
>>> @@ -870,6 +870,11 @@ static void clk_on(struct at91_udc *udc)
>>>        if (udc->clocked)
>>>            return;
>>>        udc->clocked = 1;
>>> +
>>> +    if (!IS_ERR(udc->uclk)) {
>>> +        clk_set_rate(udc->uclk, 48000000);
>>> +        clk_prepare_enable(udc->uclk);
>>> +    }
>>>        clk_prepare_enable(udc->iclk);
>>>        clk_prepare_enable(udc->fclk);
>>>    }
>>> @@ -882,6 +887,8 @@ static void clk_off(struct at91_udc *udc)
>>>        udc->gadget.speed = USB_SPEED_UNKNOWN;
>>>        clk_disable_unprepare(udc->fclk);
>>>        clk_disable_unprepare(udc->iclk);
>>> +    if (!IS_ERR(udc->uclk))
>>> +        clk_disable_unprepare(udc->uclk);
>>>    }
>>>
>>>    /*
>>> @@ -1774,10 +1781,10 @@ static int at91udc_probe(struct
>>> platform_device *pdev)
>>>        /* get interface and function clocks */
>>>        udc->iclk = clk_get(dev, "udc_clk");
>>>        udc->fclk = clk_get(dev, "udpck");
>>> +    udc->uclk = clk_get(dev, "usb_clk");
>>>        if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
>>>            DBG("clocks missing\n");
>>>            retval = -ENODEV;
>>> -        /* NOTE: we "know" here that refcounts on these are NOPs */
>>>            goto fail1;
>>>        }
>>>
>>> @@ -1851,6 +1858,12 @@ fail3:
>>>    fail2:
>>>        free_irq(udc->udp_irq, udc);
>>>    fail1:
>>> +    if (!IS_ERR(udc->uclk))
>>> +        clk_put(udc->uclk);
>>> +    if (!IS_ERR(udc->fclk))
>>> +        clk_put(udc->fclk);
>>> +    if (!IS_ERR(udc->iclk))
>>> +        clk_put(udc->iclk);
>>>        iounmap(udc->udp_baseaddr);
>>>    fail0a:
>>>        if (cpu_is_at91rm9200())
>>> @@ -1894,6 +1907,8 @@ static int __exit at91udc_remove(struct
>>> platform_device *pdev)
>>>
>>>        clk_put(udc->iclk);
>>>        clk_put(udc->fclk);
>>> +    if (!IS_ERR(udc->uclk))
>>> +        clk_put(udc->uclk);
>>>
>>>        return 0;
>>>    }
>>> diff --git a/drivers/usb/gadget/at91_udc.h
>>> b/drivers/usb/gadget/at91_udc.h
>>> index e647d1c..0175246 100644
>>> --- a/drivers/usb/gadget/at91_udc.h
>>> +++ b/drivers/usb/gadget/at91_udc.h
>>> @@ -126,7 +126,7 @@ struct at91_udc {
>>>        unsigned            active_suspend:1;
>>>        u8                addr;
>>>        struct at91_udc_data        board;
>>> -    struct clk            *iclk, *fclk;
>>> +    struct clk            *iclk, *fclk, *uclk;
>>>        struct platform_device        *pdev;
>>>        struct proc_dir_entry        *pde;
>>>        void __iomem            *udp_baseaddr;
>>>
>>
>>
>
>


-- 
Nicolas Ferre
