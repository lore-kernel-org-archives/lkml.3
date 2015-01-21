Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbbAURD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:03:58 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40131 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbbAURDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:03:51 -0500
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
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH v2 0/5] irq: Allow irqs to be routed to NMI/FIQ
Date: Wed, 21 Jan 2015 17:03:37 +0000
Message-Id: <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
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

I think most important aspects of the code are clear without reference to
the previous patchset however the patches will not run (nor apply cleanly)
without the previous patchset.

v2:

* Removed the direct calls in handle_fiq_as_nmi (Joshua Clayton). There
  is now indirection in the default FIQ handler so, to address RMK's
  concerns regarding code review, there is also a means for arch code to
  filter the avaiable handlers.

  The new approach has got rid of a *lot* of nasty hairballs in the code
  (including those that came up in the reviews Joshua Clayton and
  Russell King).


Daniel Thompson (5):
  arm: irq: Add a __nmi_count stat
  irq: Allow interrupts to routed to NMI (or similar)
  irq: gic: Add support for NMI routing
  arm: perf: Make v7 support FIQ-safe
  arm: perf: Use FIQ to handle PMU events.

 arch/arm/include/asm/hardirq.h   |  1 +
 arch/arm/include/asm/pmu.h       |  2 ++
 arch/arm/kernel/irq.c            |  7 ++++-
 arch/arm/kernel/perf_event.c     |  2 +-
 arch/arm/kernel/perf_event_cpu.c | 14 +++++++--
 arch/arm/kernel/perf_event_v7.c  | 11 ++-----
 arch/arm/kernel/traps.c          | 35 ++++++++++++++++++----
 drivers/irqchip/irq-gic.c        | 64 ++++++++++++++++++++++++++++------------
 include/linux/interrupt.h        |  5 ++++
 include/linux/irq.h              |  2 ++
 include/linux/irqchip/arm-gic.h  |  6 +++-
 include/linux/irqdesc.h          |  3 ++
 kernel/irq/irqdesc.c             | 48 ++++++++++++++++++++++++++++++
 kernel/irq/manage.c              | 46 +++++++++++++++++++++++++++++
 14 files changed, 207 insertions(+), 39 deletions(-)

--
1.9.3

