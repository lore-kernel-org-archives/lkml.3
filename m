Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3KGOdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab3KGOdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:33:13 -0500
Date: Thu, 7 Nov 2013 15:34:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: preparations for arm port
Message-ID: <20131107143432.GA6240@redhat.com>
References: <20131106191913.GA18661@redhat.com> <20131107075151.GB31560@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107075151.GB31560@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > --- a/arch/powerpc/include/asm/uprobes.h
> > +++ b/arch/powerpc/include/asm/uprobes.h
> > @@ -37,6 +37,7 @@ typedef ppc_opcode_t uprobe_opcode_t;
> >  struct arch_uprobe {
> >  	union {
> >  		u8	insn[MAX_UINSN_BYTES];
> > +		u8	ixol[MAX_UINSN_BYTES];
> >  		u32	ainsn;
> >  	};
> >  };
>
> > --- a/arch/x86/include/asm/uprobes.h
> > +++ b/arch/x86/include/asm/uprobes.h
> > @@ -35,7 +35,10 @@ typedef u8 uprobe_opcode_t;
> >
> >  struct arch_uprobe {
> >  	u16				fixups;
> > -	u8				insn[MAX_UINSN_BYTES];
> > +	union {
> > +		u8			insn[MAX_UINSN_BYTES];
> > +		u8			ixol[MAX_UINSN_BYTES];
> > +	};
> >  #ifdef CONFIG_X86_64
> >  	unsigned long			rip_rela_target_address;
> >  #endif
>
> Btw., at least on the surface, the powerpc and x86 definitions seem rather
> similar, barring senseless variations. Would it make sense to generalize
> the data structure a bit more?

Heh. You know, I have another patch, see below. It was not tested yet, it
should be splitted into 3 changes, and we need to cleanup copy_insn() first.
I didn't sent it now because I wanted to merge the minimal changes which
allow us to avoid the new arm arch_upobe_* hooks. And of course it needs
the review.

But in short, I do not think we should try to unify/generalize insn/ixol.

For the moment, please ignore the patch which adds the new ->ixol member.

The generic code knows nothing about uprobe->arch, except: arch_uprobe
must have "u8 insn[MAX_UINSN_BYTES]". And this is why powerpc also has
arch_uprobe->ainsn, it defines ->insn to make the generic code happy.

Fortunately, array == &array, so we can remove this dependency and just
require arch_uprobe->insn of any type, this is what the patch below tries
to do.

> Also, we all hate data structures that are not self-documenting. What does
> 'ixol' mean and what is its role? Is it obvious to the reader of that
> file?

Probably it makes sense a comment near "struct uprobe" anyway, will try
to do this. But I think that with the patch below the role of insn/ixol
is obvious:

	arch_uprobe->insn: this is where we copy the original instruction,
	                   arch/ can do whatever it wants with this data.

	arch_uprobe->ixol: this is what we copy into xol slot, arch/ should
	                   initialize this data.

x86 and powerpc can use the same member, arm needs to create ixol != insn.

Note: we also have set_swbp() (which doesn't use ->insn) and

	set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
	{
		return uprobe_write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
	}

I _think_ this should be cleanuped too, but I am not sure and this will
conflict with the pending arm changes. So I am going to try to do this
later, after we merge arm port. And this is really minor.

Oleg.

 arch/powerpc/include/asm/uprobes.h |    5 ++---
 arch/powerpc/kernel/uprobes.c      |    2 +-
 kernel/events/uprobes.c            |   24 +++++++++++-------------
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index 75c6ecd..7422a99 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -36,9 +36,8 @@ typedef ppc_opcode_t uprobe_opcode_t;
 
 struct arch_uprobe {
 	union {
-		u8	insn[MAX_UINSN_BYTES];
-		u8	ixol[MAX_UINSN_BYTES];
-		u32	ainsn;
+		u32	insn;
+		u32	ixol;
 	};
 };
 
diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
index 59f419b..003b209 100644
--- a/arch/powerpc/kernel/uprobes.c
+++ b/arch/powerpc/kernel/uprobes.c
@@ -186,7 +186,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	 * emulate_step() returns 1 if the insn was successfully emulated.
 	 * For all other cases, we need to single-step in hardware.
 	 */
-	ret = emulate_step(regs, auprobe->ainsn);
+	ret = emulate_step(regs, auprobe->insn);
 	if (ret > 0)
 		return true;
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e615b78..aba4ce9 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -329,7 +329,7 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 int __weak
 set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	return uprobe_write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
+	return uprobe_write_opcode(mm, vaddr, *(uprobe_opcode_t *)&auprobe->insn);
 }
 
 static int match_uprobe(struct uprobe *l, struct uprobe *r)
@@ -504,7 +504,7 @@ static bool consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
 }
 
 static int
-__copy_insn(struct address_space *mapping, struct file *filp, char *insn,
+__copy_insn(struct address_space *mapping, struct file *filp, void *insn,
 			unsigned long nbytes, loff_t offset)
 {
 	struct page *page;
@@ -527,28 +527,26 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 
 static int copy_insn(struct uprobe *uprobe, struct file *filp)
 {
-	struct address_space *mapping;
-	unsigned long nbytes;
-	int bytes;
+	struct address_space *mapping = uprobe->inode->i_mapping;
+	int bytes = sizeof(uprobe->arch.insn);
+	void *insn = &uprobe->arch.insn;
+	int nbytes;
 
 	nbytes = PAGE_SIZE - (uprobe->offset & ~PAGE_MASK);
-	mapping = uprobe->inode->i_mapping;
 
 	/* Instruction at end of binary; copy only available bytes */
-	if (uprobe->offset + MAX_UINSN_BYTES > uprobe->inode->i_size)
+	if (uprobe->offset + bytes > uprobe->inode->i_size)
 		bytes = uprobe->inode->i_size - uprobe->offset;
-	else
-		bytes = MAX_UINSN_BYTES;
 
 	/* Instruction at the page-boundary; copy bytes in second page */
 	if (nbytes < bytes) {
-		int err = __copy_insn(mapping, filp, uprobe->arch.insn + nbytes,
+		int err = __copy_insn(mapping, filp, insn + nbytes,
 				bytes - nbytes, uprobe->offset + nbytes);
 		if (err)
 			return err;
 		bytes = nbytes;
 	}
-	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
+	return __copy_insn(mapping, filp, insn, bytes, uprobe->offset);
 }
 
 static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
@@ -569,7 +567,7 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 		goto out;
 
 	ret = -ENOTSUPP;
-	if (is_trap_insn((uprobe_opcode_t *)uprobe->arch.insn))
+	if (is_trap_insn((uprobe_opcode_t *)&uprobe->arch.insn))
 		goto out;
 
 	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
@@ -1257,7 +1255,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 
 	/* Initialize the slot */
 	copy_to_page(area->page, xol_vaddr,
-			uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
+			&uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
 	 * This should work on supported architectures too.

