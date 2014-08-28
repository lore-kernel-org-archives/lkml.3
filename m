Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936190AbaH1HKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:10:08 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:47973 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934377AbaH1HKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:10:06 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <53FED69B.3020406@smartplayin.com>
Date: Thu, 28 Aug 2014 12:43:31 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: qcom: Release pin ranges when gpiochip_irqchip_add
 fails
References: <1409137049-15848-1-git-send-email-pramod.gurav@smartplayin.com> <CAJAp7OhnUD3oSLfcRMD3veSJhVQLZdW1FPb8grOYqN5Gh3Oagw@mail.gmail.com>
In-Reply-To: <CAJAp7OhnUD3oSLfcRMD3veSJhVQLZdW1FPb8grOYqN5Gh3Oagw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2014 02:54 AM, Bjorn Andersson wrote:
> On Wed, Aug 27, 2014 at 3:57 AM, Pramod Gurav
> <pramod.gurav@smartplayin.com> wrote:
>> This patches adds a call to gpiochip_remove_pin_ranges when
>> gpiochip_irqchip_add fails to release memory allocated for pin_ranges.
>>
>> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
>> @@ -845,6 +845,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>>                                    IRQ_TYPE_NONE);
>>         if (ret) {
>>                 dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
>> +               gpiochip_remove_pin_ranges(chip);
>>                 return -ENOSYS;
>>         }
> 
> Good catch, I guess this was lost in the introduction of gpiochip_irqchip...
> 
> 
> Rather than just releasing the pin_ranges of the gpio_chip you should
> probably add a gpiochip_remove() both here and in the case of
> gpiochip_add_pin_range() failing.

Thanks for review. But if I see implementation of gpiochip_remove() it does:
	gpiochip_irqchip_remove(chip);
        gpiochip_remove_pin_ranges(chip);
        of_gpiochip_remove(chip);

In above failure case only gpiochip_add() and gpiochip_add_pin_range()
have been successful hence I thought that would cause any problem to add
gpiochip_remove(). If that is not a problem I think we can call
gpiochip_remove() in fail case of gpiochip_add_pin_range() as well.
Do I make sense?

> 
> Regards,
> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
