Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbbAPCuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:50:51 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:46033 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752271AbbAPCut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:50:49 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 4/5] ARM: mediatek: Add EINT support to MTK pinctrl
 driver.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        <maoguang.meng@mediatek.com>, Russell King <linux@arm.linux.org.uk>,
        <srv_heupstream@mediatek.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <alan.cheng@mediatek.com>,
        <toby.liu@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, <dandan.he@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CACRpkdY7_A_rORDvDrGtV0aa6mJGj=Sr-k=KVGu_=0et-gNpiQ@mail.gmail.com>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	 <1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
	 <1418807365.6443.17.camel@mtksdaap41>
	 <1420535817.17567.10.camel@mtksdaap41>
	 <CACRpkdb2KJbjzFgTmDvHSw7jNAExxVtU3y4_fgyn6J8hcW5OrQ@mail.gmail.com>
	 <1421202745.27675.148.camel@mtksdaap41>
	 <CACRpkdY7_A_rORDvDrGtV0aa6mJGj=Sr-k=KVGu_=0et-gNpiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2015 10:50:39 +0800
Message-ID: <1421376639.31355.169.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 18:30 +0100, Linus Walleij wrote:
> On Wed, Jan 14, 2015 at 3:32 AM, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
> 
> > Let's me describe my problem more clearly. On our SoC, if a pin support
> > interrupt it will have 2 different numbers for it. For examples, here's
> > a partial list for the gpio and EINT number mappings on mt8135:
> >
> >    gpio  EINT
> >      0     49
> >      1     48
> >     ...........
> >     36     97
> >     37     19
> >     ...........
> >
> > To control interrupt related function, we'll need EINT number to locate
> > corresponding register bits. When interrupt occurs, the interrupt
> > handler will know which EINT interrupt occurs. In irq_chip functions,
> > only .irq_request_resources and .irq_release_resources use gpio number
> > to set pinmux to EINT mode and all the others need EINT number.
> >
> > Because EINT number is used more frequently in interrupt related
> > functions, it make sense to use EINT number as hwirq instead of gpio
> > number. That means irq_domain will translate EINT number to virq.
> > So what mtk_gpio_to_irq actually do is translate gpio number to EINT
> > number and use irq domain to translate it to virq.
> 
> But the EINT is not a hardware number is it?

It is a hardware number. eg, to mask irq for the gpio 0 above, we have
to set bit49 in EINT mask_set register. When this irq triggered, it is
reported using EINT status register bit49.

We can find out EINT number for a GPIO using mtk_desc_pin tables. In
drivers/pinctrl/mediatek/pinctrl-mtk-mt8135.h, for GPIO0, we can see its
EINT is 49 and must set to function 2 for EINT. I believe this is
similar to sunxi.

        MTK_PIN(
                PINCTRL_PIN(0, "MSDC0_DAT7"),
                "D21", "mt8135",
                MTK_EINT_FUNCTION(2, 49),
                MTK_FUNCTION(0, "GPIO0"),
                MTK_FUNCTION(1, "MSDC0_DAT7"),
                MTK_FUNCTION(2, "EINT49"),
                MTK_FUNCTION(3, "I2SOUT_DAT"),
                MTK_FUNCTION(4, "DAC_DAT_OUT"),
                MTK_FUNCTION(5, "PCM1_DO"),
                MTK_FUNCTION(6, "SPI1_MO"),
                MTK_FUNCTION(7, "NALE")
        ),

Joe.C


