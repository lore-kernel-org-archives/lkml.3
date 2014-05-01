Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaEAXTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:19:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29824 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaEAXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:18:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/8] irq: core changes for x86 ioapic hotplug
Date: Thu,  1 May 2014 16:18:14 -0700
Message-Id: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
is reserved.

Thanks

Yinghai

-v2: add new reserve/alloc_reserved sets.

Yinghai Lu (8):
  x86, irq: Remove not needed irq_reserve_irqs calling
  sh, irq: Remove irq_reserve_irq calling
  irq: Use irq_alloc_desc_at instead of irq_reserve_irq
  s390: Mark bits in allocated_irqs in general code
  irq: Kill irq_reserve_irq/irq_reserve_irqs
  irq: Add new reserved_irqs clear/mark functions
  irq: Add irq_alloc_reserved_desc()
  irq: Do not free unallocated irq descriptors

 arch/s390/kernel/irq.c         |  6 ++-
 arch/x86/kernel/apic/io_apic.c |  3 --
 drivers/sh/intc/core.c         |  5 +--
 include/linux/irq.h            | 13 +++---
 kernel/irq/chip.c              | 14 +++---
 kernel/irq/irqdesc.c           | 99 +++++++++++++++++++++++++++++++++++++-----
 6 files changed, 109 insertions(+), 31 deletions(-)

-- 
1.8.4.5

