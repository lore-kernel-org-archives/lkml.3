Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaDNUPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:15:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:38444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaDNUPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:15:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,859,1389772800"; 
   d="scan'208";a="520341945"
From: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH 0/8] Enable dma driver for MIC X100 Coprocessors.
Date: Mon, 14 Apr 2014 13:14:57 -0700
Message-Id: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sending all these patches to char-misc because there is a dependency
between the patches for dma driver and other drivers.

Description:
============
This set of patches add support for MIC X100 dma driver.
MIC PCIe card has a dma controller with 8 channels. These channels are
shared between the host s/w and the card s/w. 0 to 3 are used by host
and 4 to 7 by card. As the dma device doesn't show up as PCIe device,
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
+-----------+	      |               |	    		  |  +-----------+
| MIC DMA   |	      |               | 		  |  | MIC DMA	 |
| Driver    |         |               |	  		  |  | Driver	 |
+-----------+         |               |			  |  +-----------+
      |		      |	   	      |			  |	   |
+---------------+     |		      |			  |  +----------------+
|MIC virtual Bus|     |	 	      |			  |  |MIC virtual Bus |
+---------------+     |		      |			  |  +----------------+
      |               |               |                   |		 |
      |   +--------------+	      |            +---------------+     |
      |   |Intel MIC     |	      |            |Intel MIC      |     |
      +---|Card Driver   |            |            |Host Driver    |     |
	  +--------------+            |            +---------------+-----+
		      |               |                   |
	     +-------------------------------------------------------------+
	     |                                                             |
	     |                    PCIe Bus                                 |
	     +-------------------------------------------------------------+

The following series of patches are partitioned as follows:

Patch 1: Add mic bus and dma driver documentation.
	 Author: Siva Yerramreddy
Patch 2: Add a bus driver for virtual MIC devices.
	 Authors: Siva Yerramreddy, Sudeep Dutt
Patch 3: MIC X100 DMA Driver.
	 Author: Siva Yerramreddy
Patch 4: Add threaded irq support in host driver.
	 This is needed as the dma driver uses threaded irq.
	 Author: Siva Yerramreddy
Patch 5: Add dma support in host driver.
	 Authors: Siva Yerramreddy, Ashutosh Dixit, Sudeep Dutt
Patch 6: Add threaded irq support in card driver.
	 This is needed as the dma driver uses threaded irq.
	 Author: Siva Yerramreddy
Patch 7: Add dma support in card driver.
	 Author: Siva Yerramreddy
Patch 8: Add support for loading/unloading dma driver.
	 Author: Siva Yerramreddy

The patches have been compiled/validated against v3.14.
Tested using dmatest module with module parameter "threads_per_chan=60".

Thanks to Dan Williams, Vinod Koul, Jon Mason, Dave Jiang for the initial
review.

Siva Yerramreddy (8):
  misc: mic: Add mic bus and dma driver documentation
  misc: mic: add a bus driver for virtual MIC devices
  dma: MIC X100 DMA Driver
  misc: mic: add threaded irq support in host driver
  misc: mic: add dma support in host driver
  misc: mic: add threaded irq support in card driver
  misc: mic: add dma support in card driver
  misc: mic: add support for loading/unloading dma driver

 Documentation/mic/mic_overview.txt |  67 ++--
 Documentation/mic/mpssd/mpss       |  14 +-
 drivers/dma/Kconfig                |  19 +
 drivers/dma/Makefile               |   1 +
 drivers/dma/mic_x100_dma.c         | 774 +++++++++++++++++++++++++++++++++++++
 drivers/dma/mic_x100_dma.h         | 286 ++++++++++++++
 drivers/misc/mic/Kconfig           |  21 +-
 drivers/misc/mic/Makefile          |   1 +
 drivers/misc/mic/bus/Makefile      |   5 +
 drivers/misc/mic/bus/mic_bus.c     | 188 +++++++++
 drivers/misc/mic/card/mic_device.c |  21 +-
 drivers/misc/mic/card/mic_device.h |   8 +-
 drivers/misc/mic/card/mic_virtio.c |   4 +-
 drivers/misc/mic/card/mic_x100.c   |  52 ++-
 drivers/misc/mic/host/mic_boot.c   |  78 +++-
 drivers/misc/mic/host/mic_device.h |  24 ++
 drivers/misc/mic/host/mic_intr.c   | 116 +++---
 drivers/misc/mic/host/mic_intr.h   |  21 +-
 drivers/misc/mic/host/mic_main.c   |   5 +-
 drivers/misc/mic/host/mic_virtio.c | 185 +++++++--
 drivers/misc/mic/host/mic_virtio.h |  21 +-
 drivers/misc/mic/host/mic_x100.c   |   8 +
 include/linux/mic_bus.h            | 148 +++++++
 23 files changed, 1922 insertions(+), 145 deletions(-)
 create mode 100644 drivers/dma/mic_x100_dma.c
 create mode 100644 drivers/dma/mic_x100_dma.h
 create mode 100644 drivers/misc/mic/bus/Makefile
 create mode 100644 drivers/misc/mic/bus/mic_bus.c
 create mode 100644 include/linux/mic_bus.h

-- 
1.8.2.2

