Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbaESRYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:24:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22431 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaESRYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:24:23 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-f5-537a3e455651
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        mturquette@linaro.org
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, pawel.moll@arm.com,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC V6 0/2] clk: Default clk parents and rates assigned in DT
Date: Mon, 19 May 2014 19:22:49 +0200
Message-id: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAV1Xu6pgg2UdPBbzj5xjteh/s5DV
	4sCfHYwWZ5vesFtsenyN1eLyrjlsFrcv81qsPXKX3WLp9YtMFk8nXGSzmDB9LYtF694j7BaH
	37SzWsyY/JLNYv2M1ywO/B5r5q1h9Ghp7mHzuNzXy+SxaVUnm8eda3vYPDYvqffo27KK0ePz
	JrkAjigum5TUnMyy1CJ9uwSujKOdLAU7pSsmbu5namA8JdLFyMkhIWAiMeflTXYIW0ziwr31
	bF2MXBxCAosYJX5eW88C4XQwSbzreARWxSZgKNF7tI8RxBYRiJXY8GwvI0gRs8BuJon1n46w
	giSEBXwlTuy8zgZiswioSuxvnsMMYvMKuEp837odqIEDaJ2CxJxJNhMYuRcwMqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECA7HZ1I7GFc2WBxiFOBgVOLhPSBeFSzEmlhWXJl7iFGCg1lJ
	hNfNBCjEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qB0Tdn
	w5tHlXnpVnPd+CYxTm40ufO44l4Yz5r8w5Wur50C4v4lfJ12/+epV++PdFdWxa68tf/bxXN2
	rzJVirbK1uh+E4vZ+z55k5Le5Tdaj34ePC94oXwFl3GMxOcQjdh8k+tXDe9Nrmb9NH/HF9bC
	dyy+qcFRTuoXtr3pKFo5eU5R+dnHDNNvtiixFGckGmoxFxUnAgAehsMlQwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a DT binding documentation for new 'clock-parents'
and 'clock-rates' DT properties and a helper to parse DT and set the
specified clocks configuration. The helper is now called in the platform
bus before driver probing and by the clock core after registering a clock
provider.

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

Sylwester Nawrocki (2):
  clk: Add of_clk_get_by_clkspec() helper
  clk: Add handling of clk parent and rate assigned from DT

 .../devicetree/bindings/clock/clock-bindings.txt   |   32 +++++
 drivers/base/platform.c                            |    5 +
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-conf.c                             |  141 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   27 +++-
 drivers/clk/clk.h                                  |    1 +
 drivers/clk/clkdev.c                               |   34 ++++-
 include/linux/clk/clk-conf.h                       |   20 +++
 8 files changed, 253 insertions(+), 10 deletions(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

--
1.7.9.5

