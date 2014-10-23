Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaJWNdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:33:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:9665 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaJWNdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,775,1406617200"; 
   d="scan'208";a="619178835"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 0/3] prepare for TPM 2.0
Date: Thu, 23 Oct 2014 16:32:52 +0300
Message-Id: <1414071175-9978-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes two race conditions in the TPM subsystem:

* Two-phase initialization for struct tpm_chip so that device can
  initialize fully initialize before exposing itself to the user
  space. Also, in future TPM2 devices must be flagged before they
  can be registered.
* Machines where there are two TPM devices exposed by ACPI have
  a racy lookup for the PPI interface. This patch set fixes this
  issues

In addition, transmit_cmd() is renamed as tpm_transmit_cmd() and
made opaque so that separate command structure can be introduced
for TPM2.

Comments about v1:
* I think this could be pulled to 3.18 because this clearly fixes
  bugs in the current implementation.

Changes since v1:
* Removed dev_dbgs from tpm-chip.c
* Use driver_lock for dev_mask (the problem was existing also in
  tpm-interface.c when the code was moved).
* Check for bios_dir nullity when removed (the problem was existing
  also in tpm-interface.c when the code was moved).
* Cleaned up the control flow in tpm_i2c_stm_st33.c and tpm_atmel.c.
* Cleaned up the control flow in tpm_ppi.c.

Comments about v2:
* Thanks to Jason Gunthorpe for reviewing v1.
* I'm at T2 infosec conference right now so I wasn't able to test the
  force paths in tpm_atmel.c and tpm_tis.c.

Jarkko Sakkinen (3):
  tpm: merge duplicate transmit_cmd() functions
  tpm: two-phase chip management functions
  tpm: fix multiple race conditions in tpm_ppi.c

 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-chip.c         | 196 +++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-dev.c          |   4 +-
 drivers/char/tpm/tpm-interface.c    | 201 ++++++------------------------------
 drivers/char/tpm/tpm-sysfs.c        |  23 +----
 drivers/char/tpm/tpm.h              |  32 +++---
 drivers/char/tpm/tpm_atmel.c        |  12 ++-
 drivers/char/tpm/tpm_i2c_atmel.c    |  33 ++----
 drivers/char/tpm/tpm_i2c_infineon.c |  37 ++-----
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  44 +++-----
 drivers/char/tpm/tpm_i2c_stm_st33.c |  38 +++----
 drivers/char/tpm/tpm_ibmvtpm.c      |  17 ++-
 drivers/char/tpm/tpm_infineon.c     |  29 +++---
 drivers/char/tpm/tpm_nsc.c          |  14 ++-
 drivers/char/tpm/tpm_ppi.c          | 136 ++++++++++++++----------
 drivers/char/tpm/tpm_tis.c          |  94 ++++++++---------
 drivers/char/tpm/xen-tpmfront.c     |  14 +--
 17 files changed, 471 insertions(+), 455 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-chip.c

-- 
2.1.0

