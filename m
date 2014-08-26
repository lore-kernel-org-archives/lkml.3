Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbaHZMNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:13:55 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33892 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaHZMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:53 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-fc-53fc79fe0ad5
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 0/7] CMA & device tree, another approach
Date: Tue, 26 Aug 2014 14:09:41 +0200
Message-id: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xa7r/Kv8EG5x/yWTxd9IxdosDf3Yw
	Wqzsbmaz2LnuHaPF2aY37BbbO2ewW3y58pDJYtPja6wWl3fNYbPo2bCV1WLG+X1MFmuP3GW3
	WHC8hdVi/YzXLA58Hr9/TWL0uNzXy+TR9fYKk8eda3vYPDYvqfe4/e8xs8e6P6+YPPq2rGL0
	+LxJLoAzissmJTUnsyy1SN8ugSvjRf9l5oJzchWPLr5mbGBcI97FyMkhIWAi8e7CA3YIW0zi
	wr31bF2MXBxCAksZJb7NOMkK4fQxSfxZe58JpIpNwFCi620XG4gtIpAt8ePbZBYQm1lgKbPE
	vFlSILawgIXEkq2PWEFsFgFVian7HoNt4BXwkPj/ZBoTxDY5if8vVzBNYORewMiwilE0tTS5
	oDgpPddIrzgxt7g0L10vOT93EyMkJL/uYFx6zOoQowAHoxIP74O038FCrIllxZW5hxglOJiV
	RHh/JP0JFuJNSaysSi3Kjy8qzUktPsTIxMEp1cCYdnXOZNFbvqqP/1teSXz/MnSfRKXn0oVy
	O+wLrD++evVr4aXKVbl826xbp4ttrJ4Q1HSb/1fAjWr/0ORUlTzjeheZ57GMeubf713t2V44
	fYHiCYtZM54o1qmfXrzi8b4pG3yMEif8MN7S8VPuQuvcT7FaXJ8evzhaXqAqMvm/7fE2xQ8b
	nIKVlFiKMxINtZiLihMBPtBI1icCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is another approach to finish support for reserved memory regions
defined in device tree. Previous attempts 
(http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html
and https://lkml.org/lkml/2014/7/14/108) ended in merging parts of the
code and documentation. Merged patches allow to reserve memory, but
there is still no reserved memory drivers nor any code that actually
uses reserved memory regions.

The final conclusion from the above mentioned threads is that there is
no automated reserved memory initialization. All drivers that want to
use reserved memory, should initialize it on their own.

This patch series provides two driver for reserved memory regions (one
based on CMA and one based on dma_coherent allocator). The main
improvement comparing to the previous version is removal of automated
reserved memory for every device and support for named memory regions.

Support for more than one reserved memory region can be considered as a
separate DMA address space, so support for more than one region per
device has been implemented the same way as support for separate IO/DMA
address spaces in my Exynos IOMMU dma-mapping proposal:
http://thread.gmane.org/gmane.linux.kernel.samsung-soc/36079

Best regards
Marek Szyprowski
Samsung R&D Institute Poland

Changes since '[PATCH v2 RESEND 0/4] CMA & device tree, once again' version:
(https://lkml.org/lkml/2014/7/14/108)
- added return error value to of_reserved_mem_device_init()
- added support for named memory regions (so more than one region can be
  defined per device)
- added usage example - converted custom reserved memory code used by
  s5p-mfc driver to the generic reserved memory handling code

Patch summary:

Marek Szyprowski (7):
  drivers: of: add return value to of_reserved_mem_device_init
  drivers: of: add support for named memory regions
  drivers: dma-coherent: add initialization from device tree
  drivers: dma-contiguous: add initialization from device tree
  media: s5p-mfc: replace custom reserved memory init code with generic
    one
  ARM: Exynos: convert MFC to generic reserved memory bindings
  ARM: DTS: exynos4412-odroid*: enable MFC device

 .../devicetree/bindings/media/s5p-mfc.txt          |  16 +--
 .../bindings/reserved-memory/reserved-memory.txt   |   6 +-
 arch/arm/boot/dts/exynos4210-origen.dts            |  22 +++-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |  22 +++-
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |  24 ++++
 arch/arm/boot/dts/exynos4412-origen.dts            |  22 +++-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |  22 +++-
 arch/arm/boot/dts/exynos5250-arndale.dts           |  22 +++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  22 +++-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  22 +++-
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |  22 +++-
 arch/arm/mach-exynos/exynos.c                      |  18 ---
 arch/arm/mach-exynos/mfc.h                         |  16 ---
 arch/arm/plat-samsung/Kconfig                      |   5 -
 arch/arm/plat-samsung/Makefile                     |   1 -
 arch/arm/plat-samsung/s5p-dev-mfc.c                |  94 --------------
 drivers/base/dma-coherent.c                        | 138 ++++++++++++++++++---
 drivers/base/dma-contiguous.c                      |  71 +++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 102 ++++++---------
 drivers/of/of_reserved_mem.c                       | 102 ++++++++++-----
 include/linux/cma.h                                |   3 +
 include/linux/of_reserved_mem.h                    |   9 +-
 mm/cma.c                                           |  62 +++++++--
 23 files changed, 552 insertions(+), 291 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/mfc.h
 delete mode 100644 arch/arm/plat-samsung/s5p-dev-mfc.c

-- 
1.9.2

