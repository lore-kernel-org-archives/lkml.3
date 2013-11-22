Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3KVMOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:14:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:54222 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab3KVMOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:14:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,751,1378882800"; 
   d="scan'208";a="432088718"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] gpio / ACPI: convert users to gpiod_* and drop acpi_gpio.h
Date: Fri, 22 Nov 2013 14:14:27 +0200
Message-Id: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Now that the mainline kernel has full ACPI support for the GPIO descriptor
interface we can get rid of ACPI specific GPIO functions in favor of GPIO
descriptor (gpiod_*) interfaces.

This series first converts the existing two users to this interface and
then modifies gpiolib and gpiolib-acpi so that the ACPI functions are only
called internally in drivers/gpio. We then remove the acpi_gpio.h and
require all users to user gpiod_* interfaces.

This is second version of the series. Changes to the previous [1]:
 * paz00 is passing the lookup table so that we don't need to have gpio
   conversion function in rfkill-gpio.c anymore.
 * Corrected sdhci-acpi.c to pass con_id and added call to
   gpiod_direction_input().

I suppose it would make sense to merge the whole series via GPIO or ACPI
trees because there's a dependency that the first two patches need to be
applied before last three. Otherwise the drivers in question fail to
compile.

[1] https://lkml.org/lkml/2013/11/21/317

Heikki Krogerus (3):
  net: rfkill: gpio: convert to descriptor-based GPIO interface
  ARM: tegra: add gpiod_lookup table for paz00
  net: rfkill: gpio: remove gpio conversion support

Mika Westerberg (4):
  mmc: sdhci-acpi: covert to use GPIO descriptor API
  gpio / ACPI: register to ACPI events automatically
  gpio / ACPI: get rid of acpi_gpio.h
  Documentation / ACPI: update to GPIO descriptor API

 Documentation/acpi/enumeration.txt | 36 ++++--------------
 arch/arm/mach-tegra/board-paz00.c  |  9 ++++-
 drivers/gpio/gpiolib-acpi.c        | 20 +++++++---
 drivers/gpio/gpiolib.c             |  5 ++-
 drivers/gpio/gpiolib.h             | 46 +++++++++++++++++++++++
 drivers/mmc/host/sdhci-acpi.c      | 26 ++++++-------
 drivers/pinctrl/pinctrl-baytrail.c |  4 --
 include/linux/acpi_gpio.h          | 51 -------------------------
 net/rfkill/rfkill-gpio.c           | 77 +++++++++++++++++---------------------
 9 files changed, 125 insertions(+), 149 deletions(-)
 create mode 100644 drivers/gpio/gpiolib.h
 delete mode 100644 include/linux/acpi_gpio.h

-- 
1.8.4.3

