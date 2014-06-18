Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965939AbaFRKsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:48:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18824 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965568AbaFRKsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:48:38 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-53-53a16e83661f
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, devicetree@vger.kernel.org
Cc: wsa@the-dreams.de, broonie@kernel.org,
        linux-arm-kernel@lists.infradead.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, gregkh@linuxfoundation.org,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC V7] clk: Default clock parents and rates assigned from DT
Date: Wed, 18 Jun 2014 12:47:15 +0200
Message-id: <1403088436-29956-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jQd3mvIXBBlvvG1lMffiEzWL+kXOs
	Fv1vFrJaNC9ez2ZxtukNu8Wmx9dYLTr+fmG0uLxrDptF48eb7BZLr19ksng64SKbxYTpa1ks
	Dr9pZ7VYeWIWswOfx5p5axg9Lvf1MnlsWtXJ5nHn2h42j/1z17B7bF5S79G3ZRWjx8lTT1g8
	Pm+SC+CM4rJJSc3JLEst0rdL4Mr4u+0ka8ENxYr2BftYGxhPSXYxcnJICJhIrF37hx3CFpO4
	cG89WxcjF4eQwHRGiebWK6wQTgeTxMcdZ9hAqtgEDCV6j/YxgtgiAqYS765/YwKxmQUuMkn8
	POoJYgsL+Epcv/mDBcRmEVCV6Nn1gRXE5hVwkzi/YSrQNg6gbQoScybZTGDkXsDIsIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOCCfSe9gXNVgcYhRgINRiYeXI3dBsBBrYllxZe4hRgkO
	ZiUR3pepC4OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1
	MDI+lDRcob3gK6PxGYN5kZevtBukPKis3VujlLd/oU3iMVm/hxyl59dpnvj8sDC3dt7G1d7/
	Xzu3n5dhuHDorGrcZXd7DpV0D+brio6mbQrfxILvaxZtScy7U3dkb+5mk6bMivU2NxpbLb7e
	1OOffUbrUqH408RTh0743j9tbX273Oj1628l55VYijMSDbWYi4oTAZhlxWtEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT binding documentation for a set of properties
allowing to specify default parent clocks and clock rates in the device
tree.  It also adds a helper function to parse the 'assigned-clocks',
'assigned-clock-parents' and 'assigned-clock-rates' DT properties and
to set the specified clocks configuration.  The configuration is now
being done by the platform, I2C and SPI bus before driver probing and
in the clock core after registering a clock provider.

Changes since v6:
 - use a set of separate DT properties to specify the default parent
   clocks and rates;
 - the clock defaults setting extended to the I2C and SPI busses;
 - added struct dev_clk_info to struct device so we can prevent multiple
   calls to clk_dev_set_defaults() in case of deferred probing;
 - skipped the first patch from the series already merged upstream.

Changes since v5:
 - reverted to the DT binding as sugested by Grant, it should now work
   for both clock suppliers and consumers, similarly as pinctrl hogging;
 - fixed detecting of null phandles (ENOENT error handling);
 - the clocks will now also be attempted to be configured right after
   registering the clock provider, this allows to avoid a call to
   of_clk_set_defaults() in multiple clock provider drivers;
 - dropped of_clk_get_by_property() helper, added of_clk_get_by_clkspec.

Changes since v4:
 - added note explaining how to skip setting parent and rate of a clock,
 - added missing call to of_node_put(),
 - moved of_clk_dev_init() calls to the platform bus,
 - dropped debug traces.

Changes since v3:
 - improved documentation of the DT binding,
 - fixed build errors for !CONFIG_OF, the parsing helpers are only
   compiled in if CONFIG_OF is set.

Changes since v2:
 - code reordering to ensure there is no build errors, the clock
   configuration code moved to a separate file,
 - introduced an 'assigned-clocks' DT node which is supposed to contain
   clocks, clock-parents, clock-rates properties and be child node
   a clock provider node, and a code parsing it called from of_clk_init();
   It's for clocks which are not directly connected to consumer devices.
   An alternative would be to list such assigned clocks in 'clocks'
   property, along with "proper" parent clocks, but then there would
   be phandles in clocks property of a node pointing to itself and it
   would require proper handling in of_clock_init().
   I actually tried it but it looked a bit ugly and chose this time to
   use an extra subnode.

Changes since v1:
 - updated DT binding documentation,
 - dropped the platform bus notifier, the clock setup routine is now
   being called directly from the driver core before a driver probe() call;
   this has an advantage such as all bus types are handled and any errors
   are propagated, so that, for instance a driver probe() can be deferred
   also when resources specified by clock-parents/clock-rates properties
   are not yet available; an alternative would be to let drivers call
   of_clk_device_setup() directly,
 - dropped the patch adding a macro definition for maximum DT property
   name length for now.

This series has been tested on ARM, on Exynos4412 Odroid U3 board.
The full git tree can be found at:
 git://linuxtv.org/snawrocki/samsung.git v3.16-rc1-odroid-sound-clk

and browsed at
 http://git.linuxtv.org/cgit.cgi/snawrocki/samsung.git/log/?h=v3.16-rc1-odroid-sound-clk

Sylwester Nawrocki (1):
  clk: Support for clock parents and rates assigned from device tree

 .../devicetree/bindings/clock/clock-bindings.txt   |   36 +++++
 drivers/base/platform.c                            |    5 +
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-conf.c                             |  154 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   12 +-
 drivers/i2c/i2c-core.c                             |    5 +
 drivers/spi/spi.c                                  |    5 +
 include/linux/clk/clk-conf.h                       |   33 +++++
 include/linux/device.h                             |    4 +
 9 files changed, 255 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

--
1.7.9.5

