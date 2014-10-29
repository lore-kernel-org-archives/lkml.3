Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaJ2SgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:36:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:10954 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbaJ2SgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,278,1413270000"; 
   d="scan'208";a="613605778"
Subject: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
From: "Jason B. Akers" <jason.b.akers@intel.com>
To: linux-ide@vger.kernel.org
Cc: axboe@fb.com, dan.j.williams@intel.com, kapil.karkra@intel.com,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 11:23:38 -0700
Message-ID: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
User-Agent: StGit/0.17.1-4-g4a0c1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series enables the use of Solid State hybrid drives
ATA standard 3.2 defines the hybrid information feature, which provides a means for the host driver to provide hints to the SSHDs to guide what to place on the SSD/NAND portion and what to place on the magnetic media.

This implementation allows user space applications to provide the cache hints to the kernel using the existing ionice syscall. 

An application can pass a priority number coding up bits 11, 12, and 15 of the ionice command to form a 3 bit field that encodes the following priorities:
	OPRIO_ADV_NONE,
	IOPRIO_ADV_EVICT, /* actively discard cached data */
	IOPRIO_ADV_DONTNEED, /* caching this data has little value */
	IOPRIO_ADV_NORMAL, /* best-effort cache priority (default) */
	IOPRIO_ADV_RESERVED1, /* reserved for future use */
	IOPRIO_ADV_RESERVED2,
	IOPRIO_ADV_RESERVED3,
	IOPRIO_ADV_WILLNEED, /* high temporal locality */

For example the following commands from the user space will make dd IOs to be generated with a hint of IOPRIO_ADV_DONTNEED assuming the SSHD is /dev/sdc.

ionice -c2 -n4096 dd if=/dev/zero of=/dev/sdc bs=1M count=1024
ionice -c2 -n4096 dd if=/dev/sdc of=/dev/null bs=1M count=1024

Note that the class field indicates the best effort while the n field identifies the io priority. Also note that these io priorities translate to the SSHD hints that pass down the SATA link as follows IOPRIO_ADV_NONE translates to 0x0 IOPRIO_ADV_EVICT translates to 0x20 IOPRIO_ADV_DONTNEED translates to 0x21 IOPRIO_ADV_NORMAL translates to MAX PRI - 1 IOPRIO_ADV_NORMAL translates to MAX PRI

MAX PRI is the maximum priority level supported by the SSHD

The translation from ionice cache hint to ATA hybrid hint is controlled using a hybrid_translation_table. A default table is built-in to libata.

This default table can be overridden with a new table through the firmware_update. The new table can be applied on a per ata_device basis. The reasoning is that the translation can be optimized for VendorA SSHDs differently from VendorB SSHDs. A hybrid_information_table.bin could override the ./firmware directory to update this table.

The .config might be modified to build-in the new table CONFIG_EXTRA_FIRMWARE="hybrid_information_table.bin"
CONFIG_EXTRA_FIRMWARE_DIR="firmware"

To toggle enable/disable of the feature
echo 1 > /sys/class/ata_device/devX.0/hybrid

We ran performance tests with SSHDs from two different vendors and saw the following results with default all-insert policy:
	50% improvement in boot times
	45% improvment in App launch
	3x faster browser
	4x faster SQLite

The performance results also showed that host hinting using the above default performed significantly better than the self hinting in using benchmarks.

We are looking for feedback on the cache hinting approach, as it seems others are interested in this capability.  We're also looking for comments on the libata implementation for supporting host hinted SSHDs. A patch to sg3_utils for retrieving the Hybrid Information Log follows. Per the spec host-hinted SSHDs revert to internal firmware hinted SSHDs if the log is not read after a certain number of power cycles.

---

Dan Williams (3):
      block, ioprio: include caching advice via ionice
      block: ioprio hint to low-level device drivers
      block: untangle ioprio from BLK_CGROUP and BLK_DEV_THROTTLING

Jason B. Akers (1):
      libata: Enabling Solid State Hybrid Drives (SSHDs) based on SATA 3.2 standard

Kapil Karkra (1):
      block, mm: Added the necessary plumbing to take ioprio hints down to block layer


 block/bio.c                    |   76 +++++++-----
 block/blk-throttle.c           |    5 +
 block/blk.h                    |    2 
 block/ioprio.c                 |   22 ++-
 drivers/ata/Makefile           |    2 
 drivers/ata/libata-core.c      |   13 ++
 drivers/ata/libata-eh.c        |   11 ++
 drivers/ata/libata-hybrid.c    |  261 ++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-hybrid.h    |   14 ++
 drivers/ata/libata-scsi.c      |    4 -
 drivers/ata/libata-transport.c |   45 +++++++
 drivers/ata/libata.h           |    2 
 include/linux/ata.h            |    1 
 include/linux/bio.h            |   69 ++++++++++-
 include/linux/ioprio.h         |   32 ++++-
 include/linux/libata.h         |    4 +
 include/linux/page-flags.h     |   24 ++++
 mm/debug.c                     |    5 +
 mm/filemap.c                   |   18 +++
 19 files changed, 561 insertions(+), 49 deletions(-)
 create mode 100644 drivers/ata/libata-hybrid.c
 create mode 100644 drivers/ata/libata-hybrid.h

--
Thanks,
jba
