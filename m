Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab3IPIdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:33:21 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53975 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3IPIdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:33:16 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/9] of/irq: Defer interrupt reference resolution
Date: Mon, 16 Sep 2013 10:31:57 +0200
Message-Id: <1379320326-13241-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small series allows interrupt references from the device tree to be
resolved at driver probe time, rather than at device creation time. The
current implementation resolves such references while devices are added
during the call to of_platform_populate(), which happens very early in
the boot process. This causes probe ordering issues, because all devices
that are an interrupt parent for other devices need to have been probed
by that time. This is worked around for primary interrupt controllers by
initializing them using a device tree specific way (of_irq_init()), but
it doesn't work for something like a GPIO controller that is itself a
platform device and an interrupt parent for other devices at the same
time.

Currently such drivers use explicit initcall ordering to force these
chips to be probed earlier than other devices, but that only fixes a
subset of the problematic cases. It doesn't work if the interrupt user
is itself a platform device on the same bus. There are possibly other
cases where it doesn't work either.

This patch series attempts to fix this by not resolving the interrupt
references at device creation time. Instead, some functionality is added
to the driver core to resolve them for each device immediately before it
is probed. Often this is a lot later than the point at which the device
was created, which gives interrupt parents more time and therefore a
better chance of being probed. More importantly, however, it allows the
driver core to detect when an interrupt parent isn't there yet and cause
the device to be queued for deferred probing. After all, resolving probe
ordering issues is one of the primary reason for the introduction of
deferred probing.

Unfortunately the interrupt core code isn't prepared to handle this very
well, so some preparatory work is required.

Patch 1 is a bit of a cleanup. It modifies of_irq_count() to not use the
heavyweight of_irq_to_resource(), which will actually try to create a
mapping. While not usually harmful, it causes a warning during boot if
the interrupt parent hasn't registered an IRQ domain yet. Furthermore it
is much more than the stated intention of the function, which is to
return the number of interrupts that a device node uses.

Patches 2 and 3 introduce two new functions: __irq_create_mapping() and
__irq_create_of_mapping(), which are both equivalent to the non-__ parts
except that they return a negative error code on failure and therefore
allow propagation of a precise error code instead of 0 for all errors.
This is an important prerequisite for subsequent patches. I think that
it would've been nice to not introduced underscore-prefixed variants but
but there are about 130 callers and updating them all would've been
rather messy.

Patch 4 adds an of_irq_get() function, which is irq_of_parse_and_map()
but returns a negative error code on failure instead of 0.

Similarly, __of_irq_to_resource() as introduced in patch 5 is equivalent
to of_irq_to_resource() but returns a negative error code on failure
instead of 0.

Patch 6 uses __of_irq_to_resource() to propagate error code to callers
of the of_irq_to_resource_table() function.

Patch 7 adds functionality to the platform driver code to resolve
interrupt references at probe time. It uses the negative error code of
the of_irq_to_resource_table() function to trigger deferred probing.

Patch 8 implements similar functionality for I2C devices.

Patch 9 serves as an example of the kind of cleanup that can be done
after this series. Obviously this will require quite a bit of retesting
of working setups, but I think that in the long run we're better off
without the kind of explicit probe ordering employed by the gpio-tegra
driver and many others.

Note that I've only implemented this for platform and I2C devices, but
the same can be done for SPI and possibly other subsystems as well.

There is another use-case that I'm aware of for which a similar solution
could be implemented. IOMMUs on SoCs generally need to hook themselves
up to new platform devices. This causes a similar issues as interrupt
resolution and should be fixable by extending the of_platform_probe()
function introduced in patch 7 of this series.

Thierry

Thierry Reding (9):
  of/irq: Rework of_irq_count()
  irqdomain: Introduce __irq_create_mapping()
  irqdomain: Introduce __irq_create_of_mapping()
  of/irq: Introduce of_irq_get()
  of/irq: Introduce __of_irq_to_resource()
  of/irq: Propagate errors in of_irq_to_resource_table()
  of/platform: Resolve interrupt references at probe time
  of/i2c: Resolve interrupt references at probe time
  gpio: tegra: Use module_platform_driver()

 drivers/base/platform.c     |  4 ++
 drivers/gpio/gpio-tegra.c   |  7 +---
 drivers/i2c/i2c-core.c      | 23 ++++++++++-
 drivers/of/irq.c            | 69 +++++++++++++++++++++++--------
 drivers/of/platform.c       | 43 +++++++++++++++++---
 include/linux/of_irq.h      |  6 +++
 include/linux/of_platform.h |  7 ++++
 kernel/irq/irqdomain.c      | 98 +++++++++++++++++++++++++++++++--------------
 8 files changed, 197 insertions(+), 60 deletions(-)

-- 
1.8.4

