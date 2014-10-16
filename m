Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaJPRME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:12:04 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56115 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJPRMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:12:00 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH RFC v2 0/8] Pinctrl support for Zynq
Date: Thu, 16 Oct 2014 10:11:27 -0700
Message-Id: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.2.1.g5e69ed6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second iteration of pinctrl for Zynq (first submission:
https://lkml.org/lkml/2014/9/24/1140).

The high level changes:
 - rebase to 3.18, i.e. usage of 'groups' property in DT
 - added pinconf functionality
 - revised the DT descriptions

In more detail:
pinctrl: pinconf-generic: Add flag to print arguments
  There are some generic properties that take an argument but don't have
  a unit attached to it. Furthermore, printing the argument depended on
  the argument being non-zero, which is also not always useful. To add a
  little more flexibility, this patch adds a dedicated flag to indicate
  whether a property takes an argument that should be printed. The first
  example is the slew-rate property, that according to bindings takes a
  driver specific argument, but does not have a unit. So, printing it
  including a zero argument does make sense.

pinctrl: pinconf-generic: Add parameter 'IO standard':
  I guess this is mostly seld-explanatory. On Zynq we can select between
  different IO-standards.

pinctrl: pinconf-generic: Infer map type from DT property:
  This is the important one. Before this drivers could choose between
  pinconf_generic_dt_node_to_map_group() and
  pinconf_generic_dt_node_to_map_pin() to create mapping from DT.
  Choosing groups would make the core interpret the 'pins' property as
  group, and you lost the ability to address by pin. And vice versa,
  using the pin function would force using pins and you lose the ability
  to address groups.
  With the new 'groups' DT property, this is no longer needed and both
  options can coexist by inferring the map type by testing whether the
  pins or groups property was used.
  To make this change backwards-compatible with current usage, this
  inferring is only done when PIN_MAP_TYPE_INVALID is passed to the
  mapping function. For that reason pinconf_generic_dt_node_to_map_all()
  is introduced, which does exactly that.
  With this change it is possible to have nodes in DT that work on
  pingroups using the 'grops' property as well has nodes using 'pins'
  that address specific pins.

ARM: zynq: DT: Add pinctrl information:
  I completely rewrote this taking the v1 input into account. The common
  dtsi file does only feature the pin-controller without any
  configuration nodes. The board files define the used configurations.
  To configure all the muxes and configurations the new core features
  are used.

	Thanks,
	Sören

Soren Brinkmann (8):
  pinctrl: Add driver for Zynq
  pinctrl: pinconf-generic: Add flag to print arguments
  pinctrl: pinconf-generic: Add parameter 'IO standard'
  pinctrl: zynq: Support IO standard property
  pinctrl: zynq: Support low power mode property
  pinctrl: pinconf-generic: Infer map type from DT property
  pinctrl: zynq: Use generic map_all function
  ARM: zynq: DT: Add pinctrl information

 .../bindings/pinctrl/pinctrl-bindings.txt          |    3 +
 arch/arm/boot/dts/zynq-7000.dtsi                   |    8 +-
 arch/arm/boot/dts/zynq-zc702.dts                   |  147 +++
 arch/arm/boot/dts/zynq-zc706.dts                   |  126 +++
 arch/arm/mach-zynq/Kconfig                         |    1 +
 drivers/pinctrl/Kconfig                            |    8 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinconf-generic.c                  |   84 +-
 drivers/pinctrl/pinctrl-zynq.c                     | 1139 ++++++++++++++++++++
 include/linux/pinctrl/pinconf-generic.h            |   11 +
 10 files changed, 1496 insertions(+), 32 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-zynq.c

-- 
2.1.2.1.g5e69ed6

