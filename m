Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3KIRwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:52:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302Ab3KIRwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:52:44 -0500
Date: Sat, 9 Nov 2013 18:54:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] uprobes: Don't assume that arch_uprobe->insn/ixol is
	u8[MAX_UINSN_BYTES]
Message-ID: <20131109175406.GA17430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109175350.GA17412@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_uprobe should be opaque as much as possible to the generic
code, but currently it assumes that insn/ixol must be u8[] of the
known size. Remove this unnecessary dependency, we can use "&" and
and sizeof() with the same effect.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2546a7b..acc0317 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -330,7 +330,7 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 int __weak
 set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	return uprobe_write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
+	return uprobe_write_opcode(mm, vaddr, *(uprobe_opcode_t *)&auprobe->insn);
 }
 
 static int match_uprobe(struct uprobe *l, struct uprobe *r)
@@ -529,8 +529,8 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
 {
 	struct address_space *mapping = uprobe->inode->i_mapping;
 	loff_t offs = uprobe->offset;
-	void *insn = uprobe->arch.insn;
-	int size = MAX_UINSN_BYTES;
+	void *insn = &uprobe->arch.insn;
+	int size = sizeof(uprobe->arch.insn);
 	int len, err = -EIO;
 
 	/* Copy only available bytes, -EIO if nothing was read */
@@ -569,7 +569,7 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 		goto out;
 
 	ret = -ENOTSUPP;
-	if (is_trap_insn((uprobe_opcode_t *)uprobe->arch.insn))
+	if (is_trap_insn((uprobe_opcode_t *)&uprobe->arch.insn))
 		goto out;
 
 	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
@@ -1264,7 +1264,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 
 	/* Initialize the slot */
 	copy_to_page(area->page, xol_vaddr,
-			uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
+			&uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
 	 * This should work on supported architectures too.
-- 
1.5.5.1

