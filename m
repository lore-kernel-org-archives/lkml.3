Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab3GRQYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:24:38 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38263 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab3GRQYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:24:35 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:2933:532:a877:8867]
In-Reply-To: <002801ce797b$3d2fbc80$b78f3580$@samsung.com>
References: <002801ce797b$3d2fbc80$b78f3580$@samsung.com>
Date: Thu, 18 Jul 2013 18:24:34 +0200
Message-ID: <CAG8rG2y8ZN4ahv7DqJ11=FhJpVVxcbAbTaViyi-D4GH=p3xg=A@mail.gmail.com>
Subject: Re: [PATCH v7 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Daniel Raho <s.raho@virtualopensystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cho,

I have been trying out the Exynos System MMU driver including your
fixes, however I notice that if you try to get the iommu_group of a
device (i.e. iommu_group_get(&pdev->dev)) this will not work. Since
each device is behind its own System MMU I would expect a distinct
iommu_group for that device, instead I get NULL (I tried this with the
MFC).

Indeed, it looks like this is not currently implemented in the driver.
Is this something that is on the roadmap?

Best regards,
Antonios Motakis

On Fri, Jul 5, 2013 at 2:29 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> The current exynos-iommu(System MMU) driver does not work autonomously
> since it is lack of support for power management of peripheral blocks.
> For example, MFC device driver must ensure that its System MMU is disabled
> before MFC block is power-down not to invalidate IOTLB in the System MMU
> when I/O memory mapping is changed. Because A System MMU is resides in the
> same H/W block, access to control registers of System MMU while the H/W
> block is turned off must be prohibited.
>
> This set of changes solves the above problem with setting each System MMUs
> as the parent of the device which owns the System MMU to recieve the
> information when the device is turned off or turned on.
>
> Another big change to the driver is the support for devicetree.
> The bindings for System MMU is described in
> Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
>
> In addition, this patchset also includes several bug fixes and enhancements
> of the current driver.
>
> Change log:
> v7:
> - Rebased on the stable 3.10
> - Registered PM domains and gate clocks with DT
> - Changed connection method between a System MMU and its master H/W
>    'mmu-master' property in the node of System MMU
>    --> 'iommu' property in the node of master H/W
> - Marking device descriptor of master H/W of a System MMU with bus notifier.
> - Power management (PM_RUNTIME, PM_SLEEP) of System MMUs with gpd_dev_ops
>    of Generic IO Powerdomain. gpd_dev_ops are set to the master H/Ws
>    before they are probed in the bus notifier.
> - Removed additional debugging features like debugfs entries and
>    version names.
> - Removed support for advanced features of System MMU 3.2 and 3.3
>    the current IOMMU API cannot handle the feature
>   (A kind of L2 TLB that fetches several consequence page table entries.
>    It must be initialized by the driver of master H/W whenever it works.)
>
> v6:
> - Rebased on the branch, next/iommu-exynos of
>   git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
>
> v5:
> - new bugfix: patch 01
> - Reordered patches
>   * patch 01 ~ 05: Bugfix and enhancements of the existing driver
>   * patch 06 ~ 10: Device Tree support and callbacks for power management
>   * patch 11     : System MMU 3.2 and 3.3 support
>   * patch 12 ~ 14: Debugging features
> - Additional code compaction
>
> v4:
> - Remove Change-Id from v3 patches
> - Change the order of the third and the first patch
>   Thanks to Kukjin Kim.
> - Fix memory leak when allocating and assigning exynos_iommu_owner to client
>   device if the client device has multiple System MMUs.
>   Thanks to Rahul Sharma.
>
> v3:
> - Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
> - Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
>   Thanks to Prathyush.
>
> v2:
> - Split the patch to iommu/exynos into 9 patches
> - Support for System MMU 3.3
> - Some code compaction
>
> Patch summary:
> [PATCH v7 1/9] iommu/exynos: do not include removed header
> [PATCH v7 2/9] iommu/exynos: add missing cache flush for removed page table entries
> [PATCH v7 3/9] iommu/exynos: fix page table maintenance
> [PATCH v7 4/9] iommu/exynos: allocate lv2 page table from own slab
> [PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
> [PATCH v7 6/9] clk: exynos5250: add gate clock descriptions of System MMU
> [PATCH v7 7/9] ARM: dts: Add description of System MMU of Exynos SoCs
> [PATCH v7 8/9] iommu/exynos: support for device tree
> [PATCH v7 9/9] iommu/exynos: add bus notifier for registering System MMU
>
> Diffstats:
> .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +-
> .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 ++
> arch/arm/boot/dts/exynos4.dtsi                     |  122 +++
> arch/arm/boot/dts/exynos4210.dtsi                  |   25 +
> arch/arm/boot/dts/exynos4x12.dtsi                  |   76 ++
> arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++
> drivers/clk/samsung/clk-exynos5250.c               |   57 +-
> drivers/iommu/Kconfig                              |    5 +-
> drivers/iommu/exynos-iommu.c                       | 1011 +++++++++++++-------
> 9 files changed, 1382 insertions(+), 336 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
