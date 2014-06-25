Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaFYNiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:38:21 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10486 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaFYNiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:38:19 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-8a-53aad0c76d19
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 0/6] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Wed, 25 Jun 2014 15:37:25 +0200
Message-id: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xK7rHL6wKNtj0Ut/i0fzHzBa9C66y
	WWzvnMFuMeXPciaLTY+vsVpc3jWHzWL2kn4Wixnn9zFZ3L7Ma7H2yF12i9d9a5gt1s94zWKx
	atcfRov9V7wc+DxamnvYPL59ncTicbmvl8lj0fcsj52z7rJ73Lm2h81j85J6j74tqxg9jt/Y
	zuTxeZNcAFcUl01Kak5mWWqRvl0CV8bDtsmsBd0SFV9+vGdvYHwr1MXIySEhYCLxu7OTHcIW
	k7hwbz1bFyMXh5DAUkaJXwteskM4fUwSN1/eZwSpYhNQk/jc8IgNxBYRUJX43LYArIhZoIFF
	4krrdbCEsIC7xP3Dz8DGsgAVTbzTB2bzCjhJPGpbywqxTk6id9sb5gmM3AsYGVYxiqaWJhcU
	J6XnGukVJ+YWl+al6yXn525ihATm1x2MS49ZHWIU4GBU4uEN4FkVLMSaWFZcmXuIUYKDWUmE
	130/UIg3JbGyKrUoP76oNCe1+BAjEwenVAPj7QsTeVZ6FHqEzdM+Z6vle8B65sY3wd+VeWqa
	5Zj6DBmLO3g5bW4qz0is1WqylBZ2FzRJLSmQOXnkUrJxW/XfUxffpf7kaXAO2KN+6vdVz/TS
	C/Lrw7bVaxyXfVPjo9q06BC3+pl9h1g/cPHwrd+aJLXzCjPLpc70XbsPL2mUZJp73/TZuZtK
	LMUZiYZazEXFiQArJXwzKgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series intends to add support for L2 cache on Exynos4 SoCs on boards
running under secure firmware, which requires certain initialization steps
to be done with help of firmware, as selected registers are writable only
from secure mode.

First four patches extend existing support for secure write in L2C driver
to account for design of secure firmware running on Exynos. Namely:
 1) direct read access to certain registers is needed on Exynos, because
    secure firmware calls set several registers at once,
 2) not all boards are running secure firmware, so .write_sec callback
    needs to be installed in Exynos firmware ops initialization code,
 3) write access to {DATA,TAG}_LATENCY_CTRL registers fron non-secure world
    is not allowed and so must use l2c_write_sec as well,
 4) on certain boards, default value of prefetch register is incorrect
    and must be overridden at L2C initialization.
Patches 1-3 might affect other platforms using .write_sec callback, so
I'd like to kindly ask any interested people for testing.

Further two patches add impelmentation of .write_sec for Exynos secure
firmware and necessary DT nodes to enable L2 cache.

Tested on Exynos4210-based Universal C210 and Trats (both without secure
firmware) and Exynos4412-based TRATS2 and ODROID-U3 boards (both with secure
firmware).

Changes since v1:
(https://www.mail-archive.com/linux-omap@vger.kernel.org/msg106323.html)
 - rebased onto for-next branch of linux-samsung tree,
 - changed argument order of outer_cache.write_sec() callback to match
   l2c_write_sec() function in cache-l2x0.c,
 - added support of overriding of prefetch settings to work around incorrect
   default settings on certain Exynos4x12-based boards,
 - added call to firmware to invalidate whole L2 cache before setting enable
   bit in L2C control register (required by Exynos secure firmware).

Tomasz Figa (6):
  ARM: mm: cache-l2x0: Add base address argument to write_sec callback
  ARM: Get outer cache .write_sec callback from mach_desc only if not
    NULL
  ARM: mm: cache-l2x0: Use l2c_write_sec() for LATENCY_CTRL registers
  ARM: mm: l2x0: Add support for overriding prefetch settings
  ARM: EXYNOS: Add .write_sec outer cache callback for L2C-310
  ARM: dts: exynos4: Add nodes for L2 cache controller

 Documentation/devicetree/bindings/arm/l2cc.txt | 10 ++++
 arch/arm/boot/dts/exynos4210.dtsi              |  9 ++++
 arch/arm/boot/dts/exynos4x12.dtsi              | 14 ++++++
 arch/arm/include/asm/mach/arch.h               |  3 +-
 arch/arm/include/asm/outercache.h              |  2 +-
 arch/arm/kernel/irq.c                          |  3 +-
 arch/arm/mach-exynos/firmware.c                | 63 +++++++++++++++++++++++++
 arch/arm/mach-highbank/highbank.c              |  3 +-
 arch/arm/mach-omap2/omap4-common.c             |  3 +-
 arch/arm/mach-ux500/cache-l2x0.c               |  3 +-
 arch/arm/mm/cache-l2x0.c                       | 64 ++++++++++++++++++++++----
 11 files changed, 162 insertions(+), 15 deletions(-)

-- 
1.9.3

