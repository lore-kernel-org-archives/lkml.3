Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaLWKsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:48:55 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62246 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbaLWKst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:49 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-85-5499488bb148
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v10 0/8] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Tue, 23 Dec 2014 11:48:28 +0100
Message-id: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7rdHjNDDPqe6Fn8nXSM3eLR/MfM
	Fr0LrrJZfD28gtHibNMbdovtnTPYLab8Wc5ksenxNVaLy7vmsFnMXtLPYjHj/D4mi9uXeS3O
	bd/CYrH2yF12i6XXLzJZvPlxlsni1PXPbBardv1htNh/xctB2GPNvDWMHi3NPWwev39NYvT4
	9nUSi8flvl4mj0Xfszx2zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/iN7UwenzfJBfBGcdmk
	pOZklqUW6dslcGVMfbadpaBRuWLzhXksDYxXpbsYOTkkBEwk/rW+YoawxSQu3FvPBmILCSxl
	lPi40QjC7mOSWNImDGKzCRhKdL3tAqsREXCT+LfuEJDNxcEsMI1FYtOR80CDODiEBTwk+h9y
	g5gsAqoST9/bg5TzCrhLTD88lR1ilZzE/5crmCYwci9gZFjFKJpamlxQnJSea6hXnJhbXJqX
	rpecn7uJERLgX3YwLj5mdYhRgINRiYf35PsZIUKsiWXFlbmHGCU4mJVEeF+KzwwR4k1JrKxK
	LcqPLyrNSS0+xMjEwSnVwCg2YWORhZJ6Q2+SGyvT4/nbVGYdzti2xmftmddTn77Y2LZZPudq
	wqf2S8d/z39qyvDq6PTCosKCSefljx0LLMutWN+y41Dt/Ymr5NfzrTn1K1Xf1/GfjuXHkA9N
	ivc5v6r8Orm3PenS73XcLZezO8UbXmUp/H6X8E3ls4KNZexyrSe6dVtK4xKVWIozEg21mIuK
	EwF0g2yhTgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated patchset, which intends to add support for L2 cache
on Exynos4 SoCs on boards running under secure firmware, which requires
certain initialization steps to be done with help of firmware, as
selected registers are writable only from secure mode.

First patch updates Omap2+ platforms by moving l2cache initialization to
common code. This will resolve too early call to l2cache init, what might
cause kmalloc failure in code added in next patches.

Next four patches extend existing support for secure write in L2C driver
to account for design of secure firmware running on Exynos. Namely:
 1) direct read access to certain registers is needed on Exynos, because
    secure firmware calls set several registers at once,
 2) not all boards are running secure firmware, so .write_sec callback
    needs to be installed in Exynos firmware ops initialization code,
 3) write access to {DATA,TAG}_LATENCY_CTRL registers fron non-secure world
    is not allowed and so must use l2c_write_sec as well,
 4) on certain boards, default value of prefetch register is incorrect
    and must be overridden at L2C initialization.
For boards running with firmware that provides access to individual
L2C registers this series should introduce no functional changes. However
since the driver is widely used on other platforms I'd like to kindly ask
any interested people for testing.

Further three patches add implementation of .write_sec and .configure
callbacks for Exynos secure firmware and necessary DT nodes to enable
L2 cache.

Changes in this version tested on Exynos4412-based TRATS2 and OdroidU3+
boards (both with secure firmware). There should be no functional change
for Exynos boards running without secure firmware. I do not have access
to affected non-Exynos boards, so I could not test on them.

Omap related changes were only compile time tested.

Depends on:
- v3.19-rc1

Changelog:

Changes since v9:
(https://lkml.org/lkml/2014/11/17/217)
- Rebased onto vanilla v3.19-rc1
- Added patch for Omap2+ (move l2cache initialization to common code), what
  fixes too early initialization (kmalloc failure)

Changes since v8:
(http://lkml.org/lkml/2014/11/13/263)
- Rebased onto vanilla v3.18-rc3 and added required includes, which were
  previously added by other patches
- Added Acked-by tags for Exynos part

Changes since v7:
(https://lkml.org/lkml/2014/10/29/158)
- rebased onto arm-soc/for-next kernel tree (depends on patches merged to
  v3.18-rc3 and arm-soc/samsung/pm2 branch)
- removed 'ARM: l2c: unify L2C-310 OF initialization error messages' patch
  (no longer needed)

Changes since v6:
(https://lkml.org/lkml/2014/10/27/233)
- changed PL310 to L2C-310 prefix in error messages
- added patch shortening the error message about incorrect associativity

Changes since v5:
(https://lkml.org/lkml/2014/9/24/364)
- rebased onto v3.18-rc2
- added error message about missing properties values

Changes since v4:
(https://lkml.org/lkml/2014/8/26/461)
 - rewrote the code accessing l2x0_saved_regs from assembly code
 - added comment and reworked unconditional call to SMC_CMD_L2X0INVALL


Patch summary:

Marek Szyprowski (1):
  ARM: OMAP2+: use common l2cache initialization code

Tomasz Figa (7):
  ARM: l2c: Refactor the driver to use commit-like interface
  ARM: l2c: Add interface to ask hypervisor to configure L2C
  ARM: l2c: Get outer cache .write_sec callback from mach_desc only if
    not NULL
  ARM: l2c: Add support for overriding prefetch settings
  ARM: EXYNOS: Add .write_sec outer cache callback for L2C-310
  ARM: EXYNOS: Add support for non-secure L2X0 resume
  ARM: dts: exynos4: Add nodes for L2 cache controller

 Documentation/devicetree/bindings/arm/l2cc.txt |  10 +
 arch/arm/boot/dts/exynos4210.dtsi              |   9 +
 arch/arm/boot/dts/exynos4x12.dtsi              |  14 ++
 arch/arm/include/asm/outercache.h              |   3 +
 arch/arm/kernel/irq.c                          |   3 +-
 arch/arm/mach-exynos/firmware.c                |  50 +++++
 arch/arm/mach-exynos/sleep.S                   |  46 +++++
 arch/arm/mach-omap2/board-generic.c            |   6 +
 arch/arm/mach-omap2/common.h                   |   7 +
 arch/arm/mach-omap2/omap4-common.c             |  16 +-
 arch/arm/mm/cache-l2x0.c                       | 270 ++++++++++++++++---------
 11 files changed, 323 insertions(+), 111 deletions(-)

-- 
1.9.2

