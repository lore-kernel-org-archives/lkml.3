Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3KDTr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 14:47:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab3KDTr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 14:47:56 -0500
Date: Mon, 4 Nov 2013 20:49:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [PATCH] uprobes: introduce arch_uprobe->ixol
Message-ID: <20131104194901.GA28022@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-4-git-send-email-dave.long@linaro.org> <20131019163627.GA7837@redhat.com> <52671265.2020107@linaro.org> <20131029154006.GA22344@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029154006.GA22344@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Oleg Nesterov wrote:
>
> David. Perhaps we can avoid the new hook altogether? What if we do
> the simple change below (it ignores powerpc) ?
>
> Then arm can add "unsigned long ixol[2]" into its arch_uprobe, and
> arch_uprobe_analyze_insn() can initialize this member correctly.
>
> What do you think?

Seriouly, how about the patch below?

In fact, given that you are going to reimplement set_swbp/orig_insn,
the new member is not strictly needed (afaics). But it looks more
clear this way, and we need s/MAX_UINSN_BYTES/sizeof()/ anyway.

Oleg.
---

Subject: [PATCH] uprobes: introduce arch_uprobe->ixol

Currently xol_get_insn_slot() assumes that we should simply copy
arch_uprobe->insn[] which is (ignoring arch_uprobe_analyze_insn)
just the copy of the original insn.

This is not true for arm which needs to create another insn to
execute it out-of-line.

So this patch simply adds the new member, ->ixol into the union.
This doesn't make any difference for x86 and powerpc, but arm
can divorce insn/ixol and initialize the correct xol insn in
arch_uprobe_analyze_insn().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/powerpc/include/asm/uprobes.h |    1 +
 arch/x86/include/asm/uprobes.h     |    5 ++++-
 kernel/events/uprobes.c            |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index 2301602..541fd6f 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -37,6 +37,7 @@ typedef ppc_opcode_t uprobe_opcode_t;
 struct arch_uprobe {
 	union {
 		u8	insn[MAX_UINSN_BYTES];
+		u8	ixol[MAX_UINSN_BYTES];
 		u32	ainsn;
 	};
 };
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 6e51979..2a24180 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -35,7 +35,10 @@ typedef u8 uprobe_opcode_t;
 
 struct arch_uprobe {
 	u16				fixups;
-	u8				insn[MAX_UINSN_BYTES];
+	union {
+		u8			insn[MAX_UINSN_BYTES];
+		u8			ixol[MAX_UINSN_BYTES];
+	};
 #ifdef CONFIG_X86_64
 	unsigned long			rip_rela_target_address;
 #endif
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ad8e1bd..6aef5ad 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1256,7 +1256,8 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 		return 0;
 
 	/* Initialize the slot */
-	copy_to_page(area->page, xol_vaddr, uprobe->arch.insn, MAX_UINSN_BYTES);
+	copy_to_page(area->page, xol_vaddr,
+			uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
 	 * This should work on supported architectures too.
-- 
1.5.5.1


