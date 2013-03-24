Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3CXSXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 14:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3CXSXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 14:23:45 -0400
Date: Sun, 24 Mar 2013 19:21:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 5/5] uprobes: Change write_opcode() to use copy_*page()
Message-ID: <20130324182125.GA13327@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324182040.GA13078@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change write_opcode() to use copy_highpage() + copy_to_page()
and simplify the code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 9d943f7..72f03d4 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -232,7 +232,6 @@ static int write_opcode(struct mm_struct *mm, unsigned long vaddr,
 			uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
-	void *vaddr_old, *vaddr_new;
 	struct vm_area_struct *vma;
 	int ret;
 
@@ -253,15 +252,8 @@ retry:
 
 	__SetPageUptodate(new_page);
 
-	/* copy the page now that we've got it stable */
-	vaddr_old = kmap_atomic(old_page);
-	vaddr_new = kmap_atomic(new_page);
-
-	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
-	memcpy(vaddr_new + (vaddr & ~PAGE_MASK), &opcode, UPROBE_SWBP_INSN_SIZE);
-
-	kunmap_atomic(vaddr_new);
-	kunmap_atomic(vaddr_old);
+	copy_highpage(new_page, old_page);
+	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 
 	ret = anon_vma_prepare(vma);
 	if (ret)
-- 
1.5.5.1

