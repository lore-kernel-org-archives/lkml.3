Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbbASVvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:51:03 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32677 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbASVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:51:00 -0500
X-IronPort-AV: E=Sophos;i="5.09,429,1418112000"; 
   d="scan'208";a="55126452"
From: Ray Jui <rjui@broadcom.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Arend van Spriel <arend@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v7 0/3] Add I2C support to Broadcom iProc
Date: Mon, 19 Jan 2015 13:51:47 -0800
Message-ID: <1421704310-26857-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the initial I2C support for Broadcom iProc family of
SoCs.

The iProc I2C controller has separate internal TX and RX FIFOs, each has a
size of 64 bytes. The iProc I2C controller supports two bus speeds including
standard mode (100 kHz) and fast mode (400 kHz)

Changes from v6:
 - Get rid of unnecessary atomic variable usage in the driver
 - Improve the "waiting for transaction to complete" logic further by making
   sure there's no pending/ongoing interrupt by the time when flag
   'xfer_is_done' is checked
 - After disabling interrupt with 'writel', add 'readl' to the same register
   to flush the bus to ensure the write has gone through

Changes from v5:
 - Improve the "waiting for transaction to be complete" logic to take care of
   the corner case when an interrupt fires after wait_for_completion_timeout
   times out
 - Improve the logic to disable I2C interrupt in the remove function. Make it
   more generic so it works for both dedicated and shared interrupt

Changes from v4:
 - Remove redundant header file includes
 - Change the logic that waits for the host controller to be idle to
   simply return -EBUSY
 - Use proper print level and error codes in the driver
 - Allow zero length message in the driver to support I2C_SMBUS_QUICK
 - Change back to use devm_request_irq. Disable interrupt in the remove
   function so there's no outstanding I2C interrupt when the driver is
   being removed from the framework
 - Other minor miscellaneous improvements and fixes

Changes from v3:
 - Add config dependency to COMPILE_TEST to allow the driver to be build tested
   by other platforms
 - Improve CPU utilization efficiency in the loop of waiting for bus to idle
 - Add more comment in the driver to clarify the way how the "start busy"
   interrupt is triggered from the I2C controller
 - Fix inconsistent coding style and format
 - Improve the bus speed validation logic in the driver
 - Add code to free the interrupt line in driver's remove function. Also
   change to use non-devm API to request the interrupt line
 - Other miscellaneous improvements and fixes

Changes from v2:
 - Have the I2C driver default to y so it does not need to be selected from
   ARCH_BCM_IPROC. This also helps to get rid of one patch. The driver still
   depends on ARCH_BCM_IPROC
 - Get rid of redundant check on resource returned by platform_get_resource

Changes from v1:
 - Fix function argument parenthesis
 - Get rid of redundant driver owner field

Ray Jui (3):
  i2c: iProc: define Broadcom iProc I2C binding
  i2c: iproc: Add Broadcom iProc I2C Driver
  ARM: dts: add I2C device nodes for Broadcom Cygnus

 .../devicetree/bindings/i2c/brcm,iproc-i2c.txt     |   37 ++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   20 +
 drivers/i2c/busses/Kconfig                         |   10 +
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  505 ++++++++++++++++++++
 5 files changed, 573 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/brcm,iproc-i2c.txt
 create mode 100644 drivers/i2c/busses/i2c-bcm-iproc.c

-- 
1.7.9.5

