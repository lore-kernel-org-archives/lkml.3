Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaD1U3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:29:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbaD1U3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:29:20 -0400
Date: Mon, 28 Apr 2014 19:34:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] uprobes: use BX register for rip-relative fixups, not
	AX
Message-ID: <20140428173432.GA27363@redhat.com>
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com> <1398704774-25173-2-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398704774-25173-2-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks...

Again, the change in riprel_analyze() needs the review from someone
who understands the instruction decoding/encoding.

On 04/28, Denys Vlasenko wrote:
>
> Otherwise, instructions such as cmpxchg and div will be mishandled.

It seems that you are right. But it would be really great if you also
provide the test-case which proves the fix ;)

> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Jim Keniston <jkenisto@us.ibm.com>
> CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/uprobes.c | 57 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index ae6df8e..bc70182 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -41,7 +41,7 @@
>  /* Instruction will modify TF, don't change it */
>  #define UPROBE_FIX_SETF		0x04
>  
> -#define UPROBE_FIX_RIP_AX	0x08
> +#define UPROBE_FIX_RIP_BX	0x08
>  #define UPROBE_FIX_RIP_CX	0x10
>  
>  #define	UPROBE_TRAP_NR		UINT_MAX
> @@ -282,7 +282,7 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  	/*
>  	 * insn_rip_relative() would have decoded rex_prefix, modrm.
>  	 * Clear REX.b bit (extension of MODRM.rm field):
> -	 * we want to encode rax/rcx, not r8/r9.
> +	 * we want to encode rbx/rcx, not r11/r9.
>  	 */
>  	if (insn->rex_prefix.nbytes) {
>  		cursor = auprobe->insn + insn_offset_rex_prefix(insn);
> @@ -296,41 +296,58 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  	 */
>  	cursor = auprobe->insn + insn_offset_modrm(insn);
>  	/*
> -	 * Convert from rip-relative addressing to register-relative addressing
> -	 * via a scratch register.
> +	 * Convert from rip-relative addressing
> +	 * to register-relative addressing via a scratch register.
>  	 */
>  	reg = MODRM_REG(insn);
> -	if (reg == 0) {
> +	if (reg == 3) {
>  		/*
> -		 * The register operand (if any) is either the A register
> -		 * (%rax, %eax, etc.) or (if the 0x4 bit is set in the
> -		 * REX prefix) %r8.  In any case, we know the C register
> +		 * The register operand (if any) is either the B register
> +		 * (%rbx, %ebx, etc.) or (if the 0x4 bit is set in the
> +		 * REX prefix) %r11.  In any case, we know the C register
>  		 * is NOT the register operand, so we use %rcx (register
>  		 * #1) for the scratch register.
>  		 */
>  		auprobe->def.fixups |= UPROBE_FIX_RIP_CX;
>  		/*
> -		 * Change modrm from "00 000 101" to "10 000 001". Example:
> -		 * 89 05 disp32  mov %eax,disp32(%rip) becomes
> -		 * 89 81 disp32  mov %eax,disp32(%rcx)
> +		 * Change modrm from "00 011 101" to "10 011 001". Example:
> +		 * 89 1d disp32  mov %ebx,disp32(%rip) becomes
> +		 * 89 99 disp32  mov %ebx,disp32(%rcx)
>  		 */
> -		*cursor = 0x81;
> +		*cursor = 0x99;
>  	} else {
> -		/* Use %rax (register #0) for the scratch register. */
> -		auprobe->def.fixups |= UPROBE_FIX_RIP_AX;
> +		/* Use %rbx (register #3) for the scratch register. */
> +		auprobe->def.fixups |= UPROBE_FIX_RIP_BX;
>  		/*
> -		 * Change modrm from "00 reg 101" to "10 reg 000". Example:
> +		 * Change modrm from "00 reg 101" to "10 reg 011". Example:
>  		 * 89 1d disp32  mov %edx,disp32(%rip) becomes
> -		 * 89 98 disp32  mov %edx,disp32(%rax)
> +		 * 89 9b disp32  mov %edx,disp32(%rbx)
>  		 */
> -		*cursor = (reg << 3) | 0x80;
> +		*cursor = (reg << 3) | 0x83;
>  	}
> +	/*
> +	 * Note: we can't use rax or rdx registers as scratch!
> +	 * There are 3-operand insns which use rax or rdx:rax
> +	 * as an implicit operand, _and_ they use modrm byte
> +	 * whose reg field indicates third register or opcode extension.
> +	 * In particular, these insns:
> +	 *  f7/6 r/m        div r/m
> +	 *  0f b1 r/m       cmpxchg r/m,reg
> +	 *  0f c7/1 mem     cmpxchg{8b,16b} mem
> +	 * Looking at "reg" field won't allow to detect that rax or rdx
> +	 * are in use.
> +	 *
> +	 * FIXME: handle vex-encoded 3-operand insns too:
> +	 *  c4 e2 60 f7 0d disp32  bextr %ebx,disp32(%rip),%ecx
> +	 * %ebx is encoded in the vex.vvvv field, which we don't check
> +	 * (in this example, it's in byte 60 bits 6..3).
> +	 */
>  }
>  
>  static inline unsigned long *
>  scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	return (auprobe->def.fixups & UPROBE_FIX_RIP_AX) ? &regs->ax : &regs->cx;
> +	return (auprobe->def.fixups & UPROBE_FIX_RIP_BX) ? &regs->bx : &regs->cx;
>  }
>  
>  /*
> @@ -339,7 +356,7 @@ scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
>   */
>  static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
> +	if (auprobe->def.fixups & (UPROBE_FIX_RIP_BX | UPROBE_FIX_RIP_CX)) {
>  		struct uprobe_task *utask = current->utask;
>  		unsigned long *sr = scratch_reg(auprobe, regs);
>  
> @@ -350,7 +367,7 @@ static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  
>  static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
> +	if (auprobe->def.fixups & (UPROBE_FIX_RIP_BX | UPROBE_FIX_RIP_CX)) {
>  		struct uprobe_task *utask = current->utask;
>  		unsigned long *sr = scratch_reg(auprobe, regs);
>  
> -- 
> 1.8.1.4
> 

