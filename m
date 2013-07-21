Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3GURtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 13:49:51 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40417 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab3GURtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 13:49:50 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>
Subject: [PATCH v3] pinctrl: elaborate a bit on arrangements in doc
Date: Sun, 21 Jul 2013 19:49:40 +0200
Message-Id: <1374428980-3997-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This elaborates a bit on the pin control and pin muxing
logic vs GPIO arangements in the hardware.

Inspired by some drawings in a mail from Christian Ruppert.
Both arrangements are confirmed to exist in practice.

Cc: Rob Landley <rob@landley.net>
Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Updated with lots of good input and rewording from Stephen
  Warren.
ChangeLog v1->v2:
- Cut down to two arrangements that I *know* exist in reality.
- Reword, rehash, rinse, repeat...
---
 Documentation/pinctrl.txt | 91 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 85 insertions(+), 6 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 052e13a..d2d7fc0 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -795,18 +795,97 @@ special GPIO-handler is registered.
 GPIO mode pitfalls
 ==================
 
-Sometime the developer may be confused by a datasheet talking about a pin
-being possible to set into "GPIO mode". It appears that what hardware
-engineers mean with "GPIO mode" is not necessarily the use case that is
-implied in the kernel interface <linux/gpio.h>: a pin that you grab from
-kernel code and then either listen for input or drive high/low to
-assert/deassert some external line.
+Due to the naming conventions used by hardware engineers, where "GPIO"
+is taken to mean different things than what the kernel does, the developer
+may be confused by a datasheet talking about a pin being possible to set
+into "GPIO mode". It appears that what hardware engineers mean with
+"GPIO mode" is not necessarily the use case that is implied in the kernel
+interface <linux/gpio.h>: a pin that you grab from kernel code and then
+either listen for input or drive high/low to assert/deassert some
+external line.
 
 Rather hardware engineers think that "GPIO mode" means that you can
 software-control a few electrical properties of the pin that you would
 not be able to control if the pin was in some other mode, such as muxed in
 for a device.
 
+The GPIO portions of a pin and its relation to a certain pin controller
+configuration and muxing logic can be constructed in several ways. Here
+are two examples:
+
+(A)
+                       pin config
+                       logic regs
+                       |               +- SPI
+     Physical pins --- pad --- pinmux -+- I2C
+                               |       +- mmc
+                               |       +- GPIO
+                               pin
+                               multiplex
+                               logic regs
+
+Here some electrical properties of the pin can be configured no matter
+whether the pin is used for GPIO or not. If you multiplex a GPIO onto a
+pin, you can also drive it high/low from "GPIO" registers.
+Alternatively, the pin can be controlled by a certain peripheral, while
+still applying desired pin config properties. GPIO functionality is thus
+orthogonal to any other device using the pin.
+
+In this arrangement the registers for the GPIO portions of the pin controller,
+or the registers for the GPIO hardware module are likely to reside in a
+separate memory range only intended for GPIO driving, and the register
+range dealing with pin config and pin multiplexing get placed into a
+different memory range and a separate section of the data sheet.
+
+(B)
+
+                       pin config
+                       logic regs
+                       |               +- SPI
+     Physical pins --- pad --- pinmux -+- I2C
+                       |       |       +- mmc
+                       |       |
+                       GPIO    pin
+                               multiplex
+                               logic regs
+
+In this arrangement, the GPIO functionality can always be enabled, such that
+e.g. a GPIO input can be used to "spy" on the SPI/I2C/MMC signal while it is
+pulsed out. It is likely possible to disrupt the traffic on the pin by doing
+wrong things on the GPIO block, as it is never really disconnected. It is
+possible that the GPIO, pin config and pin multiplex registers are placed into
+the same memory range and the same section of the data sheet, although that
+need not be the case.
+
+From a kernel point of view, however, these are different aspects of the
+hardware and shall be put into different subsystems:
+
+- Registers (or fields within registers) that control electrical
+  properties of the pin such as biasing and drive strength should be
+  exposed through the pinctrl subsystem, as "pin configuration" settings.
+
+- Registers (or fields within registers) that control muxing of signals
+  from various other HW blocks (e.g. I2C, MMC, or GPIO) onto pins should
+  be exposed through the pinctrl subssytem, as mux functions.
+
+- Registers (or fields within registers) that control GPIO functionality
+  such as setting a GPIO's output value, reading a GPIO's input value, or
+  setting GPIO pin direction should be exposed through the GPIO subsystem,
+  and if they also support interrupt capabilities, through the irqchip
+  abstraction.
+
+Depending on the exact HW register design, some functions exposed by the
+GPIO subsystem may call into the pinctrl subsystem in order to
+co-ordinate register settings across HW modules. In particular, this may
+be needed for HW with separate GPIO and pin controller HW modules, where
+e.g. GPIO direction is determined by a register in the pin controller HW
+module rather than the GPIO HW module.
+
+Electrical properties of the pin such as biasing and drive strength
+may be placed at some pin-specific register in all cases or as part
+of the GPIO register in case (B) especially. This doesn't mean that such
+properties necessarily pertain to what the Linux kernel calls "GPIO".
+
 Example: a pin is usually muxed in to be used as a UART TX line. But during
 system sleep, we need to put this pin into "GPIO mode" and ground it.
 
-- 
1.8.1.4

