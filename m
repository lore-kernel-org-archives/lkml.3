Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaKIFjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 00:39:04 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50087 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaKIFjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 00:39:01 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+U8q6nEZ8T1QzFuo3WgL8dd83b0ASqZzY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 66304615830
Date: Sun, 9 Nov 2014 00:38:20 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, arm@kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        yingjoe.chen@gmail.com, hc.yen@mediatek.com, eddie.huang@mediatek.com,
        nathan.chung@mediatek.com, yh.chen@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 0/6] ARM: mediatek: Add support for interrupt
 polarity
Message-ID: <20141109053820.GU3698@titan.lakedaemon.net>
References: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Marc,

Could I get Acks for the core changes and gic changes when you have
a moment?

thx,

Jason.

On Wed, Oct 29, 2014 at 06:00:18PM +0800, Yingjoe Chen wrote:
> This series is 5th version of interrupt polarity support for MediaTek SoCs.
> This is based on Jiang's hierarchy irqdomain p2v3 [1], which is based on 
> v3.18-rc2, and my mediatek SoC basic support [2].
> 
> Besides changing base, this version addressed comments from Thomas and Marc
> and also fix a bug on mt6589 reported by Matthias.
> 
> In Jiang's version of irq_create_of_mapping, if irqdomain is hierarchy, it
> will not perform irq_find_mapping check and set_type. The outermost
> irqdomain need to take care of that. Because we will have several different
> outermost irqdomain in different ARM SoCs, this cause code duplication. I
> moved them back to irq_create_of_mapping.
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
> 
> Changes in v5:
>  - Fix bug on mt6589 reported by Matthias
>  - Fix bug for irq_find_mapping in irq_create_of_mapping
>  - Merge Marc's change to proper handle non-DT case in gic_init_bases
> 
> Changes in v4:
>  - Discussed in [3]
>  - Remove arm,hierarchy-irq-domain. When GIC is probed by DT, it will
> support hierarchy irqdomain.
> 
> Changes in v3:
>  - Discussed in [4]
>  - First implementation using hierarchy irqdomain
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/297624.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296093.html
> [3] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296911.html
> [4] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/293766.html
> 
> 
> Yingjoe Chen (6):
>   irqdomain: do irq_find_mapping and set_type for hierarchy irqdomain
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
>  drivers/irqchip/irq-gic.c                          |  90 +++++++----
>  drivers/irqchip/irq-mtk-sysirq.c                   | 168 +++++++++++++++++++++
>  include/linux/irq.h                                |   6 +
>  kernel/irq/chip.c                                  |  28 ++++
>  kernel/irq/irqdomain.c                             |  27 ++--
>  11 files changed, 348 insertions(+), 41 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
>  create mode 100644 drivers/irqchip/irq-mtk-sysirq.c
> 
