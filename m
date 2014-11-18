Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaKRTml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:42:41 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:43555 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaKRTmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:42:35 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: hch@infradead.org, axboe@fb.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: thornber@redhat.com, bvanassche@acm.org, jmad@itu.dk,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [RPC PATCH 0/5] Support for Open-Channel SSDs
Date: Tue, 18 Nov 2014 20:41:54 +0100
Message-Id: <1416339719-8488-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an updated patchset of LightNVM. It is now integrated directly into the
block layer when using blk-mq. I'll like to get some feedback on how it is
plugged in.

The block layer integration is as follows:

  block/blk-lightnvm.c holds the setup/teardown functions and calls
  in to the lightnvm code.

  Extendied the request queue flags with QUEUE_FLAG_LIGHTNVM when the queue is a
  LightNVM queue.

  The struct request structure is extended with a ->phys_sector, that holds the
  physical address that a logical address is mapped to. The ->phys_sector is set
  by blk_lightnvm_map, that calls into lightnvm and allocate new address on
  writes, and similarly look up an address on reads.

  A request has a NVM_MAP flag set when it has been mapped. This is used to know
  if completion logic should be run on blk-mq completion. It might now be for
  some targets.

  The request cmd_size field is extended to hold any per-request information
  that lightnvm requires for its bookkeeping.

A branch with the patches can be found here:

  https://github.com/OpenChannelSSD/linux.git lkml_v1

It is currently based on 3.17 on top of the NVMe blk-mq conversion.

For testing, the null_blk driver can be instantiated with:

  lightnvm_enable=1 gb=4 bs=4096 nr_devices=1

or by using the qemu branch at:

  https://github.com/OpenChannelSSD/qemu-nvme.git master

and booting qemu with:

  -drive file=filepath,if=none,id=mynvme \
  -device nvme,drive=mynvme,serial=deadbeef,namespaces=1,lver=1,lchannels=1, \
    nlbaf=5,lba_index=3

Todo:

  Multi-page accesses. Currently limited to sector size IO accesses.
  Retrieval of mapping table from device. Mapping table is forgot on module
  unload.
  Bad block handling. No method to handle flash blocks there are marked bad.

Thanks,
Matias

Jesper Madsen (1):
  block: extend rq_flag_bits

Matias Bjørling (4):
  block: expose init_request_from_bio
  lightnvm: Support for Open-Channel SSDs
  nvme: LightNVM integration
  null_blk: LightNVM integration

 Documentation/block/null_blk.txt |   8 +
 block/Makefile                   |   1 +
 block/blk-core.c                 |   6 +
 block/blk-lightnvm.c             |  81 ++++++
 block/blk-mq.c                   |  35 ++-
 block/blk-sysfs.c                |  13 +
 block/blk.h                      |  14 +
 block/ioctl.c                    |   1 +
 drivers/Kconfig                  |   2 +
 drivers/Makefile                 |   1 +
 drivers/block/null_blk.c         |  89 +++++-
 drivers/block/nvme-core.c        | 187 ++++++++++++-
 drivers/lightnvm/Kconfig         |  20 ++
 drivers/lightnvm/Makefile        |   5 +
 drivers/lightnvm/core.c          | 208 ++++++++++++++
 drivers/lightnvm/gc.c            | 370 ++++++++++++++++++++++++
 drivers/lightnvm/nvm.c           | 460 ++++++++++++++++++++++++++++++
 drivers/lightnvm/nvm.h           | 588 +++++++++++++++++++++++++++++++++++++++
 drivers/lightnvm/sysfs.c         |  68 +++++
 drivers/lightnvm/targets.c       | 244 ++++++++++++++++
 include/linux/blk-mq.h           |   1 +
 include/linux/blk_types.h        |   4 +
 include/linux/blkdev.h           |  24 ++
 include/linux/lightnvm.h         | 112 ++++++++
 include/linux/nvme.h             |   1 +
 include/trace/events/nvm.h       |  70 +++++
 include/uapi/linux/nvme.h        |  74 +++++
 27 files changed, 2677 insertions(+), 10 deletions(-)
 create mode 100644 block/blk-lightnvm.c
 create mode 100644 drivers/lightnvm/Kconfig
 create mode 100644 drivers/lightnvm/Makefile
 create mode 100644 drivers/lightnvm/core.c
 create mode 100644 drivers/lightnvm/gc.c
 create mode 100644 drivers/lightnvm/nvm.c
 create mode 100644 drivers/lightnvm/nvm.h
 create mode 100644 drivers/lightnvm/sysfs.c
 create mode 100644 drivers/lightnvm/targets.c
 create mode 100644 include/linux/lightnvm.h
 create mode 100644 include/trace/events/nvm.h

-- 
1.9.1

