Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbaDIL0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:26:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55958 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015AbaDIL0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:26:50 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-06-53452e774ed7
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mturquette@linaro.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, grant.likely@linaro.org, mark.rutland@arm.com,
        galak@codeaurora.org, laurent.pinchart@ideasonboard.com,
        s.hauer@pengutronix.de, ben.dooks@codethink.co.uk,
        pdeschrijver@nvidia.com, kyungmin.park@samsung.com, t-kristo@ti.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v5 0/2] clk: Support for DT assigned clock parents and rates
Date: Wed, 09 Apr 2014 13:26:28 +0200
Message-id: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jAd0KPddgg8mtvBYPbrUyWcw/co7V
	ov/NQlaLA392MFo0L17PZnG26Q27RefEJewWmx5fY7W4vGsOm8Xty7wWa4/cZbdYev0ik8XT
	CRfZLCatncpo0br3CLvF3+2bWCwOv2lntZgx+SWbxZKnHWwW62e8ZnEQ8Vgzbw2jR0tzD5vH
	5b5eJo9nLyczeczumMnqsWlVJ5vHnWt72Dz2z13D7rF5Sb1Hb/M7No/+vwYefVtWMXocv7Gd
	yePzJrkAvigum5TUnMyy1CJ9uwSujFlHPzAW/JWruP7kF3MD4ybxLkZODgkBE4nva44wQdhi
	EhfurWfrYuTiEBJYxCjx4OINJging0ni3KSlLCBVbAKGEr1H+xhBbBEBF4nOB+tYQIqYBe4x
	Sxw/PwesSFggQOLDqwPsIDaLgKrEsU2PwBp4BdwkuuftZ+1i5ABapyAxZ5LNBEbuBYwMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCg/+Z9A7GVQ0WhxgFOBiVeHgVLF2ChVgTy4orcw8x
	SnAwK4nwPmdzDRbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TB
	KdXAyLTniNtz/a1FbcdDZ3+aO3Om5YZb+b333ApWMrJPkGDdPH1JyN75CZIHfVc0FL3Q0OfZ
	HFZ1fqmfUcnV6nwnYwWfjJhFMk1S/dvN1i02s7E+Ze50w+/Oxvp9gqvbGjs+zdZd9+/2pddf
	THkWfYlj8fEq1Jx38FhZT/UhPc90ta5CccszN7aeV2Ipzkg01GIuKk4EABjkwnZ6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a DT binding documentation for new 'clock-parents'
and 'clock-rates' DT properties and a helper to parse DT and set the
specified clocks configuration. The helper is now called in the platform
bus before driver probing.

Changes since v4:
 - added note explaining how to skip setting parent and rate of a clock,
 - added missing call to of_node_put(),
 - moved of_clk_dev_init() calls to the platform bus,
 - dropped debug traces.

Thanks for the reviews.

Currently clock parent/rate setting is only handled automatically for
devices on Linux platform bus; I didn't add it to other busses this
time as the original problem this patch series is trying to solve is
related to the platform devices. However, in general it might make
sense to also add it to other busses, like: amba, I2C, SPI, etc.

The other issue is that in case of deferred probe of_clk_dev_init()
could be called multiple times. To avoid this a field could be added
to struct device or struct platform_device, etc. so a device can be
marked as initialized WRT clocks and initialization could be skipped
before any subsequent deferred probe calls.
I wasn't sure if I should bother generic device data structures with
something like this so I just didn't add it now.


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

Open issues:
 - handling of errors from of_clk_get_by_property() could be improved,
   currently ENOENT is returned by this function not only for a null
   entry.

This series has been tested on ARM, on Exynos4412 Trats2 board.

Sylwester Nawrocki (2):
  clk: Add function parsing arbitrary clock list DT property
  clk: Add handling of clk parent and rate assigned from DT

 .../devicetree/bindings/clock/clock-bindings.txt   |   44 ++++++++++
 drivers/base/platform.c                            |    5 ++
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-conf.c                             |   85 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   12 ++-
 drivers/clk/clkdev.c                               |   25 +++++-
 include/linux/clk.h                                |    7 ++
 include/linux/clk/clk-conf.h                       |   19 +++++
 8 files changed, 195 insertions(+), 5 deletions(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

--
1.7.9.5

