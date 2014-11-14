Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbaKNLNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:13:25 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43929 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132AbaKNLNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
Date: Fri, 14 Nov 2014 12:13:20 +0100
Message-ID: <CABuKBeJMnoX239NQTpsqjRRr=90hrkBJAehEUxQVsPZmoHP9ng@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] ARM: mediatek: Add support for interrupt polarity
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>, HC Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-13 16:37 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
>
> This series is 6th version of interrupt polarity support for MediaTek SoCs.
> This is based on tip/irq/irqdomain[1] and my mediatek SoC basic support[2].
>
> In this version, I added a minor fix to irqdomain as first patch. Patch 3,
> 4 are changed to use newly added helper functions. The other patches are
> unchanged.
>
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
>  16:     149578  MT_SYSIRQ 113  mtk_timer
>  20:       1082  MT_SYSIRQ  54  serial

It works for me on mt6589.

Tested-by: Matthias Brugger <matthias.bgg@gmail.com>

>
> Changes in v6:
>  - Rebased to tip/irq/irqdomain [1]
>
> Changes in v5:
>  - Discussed in [3]
>  - Fix bug on mt6589 reported by Matthias
>  - Fix bug for irq_find_mapping in irq_create_of_mapping
>  - Merge Marc's change to proper handle non-DT case in gic_init_bases
>
> Changes in v4:
>  - Discussed in [4]
>  - Remove arm,hierarchy-irq-domain. When GIC is probed by DT, it will
> support hierarchy irqdomain.
>
> Changes in v3:
>  - Discussed in [5]
>  - First implementation using hierarchy irqdomain
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/297624.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296093.html
> [3] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/298161.html
> [4] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296911.html
> [5] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/293766.html
>
>
> Yingjoe Chen (6):
>   irqdomain: Use consistent prototype for irq_domain_free_irqs_*
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
>  drivers/irqchip/irq-gic.c                          |  80 +++++++----
>  drivers/irqchip/irq-mtk-sysirq.c                   | 156 +++++++++++++++++++++
>  include/linux/irq.h                                |   6 +
>  include/linux/irqdomain.h                          |   8 +-
>  kernel/irq/chip.c                                  |  28 ++++
>  kernel/irq/irqdomain.c                             |   8 +-
>  12 files changed, 317 insertions(+), 39 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
>  create mode 100644 drivers/irqchip/irq-mtk-sysirq.c
>
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
