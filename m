Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaDPQAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:00:00 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57542 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaDPP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:59:57 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-5f-534ea8fb3b21
Content-transfer-encoding: 8BIT
Message-id: <1397663995.19782.4.camel@AMDC1943>
Subject: Re: [patch 0/4] genirq/exynos timers: Fix the CPU hotplug wreckage
 sanely
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Date: Wed, 16 Apr 2014 17:59:55 +0200
In-reply-to: <20140416142106.537575971@linutronix.de>
References: <20140416142106.537575971@linutronix.de>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xy7q/V/gFG7ydzm+xccZ6Vot5n2Ut
	ehdcZbM42/SG3WLT42usFpd3zWGzWHvkLrvFgo2PGC3Wz3jNYrF501RmBy6PO9f2sHm8O3eO
	3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgynjSNZ21YA9fxZIPW1gaGPu4uxg5OSQE
	TCT+bW5nhLDFJC7cW8/WxcjFISSwlFFi1cf/7CAJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQ
	l5g0bxEzRP1nRonGL/fZQGp4BfQlHs+oBKkRFgiRWPh5HiuIzSZgLLF5+RI2EFtEQENi46Vb
	YL3MAh+ZJN50nwTbxSKgKjHp+TpmkDmcAqYSBz+Vg4SFgO6cPGkD1J1KEufWrWGcwCgwC8l1
	sxCum4XkugWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQkL/6w7GpcesDjEKcDAq8fDO
	yPENFmJNLCuuzD3EKMHBrCTCy7/YL1iINyWxsiq1KD++qDQntfgQIxMHp1QDo5LD8czFR8+J
	bRHQ04j4p39wm89x1kbjbfv+vDc2StpwbPaTT7s/L4qbzHbxVnR24o52u7vRCx7GMWj8mbbe
	OUWb5+oHr5fn+yw7mjUbV6wv6883mehoIXl+/o22RXsjjRqPPJ3J/29bzZ7iHp1zkz+63mjl
	32hl8jfmVBrbmSt2m0T8HtpYtimxFGckGmoxFxUnAgB7LHf6WwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-16 at 14:36 +0000, Thomas Gleixner wrote:
> The current implementation of irq_set_affinity() refuses rightfully to
> route an interrupt to an offline cpu.
> 
> But there is a special case, where this is actually desired. Some of
> the ARM SoCs have per cpu timers which require setting the affinity
> during cpu startup where the cpu is not yet in the online mask.
> 
> If we can't do that, then the local timer interrupt for the about to
> become online cpu is routed to some random online cpu.
> 
> The developers of the affected machines tried to work around that
> issue, but that results in a massive mess in that timer code.
> 
> It's saner to provide a facility to force the affinity and make the
> affected machines use that.
> 
> The following series implements that logic w/o impact on any existing
> users.
> 
> The change to the genirq core code is not that bad:
> 
>  arch/mips/cavium-octeon/octeon-irq.c |    2 +-
>  include/linux/interrupt.h            |   35 ++++++++++++++++++++++++++++++++++-
>  include/linux/irq.h                  |    3 ++-
>  kernel/irq/manage.c                  |   17 ++++++-----------
>  4 files changed, 43 insertions(+), 14 deletions(-)
> 
> The resulting fixup for gic/exynos_mct is:
> 
>  clocksource/exynos_mct.c |   12 +++---------
>  irqchip/irq-gic.c        |    8 ++++++--
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> Krzysztofs proposed workaround was slightly smaller than that, but I
> prefer having a clean solution for backporting to stable rather than a
> messy hack around which works.
> 
> @Krzysztof: Can you please retest the series? I've changed the core
> implementation versus the first attempt to make it less intrusive.

Works fine. Tested whole patchset on board with Exynos 3250.

Best regards,
Krzysztof


