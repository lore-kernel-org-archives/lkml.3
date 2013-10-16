Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab3JPKBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:01:11 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57314 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760194Ab3JPKAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:00:41 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 0/3] ARM: at91: fix hanged boot
Date: Wed, 16 Oct 2013 11:56:13 +0200
Message-Id: <1381917376-21107-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
References: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
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

The more general problem can be triggered, for example, by doing a
user-reset while updating the RTC-time or if an RTC or RTT-alarm goes
off after a non-clean shutdown.

To fix this I add two helper functions to be called called by arch-code
to mask the relevant interrupts before enabling the system interrupt at
early boot.

The patches have been tested on at91sam9g45 and compile-tested for the
other SOCs.

Johan


v2:
 - add DT-support
 - make sys_irq_mask non-mandatory

v3
 - rebase on v3.12-rc5
 - drop DT-support (interrupt masking is needed even if RTC or RTT nodes
   are missing)
 - drop dedicated SOC-initialiser and call helpers directly from init
 - drop revert-patch of move of RTC-register definitions to drivers/ and
   copy the two needed definitions instead
 - move helper functions from setup.c to a separate file
 - add fix for new sama5d3 SOC
 - add a register read back to make sure write has reached the devices
 - split fix in two patches for RTC and RTT, respectively


Johan Hovold (3):
  ARM: at91: fix hanged boot due to early rtc-interrupt
  ARM: at91: fix hanged boot due to early rtt-interrupt
  ARM: at91/rtc: disable interrupts at shutdown

 arch/arm/mach-at91/Makefile                   |  2 +-
 arch/arm/mach-at91/at91sam9260.c              |  2 +
 arch/arm/mach-at91/at91sam9261.c              |  2 +
 arch/arm/mach-at91/at91sam9263.c              |  3 ++
 arch/arm/mach-at91/at91sam9g45.c              |  3 ++
 arch/arm/mach-at91/at91sam9n12.c              |  6 +++
 arch/arm/mach-at91/at91sam9rl.c               |  3 ++
 arch/arm/mach-at91/at91sam9x5.c               |  6 +++
 arch/arm/mach-at91/generic.h                  |  2 +
 arch/arm/mach-at91/include/mach/at91sam9n12.h |  5 ++
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |  5 ++
 arch/arm/mach-at91/include/mach/sama5d3.h     |  5 ++
 arch/arm/mach-at91/sama5d3.c                  |  6 +++
 arch/arm/mach-at91/sysirq_mask.c              | 71 +++++++++++++++++++++++++++
 drivers/rtc/rtc-at91rm9200.c                  |  9 ++++
 15 files changed, 129 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-at91/sysirq_mask.c

-- 
1.8.4

