Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaJHP5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:57:08 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:51018 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaJHP5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:57:04 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: thornber@redhat.com, snitzer@redhat.com, hch@infradead.org,
        hayakawa@valinux.co.jp, axboe@fb.com, andy@rudoff.com,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        linux-nvme@lists.infradead.org
Cc: jmad@itu.dk, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 0/5] Support for Open-Channel SSDs (was dm-lightnvm)
Date: Wed,  8 Oct 2014 17:55:31 +0200
Message-Id: <1412783736-18115-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an update on the the common layer for Open-Channel SSDs (LightNVM). A
previous patch was posted here:

  http://www.redhat.com/archives/dm-devel/2014-March/msg00115.html

Thanks for all the constructive feedback.

Architectural changes
---------------------
  * Moved LightNVM between device drivers and the blk-mq layer. Currently
    drivers hook into LightNVM. It will be integrated directly into
    the block layer later. Why the block layer? Because it is tightly coupled
    with blk-mq, uses its per-request private storage, scalability. Furthermore,
    read/write commands are piggy-backed with additional information, such as
    flash block health, translation table metadata, etc.

  * A device has a number of physical blocks. These can now be exposed through a
    number of targets. This can be a typical block layer, but can also be a
    specialization, such as key-value store, object-based storage, and so forth.
    Allowing file-systems and databases to write directly to physical block
    without multiple translation layers between.

  * Allow experimentation through QEMU. LightNVM is now initialized when
    hardware is a LightNVM-compatible device.

  * The development has been moved to https://github.com/OpenChannelSSD

Backgound
---------
Open-channel SSDs are devices which exposes direct access to its physical
flash storage, while keeping a subset of the internal features of SSDs.

A common SSD consists of a flash translation layer (FTL), bad block
management, and hardware units such as flash controller and host
interface controller and a large amount of flash chips.

LightNVM moves part of the FTL responsibility into the host, allowing
the host to manage data placement, garbage collection and parallelism. The
device continues to maintain information about bad block management, implements
a simpler FTL, that allows extensions such as atomic IOs, metadata
persistence and similar to be implemented.

The architecture of LightNVM consists of a core and multiple targets. The core
implements functionality shared across targets, such as initialization, teardown
and statistics. The other part is targets. They are how physical flash are
exposed to user-land. This can be as the block device, key-value store,
object-store, or anything else.

LightNVM is currently hooked up through the null_blk and NVMe driver. The NVMe
extension allow development using the LightNVM-extended QEMU implementation,
using Keith Busch's qemu-nvme branch.

Try it out
-------------

To try LightNVM, a device is required to register as an open-channel SSD.

Currently, two implementations exist. The null_blk and NVMe driver. The
null_blk driver is for performance testing, while the NVMe driver can be
initialized using a patches version of Keith Busch's QEMU NVMe simulator, or if
real hardware is available.

The QEMU branch is available at:

    https://github.com/OpenChannelSSD/qemu-nvme

Follow the guide at

    https://github.com/OpenChannelSSD/linux/wiki

Available Hardware
------------------

A couple of open platforms are currently being ported to utilize LightNVM:

 IIT Madras (https://bitbucket.org/casl/ssd-controller)
   An open-source implementation of a NVMe controller in BlueSpec. Can run on
   Xilix FPGA's, such as Artix 7, Kintex 7 and Vertex 7.

 OpenSSD Jasmine (http://www.openssd-project.org/)
   An open-firmware SSD, that allows the user to implement its own FTL within
   the controller.

   An experimental patch of the firmware is found in the lightnvm branch:
     https://github.com/ClydeProjects/OpenSSD/

   Todo: Requires bad block management to be useful and storing of host FTL
   metadata.

 OpenSSD Cosmos (http://www.openssd-project.org/wiki/Cosmos_OpenSSD_Platform)
   A complete development board with FPGA, ARM Cortex A9 and FPGA-accelerated
   host access.

Draft Specification
-------------------

We are currently creating a draft specification as more and more of the
host/device interface is stabilized. Please see this Google document. It's open
for comments.

  http://goo.gl/BYTjLI

In the making
-------------

 * The QEMU implementation doesn't yet support loading of translation tables and
   thereby the logical to physical sector relationship is forgotten on reboot.
 * Bad block management. This is kept device side, however the host still
   requires bad block information to prevent writing to dead flash blocks.
 * Space-efficient algorithms for translation tables.

Matias Bjørling (5):
  NVMe: Convert to blk-mq
  block: extend rq_flag_bits
  lightnvm: Support for Open-Channel SSDs
  lightnvm: NVMe integration
  lightnvm: null_blk integration

 Documentation/block/null_blk.txt |    9 +
 drivers/Kconfig                  |    2 +
 drivers/Makefile                 |    1 +
 drivers/block/null_blk.c         |  149 +++-
 drivers/block/nvme-core.c        | 1469 +++++++++++++++++++-------------------
 drivers/block/nvme-scsi.c        |    8 +-
 drivers/lightnvm/Kconfig         |   20 +
 drivers/lightnvm/Makefile        |    5 +
 drivers/lightnvm/core.c          |  212 ++++++
 drivers/lightnvm/gc.c            |  233 ++++++
 drivers/lightnvm/kv.c            |  513 +++++++++++++
 drivers/lightnvm/nvm.c           |  540 ++++++++++++++
 drivers/lightnvm/nvm.h           |  632 ++++++++++++++++
 drivers/lightnvm/sysfs.c         |   79 ++
 drivers/lightnvm/targets.c       |  246 +++++++
 include/linux/blk_types.h        |    4 +
 include/linux/lightnvm.h         |  130 ++++
 include/linux/nvme.h             |   19 +-
 include/uapi/linux/lightnvm.h    |   45 ++
 include/uapi/linux/nvme.h        |   57 ++
 20 files changed, 3603 insertions(+), 770 deletions(-)
 create mode 100644 drivers/lightnvm/Kconfig
 create mode 100644 drivers/lightnvm/Makefile
 create mode 100644 drivers/lightnvm/core.c
 create mode 100644 drivers/lightnvm/gc.c
 create mode 100644 drivers/lightnvm/kv.c
 create mode 100644 drivers/lightnvm/nvm.c
 create mode 100644 drivers/lightnvm/nvm.h
 create mode 100644 drivers/lightnvm/sysfs.c
 create mode 100644 drivers/lightnvm/targets.c
 create mode 100644 include/linux/lightnvm.h
 create mode 100644 include/uapi/linux/lightnvm.h

-- 
1.9.1

