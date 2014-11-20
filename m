Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaKTD3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 22:29:31 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:59938 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754327AbaKTD33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 22:29:29 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v7 3/4] ARM: mediatek: Add sysirq in
 mt6589/mt8135/mt8127 dtsi
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux- arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <87d28jaxmq.fsf@approximate.cambridge.arm.com>
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1416406451-4578-4-git-send-email-yingjoe.chen@mediatek.com>
	 <87d28jaxmq.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Nov 2014 11:29:21 +0800
Message-ID: <1416454161.12869.10.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-19 at 17:49 +0000, Marc Zyngier wrote:
> On Wed, Nov 19 2014 at  2:14:10 pm GMT, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
> > Add sysirq settings for mt6589/mt8135/mt8127
> > This also correct timer interrupt flag. The old setting works
> > because boot loader already set polarity for timer interrupt.
> > Without intpol support, the setting was not changed so gic
> > can get the irq correctly.
> >
> > Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> > ---
> >  arch/arm/boot/dts/mt6589.dtsi | 14 ++++++++++++--
> >  arch/arm/boot/dts/mt8127.dtsi | 14 ++++++++++++--
> >  arch/arm/boot/dts/mt8135.dtsi | 14 ++++++++++++--
> >  3 files changed, 36 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/mt6589.dtsi b/arch/arm/boot/dts/mt6589.dtsi
> > index e3c7600..c91b2a9 100644
> > --- a/arch/arm/boot/dts/mt6589.dtsi
> > +++ b/arch/arm/boot/dts/mt6589.dtsi
> > @@ -19,7 +19,7 @@
> >  
> >  / {
> >  	compatible = "mediatek,mt6589";
> > -	interrupt-parent = <&gic>;
> > +	interrupt-parent = <&sysirq>;
> 
> This worries me a bit. Your sysirq cannot handle PPIs, and yet you make
> it the top-level interrupt controller, without amending any PPI.
> 
> Does it mean you do not use *any* PPI? No per-cpu timer, nothing?

Matthias had a patch to enable arch timer[1], but that is not merged
yet. Node using PPI interrupts must add their own interrupt-parent. This
works if we don't have node that use both PPI & SPI interrupts. For
timer, we could do this:

+		timer2: timer {
+			compatible = "arm,armv7-timer";
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) |
IRQ_TYPE_LEVEL_LOW)>,
+				     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+				     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+				     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
+			clock-frequency = <13000000>;
+		};

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/277017.html

Joe.C


