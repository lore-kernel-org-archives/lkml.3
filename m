Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162808Ab3DEUY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:24:26 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40583 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162674Ab3DEUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:24:19 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 0/9] rm: mvebu: Enable LPAE support for Armada XP SoCs
Date: Fri,  5 Apr 2013 22:23:55 +0200
Message-Id: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The Armada XP SoCs have LPAE support. This is the second version patch
set whixh allow to run kernel on this SoCs with LPAE support.

The biggest changes are the conversion of the device tree file to 64
bits in order to be able to use more than 4GB of memory (without this
the LPAE is pointless).

The main change since the first version is the usage of the range
property as suggested by Rob Herring. As this massive change on the
dts file will have an impact on the mvebu-mbus driver binding, I also
added some patches from Thomas Petazzoni. The purpose is to avoid a
new big change in the devices tree files when Thomas will improve the
mvebu-mbus driver to rely on the device tree.

The other point is about DMA usage. LPAE allows to use 40bits address
only between CPU and DRAM. All the DMA transfer are restricted to the
low 32 bits address space. The first version try to use DMABOUNCE to
allows DMA transfer from any place in memory. There were a consensus
on the fact that was a something to avoid. The alternative was
swiotlb, however it will require a large rewrite of
arch/arm/mach-mvebu/coherency.c (our dma_map_ops was defined here),
and we are close the opening of the merge window. So I chose, in a
first phase, to use ZONE_DMA to limit the use of the DMA on the 32
bits address space. Later our dma_map_ops would be improve with
swiotlb.

This new patch set have been tested on a Armada XP GP board with 8GB
of DRAM with LPAE selected. It have been tested on Armada XP DB board
with 3GB of DRAM with and without LPAE. And also on the Armada 370 DB
board (without LPAE) to check that no regression appeared.

This patch set is based on 3.9-rc5 and is still 3.10 material. The git
branch called lpae-v2 is available at:

https://github.com/MISL-EBU-System-SW/mainline-public.git.

Thanks,

Changelog:
v1 -> v2:

* The patch to convert the mvebu device tree files to 64 bits was
  split in 3 parts:

    - "arm: dts: move all peripherals inside soc" from Thomas

	- then "arm: dts: Convert all the mvebu files to use the range
    property" which will allow to keep 32 bits addresses for the
    internal registers whereas the memory of the system will be 64
    bits

	- and finally "arm: dts: Convert mvebu device tree files to 64
      bits" which was the move to 64 bits itself.

* A new patch was added "arm: dts: introduce internal-regs node" based
  on the work of Thomas for the mvebu-mbus driver. It introduce a
  'internal-regs' subnode, under which all devices are moved. This is
  not really needed for now, but will be for the mvebu-mbus
  driver. This generates a lot of code movement since it's indenting
  by one more tab all the devices. So it was a good opportunity to fix
  all the bad indentation.

* New patch from Thomas "fix cpus section indentation" to finalize the
  fixing of the bad indentation

* For DMA transfer, DMA_ZONE was selected instead of DMABOUNCE: all
  the DMA transfer are restricted to the low 32 bits address space.


Gregory CLEMENT (4):
  arm: mvebu: Limit the DMA zone when LPAE is selected
  arm: dts: mvebu: Convert all the mvebu files to use the range
    property
  arm: dts: mvebu: introduce internal-regs node
  arm: dts: mvebu: Convert mvebu device tree files to 64 bits

Lior Amsalem (3):
  arm: mvebu: Align the internal registers virtual base to support LPAE
  arm: mvebu: Enable pj4b on LPAE compilations
  arm: dts: Add a 64 bits version of the skeleton device tree

Thomas Petazzoni (2):
  arm: dts: mvebu: move all peripherals inside soc
  arm: dts: mvebu: fix cpus section indentation

 arch/arm/boot/dts/armada-370-db.dts              |  110 +++++-----
 arch/arm/boot/dts/armada-370-mirabox.dts         |   80 +++----
 arch/arm/boot/dts/armada-370-rd.dts              |   18 +-
 arch/arm/boot/dts/armada-370-xp.dtsi             |  253 +++++++++++-----------
 arch/arm/boot/dts/armada-370.dtsi                |  211 +++++++++---------
 arch/arm/boot/dts/armada-xp-db.dts               |  156 ++++++-------
 arch/arm/boot/dts/armada-xp-gp.dts               |  138 ++++++------
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         |   84 +++----
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         |  110 +++++-----
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         |  136 ++++++------
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  198 ++++++++---------
 arch/arm/boot/dts/armada-xp.dtsi                 |  191 ++++++++--------
 arch/arm/boot/dts/skeleton64.dtsi                |   13 ++
 arch/arm/include/debug/mvebu.S                   |    2 +-
 arch/arm/mach-mvebu/Kconfig                      |    1 +
 arch/arm/mach-mvebu/armada-370-xp.h              |    2 +-
 arch/arm/mm/proc-v7.S                            |    3 +-
 17 files changed, 873 insertions(+), 833 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton64.dtsi

-- 
1.7.9.5

