Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaLIGsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:48:06 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56018 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLIGsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:48:04 -0500
Message-ID: <54869B1C.6050401@hitachi.com>
Date: Tue, 09 Dec 2014 15:47:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND][PATCH v15 7/7] ARM: kprobes: enable OPTPROBES for ARM
 32
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com> <1418047765-53197-8-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1418047765-53197-8-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/08 23:09), Wang Nan wrote:
> This patch introduce kprobeopt for ARM 32.
> 
> Limitations:
>  - Currently only kernel compiled with ARM ISA is supported.
> 
>  - Offset between probe point and optinsn slot must not larger than
>    32MiB. Masami Hiramatsu suggests replacing 2 words, it will make
>    things complex. Futher patch can make such optimization.
> 
> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
> ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
> replace probed instruction by a 'b', branch to trampoline code and then
> calls optimized_callback(). optimized_callback() calls opt_pre_handler()
> to execute kprobe handler. It also emulate/simulate replaced instruction.
> 
> When unregistering kprobe, the deferred manner of unoptimizer may leave
> branch instruction before optimizer is called. Different from x86_64,
> which only copy the probed insn after optprobe_template_end and
> reexecute them, this patch call singlestep to emulate/simulate the insn
> directly. Futher patch can optimize this behavior.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
> v1 -> v2:
>  - Improvement: if replaced instruction is conditional, generate a
>    conditional branch instruction for it;
>  - Introduces RELATIVEJUMP_OPCODES due to ARM kprobe_opcode_t is 4
>    bytes;
>  - Removes size field in struct arch_optimized_insn;
>  - Use arm_gen_branch() to generate branch instruction;
>  - Remove all recover logic: ARM doesn't use tail buffer, no need
>    recover replaced instructions like x86;
>  - Remove incorrect CONFIG_THUMB checking;
>  - can_optimize() always returns true if address is well aligned;
>  - Improve optimized_callback: using opt_pre_handler();
>  - Bugfix: correct range checking code and improve comments;
>  - Fix commit message.
> 
> v2 -> v3:
>  - Rename RELATIVEJUMP_OPCODES to MAX_COPIED_INSNS;
>  - Remove unneeded checking:
>       arch_check_optimized_kprobe(), can_optimize();
>  - Add missing flush_icache_range() in arch_prepare_optimized_kprobe();
>  - Remove unneeded 'return;'.
> 
> v3 -> v4:
>  - Use __mem_to_opcode_arm() to translate copied_insn to ensure it
>    works in big endian kernel;
>  - Replace 'nop' placeholder in trampoline code template with
>    '.long 0' to avoid confusion: reader may regard 'nop' as an
>    instruction, but it is value in fact.
> 
> v4 -> v5:
>  - Don't optimize stack store operations.
>  - Introduce prepared field to arch_optimized_insn to indicate whether
>    it is prepared. Similar to size field with x86. See v1 -> v2.
> 
> v5 -> v6:
>  - Dynamically reserve stack according to instruction.
>  - Rename: kprobes-opt.c -> kprobes-opt-arm.c.
>  - Set op->optinsn.insn after all works are done.
> 
> v6 -> v7:
>   - Using checker to check stack consumption.
> 
> v7 -> v8:
>   - Small code adjustments.
> 
> v8 -> v9:
>   - Utilize original kprobe passed to arch_prepare_optimized_kprobe()
>     to avoid copy ainsn twice.
>   - A bug in arch_prepare_optimized_kprobe() is found and fixed.
> 
> v9 -> v10:
>   - Commit message improvements.
> 
> v10 -> v11:
>   - Move to arch/arm/probes/, insn.h is moved to arch/arm/include/asm.
>   - Code cleanup.
>   - Bugfix based on Tixy's test result:
>     - Trampoline deal with ARM -> Thumb transision instructions and
>       AEABI stack alignment requirement correctly.
>     - Trampoline code buffer should start at 4 byte aligned address.
>       We enforces it in this series by using macro to wrap 'code' var.
> 
> v11 -> v12:
>   - Remove trampoline code stack trick and use r4 to save original
>     stack.
>   - Remove trampoline code buffer alignment trick.
>   - Names of files are changed.
> 
> v12 -> v13:
>   - Assume stack always aligned by 4-bytes in any case.
>   - Comments update.
> 
> v13 -> v14:
>   - Use stop_machine to wrap arch_optimize_kprobes to avoid a racing.
> 
> v14 -> v15:
>   - In v14, stop_machine() wraps a coarse-grained piece of code which
>     makes things complex than it should be. In this version,
>     kprobes_remove_breakpoint() is extracted, core.c and opt-arm.c use it
>     to replace breakpoint to valid instruction. stop_machine() used inside
>     in kprobes_remove_breakpoint().
> ---
>  arch/arm/Kconfig                        |   1 +
>  arch/arm/{kernel => include/asm}/insn.h |   0
>  arch/arm/include/asm/kprobes.h          |  29 +++
>  arch/arm/kernel/Makefile                |   2 +-
>  arch/arm/kernel/ftrace.c                |   3 +-
>  arch/arm/kernel/jump_label.c            |   3 +-
>  arch/arm/probes/kprobes/Makefile        |   1 +
>  arch/arm/probes/kprobes/core.c          |  26 ++-
>  arch/arm/probes/kprobes/core.h          |   2 +
>  arch/arm/probes/kprobes/opt-arm.c       | 317 ++++++++++++++++++++++++++++++++
>  10 files changed, 372 insertions(+), 12 deletions(-)
>  rename arch/arm/{kernel => include/asm}/insn.h (100%)
>  create mode 100644 arch/arm/probes/kprobes/opt-arm.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89c4b5c..2471240 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -59,6 +59,7 @@ config ARM
>  	select HAVE_MEMBLOCK
>  	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
>  	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
> +	select HAVE_OPTPROBES if !THUMB2_KERNEL
>  	select HAVE_PERF_EVENTS
>  	select HAVE_PERF_REGS
>  	select HAVE_PERF_USER_STACK_DUMP
> diff --git a/arch/arm/kernel/insn.h b/arch/arm/include/asm/insn.h
> similarity index 100%
> rename from arch/arm/kernel/insn.h
> rename to arch/arm/include/asm/insn.h
> diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
> index 56f9ac6..50ff3bc 100644
> --- a/arch/arm/include/asm/kprobes.h
> +++ b/arch/arm/include/asm/kprobes.h
> @@ -50,5 +50,34 @@ int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
>  int kprobe_exceptions_notify(struct notifier_block *self,
>  			     unsigned long val, void *data);
>  
> +/* optinsn template addresses */
> +extern __visible kprobe_opcode_t optprobe_template_entry;
> +extern __visible kprobe_opcode_t optprobe_template_val;
> +extern __visible kprobe_opcode_t optprobe_template_call;
> +extern __visible kprobe_opcode_t optprobe_template_end;
> +extern __visible kprobe_opcode_t optprobe_template_sub_sp;
> +extern __visible kprobe_opcode_t optprobe_template_add_sp;
> +
> +#define MAX_OPTIMIZED_LENGTH	4
> +#define MAX_OPTINSN_SIZE				\
> +	((unsigned long)&optprobe_template_end -	\
> +	 (unsigned long)&optprobe_template_entry)
> +#define RELATIVEJUMP_SIZE	4
> +
> +struct arch_optimized_insn {
> +	/*
> +	 * copy of the original instructions.
> +	 * Different from x86, ARM kprobe_opcode_t is u32.
> +	 */
> +#define MAX_COPIED_INSN	DIV_ROUND_UP(RELATIVEJUMP_SIZE, sizeof(kprobe_opcode_t))
> +	kprobe_opcode_t copied_insn[MAX_COPIED_INSN];
> +	/* detour code buffer */
> +	kprobe_opcode_t *insn;
> +	/*
> +	 * We always copy one instruction on ARM,
> +	 * so size will always be 4, and unlike x86, there is no
> +	 * need for a size field.
> +	 */
> +};
>  
>  #endif /* _ARM_KPROBES_H */
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 40d3e00..1d0f4e7 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -52,7 +52,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
>  obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
>  # Main staffs in KPROBES are in arch/arm/probes/ .
> -obj-$(CONFIG_KPROBES)		+= patch.o
> +obj-$(CONFIG_KPROBES)		+= patch.o insn.o
>  obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
>  obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
>  obj-$(CONFIG_KGDB)		+= kgdb.o
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index af9a8a9..ec7e332 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -19,8 +19,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/opcodes.h>
>  #include <asm/ftrace.h>
> -
> -#include "insn.h"
> +#include <asm/insn.h>
>  
>  #ifdef CONFIG_THUMB2_KERNEL
>  #define	NOP		0xf85deb04	/* pop.w {lr} */
> diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
> index c6c73ed..35a8fbb 100644
> --- a/arch/arm/kernel/jump_label.c
> +++ b/arch/arm/kernel/jump_label.c
> @@ -1,8 +1,7 @@
>  #include <linux/kernel.h>
>  #include <linux/jump_label.h>
>  #include <asm/patch.h>
> -
> -#include "insn.h"
> +#include <asm/insn.h>
>  
>  #ifdef HAVE_JUMP_LABEL
>  
> diff --git a/arch/arm/probes/kprobes/Makefile b/arch/arm/probes/kprobes/Makefile
> index bc8d504..76a36bf 100644
> --- a/arch/arm/probes/kprobes/Makefile
> +++ b/arch/arm/probes/kprobes/Makefile
> @@ -7,5 +7,6 @@ obj-$(CONFIG_KPROBES)		+= actions-thumb.o checkers-thumb.o
>  test-kprobes-objs		+= test-thumb.o
>  else
>  obj-$(CONFIG_KPROBES)		+= actions-arm.o checkers-arm.o
> +obj-$(CONFIG_OPTPROBES)		+= opt-arm.o
>  test-kprobes-objs		+= test-arm.o
>  endif
> diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
> index 3a58db4..a4ec240 100644
> --- a/arch/arm/probes/kprobes/core.c
> +++ b/arch/arm/probes/kprobes/core.c
> @@ -163,19 +163,31 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
>   * memory. It is also needed to atomically set the two half-words of a 32-bit
>   * Thumb breakpoint.
>   */
> -int __kprobes __arch_disarm_kprobe(void *p)
> -{
> -	struct kprobe *kp = p;
> -	void *addr = (void *)((uintptr_t)kp->addr & ~1);
> -
> -	__patch_text(addr, kp->opcode);
> +struct patch {
> +	void *addr;
> +	unsigned int insn;
> +};
>  
> +static int __kprobes_remove_breakpoint(void *data)
> +{
> +	struct patch *p = data;
> +	__patch_text(p->addr, p->insn);
>  	return 0;
>  }
>  
> +void __kprobes kprobes_remove_breakpoint(void *addr, unsigned int insn)
> +{
> +	struct patch p = {
> +		.addr = addr,
> +		.insn = insn,
> +	};
> +	stop_machine(__kprobes_remove_breakpoint, &p, cpu_online_mask);
> +}

Hmm, I think finally we should fix patch_text() in patch.c to forcibly use stop_machine
by adding "bool stop" parameter, instead of introducing new another patch_text()
implementation, because we'd better avoid two private "patch" data structures.
Maybe someday we can find another better solution for self modifying.
(I actually doesn't like stop_machine() which disturbs real-time processing)

The other parts look good to me :)

Thank you!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


