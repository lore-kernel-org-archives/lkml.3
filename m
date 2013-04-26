Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3DZMnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:43:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43779 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab3DZMnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:43:10 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCHv4 0/5] Serial Omap fixes and cleanups
Date: Fri, 26 Apr 2013 18:12:43 +0530
Message-ID: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series contains fixes and cleanups around the issue that
the console UART should not idled on suspend while using "no_console_suspend"
in bootargs.

The approach thought of is to modify the serial core/serial driver to bypass
runtime PM if the UART in contention is a console and we are using "no_console_suspend"
in our bootargs.

While fixing the above issue, there are other cleanups also done as part of
this series which are no longer required. This cleanups mainly include getting
rid of using "omap_device_disable_idle_on_suspend" api for both dt and non dt case
as the serial driver will be self sufficient to handle the "no_idle_on_suspend" issue.
Serial was the only one making use of "omap_device_disable_idle_on_suspend"

There were discussions about how to handle "no_idle_on_suspend" issue and all the
discussions are as follows:
https://lkml.org/lkml/2013/4/5/239
https://lkml.org/lkml/2013/4/2/350
https://lkml.org/lkml/2013/3/18/199
https://lkml.org/lkml/2013/3/18/295
Due to the amount of change in approach and other cleanups coming around it, I am posting
this as a new series.

v3->v4
1. check for console in runtime api.
2. Prevent setting od->flags to OMAP_DEVICE_SUSPENDED

v2->v3
1. Use "-EBUSY" for no_console_suspend case
2. Bypass runtime PM only during suspend
3. Improve the commit log based on community suggestion.

v1->v2
1. Remove the prepare/complete callback.
2. Adapt runtime PM callback to deal with the issue.
3. Fold patch(1,2) of previous series into 1.
4. Reordered the patch.
5. Change $subject and chage log for few patches.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>

Test info
Omap4430sdp:
- Tested wakeup from UART after suspend for dt and non dt case.
Omap5430evm:
- Tested wakeup from UART after suspend for dt case.

This patches are based on 3.9-rc8

The following changes since commit 824282ca7d250bd7c301f221c3cd902ce906d731:

  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2013-04-22 15:00:59 -0700)

are available in the git repository at:

  git://gitorious.org/linux-connectivity/linux-connectivity.git serial_omap_fix_cleanup

Sourav Poddar (5):
      driver: tty: serial: Move "uart_console" def to core header file.
      driver: serial: omap: prevent runtime PM for "no_console_suspend"
      arm: omap2+: serial: remove no_console_suspend support
      arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
      arm: omap2+: omap_device: remove no_idle_on_suspend

 arch/arm/boot/dts/am33xx.dtsi     |    1 -
 arch/arm/mach-omap2/omap_device.c |    9 ++-------
 arch/arm/mach-omap2/omap_device.h |   10 ----------
 arch/arm/mach-omap2/serial.c      |    7 -------
 drivers/tty/serial/mpc52xx_uart.c |   10 ----------
 drivers/tty/serial/omap-serial.c  |   28 +++++++++++++++++++++++++++-
 drivers/tty/serial/serial_core.c  |    6 ------
 include/linux/serial_core.h       |    7 +++++++
 8 files changed, 36 insertions(+), 42 deletions(-)
