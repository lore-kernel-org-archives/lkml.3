Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbbAMQfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:35:54 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:41292 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbbAMQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:35:52 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: [RFC PATCH 0/5] irq: Allow irqs to be routed to NMI/FIQ
Date: Tue, 13 Jan 2015 16:35:26 +0000
Message-Id: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Hi Russell:
    This RFC is particularly for your attention since it results
    directly from feedback I've received from both of you, albeit
    quite a few months ago now.

This patchset demonstrates using FIQ to improve the quality of the
PMU trace on ARM systems. To do so it introduces generic changes
that allow irqs to be routed to NMI.

This patchset applies on top of my own patchset:

    arm: Implement arch_trigger_all_cpu_backtrace
    http://thread.gmane.org/gmane.linux.kernel/1864829

I think the important points of this set are clear without reference to
the previous patchset but the patches will not run (nor apply cleanly)
without the previous patchset.

Currently these patches strictly honour a request from Russell to avoid
indirection (notifiers, etc) in the ARM default FIQ handler. I have
therefore separated the request that an irq be routed to NMI from the
installation of a handler for it.

Avoiding indirection does raise some problems though, because it means
we arrive in the PMU code without a context pointer. At present I have
just added a global variables into the ARM PMU code in order to hold
information about irq allocations in a form I can safely read from NMI.


Daniel Thompson (5):
  arm: irq: Add a __nmi_count stat
  irq: Allow interrupts to routed to NMI (or similar)
  irq: gic: Add support for NMI routing
  arm: perf: Make v7 support FIQ-safe
  arm: perf: Use FIQ to handle PMU events.

 arch/arm/include/asm/hardirq.h   |  1 +
 arch/arm/include/asm/pmu.h       |  4 +++
 arch/arm/kernel/irq.c            |  7 +++-
 arch/arm/kernel/perf_event.c     |  2 +-
 arch/arm/kernel/perf_event_cpu.c | 35 +++++++++++++++++--
 arch/arm/kernel/perf_event_v7.c  | 11 ++----
 arch/arm/kernel/traps.c          | 15 +++++---
 drivers/irqchip/irq-gic.c        | 75 ++++++++++++++++++++++++++++++----------
 include/linux/interrupt.h        | 20 +++++++++++
 include/linux/irq.h              |  2 ++
 include/linux/irqchip/arm-gic.h  |  8 ++++-
 kernel/irq/manage.c              | 29 ++++++++++++++--
 12 files changed, 169 insertions(+), 40 deletions(-)

--
1.9.3

