Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaE1XUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:20:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47765 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754535AbaE1XUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:20:32 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 00/15] move at91 and avr32 to the PWM framework, remove obsolete drivers
Date: Thu, 29 May 2014 01:20:03 +0200
Message-Id: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg, the whole series has been acked by all the maintainers but you. I know
that Nicolas was volunteering to take it but maybe you can take it for
3.16. Else, I believe it will have to wait for 3.17.

This patch set switches the at91 and avr32 SoCs and board to the generic PWM
framework. This allows to remove the obsolete leds-atmel-pwm, atmel-pwm-bl and
atmel_pwm drivers.

The first 6 patches take care of the AT91 boards and removes a useless function
in the process.

Patch 7 makes pwm-atmel buildable for AVR32

Patches 8-12 take care of the AVR32 boards. This has only been compile tested as
I don't own any of those boards.

And the last 3 patches are removing the now obsolete drivers.

As a note, the atmel_pwm driver has two features not yet available through
pwm-atmel:
 - it is possible to pass an IRQ handler that will get called each time one of
   the channel period has been achieved.
 - it was possible to set clka and clkb, two clock that divided mck before
   feeding the pwm controller.

Those features are not used by anything in the mainline. I'm not sure we can
implement the first one. We'll get back the second one once all the boards have
switched to the common clock framework.

Changes in v2:
 - rebased on next-20140528 because of the dependency on the pwm tree
 - removed the now unnecessary patch to pwm_bl
 - moved to the new PWM_LOOKUP macro

Alexandre Belloni (15):
  ARM: at91: at91sam9g45: switch to generic PWM framework
  ARM: at91: sam9m10g45ek: use generic leds_pwm driver
  ARM: at91: at91sam9263: switch to generic PWM framework
  ARM: at91: sam9263ek: use generic leds_pwm driver
  ARM: at91: at91sam9rl: switch to generic PWM framework
  ARM: at91: remove useless at91_pwm_leds()
  PWM: atmel: allow building for AVR32
  avr32/at32ap: switch to the generic PWM framework
  avr32: MRMT: use generic leds_pwm driver
  avr32: merisc: use generic leds_pwm driver
  avr32: favr-32: use generic pwm_bl driver
  avr32: update defconfig to use the generic PWM framework
  backlight: atmel-pwm-bl: remove obsolete driver
  leds: atmel-pwm: remove obsolete driver
  misc: atmel_pwm: remove obsolete driver

 arch/arm/mach-at91/at91sam9263.c           |   1 +
 arch/arm/mach-at91/at91sam9263_devices.c   |  11 +-
 arch/arm/mach-at91/at91sam9g45.c           |   1 +
 arch/arm/mach-at91/at91sam9g45_devices.c   |  11 +-
 arch/arm/mach-at91/at91sam9rl.c            |   1 +
 arch/arm/mach-at91/at91sam9rl_devices.c    |  11 +-
 arch/arm/mach-at91/board-sam9263ek.c       |  55 +++-
 arch/arm/mach-at91/board-sam9m10g45ek.c    |  42 ++-
 arch/arm/mach-at91/board.h                 |   1 -
 arch/arm/mach-at91/leds.c                  |  37 ---
 arch/avr32/boards/atngw100/mrmt.c          |  34 ++-
 arch/avr32/boards/favr-32/setup.c          |  48 ++--
 arch/avr32/boards/merisc/setup.c           |  34 ++-
 arch/avr32/configs/atngw100_mrmt_defconfig |   5 +-
 arch/avr32/configs/atstk1002_defconfig     |   5 +-
 arch/avr32/configs/atstk1003_defconfig     |   5 +-
 arch/avr32/configs/atstk1004_defconfig     |   5 +-
 arch/avr32/configs/atstk1006_defconfig     |   5 +-
 arch/avr32/configs/favr-32_defconfig       |   6 +-
 arch/avr32/configs/merisc_defconfig        |   5 +-
 arch/avr32/mach-at32ap/at32ap700x.c        |   7 +-
 drivers/leds/Kconfig                       |   8 -
 drivers/leds/Makefile                      |   1 -
 drivers/leds/leds-atmel-pwm.c              | 149 -----------
 drivers/misc/Kconfig                       |  10 -
 drivers/misc/Makefile                      |   1 -
 drivers/misc/atmel_pwm.c                   | 402 -----------------------------
 drivers/pwm/Kconfig                        |   2 +-
 drivers/video/backlight/Kconfig            |  11 -
 drivers/video/backlight/Makefile           |   1 -
 drivers/video/backlight/atmel-pwm-bl.c     | 223 ----------------
 include/linux/atmel-pwm-bl.h               |  43 ---
 include/linux/atmel_pwm.h                  |  70 -----
 33 files changed, 186 insertions(+), 1065 deletions(-)
 delete mode 100644 drivers/leds/leds-atmel-pwm.c
 delete mode 100644 drivers/misc/atmel_pwm.c
 delete mode 100644 drivers/video/backlight/atmel-pwm-bl.c
 delete mode 100644 include/linux/atmel-pwm-bl.h
 delete mode 100644 include/linux/atmel_pwm.h

-- 
1.9.1

