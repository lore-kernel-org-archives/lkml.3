Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaKSOOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:14:34 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:43363 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753824AbaKSOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:14:31 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <hc.yen@mediatek.com>,
        <srv_heupstream@mediatek.com>, <yh.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        <nathan.chung@mediatek.com>, <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v7 0/4] ARM: mediatek: Add support for interrupt polarity
Date: Wed, 19 Nov 2014 22:14:07 +0800
Message-ID: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is 7th version of interrupt polarity support for MediaTek SoCs.

I rebased previous version on latest tip/irq/irqdomain and use newly added
helper function irq_domain_add_hierarchy(). I also changed according to
Marc's suggestion.

Simplified block diagram for interrupt on my system:

    +-------+      +-------+
 ---| SYSIRQ|------|ARM GIC|
 ---|       |------|       |
 ---|       |------|       |
 ---|       |------|       |
 ---|       |------|       |
    +-------+      +-------+

In device tree, interrupt-parent for other devices is sysirq, child of gic.
This describe HW better and allow device to specify polarity as it is sent
by the device.

When using hierarchy irq domain, gic will use irq_domain_add_linear to
create irqdomain and all interrupt numbers must come from device tree. My
/proc/interrupts looks like this now:

# cat /proc/interrupts
           CPU0
 16:     149578  MT_SYSIRQ 113  mtk_timer
 20:       1082  MT_SYSIRQ  54  serial

Changes in v7:
 - Rebased to tip/irq/irqdomain
 - In mtk_sysirq_domain_alloc, use copy of irq_data to workaound of_node
   check in gic_irq_domain_xlate.

Changes in v6:
 - Discussed in [1]
 - Rebased to tip/irq/irqdomain

Changes in v5:
 - Discussed in [2]
 - Fix bug on mt6589 reported by Matthias
 - Fix bug for irq_find_mapping in irq_create_of_mapping
 - Merge Marc's change to proper handle non-DT case in gic_init_bases

Changes in v4:
 - Discussed in [3]
 - Remove arm,hierarchy-irq-domain. When GIC is probed by DT, it will
support hierarchy irqdomain.

Changes in v3:
 - Discussed in [4]
 - First implementation using hierarchy irqdomain

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/302221.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/298161.html
[3] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296911.html
[4] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/293766.html

Yingjoe Chen (4):
  irqchip: gic: Support hierarchy irq domain.
  ARM: mediatek: Add sysirq interrupt polarity support
  ARM: mediatek: Add sysirq in mt6589/mt8135/mt8127 dtsi
  dt-bindings: add bindings for mediatek sysirq

 .../bindings/arm/mediatek/mediatek,sysirq.txt      |  26 ++++
 arch/arm/boot/dts/mt6589.dtsi                      |  14 +-
 arch/arm/boot/dts/mt8127.dtsi                      |  14 +-
 arch/arm/boot/dts/mt8135.dtsi                      |  14 +-
 drivers/irqchip/Kconfig                            |   1 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-gic.c                          |  78 ++++++----
 drivers/irqchip/irq-mtk-sysirq.c                   | 158 +++++++++++++++++++++
 8 files changed, 276 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
 create mode 100644 drivers/irqchip/irq-mtk-sysirq.c

