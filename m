Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaJXO7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:59:48 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:48059 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaJXO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <1414079595-26129-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1414079595-26129-1-git-send-email-yingjoe.chen@mediatek.com>
Date: Fri, 24 Oct 2014 16:59:44 +0200
Message-ID: <CABuKBeLjFDm2TSqxc=K3rDnYTKRok3sCvEuL+chxxo7p1UbhLQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] ARM: mediatek: Add support for interrupt polarity
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

2014-10-23 17:53 GMT+02:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> This series is 4th version of interrupt polarity support for MediaTek SoCs.
> This is based on Jiang's hierarchy irqdomain v2 [1] and my mediatek SoC
> basic support [2].
>
> This version addressed comments from previous discussion[3]. I removed
> arm,hierarchy-irq-domain property. When GIC is probed by DT, it will
> support hierarchy irqdomain. I still keep the first patch because this is
> still base on hierarchy irqdomain v2.

Is this set based on v3.17-rc1?
Is it based on one of Jiangs trees [0]?

I tried to use your patch set with v3.18-rc1 using Jiangs tree but the
kernel crashed on mt6589 with a null-pointer exception [1]. A test
with mt6592 didn't work either.

It would be convenient if you rebase your patches to v3.18-rc1.

Thanks,
Matthias

[0] https://github.com/jiangliu/linux
[1] http://pastebin.com/3F1pVaM9

>
> In Jiang's version of irq_create_of_mapping, if irqdomain is hierarchy, it
> will not perform irq_find_mapping check and set_type. The outermost
> irqdomain need to take care of that. Because we will have several different
> outermost irqdomain in different ARM SoCs, this cause code duplication. I
> moved them back to irq_create_of_mapping. Since Jiang's changes are not
> merged yet, maybe that patch should be merged there.
>
> Simplified block diagram for interrupt on my system:
>
>     +-------+      +-------+
>  ---| SYSIRQ|------|ARM GIC|
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>     +-------+      +-------+
>
> In device tree, interrupt-parent for other devices is sysirq, child of gic.
> This describe HW better and allow device to specify polarity as it is sent
> by the device.
>
> When using hierarchy irq domain, gic will use irq_domain_add_linear to
> create irqdomain and all interrupt numbers must come from device tree. My
> /proc/interrupts looks like this now:
>
> # cat /proc/interrupts
>            CPU0
>  16:       1862  MT_SYSIRQ 113  mtk_timer
>  17:         67  MT_SYSIRQ  54  mtk-uart
>
> Changes in v3:
>  - Discussion in [3]
>  - First implementation using hierarchy irqdomain
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/290832.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/284553.html
> [3] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/293766.html
>
> Yingjoe Chen (7):
>   irqdomain: Fix irq_domain_alloc_irqs return check.
>   irqdomain: Add back xlate and set_type for hierarchy irq domain
>   genirq: Add more helper functions to support stacked irq_chip
>   irqchip: gic: Support hierarchy irq domain.
>   ARM: mediatek: Add sysirq interrupt polarity support
>   ARM: mediatek: Add sysirq in mt6589/mt8135/mt8127 dtsi
>   dt-bindings: add bindings for mediatek sysirq
>
>  .../bindings/arm/mediatek/mediatek,sysirq.txt      |  26 ++++
>  arch/arm/boot/dts/mt6589.dtsi                      |  14 +-
>  arch/arm/boot/dts/mt8127.dtsi                      |  14 +-
>  arch/arm/boot/dts/mt8135.dtsi                      |  14 +-
>  drivers/irqchip/Kconfig                            |   1 +
>  drivers/irqchip/Makefile                           |   1 +
>  drivers/irqchip/irq-gic.c                          |  54 +++++--
>  drivers/irqchip/irq-mtk-sysirq.c                   | 168 +++++++++++++++++++++
>  include/linux/irq.h                                |   6 +
>  kernel/irq/chip.c                                  |  28 ++++
>  kernel/irq/irqdomain.c                             |  31 ++--
>  11 files changed, 332 insertions(+), 25 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
>  create mode 100644 drivers/irqchip/irq-mtk-sysirq.c
>
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
