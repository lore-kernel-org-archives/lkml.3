Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaAQGrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:47:43 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:33722 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaAQGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:47:37 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH RFC 0/6] net: rfkill: gpio: Add device tree support
Date: Fri, 17 Jan 2014 14:47:25 +0800
Message-Id: <1389941251-32692-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch series adds device tree support to rfkill-gpio, and
fixes some issues I ran into. This is so we can define and control
RF devices through the device tree, such as the Broadcom BCM20710
UART-based Bluetooth device found on the CubieTruck,

The CubieTruck uses a non-default clock rate oscillator for the
BCM20710 device. As the datasheet states, a precise 32.768 KHz
low power clock must be provided at power on for the device to
detect the correct clock rate of the main oscillator. Hence the
need for the "clock-frequency" property.

The device tree bindings aren't pretty. They are the result of how
gpiod_find was implemented: of_gpiod_find includes con_id in the
DT property name; acpi_gpiod_find ignores it and only uses the index.
A more elegant DT binding would mean splitting the gpio lookup code
path in rfkill-gpio, which would be more like rfkill-gpio prior to
the descriptor-based GPIO patch.

I am aware there is a need for similar functionality for SDIO devices,
which the CubieTruck has as well. A mail thread [1] started yesterday
indicated that generic SDIO DT support was the way to go. I don't know
if that could be applied to UART-based devices though.

[1] http://www.spinics.net/lists/arm-kernel/msg301182.html

The series depends on

    [PATCH v3 2/6] net: rfkill: gpio: convert to descriptor-based GPIO interface

which has been applied through the GPIO tree.

The last patch depends on

    ARM: dts: sun7i: add pin muxing options for UART2

which I sent earlier this week.


Comments, please?


Cheers,
ChenYu


Chen-Yu Tsai (6):
  net: rfkill: gpio: fix gpio name buffer size off by 1
  net: rfkill: gpio: use clk_prepare_enable/clk_disable_unprepare
  net: rfkill: gpio: fix reversed clock enable state
  net: rfkill: gpio: add device tree support
  net: rfkill: gpio: add clock-frequency device tree property
  ARM: sun7i: cubietruck: enable bluetooth module

 .../devicetree/bindings/rfkill/rfkill-gpio.txt     | 28 ++++++++++++++++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         | 37 ++++++++++++++++++++++
 net/rfkill/rfkill-gpio.c                           | 37 +++++++++++++++++++---
 3 files changed, 97 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt

-- 
1.8.5.2

