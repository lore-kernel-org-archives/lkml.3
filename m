Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaGKVFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:05:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:38263 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaGKVFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:05:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,645,1400050800"; 
   d="scan'208";a="456056337"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next v3 0/8] Enable dma driver for MIC X100 Coprocessors
Date: Fri, 11 Jul 2014 14:04:18 -0700
Message-Id: <cover.1405109401.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog:
=========
v2 => v3:
a) MIC bus device private pointer cleanup as per feedback from
   Greg Kroah-Hartman.
b) Fixed minor Makefile conflict after rebasing to v3.16-rc2

v1 => v2: https://lkml.org/lkml/2014/5/29/981
a) MIC bus driver cleanups and device release callback fix in patch 2,
   as per feedback from Greg Kroah-Hartman.

v1: Initial post @ https://lkml.org/lkml/2014/5/27/819

These patches are being sent to char-misc because there is a dependency
between the patches for dma driver and other drivers.

Description:
============
This set of patches add support for MIC X100 dma driver.
MIC PCIe card has a dma controller with 8 channels. These channels are
shared between the host s/w and the card s/w. 0 to 3 are used by host
nd 4 to 7 by card. As the dma device doesn't show up as PCIe device,
a virtual bus called mic bus is created and virtual dma devices are
created on it by the host/card drivers. On host the channels are private
and used only by the host driver to transfer data for the virtio devices.

Here is a higher level block diagram.
                                      |
               +----------+           |             +----------+
               | Card OS  |           |             | Host OS  |
               +----------+           |             +----------+
                                      |
        +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
        | Virtio| |Virtio  | |Virtio| | |Virtio   |  |Virtio  | |Virtio  |
        | Net   | |Console | |Block | | |Net      |  |Console | |Block   |
        | Driver| |Driver  | |Driver| | |backend  |  |backend | |backend |
        +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
            |         |         |     |      |            |         |
            |         |         |     |User  |            |         |
            |         |         |     |------|------------|---------|-------
            +-------------------+     |Kernel +--------------------------+
                      |               |       | Virtio over PCIe IOCTLs  |
                      |               |       +--------------------------+
+-----------+         |               |                   |  +-----------+
| MIC DMA   |         |               |                   |  | MIC DMA   |
| Driver    |         |               |                   |  | Driver    |
+-----------+         |               |                   |  +-----------+
      |               |               |                   |        |
+---------------+     |               |                   |  +----------------+
|MIC virtual Bus|     |               |                   |  |MIC virtual Bus |
+---------------+     |               |                   |  +----------------+
      |               |               |                   |              |
      |   +--------------+            |            +---------------+     |
      |   |Intel MIC     |            |            |Intel MIC      |     |
      +---|Card Driver   |            |            |Host Driver    |     |
          +--------------+            |            +---------------+-----+
                      |               |                   |
             +-------------------------------------------------------------+
             |                                                             |
             |                    PCIe Bus                                 |
             +-------------------------------------------------------------+

The following series of patches are partitioned as follows:

Patch 1: Add mic bus and dma driver documentation.
Patch 2: Add a bus driver for virtual MIC devices.
Patch 3: MIC X100 DMA Driver.
Patch 4: Add threaded irq support in host driver.
	 This is needed as the dma driver uses threaded irq.
Patch 5: Use dma to transfer data between MIC and host.
	 Authors: Siva Yerramreddy, Ashutosh Dixit
Patch 6: Add threaded irq support in mic_request_card_irq.
	 This is needed as the dma driver uses threaded irq.
Patch 7: Add dma device on mic bus.
Patch 8: Modify the mpss script to load/unload mic_x100_dma.ko.

The patches have been compiled/validated against v3.16-rc2. Tested using
dmatest module with module parameter "threads_per_chan=60". These patches
have also been scanned by Fengguang Wu's 0-day infrastructure and no
issues have been reported.

Thanks to Dan Williams, Vinod Koul, Jon Mason, Dave Jiang for the initial
review.

Siva Yerramreddy (7):
  misc: mic: Add mic bus and dma driver documentation
  dma: MIC X100 DMA Driver
  misc: mic: add threaded irq support in host driver
  misc: mic: add dma support in host driver
  misc: mic: add threaded irq support in card driver
  misc: mic: add dma support in card driver
  misc: mic: add support for loading/unloading dma driver

Sudeep Dutt (1):
  misc: mic: add a bus driver for virtual MIC devices

 Documentation/mic/mic_overview.txt |  67 ++--
 Documentation/mic/mpssd/mpss       |  14 +-
 drivers/dma/Kconfig                |  19 +
 drivers/dma/Makefile               |   1 +
 drivers/dma/mic_x100_dma.c         | 774 +++++++++++++++++++++++++++++++++++++
 drivers/dma/mic_x100_dma.h         | 286 ++++++++++++++
 drivers/misc/mic/Kconfig           |  21 +-
 drivers/misc/mic/Makefile          |   1 +
 drivers/misc/mic/bus/Makefile      |   5 +
 drivers/misc/mic/bus/mic_bus.c     | 218 +++++++++++
 drivers/misc/mic/card/mic_device.c |  23 +-
 drivers/misc/mic/card/mic_device.h |   9 +-
 drivers/misc/mic/card/mic_virtio.c |   7 +-
 drivers/misc/mic/card/mic_x100.c   |  55 ++-
 drivers/misc/mic/host/mic_boot.c   |  83 +++-
 drivers/misc/mic/host/mic_device.h |  24 ++
 drivers/misc/mic/host/mic_intr.c   | 121 +++---
 drivers/misc/mic/host/mic_intr.h   |  27 +-
 drivers/misc/mic/host/mic_main.c   |   5 +-
 drivers/misc/mic/host/mic_virtio.c | 187 +++++++--
 drivers/misc/mic/host/mic_virtio.h |  21 +-
 drivers/misc/mic/host/mic_x100.c   |   8 +
 include/linux/mic_bus.h            | 110 ++++++
 23 files changed, 1935 insertions(+), 151 deletions(-)
 create mode 100644 drivers/dma/mic_x100_dma.c
 create mode 100644 drivers/dma/mic_x100_dma.h
 create mode 100644 drivers/misc/mic/bus/Makefile
 create mode 100644 drivers/misc/mic/bus/mic_bus.c
 create mode 100644 include/linux/mic_bus.h

-- 
1.8.2.1

