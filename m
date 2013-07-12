Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965546Ab3GLVtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:49:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48890 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965502Ab3GLVt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:49:28 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [RFC/RFT PATCH 0/5] mm: ARM nobootmem and few dma_mask fixes
Date: Fri, 12 Jul 2013 17:48:09 -0400
Message-ID: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series is an attempt to move ARM port to NO_BOOTMEM. As discussed
on list NO_BOOTMEM move needed updates to max*pfn meaning to be maximum
PFNs but that breaks the dma_mask for few block layer drivers since
ARM start of physical memory is not PFN0 unlike most of the architectures.
Some more read on it is here:
	http://lwn.net/Articles/543408/
	http://lwn.net/Articles/543424/

To address this issue, we introduce generic dma_max_pfn() helper which
can be overridden from the architectures.
	
Another intention behind move to nobootmem is also to convert ARM to
switch to memblock and getting rid of bootmem allocator dependency which
don't work for LPAE machines which has physical memory starting beyond
4 GB boundary. It needs changes to core kernel and also a new memblock
API. More on this can be found here:
	https://lkml.org/lkml/2013/6/29/77

I have been trying to cook up these patches with kind help from Russell
and we know series don't solve all the dma_mask bad assumptions. But at
least I am hoping that it can get the ball rolling.	

Comments/testing help is welcome !!

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>

Santosh Shilimkar (5):
  block: Rename parameter dma_mask to max_addr for
    blk_queue_bounce_limit()
  mm: dma-mapping: Add dma_max_pfn(dev) helper function
  scsi: Use dma_max_pfn(dev) helper for bounce_limit calculations
  ARM: mm: change max*pfn to include the physical offset of memory
  ARM: mm: Remove bootmem code and switch to NO_BOOTMEM

 arch/arm/Kconfig                   |    1 +
 arch/arm/include/asm/dma-mapping.h |   16 ++++++---
 arch/arm/kernel/setup.c            |    2 +-
 arch/arm/mm/init.c                 |   68 ++++--------------------------------
 block/blk-settings.c               |    8 ++---
 drivers/scsi/scsi_lib.c            |    2 +-
 include/linux/dma-mapping.h        |    7 ++++
 7 files changed, 32 insertions(+), 72 deletions(-)

-- 
1.7.9.5

