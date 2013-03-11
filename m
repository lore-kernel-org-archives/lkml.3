Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3CKSLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:11:23 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36541 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3CKSLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:11:22 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 0/5] ARM: at91: fix hanged boot
Date: Mon, 11 Mar 2013 19:07:54 +0100
Message-Id: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130311180611.GF8797@localhost>
References: <20130311180611.GF8797@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a few severe issues affecting most AT91 SOCs where
boot can hang after a non-general reset, and where the only way to get
the system booting again is to do a general reset -- something which
could require physically removing any backup battery.

The problems stem from the fact that the RTC and RTT-peripherals are
powered by backup power (VDDBU) and are not reset on wake-up, user,
watchdog or software reset. Consequently, RTC and RTT-alarms and their
interrupts may be enabled at boot, leading to a system lock-up when an
interrupt arrives on the shared system-interrupt line before the
appropriate handler (e.g. RTC-driver) has been installed.

The easiest way to trigger this is to simply wake up from an RTC-alarm
on at91sam9g45. The RTC-driver currently does not disable interrupts at
shutdown so even after a clean shut-down the system will always hang
after waking up.

The first patch fixes this very general case of RTC-wake up after a
clean shutdown in the RTC-driver and is marked for stable as it is
perfectly straight-forward. [ Note that the other, RTT-based, AT91
RTC-driver already disables its interrupts at shutdown. ]

The more general problem can be triggered, for example, by doing a
user-reset while updating the RTC-time or if an RTC or RTT-alarm goes
off after a non-clean shutdown.

To fix this I propose that arch-code should mask the relevant interrupts
before enabling the system interrupt at early boot, and this is what
the fifth patch does. To access the RTC-registers I choose to revert a
recent patch that moved the register definitions to drivers/rtc.

Arguably, the relevant interrupts could also be disabled in bootloaders,
but I suggest fixing it in the kernel once and for all.

The patches have been tested on at91sam9263 and at91sam9g45 (non-DT),
and compile-tested for the other SOCs and DT.

Johan


v2:
 - add DT-support
 - make sys_irq_mask non-mandatory


Johan Hovold (5):
  ARM: at91/rtc: fix boot after RTC wake-up
  ARM: at91/dts: add RTC nodes
  ARM: at91/dts: add RTT nodes
  Revert "arm: at91: move at91rm9200 rtc header in drivers/rtc"
  ARM: at91: fix hanged boot

 arch/arm/boot/dts/at91rm9200.dtsi          |  5 ++
 arch/arm/boot/dts/at91sam9260.dtsi         |  5 ++
 arch/arm/boot/dts/at91sam9263.dtsi         | 10 ++++
 arch/arm/boot/dts/at91sam9g45.dtsi         | 10 ++++
 arch/arm/boot/dts/at91sam9n12.dtsi         |  5 ++
 arch/arm/boot/dts/at91sam9x5.dtsi          |  5 ++
 arch/arm/mach-at91/at91sam9260.c           |  6 ++
 arch/arm/mach-at91/at91sam9261.c           |  6 ++
 arch/arm/mach-at91/at91sam9263.c           |  7 +++
 arch/arm/mach-at91/at91sam9g45.c           |  7 +++
 arch/arm/mach-at91/at91sam9rl.c            |  7 +++
 arch/arm/mach-at91/generic.h               |  2 +
 arch/arm/mach-at91/include/mach/at91_rtc.h | 75 +++++++++++++++++++++++++
 arch/arm/mach-at91/setup.c                 | 88 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/soc.h                   |  1 +
 drivers/rtc/rtc-at91rm9200.c               | 11 +++-
 drivers/rtc/rtc-at91rm9200.h               | 75 -------------------------
 17 files changed, 249 insertions(+), 76 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at91_rtc.h
 delete mode 100644 drivers/rtc/rtc-at91rm9200.h

-- 
1.8.1.5

