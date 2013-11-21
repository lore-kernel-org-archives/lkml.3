Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3KUSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:25:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3KUSZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:25:27 -0500
Date: Thu, 21 Nov 2013 19:26:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131121182623.GA21535@redhat.com>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can't really comment this patch, just a couple of nits...

On 11/18, Andi Kleen wrote:
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

This looks a bit confusing, afaics we can avoid the duplications:

	// also handles bp_target_mm == NULL case
	if (user_mode_vm(regs) && current->mm != bp_target_mm)
		return 0;

	if (regs->ip != (unsigned long)bp_int3_addr)
		return 0;

	/* set up the specified breakpoint handler */
	regs->ip = (unsigned long) bp_int3_handler;

	return 1;

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
> +	err = get_user_pages_fast((unsigned long)addr, npages, 1, pages);
> +	if (err < 0)
> +		return err;
> +	err = 0;
> +	mutex_lock(&text_mutex);
> +	bp_target_mm = current->mm;
> +	bp_int3_addr = (u8 *)addr + 1;
> +	__text_poke_bp(pages, 
> +		       (unsigned long)addr & ~PAGE_MASK,
> +		       insn, len, handler);

This doesn't look right if npages == 2 but get_user_pages_fast() returns 1.

__text_poke() checks pages[1] != NULL, but in this case it assumes
that memcpy(vaddr, opcode, len) should fit into the 1st page.


Ingo, Andi, I do not think that it is good idea to implement this
via ptrace. If nothing else, you need to fork the tracer which can
do PTRACE_POKETEXT.

Please note that PTRACE_TRACEME does not mean self-tracing, it means
that current->real_parent becomes the tracer (imho this interface
should die but we obviously can't kill it). So I don't see how it
can help. And you can't ptrace yourself of a sub-thread, this is
explicitly forbidden by ptrace_attach()->same_thread_group() check.

And ptrace can't really help with CLONE_VM tasks.

Or I misunderstood the suggestion.

Oleg.

