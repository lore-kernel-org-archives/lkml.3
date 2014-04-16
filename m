Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161513AbaDPOgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:36:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:39616 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161439AbaDPOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:36:31 -0400
Message-Id: <20140416142106.537575971@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 16 Apr 2014 14:36:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
Subject: [patch 0/4] genirq/exynos timers: Fix the CPU hotplug wreckage sanely
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of irq_set_affinity() refuses rightfully to
route an interrupt to an offline cpu.

But there is a special case, where this is actually desired. Some of
the ARM SoCs have per cpu timers which require setting the affinity
during cpu startup where the cpu is not yet in the online mask.

If we can't do that, then the local timer interrupt for the about to
become online cpu is routed to some random online cpu.

The developers of the affected machines tried to work around that
issue, but that results in a massive mess in that timer code.

It's saner to provide a facility to force the affinity and make the
affected machines use that.

The following series implements that logic w/o impact on any existing
users.

The change to the genirq core code is not that bad:

 arch/mips/cavium-octeon/octeon-irq.c |    2 +-
 include/linux/interrupt.h            |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/irq.h                  |    3 ++-
 kernel/irq/manage.c                  |   17 ++++++-----------
 4 files changed, 43 insertions(+), 14 deletions(-)

The resulting fixup for gic/exynos_mct is:

 clocksource/exynos_mct.c |   12 +++---------
 irqchip/irq-gic.c        |    8 ++++++--
 2 files changed, 9 insertions(+), 11 deletions(-)

Krzysztofs proposed workaround was slightly smaller than that, but I
prefer having a clean solution for backporting to stable rather than a
messy hack around which works.

@Krzysztof: Can you please retest the series? I've changed the core
implementation versus the first attempt to make it less intrusive.

Thanks,

	tglx

