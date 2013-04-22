Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3DVNpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:45:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55207 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab3DVNoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:44:17 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCHv2 0/5] Serial Omap fixes and cleanups
Date: Mon, 22 Apr 2013 19:13:52 +0530
Message-ID: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
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

Test info (except drivers: serial: mpc52xx_uart: Remove "uart_console" defintion):
Omap4430sdp:
- Tested wakeup from UART after suspend for dt and non dt case.
Omap5430evm:
- Tested wakeup from UART after suspend for dt case.


This patches are based on 3.9-rc3 custom tree which has
Santosh Shilimkar serial patch[1]
[1]: http://permalink.gmane.org/gmane.linux.ports.arm.omap/95828

v1->v2
1. Remove the prepare/complete callback.
2. Adapt runtime PM callback to deal with the issue.
3. Fold patch(1,2) of previous series into 1.
4. Reordered the patch.
5. Change $subject and chage log for few patches.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>


Sourav Poddar (5):
  driver: tty: serial: Move "uart_console" def to core header file.
  driver: serial: omap: prevent runtime PM for "no_console_suspend"
    case
  arm: omap2+: serial: remove no_console_suspend support
  arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
  arm: omap2+: device: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check

 arch/arm/boot/dts/am33xx.dtsi     |    1 -
 arch/arm/mach-omap2/omap_device.c |   12 +++---------
 arch/arm/mach-omap2/omap_device.h |   10 ----------
 arch/arm/mach-omap2/serial.c      |    7 -------
 drivers/tty/serial/mpc52xx_uart.c |   10 ----------
 drivers/tty/serial/omap-serial.c  |    5 ++++-
 drivers/tty/serial/serial_core.c  |    6 ------
 include/linux/serial_core.h       |    7 +++++++
 8 files changed, 14 insertions(+), 44 deletions(-)

