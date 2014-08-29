Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaH2DtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 23:49:04 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6227 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbaH2DtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 23:49:02 -0400
Date: Thu, 28 Aug 2014 20:49:01 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: qcom: Release pin ranges when
 gpiochip_irqchip_add fails
Message-ID: <20140829034900.GF12494@sonymobile.com>
References: <1409137049-15848-1-git-send-email-pramod.gurav@smartplayin.com>
 <CAJAp7OhnUD3oSLfcRMD3veSJhVQLZdW1FPb8grOYqN5Gh3Oagw@mail.gmail.com>
 <53FED69B.3020406@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53FED69B.3020406@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28 Aug 00:13 PDT 2014, Pramod Gurav wrote:

> On Thursday 28 August 2014 02:54 AM, Bjorn Andersson wrote:
> > On Wed, Aug 27, 2014 at 3:57 AM, Pramod Gurav
> > <pramod.gurav@smartplayin.com> wrote:
> >> This patches adds a call to gpiochip_remove_pin_ranges when
> >> gpiochip_irqchip_add fails to release memory allocated for pin_ranges.
> >>
> >> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> >> @@ -845,6 +845,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
> >>                                    IRQ_TYPE_NONE);
> >>         if (ret) {
> >>                 dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
> >> +               gpiochip_remove_pin_ranges(chip);
> >>                 return -ENOSYS;
> >>         }
> > 
> > Good catch, I guess this was lost in the introduction of gpiochip_irqchip...
> > 
> > 
> > Rather than just releasing the pin_ranges of the gpio_chip you should
> > probably add a gpiochip_remove() both here and in the case of
> > gpiochip_add_pin_range() failing.
> 
> Thanks for review. But if I see implementation of gpiochip_remove() it does:
> 	gpiochip_irqchip_remove(chip);
>         gpiochip_remove_pin_ranges(chip);
>         of_gpiochip_remove(chip);
> 
> In above failure case only gpiochip_add() and gpiochip_add_pin_range()
> have been successful hence I thought that would cause any problem to add
> gpiochip_remove(). If that is not a problem I think we can call
> gpiochip_remove() in fail case of gpiochip_add_pin_range() as well.
> Do I make sense?
> 

As soon as gpiochip_add() have returned successfully we will have a live
gpio_chip, upon returning unsuccessfully from probe devres will free the pctrl
node and the gpio core will continue to operate on freed memory.

Therefor we need to call gpio_remove() in the ccase of both
gpiochip_add_pin_range() and gpiochip_irqchip_add() failing.

The gpio_remove() does as you say remove those additional items, but handles
the case where they are not yet "allocated".

I hope this answers your conserns.

Regards,
Bjorn
