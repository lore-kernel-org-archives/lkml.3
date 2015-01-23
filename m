Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbbAWRJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:09:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52676 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752183AbbAWRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:09:35 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 0/5] ARM: at91: fix irq_pm_install_action WARNING
Date: Fri, 23 Jan 2015 18:09:26 +0100
Message-Id: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cab303be91dc47942bc25de33dc1140123540800 [1] introduced a WARN_ON
test which triggers a WARNING backtrace on at91 platforms.
While this WARN_ON is absolutely necessary to warn users that they should
not mix request with and without IRQF_NO_SUSPEND flags on shared IRQs,
there is no easy way to solve this issue on at91 platforms.

The main reason is that the init timer is often using a shared irq line
and thus request this irq with IRQF_NO_SUSPEND flag set, while other
peripherals request the same irq line without this flag.

As suggested by Thomas, the first 3 patches of this series add a dumb
demultiplexer irqchip implementation.
This demuxer registers to a source interrupt and then forwards all received
interrupts to its children (it they are enabled).

The last two patches rework at91 DTs and config to make use of this dumb
demuxer implementation.

Rob, I know you were not in favor of exposing this in the DT but we really
need to quickly a solution: more and more people complain about this warning.
If you see a better way to handle this case please share it.

Best Regards,

Boris

Changes since v2:
 - removed unneeded dumb demux flags passed to irq_alloc_dumb_demux_chip
 - set nested lockdep class for all requested irqs
 - add some explanation to the DT binding doc
 - change the compatible string to clearly show that this chip is purely
   virtual
 - added dumb demuxer to all at91 impacted SoCs

Changes since v1:
 - went for an dumb irq demuxer approach instead of trying to fix the
   current shared irq code

Boris Brezillon (5):
  genirq: Authorize chained handlers to remain disabled when initialized
  irqchip: add dumb demultiplexer implementation
  irqchip: Add DT binding doc for dumb demuxer chips
  ARM: at91/dt: select DUMB_IRQ_DEMUX for all at91 SoCs
  ARM: at91/dt: define a dumb irq demultiplexer chip connected on irq1

 .../bindings/interrupt-controller/dumb-demux.txt   |  41 ++++++
 arch/arm/boot/dts/at91rm9200.dtsi                  |  20 ++-
 arch/arm/boot/dts/at91sam9260.dtsi                 |  26 +++-
 arch/arm/boot/dts/at91sam9261.dtsi                 |  26 +++-
 arch/arm/boot/dts/at91sam9263.dtsi                 |  29 ++++-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  29 ++++-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  25 +++-
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  29 ++++-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  26 +++-
 arch/arm/mach-at91/Kconfig                         |   2 +
 drivers/irqchip/Kconfig                            |   4 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-dumb-demux.c                   |  72 +++++++++++
 include/linux/irq.h                                |  64 +++++++++-
 include/linux/irqdomain.h                          |   1 +
 kernel/irq/Kconfig                                 |   5 +
 kernel/irq/Makefile                                |   1 +
 kernel/irq/chip.c                                  |  53 +++++++-
 kernel/irq/dumb-demux-chip.c                       | 140 +++++++++++++++++++++
 kernel/irq/handle.c                                |  31 ++++-
 kernel/irq/internals.h                             |   3 +
 kernel/irq/irqdomain.c                             |   2 +-
 kernel/irq/msi.c                                   |   3 +-
 23 files changed, 580 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
 create mode 100644 drivers/irqchip/irq-dumb-demux.c
 create mode 100644 kernel/irq/dumb-demux-chip.c

-- 
1.9.1

