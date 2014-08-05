Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaHEKs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:48:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18304 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaHEKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-96-53e0b690c57f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 00/29] Exynos SYSMMU (IOMMU) integration with DT and
 DMA-mapping subsystem
Date: Tue, 05 Aug 2014 12:47:28 +0200
Message-id: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xq7oTtj0INri828Ti76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlfHsiGrB9NqKX8/PsjUw/kvqYuTkkBAwkTi8
	t5EZwhaTuHBvPRuILSSwlFFi2lyWLkYuILuPSaL1WxcTSIJNwFCi620XG0hCRKCXUaK/6QcT
	iMMssI5VYn/vdRaQKmGBGIkZd7eDjWIRUJVYdGISYxcjBwevgIdE84YKiG1yEv9frmCawMi9
	gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIFHzZwbj4mNUhRgEORiUeXoPTd4OFWBPL
	iitzDzFKcDArifBKrHkQLMSbklhZlVqUH19UmpNafIiRiYNTqoExU+QB5zwfhxWmWSfYir5P
	fSV24oKe1oLWS4d3yHQ8ESm5q1q1wtuiJGe23veap0w3YzrSnv6+58i1QlHqEeOf5By7GYkL
	Y7RX8u87l3PZJ0p4SXZPYUNCa8VzVs7qs5dspkTMvOyefqO/S3afz8sX/w/MMC1hWZcRHuOT
	vDLkavvtnbbOs28rsRRnJBpqMRcVJwIAM5N6h2ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everyone,

A lot of things has happened in the area of improving Exynos IOMMU
driver and discussion about generic IOMMU bindings, which finally
motivated me to get back to IOMMU related tasks. Just to remind, here
are those 2 important threads:

1. [PATCH v13 00/19] iommu/exynos: Fixes and Enhancements of System MMU
driver with DT: https://lkml.org/lkml/2014/5/12/34

2. [PATCH v4] devicetree: Add generic IOMMU device tree bindings:
https://lkml.org/lkml/2014/7/4/349

As a follow up of those discussions I've decided to finish our internal
code, which adapts Exynos SYSMMU driver to meet generic IOMMU bindings
requirements and implement all needed glue code to finally demonstare
seemless integration IOMMU controller with DMA-mapping subsystem for
the drivers available on Exynos SoCs.


1. Introduction - a few words for those who are not fully aware of the
Exynos SoC hardware

Exynos SoC consists of various devices integrated directly into SoCs.
Most of them are multimedia devices, which usually process large
buffers. Some of them (like i.e. MFC - a multimedia codec or FIMD - a
multi-window framebuffer device & lcd panel controller) are equipped
with more than one memory interface for higher processing performance.
There are also really complex subsystems (like ISP, the camera sensor
interface & processor), which consist of many sub-blocks, each having
its own memory interface/channel/bus (different names are used for the
same thing).

Each such memory controller might be equipped with SYSMMU device, which
acts as IOMMU controller for the parent device (called master device, a
device which that memory interface belongs to). Each SYSMMU controller
has its own register set and clock, belongs to the same power domain as
master device. There is also some non-direct relation from master's
device gate clock - SYSMMU registers can be accessed only when master's
gate clock is enabled.

Basically we have following dependencies between hardware and drivers:
- each multimedia device might have 1 or more SYSMMU controller
- each SYSMMU controller belongs only to 1 master device
- all SYSMMU controllers are independent of each other, there is no
  global hardware ID that must be assigned to enable given SYSMMU
  controller
- multimedia devices are modeled usually by a separate node in device
  tree with it's own compatible string and separate driver for them
- sub-blocks of complex devices right now are not modeled by a separate
  device tree nodes, but this might be changed in the future
- some multimedia devices have limited address space per each memory
  controller/channel (i.e. codec might access buffers only in a 256MiB
  window for each of it's memory channels)
- some drivers for independent device are used together to provide a
  more complex subsystem, i.e. FIMD, HDMI-mixer and others form together
  Exynos DRM subsystem; it is highly welcome to let them to operate in
  the same, shared DMA address space to simplify buffer sharing


2. Introduction part 2 - a few word of summary of the discussions about
generic IOMMU DT bindings

There have been a lot of discussions on the method of modeling IOMMU
controllers in device tree. The approach which has been selected as the
generic IOMMU binding candidate has been described in the '[PATCH v4]
devicetree: Add generic IOMMU device tree bindings' thread.

Those bindings describe how to link an IOMMU controller with its master
device. Basically an 'iommus' property placed in the master's device
node has been introduced. This property contains phandle to IOMMU
controller node. Optional properties of the particular binding can also
be specified after the phandle, assuming that IOMMU controller node
contains '#iommu-cells' property, which defines number of cells used for
those parameters. Those parameters are then interpreted by particular
IOMMU controller driver. Those parameters might be some hw channel id
required for correct hardware setup, base address and size pair for
limited IO address space window or others hardware dependant properties.


3. IOMMU integration to DMA-mapping subsystem

By default we assume that each master device, which has been equipped
with IOMMU controller gets its own DMA (IO) address space. This is
created automatically and transparently without any changes in the
device driver code. All DMA-mapping functions are replaced with the
IOMMU aware versions. This has to be done somewhere by the architecture
or SoC startup code, so when master's driver probe() function is called,
everything is in place.

However some device drivers might need (for various reasons) to manually
manage DMA (IO) address space. For this case a driver need to notify
kernel about that and do the management of DMA address space on its own.
This has been achieved by introducing DRIVER_HAS_OWN_IOMMU_MANAGER flag,
which can be set in struct device_driver. This way the startup code can
easily determine if creating the default per-device separate DMA
address space is required for a given driver or not without any unneeded
alloc/free call sequences.


4. Linux DMA-mapping subsystem and more than one DMA address space

DMA-mapping subsystem assumes that there is only one DMA (IO) address
space associated with the given struct device entity. Usually struct
device is mapped in one-to-one relation to a node describing given
device in device tree. To let driver to access other DMA (IO) address
spaces a sub-device has been introduced. This approach has been already
used by s5p-mfc driver (drivers/media/platform/s5p-mfc/s5p_mfc.c). The
only question is how and when sub-devices are created.

In the proposed approach, such additional address spaces are named with
the names of the respective IOMMU controllers (iommu-names property in
master's DT node). To let driver to access an address space, a
sub-device named 'parent_device_name:address_space_name' need to be
created and added as a child to master's struct device. A good example
is codec device, which on Exynos4412 SoC is instantiated as
'13400000.codec' device. It has 2 memory interfaces ('left' and
'right'), so the sub-devices called '13400000.codec:left' and
'13400000.codec:right' must be created by a driver and added as children
of '13400000.codec' device. Once then the driver is allowed to allocate
2 separate dma-mapping address spaces by calling
arm_iommu_create_mapping() and arm_iommu_detach_device() functions or
newly introduced helper arm_iommu_create_default_mapping(). For more
details, please refer to the last patch in this series.

Exactly the same approach is planned to be done for memory regions and
DMA-mapping implemented on top of CMA or DMA-coherent memory allocators.

When driver doesn't specify that it wants to manage its DMA (IO) address
spaces, a default DMA (IO) address space will be created and all SYSMMU
controllers will be bound to it, so this space will be shared across
master's device IO channels / memory interfaces. This way IOMMU support
might be added only to drivers which really benefit from having
separate IO address space per memory interface without a need to alter
the other drivers.

Why driver might need to manage the IO address space on its own? Once
again the codec device on Exynos4 series is a good example. Memory
interfaces found in the mentioned codec device are limited and can
address only 256MiB window. If we bind both interfaces to common address
space, driver is able only to access memory buffers, which fits into
256MiB window. If we use separate spaces for each memory interface,
codec device will be able to access buffers of total 2*256MiB=512MiB,
which is a significant advantage over the default case of shared address
space.


5. Power management (runtime)

Runtime power management is the most tricky part of the proposed
solution. I assumed that it is a sane requirement that from the
master's device driver the operation without IOMMU and with IOMMU (with
default, per-device mapping) should be exactly the same. The runtime
power management, which is now mainly limited to enabling and disabling
hardware power domains is done by the master's device driver. However
from the hardware perspective, there is also a need to save SYSMMU
context before switch pm domain off and restore it after switching pm
domain on.

To achieve this way of SYSMMU operation, a notifiers for power domains
have been introduces. With such an approach no changes are needed in
master's device driver and SYSMMU driver seamlessly integrates with
master's device runtime pm operations.


6. Proposed patches and changes

Patch 0001 "pm: Add PM domain notifications" adds support for power
domain notifiers (see chapter 5 above).

Patch 0002 "ARM: Exynos: bind power domains earlier, on device creation"
changes the time, when Exynos power domains are bound to the device. Now
this happens on DEVICE_ADD event instead of DRIVER_BIND, so when SYSMMU
driver is being initialized, the power domains are already bound and
notifiers can be added.

Patch 0003 "clk: exynos: add missing smmu_g2d clock and update comments"
simply simply adds missing sysmmu related entities to Exynos clock
driver.

Patch 0004 "drivers: base: add notifier for failed driver bind" add
event for failed driver bind, so things prepared in DRIVER_BIND event
can be cleaned up, similar to DRIVER_UNBOUND.

Patch 0005 "drivers: convert suppress_bind_attrs parameter into flags"
is preparation for adding new flags to struct device_driver.

Patch 0006 "drivers: iommu: add notify about failed bind" adds support
for recently introduced failed driver bind event to IOMMU subsystem.

Patch 0007 "ARM: dma-mapping: arm_iommu_attach_device: automatically set
max_seg_size" moves common operation of setting dma max_seg_size
directly to arm_iommu_attach_device function.

Patch 0008 "ARM: dma-mapping: add helpers for managing default
per-device dma mappings" adds convenient helpers for the most common
case of setting up per-device, separate DMA (IO) address space.

Patch 0009 "ARM: dma-mapping: provide stubs if no ARM_DMA_USE_IOMMU has
been selected" fixes usage of IOMMU related ARM DMA-mapping functions in
common code.

Patch 0010 "drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag" adds a flag
described in chapter 3.

Patch 0011 "DRM: exynos: add DRIVER_HAS_OWN_IOMMU_MANAGER flag to all
sub-drivers" marks all Exynos DRM sub-drivers with a flag notifying that
they perform own management of DMA (IO) address space. All the code to
setup dma-mapping and attach all devices is realy there.

Patch 0012 "DRM: Exynos: fix window clear code" is a simple bugfix of
broken init code, which triggers issues when used with IOMMU (page fault
happens on systems, where bootloader has left framebuffer enabled).

Patch 0013 "temporary: media: s5p-mfc: remove DT hacks & initialization
custom memory init code" removes all custom memory region handling, to
let later demonstrate how to use separate DMA (IO) address spaces from
master's device driver.

Patch 0014 "devicetree: Update Exynos SYSMMU device tree bindings" adds
a few words about proposed solution to SYSMMU device tree bindings
documentation.

Patch 0015 "ARM: DTS: Exynos4: add System MMU nodes" adds device tree
nodes for all SYSMMU controllers found in Exynos 4210 and 4x12 SoC and
respective properties to their master devices.

Patch 0016-0021 are simple bugfixes and code refactoring to simplify
the driver: 
	"iommu: exynos: make driver multiarch friendly",
	"iommu: exynos: don't read version register on every tlb",
	"iommu: exynos: remove unused functions",
	"iommu: exynos: remove useless spinlock",
	"iommu: exynos: refactor function parameters to simplify code",
	"iommu: exynos: remove unused functions, part 2".

Patch 0022 "iommu: exynos: add support for binding more than one sysmmu
to master device" adds support for storing a list of SYSMMU controllers
in the master's iommu arch data structure.

Patch 0023 "iommu: exynos: init iommu controllers from device tree"
finally implements bindings described in patch 0015 and access to
particular DMA address space managed by SYSMMU controller via sub-device
of predefined name (see chapter 4).

Patch 0024 "iommu: exynos: create default iommu-based dma-mapping for
master devices" does what patch title says.

Patch 0025 "iommu: exynos: add support for runtime_pm" implements power
management scheme described in chapter 5.

Patch 0026-0028 are cleanup and refactoring to make the code easier to
understand:
	"iommu: exynos: rename variables to reflect their purpose",
	"iommu: exynos: document internal structures",
	"iommu: exynos: remove excessive includes and sort others
	 alphabetically".

Patch 0029 "temporary: media: s5p-mfc: add support for IOMMU"
demonstrates how to use sub-devices to get access to separate DMA (IO)
address spaces. The driver is able to work both with and without this
patch. Without this patch a common shared address space is created for
both SYSMMU controllers (so only 256MiB of total address space is
available, see end of chapter 4).


7. Summary

All the development of those patches have been done on Exynos4412-based
OdroidU3 board and Exynos4210-based UniversalC210, on top of v3.16
kernel with some additional patches to enable HDMI support on Odroid
board. This version is available in the following GIT repository:
http://git.linaro.org/git/people/marek.szyprowski/linux-dma-mapping.git
on branch v3.16-odroid-iommu.

However, the version posted here has been rebased on top of linux-next
kernel (next-20140804 tag), to make marging the easier once v3.17-rc1 is
out.


8. Diffstat

 .../devicetree/bindings/iommu/samsung,sysmmu.txt   |  93 ++-
 Documentation/power/notifiers.txt                  |  14 +
 arch/arm/boot/dts/exynos4.dtsi                     | 118 ++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  23 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |  82 +++
 arch/arm/include/asm/dma-iommu.h                   |  36 ++
 arch/arm/mach-exynos/pm_domains.c                  |  12 +-
 arch/arm/mach-integrator/impd1.c                   |   2 +-
 arch/arm/mm/dma-mapping.c                          |  47 ++
 drivers/base/bus.c                                 |   4 +-
 drivers/base/dd.c                                  |  10 +-
 drivers/base/platform.c                            |   2 +-
 drivers/base/power/domain.c                        |  70 ++-
 drivers/clk/samsung/clk-exynos4.c                  |   1 +
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |   1 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  26 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   1 +
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   1 +
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |   1 +
 drivers/gpu/drm/exynos/exynos_mixer.c              |   1 +
 drivers/iommu/exynos-iommu.c                       | 663 +++++++++++++--------
 drivers/iommu/iommu.c                              |   3 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 107 ++--
 drivers/pci/host/pci-mvebu.c                       |   2 +-
 drivers/pci/host/pci-rcar-gen2.c                   |   2 +-
 drivers/pci/host/pci-tegra.c                       |   2 +-
 drivers/pci/host/pcie-rcar.c                       |   2 +-
 drivers/soc/tegra/pmc.c                            |   2 +-
 include/dt-bindings/clock/exynos4.h                |  10 +-
 include/linux/device.h                             |  12 +-
 include/linux/iommu.h                              |   1 +
 include/linux/pm.h                                 |   2 +
 include/linux/pm_domain.h                          |  19 +
 33 files changed, 1016 insertions(+), 356 deletions(-)


Best regards
Marek Szyprowski
Samsung R&D Institute Poland

