Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaF3PlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:41:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:63167 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaF3PlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,575,1400050800"; 
   d="scan'208";a="555316845"
Subject: Re: [PATCH char-misc-next v2 0/8] Enable dma driver for MIC X100
 Coprocessors
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
In-Reply-To: <1402934289.16234.6.camel@rbtaylor-desk1.amr.corp.intel.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
	 <1402934289.16234.6.camel@rbtaylor-desk1.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jun 2014 08:33:53 -0700
Message-ID: <1404142433.27474.6.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 08:58 -0700, Sudeep Dutt wrote:
> On Thu, 2014-05-29 at 14:23 -0700, Sudeep Dutt wrote:
> > ChangeLog:
> > =========
> > v1 => v2:
> > a) MIC bus driver cleanups and device release callback fix in patch 2,
> >    as per feedback from Greg Kroah-Hartman.
> > 
> > v1: Initial post @ https://lkml.org/lkml/2014/5/27/819
> > 
> 
> Hi Greg/Dan,
> 
> We have addressed the feedback received so far. Please take a look at
> this patch series.
> 

Another gentle reminder to take a look at this patch series. Greg/Dan,
please let us know what we can do to speed things up here.

Thanks,
Sudeep Dutt

> > These patches are being sent to char-misc because there is a dependency
> > between the patches for dma driver and other drivers.
> > 
> > Description:
> > ============
> > This set of patches add support for MIC X100 dma driver.
> > MIC PCIe card has a dma controller with 8 channels. These channels are
> > shared between the host s/w and the card s/w. 0 to 3 are used by host
> > nd 4 to 7 by card. As the dma device doesn't show up as PCIe device,
> > a virtual bus called mic bus is created and virtual dma devices are
> > created on it by the host/card drivers. On host the channels are private
> > and used only by the host driver to transfer data for the virtio devices.
> > 
> > Here is a higher level block diagram.
> >                                       |
> >                +----------+           |             +----------+
> >                | Card OS  |           |             | Host OS  |
> >                +----------+           |             +----------+
> >                                       |
> >         +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
> >         | Virtio| |Virtio  | |Virtio| | |Virtio   |  |Virtio  | |Virtio  |
> >         | Net   | |Console | |Block | | |Net      |  |Console | |Block   |
> >         | Driver| |Driver  | |Driver| | |backend  |  |backend | |backend |
> >         +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
> >             |         |         |     |      |            |         |
> >             |         |         |     |User  |            |         |
> >             |         |         |     |------|------------|---------|-------
> >             +-------------------+     |Kernel +--------------------------+
> >                       |               |       | Virtio over PCIe IOCTLs  |
> >                       |               |       +--------------------------+
> > +-----------+         |               |                   |  +-----------+
> > | MIC DMA   |         |               |                   |  | MIC DMA   |
> > | Driver    |         |               |                   |  | Driver    |
> > +-----------+         |               |                   |  +-----------+
> >       |               |               |                   |        |
> > +---------------+     |               |                   |  +----------------+
> > |MIC virtual Bus|     |               |                   |  |MIC virtual Bus |
> > +---------------+     |               |                   |  +----------------+
> >       |               |               |                   |              |
> >       |   +--------------+            |            +---------------+     |
> >       |   |Intel MIC     |            |            |Intel MIC      |     |
> >       +---|Card Driver   |            |            |Host Driver    |     |
> >           +--------------+            |            +---------------+-----+
> >                       |               |                   |
> >              +-------------------------------------------------------------+
> >              |                                                             |
> >              |                    PCIe Bus                                 |
> >              +-------------------------------------------------------------+
> > 
> > The following series of patches are partitioned as follows:
> > 
> > Patch 1: Add mic bus and dma driver documentation.
> > 	 Author: Siva Yerramreddy
> > Patch 2: Add a bus driver for virtual MIC devices.
> > 	 Authors: Siva Yerramreddy, Sudeep Dutt
> > Patch 3: MIC X100 DMA Driver.
> > 	 Author: Siva Yerramreddy
> > Patch 4: Add threaded irq support in host driver.
> > 	 This is needed as the dma driver uses threaded irq.
> > 	 Author: Siva Yerramreddy
> > Patch 5: Use dma to transfer data between MIC and host.
> > 	 Authors: Siva Yerramreddy, Ashutosh Dixit
> > Patch 6: Add threaded irq support in mic_request_card_irq.
> > 	 This is needed as the dma driver uses threaded irq.
> > 	 Author: Siva Yerramreddy
> > Patch 7: Add dma device on mic bus.
> > 	 Author: Siva Yerramreddy
> > Patch 8: Modify the mpss script to load/unload mic_x100_dma.ko.
> > 	 Author: Siva Yerramreddy
> > 
> > The patches have been compiled/validated against v3.15-rc3. Tested using
> > dmatest module with module parameter "threads_per_chan=60". These patches
> > have also been scanned by Fengguang Wu's 0-day infrastructure and no
> > issues have been reported.
> > 
> > Thanks to Dan Williams, Vinod Koul, Jon Mason, Dave Jiang for the initial
> > review.
> > 
> > Siva Yerramreddy (7):
> >   misc: mic: Add mic bus and dma driver documentation
> >   dma: MIC X100 DMA Driver
> >   misc: mic: add threaded irq support in host driver
> >   misc: mic: add dma support in host driver
> >   misc: mic: add threaded irq support in card driver
> >   misc: mic: add dma support in card driver
> >   misc: mic: add support for loading/unloading dma driver
> > 
> > Sudeep Dutt (1):
> >   misc: mic: add a bus driver for virtual MIC devices
> > 
> >  Documentation/mic/mic_overview.txt |  67 ++--
> >  Documentation/mic/mpssd/mpss       |  14 +-
> >  drivers/dma/Kconfig                |  19 +
> >  drivers/dma/Makefile               |   1 +
> >  drivers/dma/mic_x100_dma.c         | 774 +++++++++++++++++++++++++++++++++++++
> >  drivers/dma/mic_x100_dma.h         | 286 ++++++++++++++
> >  drivers/misc/mic/Kconfig           |  21 +-
> >  drivers/misc/mic/Makefile          |   1 +
> >  drivers/misc/mic/bus/Makefile      |   5 +
> >  drivers/misc/mic/bus/mic_bus.c     | 219 +++++++++++
> >  drivers/misc/mic/card/mic_device.c |  23 +-
> >  drivers/misc/mic/card/mic_device.h |   9 +-
> >  drivers/misc/mic/card/mic_virtio.c |   7 +-
> >  drivers/misc/mic/card/mic_x100.c   |  55 ++-
> >  drivers/misc/mic/host/mic_boot.c   |  83 +++-
> >  drivers/misc/mic/host/mic_device.h |  24 ++
> >  drivers/misc/mic/host/mic_intr.c   | 121 +++---
> >  drivers/misc/mic/host/mic_intr.h   |  27 +-
> >  drivers/misc/mic/host/mic_main.c   |   5 +-
> >  drivers/misc/mic/host/mic_virtio.c | 187 +++++++--
> >  drivers/misc/mic/host/mic_virtio.h |  21 +-
> >  drivers/misc/mic/host/mic_x100.c   |   8 +
> >  include/linux/mic_bus.h            | 112 ++++++
> >  23 files changed, 1938 insertions(+), 151 deletions(-)
> >  create mode 100644 drivers/dma/mic_x100_dma.c
> >  create mode 100644 drivers/dma/mic_x100_dma.h
> >  create mode 100644 drivers/misc/mic/bus/Makefile
> >  create mode 100644 drivers/misc/mic/bus/mic_bus.c
> >  create mode 100644 include/linux/mic_bus.h
> > 
> 
> 


