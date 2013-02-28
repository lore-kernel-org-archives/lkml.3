Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3B1LGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:06:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab3B1LGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:06:00 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v3 3/6] uretprobes: generalize xol_get_insn_slot()
Date: Thu, 28 Feb 2013 12:00:12 +0100
Message-Id: <1362049215-5780-4-git-send-email-anton@redhat.com>
In-Reply-To: <1362049215-5780-1-git-send-email-anton@redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Generalize xol_take_insn_slot() to enable more consumers of the
function, e.g. trampoline implementation for return probes.

  The first time a uprobe with return consumer is hit for a process, a
trampoline slot is obtained in the xol_area and initialized with a
breakpoint instruction. This slot is subsequently used by all
uretprobes.

v3:
 - unified xol_get_insn_slot(), thus get rid of xol_get_trampoline_slot()

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d904164..69bf060 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1221,7 +1221,7 @@ static unsigned long xol_take_insn_slot(struct xol_area *area)
  * xol_get_insn_slot - allocate a slot for xol.
  * Returns the allocated slot address or 0.
  */
-static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
+static unsigned long xol_get_insn_slot(unsigned char *insn)
 {
 	struct xol_area *area;
 	unsigned long offset;
@@ -1239,7 +1239,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 	/* Initialize the slot */
 	offset = xol_vaddr & ~PAGE_MASK;
 	vaddr = kmap_atomic(area->page);
-	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
+	memcpy(vaddr + offset, insn, MAX_UINSN_BYTES);
 	kunmap_atomic(vaddr);
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
@@ -1353,7 +1353,7 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
 	if (!utask)
 		return -ENOMEM;
 
-	xol_vaddr = xol_get_insn_slot(uprobe);
+	xol_vaddr = xol_get_insn_slot(uprobe->arch.insn);
 	if (!xol_vaddr)
 		return -ENOMEM;
 
-- 
1.8.1.2

