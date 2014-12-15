Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaLOQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:16:01 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57004 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbaLOQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:15:57 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/5] ARM: at91: fix irq_pm_install_action WARNING
Date: Mon, 15 Dec 2014 17:15:47 +0100
Message-Id: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
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

We could deal with that by identifying whether a given peripheral is
connected to the init timer shared irq line and add the IRQF_NO_SUSPEND
in this case, but this implies adding the logic in all peripheral drivers
that could be connected to this shared irq.

This series takes the reverse approach: force IRQ users to specify that
they take care of disabling peripheral interrupts and that IRQ core can
safely leave the handler in a suspended state without having to bother
about spurious interrupts.
This is done by mean of a new IRQF_SUSPEND_NOACTION flag which tells the
core to move the action handler to a suspended list, thus preventing its
execution when we are in suspend mode.
Of course, specifying the IRQF_SUSPEND_NOACTION flag implies taking care
of masking/unmasking the peripheral interrupts in the suspend/resume
implementation.

The WARN_ON is kept, but now it is only triggered when (no_suspend_depth +
suspend_noaction_depth) and nr_actions are unbalanced.

The first patch introduces the IRQF_SUSPEND_NOACTION logic, while other
patches modify existing at91 drivers to specify this flag (and implement
suspend/resume if needed).


Best Regards,

Boris

[1]https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/kernel/irq/pm.c?id=cab303be91dc47942bc25de33dc1140123540800

Boris Brezillon (5):
  genirq: Support mixing IRQF_NO_SUSPEND/IRQF_SUSPEND on shared irqs
  clk: at91: implement suspend/resume for the PMC irqchip
  watchdog: at91sam9: request the irq with IRQF_NO_SUSPEND
  rtc: at91: request IRQs with IRQF_SUSPEND_NOACTION
  tty: serial: atmel: request IRQ with IRQF_SUSPEND_NOACTION

 drivers/clk/at91/pmc.c            | 20 ++++++++++-
 drivers/clk/at91/pmc.h            |  1 +
 drivers/rtc/rtc-at91rm9200.c      |  2 +-
 drivers/rtc/rtc-at91sam9.c        |  3 +-
 drivers/tty/serial/atmel_serial.c |  3 +-
 drivers/watchdog/at91sam9_wdt.c   |  3 +-
 include/linux/interrupt.h         | 11 ++++++
 include/linux/irqdesc.h           |  3 ++
 kernel/irq/pm.c                   | 71 +++++++++++++++++++++++++++++++++++++--
 9 files changed, 109 insertions(+), 8 deletions(-)

-- 
1.9.1

