Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3KSCcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:32:22 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59726 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3KSCcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:32:21 -0500
Message-ID: <528ACDB2.9040806@amacapital.net>
Date: Mon, 18 Nov 2013 18:32:18 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 04:27 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Properly patching running code ("cross modification")
> is a quite complicated business on x86.
> 
> The CPU has specific rules that need to be followed, including
> multiple global barriers.
> 
> Self modifying code is getting more popular, so it's important
> to make it easy to follow the rules.
> 
> The kernel does it properly with text_poke_bp(). But the same
> method is hard to do for user programs.
> 
> This patch adds a (x86 specific) text_poke() syscall that exposes
> the text_poke_bp() machinery to user programs.
> 
> The interface is practically the same as text_poke_bp, just as
> a syscall. I added an extra timeout parameter, that
> will potentially allow batching the global barriers in
> the future. Right now it is enforced to be 0.
> 
> The call also still has a global lock, so it has some scaling
> limitations. If it was commonly used this could be fixed
> by setting up a list of break point locations. Then
> a lock would only be hold to modify the list.
> 
> Right now the implementation is just as simple as possible.
> 
> Proposed man page:
> 
> NAME
> 	text_poke - Safely modify running instructions (x86)
> 
> SYNOPSYS
> 	int text_poke(void *addr, const void *opcode, size_t len,
> 	              void (*handler)(void), int timeout);
> 
> DESCRIPTION
> 	The text_poke system allows to safely modify code that may
> 	be currently executing in parallel on other threads.
> 	Patch the instruction at addr with the new instructions
> 	at opcode of length len. The target instruction will temporarily
> 	be patched with a break point, before it is replaced
> 	with the final replacement instruction. When the break point
> 	hits the code handler will be called in the context
> 	of the thread. The handler does not save any registers
> 	and cannot return. Typically it would consist of the
> 	original instruction and then a jump to after the original
> 	instruction. The handler is only needed during the
> 	patching process and can be overwritten once the syscall
> 	returns. timeout defines an optional timout to indicate
> 	to the kernel how long the patching could be delayed.
> 	Right now it has to be 0.
> 
> EXAMPLE
> 
> volatile int finished;
> 
> extern char patch[], recovery[], repl[];
> 
> struct res {
>         long total;
>         long val1, val2, handler;
> };
> 
> int text_poke(void *insn, void *repl, int len, void *handler, int to)
> {
>         return syscall(314, insn, repl, len, handler, to);
> }
> 
> void *tfunc(void *arg)
> {
>         struct res *res = (struct res *)arg;
> 
>         while (!finished) {
>                 int val;
>                 asm volatile(   ".globl patch\n"
>                                 ".globl recovery\n"
>                                 ".global repl\n"
> 				/* original code to be patched */
>                                 "patch: mov $1,%0\n"
>                                 "1:\n"
>                                 ".section \".text.patchup\",\"x\"\n"
> 				/* Called when a race happens during patching.
> 				   Just execute the original code and jump back. */
>                                 "recovery:\n"
>                                 " mov $3,%0\n"
>                                 " jmp 1b\n"
> 				/* replacement code that gets patched in: */
>                                 "repl:\n"
>                                 " mov $2,%0\n"
>                                 ".previous" : "=a" (val));
>                         if (val == 1)
>                                 res->val1++;
>                         else if (val == 3)
>                                 res->handler++;
>                         else
>                                 res->val2++;
>                         res->total++;
>         }
>         return NULL;
> }
> 
> int main(int ac, char **av)
> {
>         int ncpus = sysconf(_SC_NPROCESSORS_ONLN);
>         int ps = sysconf(_SC_PAGESIZE);
>         pthread_t pthr[ncpus];
>         struct res res[ncpus];
>         int i;
> 
>         srand(1);
>         memset(&res, 0, sizeof(struct res) * ncpus);
>         mprotect(patch - (unsigned long)patch % ps, ps,
> 		 PROT_READ|PROT_WRITE|PROT_EXEC);
>         for (i = 0; i < ncpus - 1; i++)
>                 pthread_create(&pthr[i], NULL, tfunc, &res[i]);
>         for (i = 0; i < 500000; i++) {
>                 text_poke(patch, repl, 5, recovery, 0);
>                 nanosleep(&((struct timespec) { 0, rand() % 100 }), NULL);
>                 text_poke(repl, patch, 5, recovery, 0);
>         }
>         finished = 1;
>         for (i = 0; i < ncpus - 1; i++) {
>                 pthread_join(pthr[i], NULL);
>                 printf("%d: val1 %lu val2 %lu handler %lu to %lu\n",
>                                 i, res[i].val1, res[i].val2, res[i].handler,
> 				res[i].total);
>                 assert(res[i].val1 + res[i].val2 + res[i].handler
> 				== res[i].total);
>         }
>         return 0;
> }
> 
> RETURN VALUE
> 	On success, text_poke returns 0, otherwise -1 is returned
> 	and errno is set appropiately.
> 
> ERRORS
> 	EINVAL		len was too long
> 			timeout was an invalid value
> 	EFAULT		An error happened while accessing opcode
> 
> VERSIONS
> 	text_poke has been added with the Linux XXX kernel.
> 
> CONFORMING TO
> 	The call is Linux and x86 specific and should not be used
> 	in programs intended to be portable.
> ---
>  arch/x86/kernel/alternative.c    | 121 ++++++++++++++++++++++++++++++++-------
>  arch/x86/syscalls/syscall_32.tbl |   1 +
>  arch/x86/syscalls/syscall_64.tbl |   1 +
>  3 files changed, 102 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index df94598..c143ff5 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -12,6 +12,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/slab.h>
>  #include <linux/kdebug.h>
> +#include <linux/syscalls.h>
>  #include <asm/alternative.h>
>  #include <asm/sections.h>
>  #include <asm/pgtable.h>
> @@ -538,6 +539,23 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
>  	return addr;
>  }
>  
> +static void __kprobes __text_poke(struct page **pages, 
> +				  int offset,
> +				  const void *opcode, size_t len);
> +
> +static void resolve_pages(struct page **pages, void *addr)
> +{
> +	if (!core_kernel_text((unsigned long)addr)) {
> +		pages[0] = vmalloc_to_page(addr);
> +		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> +	} else {
> +		pages[0] = virt_to_page(addr);
> +		WARN_ON(!PageReserved(pages[0]));
> +		pages[1] = virt_to_page(addr + PAGE_SIZE);
> +	}
> +	BUG_ON(!pages[0]);
> +}
> +
>  /**
>   * text_poke - Update instructions on a live kernel
>   * @addr: address to modify
> @@ -553,26 +571,27 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
>   */
>  void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  {
> +	struct page *pages[2];
> +
> +	resolve_pages(pages, addr);
> +	__text_poke(pages, (unsigned long)addr & ~PAGE_MASK,
> +		    opcode, len);
> +	return addr;
> +}
> +
> +static void __kprobes __text_poke(struct page **pages,
> +				   int offset,
> +				   const void *opcode, size_t len)
> +{
>  	unsigned long flags;
>  	char *vaddr;
> -	struct page *pages[2];
> -	int i;
>  
> -	if (!core_kernel_text((unsigned long)addr)) {
> -		pages[0] = vmalloc_to_page(addr);
> -		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> -	} else {
> -		pages[0] = virt_to_page(addr);
> -		WARN_ON(!PageReserved(pages[0]));
> -		pages[1] = virt_to_page(addr + PAGE_SIZE);
> -	}
> -	BUG_ON(!pages[0]);
>  	local_irq_save(flags);
>  	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
>  	if (pages[1])
>  		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
>  	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
> -	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> +	memcpy(&vaddr[offset], opcode, len);
>  	clear_fixmap(FIX_TEXT_POKE0);
>  	if (pages[1])
>  		clear_fixmap(FIX_TEXT_POKE1);
> @@ -580,10 +599,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>  	   that causes hangs on some VIA CPUs. */
> -	for (i = 0; i < len; i++)
> -		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
>  	local_irq_restore(flags);
> -	return addr;
>  }
>  
>  static void do_sync_core(void *info)
> @@ -593,6 +609,7 @@ static void do_sync_core(void *info)
>  
>  static bool bp_patching_in_progress;
>  static void *bp_int3_handler, *bp_int3_addr;
> +static struct mm_struct *bp_target_mm;
>  
>  int poke_int3_handler(struct pt_regs *regs)
>  {
> @@ -602,6 +619,14 @@ int poke_int3_handler(struct pt_regs *regs)
>  	if (likely(!bp_patching_in_progress))
>  		return 0;
>  
> +	if (user_mode_vm(regs) &&
> +		bp_target_mm &&
> +		current->mm == bp_target_mm &&
> +		regs->ip == (unsigned long)bp_int3_addr) {
> +		regs->ip = (unsigned long) bp_int3_handler;
> +		return 1;
> +	}
> +
>  	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
>  		return 0;
>  
> @@ -612,6 +637,9 @@ int poke_int3_handler(struct pt_regs *regs)
>  
>  }
>  
> +static void __text_poke_bp(struct page **pages, int offset,
> +			   const void *opcode, size_t len, void *handler);
> +
>  /**
>   * text_poke_bp() -- update instructions on live kernel on SMP
>   * @addr:	address to patch
> @@ -636,10 +664,22 @@ int poke_int3_handler(struct pt_regs *regs)
>   */
>  void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  {
> +	struct page *pages[2];
> +
> +	resolve_pages(pages, addr);
> +	bp_int3_addr = (u8 *)addr + 1;
> +	__text_poke_bp(pages, (unsigned long)addr & ~PAGE_MASK,
> +		       opcode, len, handler);
> +	return addr;
> +}
> +
> +/* Caller must set up bp_int3_addr and hold text_mutex */
> +static void __text_poke_bp(struct page **pages, int offset,
> +		     const void *opcode, size_t len, void *handler)
> +{
>  	unsigned char int3 = 0xcc;
>  
>  	bp_int3_handler = handler;
> -	bp_int3_addr = (u8 *)addr + sizeof(int3);
>  	bp_patching_in_progress = true;
>  	/*
>  	 * Corresponding read barrier in int3 notifier for
> @@ -648,13 +688,14 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	 */
>  	smp_wmb();
>  
> -	text_poke(addr, &int3, sizeof(int3));
> +	__text_poke(pages, offset, &int3, sizeof(int3));
>  
>  	on_each_cpu(do_sync_core, NULL, 1);
>  
>  	if (len - sizeof(int3) > 0) {
>  		/* patch all but the first byte */
> -		text_poke((char *)addr + sizeof(int3),
> +		__text_poke(pages, 
> +			  offset + sizeof(int3),
>  			  (const char *) opcode + sizeof(int3),
>  			  len - sizeof(int3));
>  		/*
> @@ -666,13 +707,51 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	}
>  
>  	/* patch the first byte */
> -	text_poke(addr, opcode, sizeof(int3));
> +	__text_poke(pages, offset, opcode, sizeof(int3));
>  
>  	on_each_cpu(do_sync_core, NULL, 1);
>  
>  	bp_patching_in_progress = false;
>  	smp_wmb();
> -
> -	return addr;
>  }
>  
> +#define MAX_INSN_LEN 32
> +
> +SYSCALL_DEFINE5(text_poke,
> +		__user void *, addr,
> +		const void *, opcode, 
> +		size_t, len,
> +		void *, handler,
> +		int, timeout)
> +{
> +	struct page *pages[2];
> +	char insn[MAX_INSN_LEN];
> +	int err, npages;
> +
> +	if ((unsigned long)len > MAX_INSN_LEN || len == 0)
> +		return -EINVAL;
> +	/* For future extension */
> +	if (timeout != 0)
> +		return -EINVAL;
> +	if (copy_from_user(insn, opcode, len))
> +		return -EFAULT;
> +	pages[1] = NULL;
> +	npages = ((unsigned long)addr & PAGE_MASK) == 
> +		(((unsigned long)addr + len) & PAGE_MASK) ? 1 : 2;

This is off by one, I think.  That should be addr + len - 1.

> +	err = get_user_pages_fast((unsigned long)addr, npages, 1, pages);
> +	if (err < 0)
> +		return err;
> +	err = 0;
> +	mutex_lock(&text_mutex);
> +	bp_target_mm = current->mm;
> +	bp_int3_addr = (u8 *)addr + 1;

Do you need an smp_wmb here?  (Maybe there's a strong enough barrier in
__text_poke_bp.)

It might pay to verify that the pages are executable, although I don't
see what the harm would be to poking at non-executable pages.

--Andy
