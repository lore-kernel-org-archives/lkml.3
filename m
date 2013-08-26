Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3HZCg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:36:27 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36059 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3HZCg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:36:26 -0400
Message-ID: <521ABF22.4030903@hitachi.com>
Date: Mon, 26 Aug 2013 11:36:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [Patch v2 3/3] s390/kprobes: add support for pc-relative long
 displacement instructions
References: <1377255854-30163-1-git-send-email-heiko.carstens@de.ibm.com> <1377255854-30163-4-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1377255854-30163-4-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/23 20:04), Heiko Carstens wrote:
> With the general-instruction extension facility (z10) a couple of
> instructions with a pc-relative long displacement were introduced.
> The kprobes support for these instructions however was never implemented.
> 
> In result, if anybody ever put a probe on any of these instructions the
> result would have been random behaviour after the instruction got executed
> within the insn slot.
> 
> So lets add the missing handling for these instructions. Since all of the
> new instructions have 32 bit signed displacement the easiest solution is
> to allocate an insn slot that is within the same 2GB area like the original
> instruction and patch the displacement field.
> 

At least generic kprobes flow looks good for me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/include/asm/kprobes.h |    4 +-
>  arch/s390/kernel/kprobes.c      |  144 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 140 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kprobes.h b/arch/s390/include/asm/kprobes.h
> index dcf6948..4176dfe 100644
> --- a/arch/s390/include/asm/kprobes.h
> +++ b/arch/s390/include/asm/kprobes.h
> @@ -31,6 +31,8 @@
>  #include <linux/ptrace.h>
>  #include <linux/percpu.h>
>  
> +#define __ARCH_WANT_KPROBES_INSN_SLOT
> +
>  struct pt_regs;
>  struct kprobe;
>  
> @@ -57,7 +59,7 @@ typedef u16 kprobe_opcode_t;
>  /* Architecture specific copy of original instruction */
>  struct arch_specific_insn {
>  	/* copy of original instruction */
> -	kprobe_opcode_t insn[MAX_INSN_SIZE];
> +	kprobe_opcode_t *insn;
>  };
>  
>  struct prev_kprobe {
> diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
> index 3388b2b..cb7ac9e 100644
> --- a/arch/s390/kernel/kprobes.c
> +++ b/arch/s390/kernel/kprobes.c
> @@ -37,6 +37,26 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
>  struct kretprobe_blackpoint kretprobe_blacklist[] = { };
>  
> +DEFINE_INSN_CACHE_OPS(dmainsn);
> +
> +static void *alloc_dmainsn_page(void)
> +{
> +	return (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
> +}
> +
> +static void free_dmainsn_page(void *page)
> +{
> +	free_page((unsigned long)page);
> +}
> +
> +struct kprobe_insn_cache kprobe_dmainsn_slots = {
> +	.mutex = __MUTEX_INITIALIZER(kprobe_dmainsn_slots.mutex),
> +	.alloc = alloc_dmainsn_page,
> +	.free = free_dmainsn_page,
> +	.pages = LIST_HEAD_INIT(kprobe_dmainsn_slots.pages),
> +	.insn_size = MAX_INSN_SIZE,
> +};
> +
>  static int __kprobes is_prohibited_opcode(kprobe_opcode_t *insn)
>  {
>  	switch (insn[0] >> 8) {
> @@ -100,9 +120,8 @@ static int __kprobes get_fixup_type(kprobe_opcode_t *insn)
>  			fixup |= FIXUP_RETURN_REGISTER;
>  		break;
>  	case 0xc0:
> -		if ((insn[0] & 0x0f) == 0x00 ||	/* larl  */
> -		    (insn[0] & 0x0f) == 0x05)	/* brasl */
> -		fixup |= FIXUP_RETURN_REGISTER;
> +		if ((insn[0] & 0x0f) == 0x05)	/* brasl */
> +			fixup |= FIXUP_RETURN_REGISTER;
>  		break;
>  	case 0xeb:
>  		if ((insn[2] & 0xff) == 0x44 ||	/* bxhg  */
> @@ -117,18 +136,128 @@ static int __kprobes get_fixup_type(kprobe_opcode_t *insn)
>  	return fixup;
>  }
>  
> +static int __kprobes is_insn_relative_long(kprobe_opcode_t *insn)
> +{
> +	/* Check if we have a RIL-b or RIL-c format instruction which
> +	 * we need to modify in order to avoid instruction emulation. */
> +	switch (insn[0] >> 8) {
> +	case 0xc0:
> +		if ((insn[0] & 0x0f) == 0x00) /* larl */
> +			return true;
> +		break;
> +	case 0xc4:
> +		switch (insn[0] & 0x0f) {
> +		case 0x02: /* llhrl  */
> +		case 0x04: /* lghrl  */
> +		case 0x05: /* lhrl   */
> +		case 0x06: /* llghrl */
> +		case 0x07: /* sthrl  */
> +		case 0x08: /* lgrl   */
> +		case 0x0b: /* stgrl  */
> +		case 0x0c: /* lgfrl  */
> +		case 0x0d: /* lrl    */
> +		case 0x0e: /* llgfrl */
> +		case 0x0f: /* strl   */
> +			return true;
> +		}
> +		break;
> +	case 0xc6:
> +		switch (insn[0] & 0x0f) {
> +		case 0x00: /* exrl   */
> +		case 0x02: /* pfdrl  */
> +		case 0x04: /* cghrl  */
> +		case 0x05: /* chrl   */
> +		case 0x06: /* clghrl */
> +		case 0x07: /* clhrl  */
> +		case 0x08: /* cgrl   */
> +		case 0x0a: /* clgrl  */
> +		case 0x0c: /* cgfrl  */
> +		case 0x0d: /* crl    */
> +		case 0x0e: /* clgfrl */
> +		case 0x0f: /* clrl   */
> +			return true;
> +		}
> +		break;
> +	}
> +	return false;
> +}
> +
> +static void __kprobes copy_instruction(struct kprobe *p)
> +{
> +	s64 disp, new_disp;
> +	u64 addr, new_addr;
> +
> +	memcpy(p->ainsn.insn, p->addr, ((p->opcode >> 14) + 3) & -2);
> +	if (!is_insn_relative_long(p->ainsn.insn))
> +		return;
> +	/*
> +	 * For pc-relative instructions in RIL-b or RIL-c format patch the
> +	 * RI2 displacement field. We have already made sure that the insn
> +	 * slot for the patched instruction is within the same 2GB area
> +	 * as the original instruction (either kernel image or module area).
> +	 * Therefore the new displacement will always fit.
> +	 */
> +	disp = *(s32 *)&p->ainsn.insn[1];
> +	addr = (u64)(unsigned long)p->addr;
> +	new_addr = (u64)(unsigned long)p->ainsn.insn;
> +	new_disp = ((addr + (disp * 2)) - new_addr) / 2;
> +	*(s32 *)&p->ainsn.insn[1] = new_disp;
> +}
> +
> +static inline int is_kernel_addr(void *addr)
> +{
> +	return addr < (void *)_end;
> +}
> +
> +static inline int is_module_addr(void *addr)
> +{
> +#ifdef CONFIG_64BIT
> +	BUILD_BUG_ON(MODULES_LEN > (1UL << 31));
> +	if (addr < (void *)MODULES_VADDR)
> +		return 0;
> +	if (addr > (void *)MODULES_END)
> +		return 0;
> +#endif
> +	return 1;
> +}
> +
> +static int __kprobes s390_get_insn_slot(struct kprobe *p)
> +{
> +	/*
> +	 * Get an insn slot that is within the same 2GB area like the original
> +	 * instruction. That way instructions with a 32bit signed displacement
> +	 * field can be patched and executed within the insn slot.
> +	 */
> +	p->ainsn.insn = NULL;
> +	if (is_kernel_addr(p->addr))
> +		p->ainsn.insn = get_dmainsn_slot();
> +	if (is_module_addr(p->addr))
> +		p->ainsn.insn = get_insn_slot();
> +	return p->ainsn.insn ? 0 : -ENOMEM;
> +}
> +
> +static void __kprobes s390_free_insn_slot(struct kprobe *p)
> +{
> +	if (!p->ainsn.insn)
> +		return;
> +	if (is_kernel_addr(p->addr))
> +		free_dmainsn_slot(p->ainsn.insn, 0);
> +	else
> +		free_insn_slot(p->ainsn.insn, 0);
> +	p->ainsn.insn = NULL;
> +}
> +
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
>  	if ((unsigned long) p->addr & 0x01)
>  		return -EINVAL;
> -
>  	/* Make sure the probe isn't going on a difficult instruction */
>  	if (is_prohibited_opcode(p->addr))
>  		return -EINVAL;
> -
> +	if (s390_get_insn_slot(p))
> +		return -ENOMEM;
>  	p->opcode = *p->addr;
> -	memcpy(p->ainsn.insn, p->addr, ((p->opcode >> 14) + 3) & -2);
> -
> +	copy_instruction(p);
>  	return 0;
>  }
>  
> @@ -169,6 +298,7 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
>  {
> +	s390_free_insn_slot(p);
>  }
>  
>  static void __kprobes enable_singlestep(struct kprobe_ctlblk *kcb,
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


