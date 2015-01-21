Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbbAUKc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:32:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:45244 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbbAUKcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:32:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,440,1418112000"; 
   d="scan'208";a="654193798"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@intel.com>
Cc: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] Consolidate similar algorithms in gpio-sch
Date: Wed, 21 Jan 2015 18:32:20 +0800
Message-Id: <1421836341-2036-1-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some background about this patch:
This patch come from the previous threads on enabling Quark X1000 support in
gpio-sch. The patches were found to break the build on devel branch.
Refer to: https://lists.01.org/pipermail/kbuild-all/2015-January/008513.html

One of the patch (mentioned below) was already applied in devel branch.
(Patch 2/2) 9202149 gpio: sch: Add support for Intel Quark X1000 SoC.
Meanwhile the patch that breaks the build was removed from devel branch.

So, in this email, I've attached a patch that contains the algorithms
consolidation together with the fix for build warnings on wrong arguments
passing in sch_gpio_reg_set().

The patch was built with the configurations provided in the mail by
Wu, Fengguang:
https://lists.01.org/pipermail/kbuild-all/2015-January/008511.html

Procedures for build test on devel branch:
$ cp ATT23421.config .config
$ make ARCH=x86_64 oldconfig
$ make ARCH=x86_64
Same procedures applied for ARCH=x86 and no build warnings was found on
gpio-sch.

Driver test procedures on Galileo board using Yocto Project as reference OS:

Check driver availability:
$ ls /sys/bus/platform/drivers/
Result: Driver sch_gpio available

Check device availability:
$ ls /sys/bus/platform/devices/
Result: Device sch_gpio.2398 available

Check the driver binded with the device successfully through sysfs:
$ ls -al /sys/class/gpio/gpiochip0/device
Result: gpiochip0/device/ -> ../../../sch_gpio.2398

Check using sysfs debug:
$ cat /sys/kernel/debug/gpio
GPIOs 0-7, platform/sch_gpio.2398, sch_gpio.2398:
Result: Both driver and device are available

The driver should allow user to export GPIO pin.
$ echo 3 > export
Result: gpio3 create with no error message

The driver should allow user to configure GPIO pin direction and pin value.
Since gpio3 (on sysfs for Galileo) is connected to an LED, we will use this as
our test equipment.
$ echo out > gpio3/direction
$ cat gpio3/direction
out
Result: Pin direction was set without error prompts.

$ echo 1 > gpio3/value
$ cat gpio3/value
1
Result: LED will turn on

$ echo 0 > gpio3/value
$ cat gpio3/value
0
Result: LED will turn off

$ echo in > gpio3/direction
$ cat gpio3/direction
in
Result: Pin direction was set without error prompts.

The driver should allow user to do unexport for unused pin.
$ echo 3 > unexport
Result: gpio3 directory was wiped out without error logs.

Please review the patch and provide feedback if any. Thanks.

Regards,
Rebecca

Chang Rebecca Swee Fun (1):
  gpio: sch: Consolidate similar algorithms

 drivers/gpio/gpio-sch.c | 83 +++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 54 deletions(-)

-- 
1.9.1

