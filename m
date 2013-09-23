Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3IWSQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:00 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37313 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab3IWSPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:15:04 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 00/13] TPM cleanup
Date: Mon, 23 Sep 2013 12:14:30 -0600
Message-Id: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While writing two new TPM drivers I noticed that there was a big and growing
mess in drivers/char/tpm. This series of patches is the first batch of patches
containing my attempt to fix it.

This series makes several small repetitive changes to all the drivers. These
are bundled in with the commits changing the core, because the core API is
changed and everything must be kept together to retain bisect-ability.

I have decided not to tackle the lifetime issues in this series. My
first attempt was flawed.

I have presented the series in the full linear format. It is available on
my github:
  https://github.com/jgunthorpe/linux/commits/tpm-devel
The branch is not stable, I will rebase and rewrite history as needed.

All patches have been compile tested on x86-64 (including vtpm, I have a hack
to make that happen) and all patches are checkpatch.pl clean.

I have tested tpm_tis (PPC32), tpm_i2c_atmel and tpm_i2c_nuvoton (ARM32) on my
hardware here.

There is very little new code here, the majority of lines is just code motion
to remove duplication.

Patches 1 -> 6, 12
 - These are just simple cleanups that I discovered while doing the other
   work.

Patch 7
 - This is important to unify the sysfs code. I've choosen to simplify
   and not make the TPM version bus-dependent.

Patch 8-9
 - The drivers have this duplication of the file_operations
   and sysfs code. This series pulls all of that code out of the drivers
   and into the core

Patches 10->11
 - This is the first step in making the TPM subsystem be like other
   subsystems in the kernel.

Patches 13
 - This cleans up the struct tpm_chip by hiding stuff that isn't
   public

This is already a fair clean up, but there is still more to do someday:
 * The lifetime issues around struct tpm_chip/etc and the way userspace
   can hold /dev/tpmX open even after the driver has detached.
 * struct tpm_chip and struct tpm_vendor_specific need to be merged
 * The above two structs have many members that are never used by the
   core code. These members need to be migrated into driver
   private structures
 * The resulting merged struct should live in linux/include/tpm.h
   like all other device classes in the kernel.
 * Several drivers need clean up to move singleton static
   variables into dynamic structures
 * Consolidate TCG defined constants that are duplicated in many
   drivers
 * Consolidate device startup (tpm_startup, tpm_get_timeoutes)
   into core code

If this series is successful I may be able to do some of the above as well.

Jason Gunthorpe (13):
  tpm: ibmvtpm: Use %zd formatting for size_t format arguments
  tpm atmel: Call request_region with the correct base
  tpm: xen-tpmfront: Fix default durations
  tpm: Store devname in the tpm_chip
  tpm: Use container_of to locate the tpm_chip in tpm_open
  tpm: Remove redundant dev_set_drvdata
  tpm: Remove tpm_show_caps_1_2
  tpm: Pull everything related to /dev/tpmX into tpm-dev.c
  tpm: Pull everything related to sysfs into tpm-sysfs.c
  tpm: Create a tpm_class_ops structure and use it in the drivers
  tpm: Use the ops structure instead of a copy in tpm_vendor_specific
  tpm: st33: Remove chip->data_buffer access from this driver
  tpm: Make tpm-dev allocate a per-file structure

 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-dev.c          | 213 +++++++++++++++
 drivers/char/tpm/tpm-sysfs.c        | 318 ++++++++++++++++++++++
 drivers/char/tpm/tpm.c              | 524 +++---------------------------------
 drivers/char/tpm/tpm.h              |  86 +++---
 drivers/char/tpm/tpm_atmel.c        |  30 +--
 drivers/char/tpm/tpm_i2c_atmel.c    |  42 +--
 drivers/char/tpm/tpm_i2c_infineon.c |  44 +--
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  42 +--
 drivers/char/tpm/tpm_i2c_stm_st33.c |  51 +---
 drivers/char/tpm/tpm_ibmvtpm.c      |  44 +--
 drivers/char/tpm/tpm_infineon.c     |  28 +-
 drivers/char/tpm/tpm_nsc.c          |  28 +-
 drivers/char/tpm/tpm_spi_stm_st33.c |  50 +---
 drivers/char/tpm/tpm_tis.c          |  43 +--
 drivers/char/tpm/xen-tpmfront.c     |  57 +---
 include/linux/tpm.h                 |  15 ++
 17 files changed, 638 insertions(+), 979 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev.c
 create mode 100644 drivers/char/tpm/tpm-sysfs.c

-- 
1.8.1.2

