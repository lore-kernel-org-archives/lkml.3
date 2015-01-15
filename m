Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbbAORaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:30:15 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48032 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbAORaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:30:12 -0500
MIME-Version: 1.0
In-Reply-To: <1421202745.27675.148.camel@mtksdaap41>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	<1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
	<1418807365.6443.17.camel@mtksdaap41>
	<1420535817.17567.10.camel@mtksdaap41>
	<CACRpkdb2KJbjzFgTmDvHSw7jNAExxVtU3y4_fgyn6J8hcW5OrQ@mail.gmail.com>
	<1421202745.27675.148.camel@mtksdaap41>
Date: Thu, 15 Jan 2015 18:30:12 +0100
Message-ID: <CACRpkdY7_A_rORDvDrGtV0aa6mJGj=Sr-k=KVGu_=0et-gNpiQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] ARM: mediatek: Add EINT support to MTK pinctrl driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>, maoguang.meng@mediatek.com,
        Russell King <linux@arm.linux.org.uk>, srv_heupstream@mediatek.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, alan.cheng@mediatek.com,
        toby.liu@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, dandan.he@mediatek.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 3:32 AM, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:

> Let's me describe my problem more clearly. On our SoC, if a pin support
> interrupt it will have 2 different numbers for it. For examples, here's
> a partial list for the gpio and EINT number mappings on mt8135:
>
>    gpio  EINT
>      0     49
>      1     48
>     ...........
>     36     97
>     37     19
>     ...........
>
> To control interrupt related function, we'll need EINT number to locate
> corresponding register bits. When interrupt occurs, the interrupt
> handler will know which EINT interrupt occurs. In irq_chip functions,
> only .irq_request_resources and .irq_release_resources use gpio number
> to set pinmux to EINT mode and all the others need EINT number.
>
> Because EINT number is used more frequently in interrupt related
> functions, it make sense to use EINT number as hwirq instead of gpio
> number. That means irq_domain will translate EINT number to virq.
> So what mtk_gpio_to_irq actually do is translate gpio number to EINT
> number and use irq domain to translate it to virq.

But the EINT is not a hardware number is it?

That sounds like an abuse of the irqdomain framework.

The purpose of that code is to map hardware IRQs to Linux
IRQs nothing else.

This sounds more like mapping a Linux IRQ (the EINT) to
another Linux IRQ (whatever the irqdomain allocates for
you).

Since the EINTs are already Linux IRQs, these should be used
directly.

I would solve this by just having some cross-reference table
for mapping GPIOs to EINTs without involving the irqdomain
at all.

struct eint_map {
    int gpio_offset;
    int eint;
};

But also check with the irqdomain people.

Yours,
Linus Walleij
