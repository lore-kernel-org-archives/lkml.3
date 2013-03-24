Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3CXSXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 14:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab3CXSXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 14:23:33 -0400
Date: Sun, 24 Mar 2013 19:21:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 1/5] uprobes: Turn copy_opcode() into copy_from_page()
Message-ID: <20130324182110.GA13301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324182040.GA13078@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Rename copy_opcode() into copy_from_page() and
add the new "int len" argument to make it more more generic for the
new users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5c273b3..d6891cb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -173,10 +173,10 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
 	return *insn == UPROBE_SWBP_INSN;
 }
 
-static void copy_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *opcode)
+static void copy_from_page(struct page *page, unsigned long vaddr, void *dst, int len)
 {
 	void *kaddr = kmap_atomic(page);
-	memcpy(opcode, kaddr + (vaddr & ~PAGE_MASK), UPROBE_SWBP_INSN_SIZE);
+	memcpy(dst, kaddr + (vaddr & ~PAGE_MASK), len);
 	kunmap_atomic(kaddr);
 }
 
@@ -185,7 +185,7 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
 	uprobe_opcode_t old_opcode;
 	bool is_swbp;
 
-	copy_opcode(page, vaddr, &old_opcode);
+	copy_from_page(page, vaddr, &old_opcode, UPROBE_SWBP_INSN_SIZE);
 	is_swbp = is_swbp_insn(&old_opcode);
 
 	if (is_swbp_insn(new_opcode)) {
@@ -1449,7 +1449,7 @@ static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
 	if (result < 0)
 		return result;
 
-	copy_opcode(page, vaddr, &opcode);
+	copy_from_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 	put_page(page);
  out:
 	return is_swbp_insn(&opcode);
-- 
1.5.5.1

