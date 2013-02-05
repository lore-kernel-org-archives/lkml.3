Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3BEAb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:31:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58526 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BEAb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:31:56 -0500
X-AuditID: 9c930179-b7c24ae00000119c-49-511052f8e759
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v5 0/3] introduce static_vm for ARM-specific static mapped area
Date: Tue,  5 Feb 2013 09:31:51 +0900
Message-Id: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, we used ARM-specific flag, that is,
VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
The purpose of static mapped area is to re-use static mapped area when
entire physical address range of the ioremap request can be covered
by this area.

This implementation causes needless overhead for some cases.
For example, assume that there is only one static mapped area and
vmlist has 300 areas. Every time we call ioremap, we check 300 areas for
deciding whether it is matched or not. Moreover, even if there is
no static mapped area and vmlist has 300 areas, every time we call
ioremap, we check 300 areas in now.

If we construct a extra list for static mapped area, we can eliminate
above mentioned overhead.
With a extra list, if there is one static mapped area,
we just check only one area and proceed next operation quickly.

In fact, it is not a critical problem, because ioremap is not frequently
used. But reducing overhead is better idea.

Another reason for doing this work is for removing vm_struct list management,
entirely. For more information, look at the following link.
http://lkml.org/lkml/2012/12/6/184

Changelog
v4->v5:
  [2/3]: Changes from Nicolas' suggestion
  	 - don't use separate flags for static_vm
  	 - remove a lock
  	 - declare add_static_vm_early() as __init
  [3/3]: Changes from Nicolas' suggestion
  	 - add / leave comments

v3->v4:
  [2/3]: Changes from Nicolas' suggestion
         - embed static_vm code in ioremap.c
         - simplify struct static_vm
         - remove init_static_vm, instead, add_static_vm_early() init static_vm
         Use generic list for list management of static_vm
         Convert spin_lock to rw_lock
         Modify static_vm's flags bits
  [3/3]: Rework according to [2/3] change
  Rebased on v3.8-rc5

v2->v3:
  coverletter: refer a link related to this work
  [2/3]: drop @flags of find_static_vm_vaddr
  Rebased on v3.8-rc4

v1->v2: 
  [2/3]: patch description is improved.
  Rebased on v3.7-rc7

Joonsoo Kim (3):
  ARM: vmregion: remove vmregion code entirely
  ARM: ioremap: introduce an infrastructure for static mapped area
  ARM: mm: use static_vm for managing static mapped areas

 arch/arm/mm/Makefile   |    2 +-
 arch/arm/mm/ioremap.c  |  135 +++++++++++++++++++++----------
 arch/arm/mm/mm.h       |   12 +++
 arch/arm/mm/mmu.c      |   34 ++++----
 arch/arm/mm/vmregion.c |  205 ------------------------------------------------
 arch/arm/mm/vmregion.h |   31 --------
 6 files changed, 123 insertions(+), 296 deletions(-)
 delete mode 100644 arch/arm/mm/vmregion.c
 delete mode 100644 arch/arm/mm/vmregion.h

-- 
1.7.9.5

