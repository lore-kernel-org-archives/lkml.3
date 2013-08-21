Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3HURuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:50:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:2663 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3HURut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:50:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="366351287"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH v3 0/7] Enable Drivers for Intel MIC X100 Coprocessors.
Date: Wed, 21 Aug 2013 10:50:08 -0700
Message-Id: <cover.1377104309.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog:
=========

v2 => v3:
a) Patch 1 data structure cleanups, header file include cleanups,
   IDA interface reuse and switching to device_create_with_groups(..)
   as per feedback from Greg Kroah-Hartman.
b) Patch 7 signal documentation, sleep workaround removal and sysfs
   access API cleanups as per feedback from Michael S. Tsirkin.

v1 => v2: @ http://lwn.net/Articles/563131/
a) License wording cleanup, sysfs ABI documentation, patch 1 refactoring
   into 3 smaller patches and function renames, as per feedback from
   Greg Kroah-Hartman.
b) Use VRINGH infrastructure for accessing virtio rings from the host
   in patch 5, as per feedback from Michael S. Tsirkin.

v1: Initial post @ https://lwn.net/Articles/561314/

Description:
============

An Intel MIC X100 device is a PCIe form factor add-in coprocessor
card based on the Intel Many Integrated Core (MIC) architecture
that runs a Linux OS. It is a PCIe endpoint in a platform and therefore
implements the three required standard address spaces i.e. configuration,
memory and I/O. The host OS loads a device driver as is typical for
PCIe devices. The card itself runs a bootstrap after reset that
transfers control to the card OS downloaded from the host driver.
The card OS as shipped by Intel is a Linux kernel with modifications
for the X100 devices.

Since it is a PCIe card, it does not have the ability to host hardware
devices for networking, storage and console. We provide these devices
on X100 coprocessors thus enabling a self-bootable equivalent environment
for applications. A key benefit of our solution is that it leverages
the standard virtio framework for network, disk and console devices,
though in our case the virtio framework is used across a PCIe bus.

Here is a block diagram of the various components described above. The
virtio backends are situated on the host rather than the card given better
single threaded performance for the host compared to MIC, the ability of
the host to initiate DMA's to/from the card using the MIC DMA engine and
the fact that the virtio block storage backend can only be on the host.

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
      +--------------+        |                   |
      |Intel MIC     |        |            +---------------+
      |Card Driver   |        |            |Intel MIC      |
      +--------------+        |            |Host Driver    |
              |               |            +---------------+
              |               |                   |
     +-------------------------------------------------------------+
     |                                                             |
     |                    PCIe Bus                                 |
     +-------------------------------------------------------------+

The following series of patches are partitioned as follows:

Patch 1: This patch introduces the "Intel MIC Host Driver" in the block
diagram which does the following:
a) Initializes the Intel MIC X100 PCIe devices.
b) Provides sysfs entries for family and stepping information.

Patch 2: This patch enables the following features in the
"Intel MIC Host Driver" in the block diagram:
a) MSIx, MSI and legacy interrupt support.
b) System Memory Page Table(SMPT) support. SMPT enables system memory
   access from the card. On X100 devices the host can program 32 SMPT
   registers each capable of accessing 16GB of system memory
   address space from X100 devices. The registers can thereby be used
   to access a cumulative 512GB of system memory address space from
   X100 devices at any point in time.

Patch 3: This patch enables the following features in the
"Intel MIC Host Driver" in the block diagram:
a) Boots and shuts down the card via sysfs entries.
b) Allocates and maps a device page for communication with the
   card driver and updates the device page address via scratchpad
   registers.
c) Provides sysfs entries for shutdown status, kernel command line,
   firmware, ramdisk, bootmode and log buffer information.

Patch 4: This patch introduces the "Intel MIC Card Driver" in the block
diagram which does the following:
a) Initializes the Intel MIC X100 platform device and driver.
b) Sets up support to handle shutdown requests from the host.
c) Maps the device page after obtaining the device page address
   from the scratchpad registers updated by the host.
d) Informs the host upon a card crash by registering a panic notifier.
e) Informs the host upon a poweroff/halt event.

Patch 5: This patch introduces the host "Virtio over PCIe" interface for
Intel MIC. It allows creating user space backends on the host and instantiating
virtio devices for them on the Intel MIC card. It uses the existing VRINGH
infrastructure in the kernel to access virtio rings from the host. A character
device per MIC is exposed with IOCTL, mmap and poll callbacks. This allows the
user space backend to:
(a) add/remove a virtio device via a device page.
(b) map (R/O) virtio rings and device page to user space.
(c) poll for availability of data.
(d) copy a descriptor or entire descriptor chain to/from the card.
(e) modify virtio configuration.
(f) handle virtio device reset.
The buffers are copied over using CPU copies for this initial patch
and host initiated MIC DMA support is planned for future patches.
The avail and desc virtio rings are in host memory and the used ring
is in card memory to maximize writes across PCIe for performance.

Patch 6: This patch introduces the card "Virtio over PCIe" interface for
Intel MIC. It allows virtio drivers on the card to communicate with their
user space backends on the host via a device page. Ring 3 apps on the host
can add, remove and configure virtio devices. A thin MIC specific
virtio_config_ops is implemented which is borrowed heavily from previous
similar implementations in lguest and s390 @
drivers/lguest/lguest_device.c
drivers/s390/kvm/kvm_virtio.c

Patch 7: This patch introduces a sample user space daemon which
implements the virtio device backends on the host. The daemon
creates/removes/configures virtio device backends by communicating with
the Intel MIC Host Driver. The virtio devices currently supported are
virtio net, virtio console and virtio block. Virtio net supports TSO/GSO.
The daemon also monitors card shutdown status and takes appropriate actions
like killing the virtio backends and resetting the card upon card shutdown
and crashes.

The patches have been compiled/validated against v3.11-rc5.

Ashutosh Dixit (2):
  Intel MIC Host Driver Changes for Virtio Devices.
  Intel MIC Card Driver Changes for Virtio Devices.

Caz Yokoyama (1):
  Sample Implementation of Intel MIC User Space Daemon.

Dasaratharaman Chandramouli (1):
  Intel MIC Host Driver Interrupt/SMPT support.

Sudeep Dutt (3):
  Intel MIC Host Driver for X100 family.
  Intel MIC Host Driver, card OS state management.
  Intel MIC Card Driver for X100 family.

 Documentation/ABI/testing/sysfs-class-mic.txt |  147 +++
 Documentation/mic/mic_overview.txt            |   49 +
 Documentation/mic/mpssd/.gitignore            |    1 +
 Documentation/mic/mpssd/Makefile              |   19 +
 Documentation/mic/mpssd/micctrl               |  173 +++
 Documentation/mic/mpssd/mpss                  |  202 +++
 Documentation/mic/mpssd/mpssd.c               | 1701 +++++++++++++++++++++++++
 Documentation/mic/mpssd/mpssd.h               |  100 ++
 Documentation/mic/mpssd/sysfs.c               |  102 ++
 drivers/misc/Kconfig                          |    1 +
 drivers/misc/Makefile                         |    1 +
 drivers/misc/mic/Kconfig                      |   39 +
 drivers/misc/mic/Makefile                     |    6 +
 drivers/misc/mic/card/Makefile                |   11 +
 drivers/misc/mic/card/mic_debugfs.c           |  130 ++
 drivers/misc/mic/card/mic_device.c            |  306 +++++
 drivers/misc/mic/card/mic_device.h            |  133 ++
 drivers/misc/mic/card/mic_virtio.c            |  631 +++++++++
 drivers/misc/mic/card/mic_virtio.h            |   77 ++
 drivers/misc/mic/card/mic_x100.c              |  256 ++++
 drivers/misc/mic/card/mic_x100.h              |   48 +
 drivers/misc/mic/common/mic_device.h          |   51 +
 drivers/misc/mic/host/Makefile                |   13 +
 drivers/misc/mic/host/mic_boot.c              |  185 +++
 drivers/misc/mic/host/mic_debugfs.c           |  496 +++++++
 drivers/misc/mic/host/mic_device.h            |  300 +++++
 drivers/misc/mic/host/mic_fops.c              |  221 ++++
 drivers/misc/mic/host/mic_fops.h              |   32 +
 drivers/misc/mic/host/mic_main.c              | 1098 ++++++++++++++++
 drivers/misc/mic/host/mic_smpt.c              |  440 +++++++
 drivers/misc/mic/host/mic_smpt.h              |   98 ++
 drivers/misc/mic/host/mic_sysfs.c             |  468 +++++++
 drivers/misc/mic/host/mic_virtio.c            |  704 ++++++++++
 drivers/misc/mic/host/mic_virtio.h            |  138 ++
 drivers/misc/mic/host/mic_x100.c              |  573 +++++++++
 drivers/misc/mic/host/mic_x100.h              |   99 ++
 include/uapi/linux/Kbuild                     |    2 +
 include/uapi/linux/mic_common.h               |  238 ++++
 include/uapi/linux/mic_ioctl.h                |   74 ++
 39 files changed, 9363 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mic.txt
 create mode 100644 Documentation/mic/mic_overview.txt
 create mode 100644 Documentation/mic/mpssd/.gitignore
 create mode 100644 Documentation/mic/mpssd/Makefile
 create mode 100755 Documentation/mic/mpssd/micctrl
 create mode 100755 Documentation/mic/mpssd/mpss
 create mode 100644 Documentation/mic/mpssd/mpssd.c
 create mode 100644 Documentation/mic/mpssd/mpssd.h
 create mode 100644 Documentation/mic/mpssd/sysfs.c
 create mode 100644 drivers/misc/mic/Kconfig
 create mode 100644 drivers/misc/mic/Makefile
 create mode 100644 drivers/misc/mic/card/Makefile
 create mode 100644 drivers/misc/mic/card/mic_debugfs.c
 create mode 100644 drivers/misc/mic/card/mic_device.c
 create mode 100644 drivers/misc/mic/card/mic_device.h
 create mode 100644 drivers/misc/mic/card/mic_virtio.c
 create mode 100644 drivers/misc/mic/card/mic_virtio.h
 create mode 100644 drivers/misc/mic/card/mic_x100.c
 create mode 100644 drivers/misc/mic/card/mic_x100.h
 create mode 100644 drivers/misc/mic/common/mic_device.h
 create mode 100644 drivers/misc/mic/host/Makefile
 create mode 100644 drivers/misc/mic/host/mic_boot.c
 create mode 100644 drivers/misc/mic/host/mic_debugfs.c
 create mode 100644 drivers/misc/mic/host/mic_device.h
 create mode 100644 drivers/misc/mic/host/mic_fops.c
 create mode 100644 drivers/misc/mic/host/mic_fops.h
 create mode 100644 drivers/misc/mic/host/mic_main.c
 create mode 100644 drivers/misc/mic/host/mic_smpt.c
 create mode 100644 drivers/misc/mic/host/mic_smpt.h
 create mode 100644 drivers/misc/mic/host/mic_sysfs.c
 create mode 100644 drivers/misc/mic/host/mic_virtio.c
 create mode 100644 drivers/misc/mic/host/mic_virtio.h
 create mode 100644 drivers/misc/mic/host/mic_x100.c
 create mode 100644 drivers/misc/mic/host/mic_x100.h
 create mode 100644 include/uapi/linux/mic_common.h
 create mode 100644 include/uapi/linux/mic_ioctl.h

-- 
1.8.2.1

