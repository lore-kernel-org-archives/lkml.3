Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbaEFBeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:34:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36580 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbaEFBd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:33:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 0/8] irq: core changes for x86 ioapic hotplug
Date: Mon,  5 May 2014 18:33:18 -0700
Message-Id: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are core changes for x86 ioapic hotplug support.

First part for kill old irq_reserve_irqs:
During reviewing ioapic hotplug patchset, Thomas pointed out that
should not extend irq_reserve_irq for that purpose as that is not
actually reserve.
Neet to clean up old irq_reserve_irq before introduce reserve/alloc_reserved
method for ioapic hotplug.
So here patchset that kill irq_reserve_irq that actually set allocated_irqs.
First remove irq_reserve_irqs for x86, and remove irq_reserve_irq
for sh.
Then in set_irq_chip use irq_alloc_desc instead of irq_reserve_irq.
Next will mark bits in allocated_irqs early for init irqs in !SPARSE_IRQ

Second parts are new reserve/alloc_reserved functions:
It will introduce reserved_irqs bit maps to track reserved irqs.
New irq_alloc_reserved_desc() will only allocate desc when that irq
is reserved, at the same time irq_alloc_desc will only allocate desc
when irq is not reserved.

Thanks

Yinghai

-v2: add new reserve/alloc_reserved sets.
-v3: make irq_alloc_descs to avoid reserved irqs.

Yinghai Lu (8):
  x86, irq: Remove not needed irq_reserve_irqs calling
  sh, irq: Remove irq_reserve_irq calling
  irq: Use irq_alloc_desc_at instead of irq_reserve_irq
  s390: Mark bits in allocated_irqs in general code
  irq: Kill irq_reserve_irq/irq_reserve_irqs
  irq: Add new reserved_irqs clear/mark functions
  irq: Add irq_alloc_reserved_desc()
  irq: Do not free unallocated irq descriptors

 arch/s390/kernel/irq.c         |   6 +-
 arch/x86/kernel/apic/io_apic.c |   3 -
 drivers/sh/intc/core.c         |   7 +-
 include/linux/irq.h            |  13 ++--
 kernel/irq/chip.c              |  14 ++--
 kernel/irq/irqdesc.c           | 144 ++++++++++++++++++++++++++++++++++-------
 6 files changed, 141 insertions(+), 46 deletions(-)

-- 
1.8.4.5

