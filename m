Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab3AULtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:49:25 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55012 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3AULtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:49:24 -0500
X-AuditID: 85900ec0-d5e7ab900000152f-dc-50fd2b40b5ad
Message-ID: <50FD2B30.20100@hitachi.com>
Date: Mon, 21 Jan 2013 20:49:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, jbaron@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 3/5] kprobes: constify check_kprobe_address_safe and
 friends
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com> <1357772960-4436-3-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1357772960-4436-3-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/10 8:09), Sasha Levin wrote:
> Constify the parameters of lookup functions.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  arch/x86/kernel/kprobes-opt.c | 8 ++++----
>  kernel/kprobes.c              | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes-opt.c b/arch/x86/kernel/kprobes-opt.c
> index c5e410e..5876966 100644
> --- a/arch/x86/kernel/kprobes-opt.c
> +++ b/arch/x86/kernel/kprobes-opt.c
> @@ -192,7 +192,7 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
>  }
>  
>  /* Check whether insn is indirect jump */
> -static int __kprobes insn_is_indirect_jump(struct insn *insn)
> +static int __kprobes insn_is_indirect_jump(const struct insn *insn)
>  {
>  	return ((insn->opcode.bytes[0] == 0xff &&
>  		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
> @@ -200,7 +200,7 @@ static int __kprobes insn_is_indirect_jump(struct insn *insn)
>  }
>  
>  /* Check whether insn jumps into specified address range */
> -static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
> +static int insn_jump_into_range(const struct insn *insn, unsigned long start, int len)
>  {
>  	unsigned long target = 0;
>  

These are OK for me.

> @@ -278,7 +278,7 @@ static int __kprobes can_optimize(unsigned long paddr)
>  }
>  
>  /* Check optimized_kprobe can actually be optimized. */
> -int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
> +int __kprobes arch_check_optimized_kprobe(const struct optimized_kprobe *op)
>  {
>  	int i;
>  	struct kprobe *p;

This can be change optimized_kprobe inside, e.g. change flags.
IMHO, I don't like to change this interface.

> @@ -294,7 +294,7 @@ int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
>  
>  /* Check the addr is within the optimized instructions. */
>  int __kprobes
> -arch_within_optimized_kprobe(struct optimized_kprobe *op, unsigned long addr)
> +arch_within_optimized_kprobe(const struct optimized_kprobe *op, unsigned long addr)
>  {
>  	return ((unsigned long)op->kp.addr <= addr &&
>  		(unsigned long)op->kp.addr + op->optinsn.size > addr);

This is OK for me. But you need to update the prototype in
include/linux/kprobes.h too.

> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 098f396..7daddb0 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1402,7 +1402,7 @@ static inline int check_kprobe_rereg(struct kprobe *p)
>  	return ret;
>  }
>  
> -static __kprobes int check_kprobe_address_safe(struct kprobe *p,
> +static __kprobes int check_kprobe_address_safe(const struct kprobe *p,
>  					       struct module **probed_mod)
>  {
>  	int ret = 0;
> 

No, p is NOT constant in this function. This changes p->flags.

---
#ifdef KPROBES_CAN_USE_FTRACE
                /* Given address is not on the instruction boundary */
                if ((unsigned long)p->addr != ftrace_addr)
                        return -EILSEQ;
                p->flags |= KPROBE_FLAG_FTRACE;
#else   /* !KPROBES_CAN_USE_FTRACE */
---

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


