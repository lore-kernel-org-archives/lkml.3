Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3APOoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:44:13 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43032 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3APOoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:12 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 00/11] remoteproc: Support bi-directional vdev config space
Date: Wed, 16 Jan 2013 15:43:39 +0100
Message-Id: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Changes since v2:
- Addressed review comments
- Reworked patch "Load firmware once". 

This patch-set is not yet thoroughly tested, but works in my
simulated environment.

This patch-set adds support for shared resource table between
Linux kernel and remote devices. 
- dynamically-allocated address of the vrings can be communicated
- vdev statuses can be communicated
- virtio config space becomes bi-directional
- virtio feature negotiation is two-way 
- Carveout can be allocated from start of device memory.
  dma_alloc_coherent() aligns to size of memory area. So if you e.g. 
  have 8Mb of memory, you cannot have carveout larger than 4Mb
  unless the carveout is allocated from start of the device memory
  area.

NOTE: This change is not backwards compatible with existing
device firmware! The memory allocation order changes. Previously
the Virtio Rings were always allocated at start of the share memory
area, but with this patch-set Virtio Rings are allocated after the
Carveouts. The address of the vrings are set in the resource table.

Cheers,
Sjur

Sjur Brændeland (11):
  remoteproc: Move enable_iommu to rproc_boot
  remoteproc: Code cleanup of resource parsing
  remoteproc: Move check on firmware name to rproc_add
  remoteproc: Refactor function rproc_elf_find_rsc_table
  remoteproc: Parse ELF file to find resource table address
  remoteproc: Parse STE-firmware and find resource table address
  remoteproc: Add state RPROC_LOADED
  remoteproc: Set vring addresses in resource table
  remoteproc: Load firmware once.
  remoteproc: Support virtio config space.
  remoteproc: Calculate max_notifyid by counting vrings

 drivers/remoteproc/remoteproc_core.c       |  264 +++++++++++++---------------
 drivers/remoteproc/remoteproc_debugfs.c    |    1 +
 drivers/remoteproc/remoteproc_elf_loader.c |   96 +++++++---
 drivers/remoteproc/remoteproc_internal.h   |   16 ++
 drivers/remoteproc/remoteproc_virtio.c     |   38 ++++-
 drivers/remoteproc/ste_modem_rproc.c       |   43 +++--
 include/linux/remoteproc.h                 |    7 +-
 7 files changed, 273 insertions(+), 192 deletions(-)

-- 
1.7.5.4

