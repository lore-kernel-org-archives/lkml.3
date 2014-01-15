Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaAOAdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:33:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:15668 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751920AbaAOAdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:33:42 -0500
Date: Tue, 14 Jan 2014 19:33:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 3/8] x86: add generic function to modify more calls
 using int3 framework
Message-ID: <20140114193338.4375f205@gandalf.local.home>
In-Reply-To: <1386690140-19941-4-git-send-email-pmladek@suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-4-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 16:42:15 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index 586747f5f41d..82ffe7e1529c 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -232,4 +232,40 @@ extern int text_poke_bp(void *addr, const void *opcode, size_t len,
>  extern void text_poke_bp_or_die(void *addr, const void *opcode, size_t len,
>  				void *handler);

Small nit. If you can, place comments on the same line as the
structure field.
  
> +struct text_poke_bp_iter {
> +	/* information used to start iteration from the beginning */
> +	void *init;
> +	/* length of the patched instruction */
> +	size_t len;
> +	/* details about failure if any */
> +	int fail_count;
> +	void *fail_addr;

The above should have the comments on the same line as the field.
Something like this:

	void		*init;	/* information used to start
	iteration from the beginning */

The comments for the function pointers below are fine.

> +	/* iteration over entries */
> +	void *(*start)(void *init);
> +	void *(*next)(void *prev);
> +	/* callback to get patched address */
> +	void *(*get_addr)(void *cur);
> +	/*
> +	 * Callbacks to get the patched code. They could return NULL if no
> +	 * patching is needed; This is useful for example in ftrace.
> +	 */
> +	const void *(*get_opcode)(void *cur);
> +	const void *(*get_old_opcode)(void *cur);
> +	/*
> +	 * Optional function that is called when the patching of the given
> +	 * has finished. It might be NULL if no postprocess is needed.
> +	 */
> +	int (*finish)(void *cur);
> +	/*
> +	 * Helper function for int3 handler. It decides whether the given IP
> +	 * is being patched or not.
> +	 *
> +	 * Try to implement it as fast as possible. It affects performance
> +	 * of the system when the patching is in progress.
> +	 */
> +	void *(*is_handled)(const unsigned long ip);
> +};
> +
> +extern int text_poke_bp_list(struct text_poke_bp_iter *iter);
> +
>  #endif /* _ASM_X86_ALTERNATIVE_H */
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 6436beec7b0c..8e57ac03a0e8 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -7,6 +7,7 @@
>  #include <linux/stringify.h>
>  #include <linux/kprobes.h>
>  #include <linux/mm.h>
> +#include <linux/uaccess.h>
>  #include <linux/vmalloc.h>
>  #include <linux/memory.h>
>  #include <linux/stop_machine.h>
> @@ -610,8 +611,11 @@ static void run_sync(void)
>  		on_each_cpu(do_sync_core, NULL, 1);
>  }
>  
> +static char bp_int3;

bp_int3 is not going to be anything but 0xcc. Let's change that to:

static char bp_int3 = 0xcc;

And remove the other initializations.

>  static bool bp_patching_in_progress;
>  static void *bp_int3_handler, *bp_int3_addr;
> +static size_t bp_int3_len;
> +static void *(*bp_int3_is_handled)(const unsigned long ip);
>  
>  int poke_int3_handler(struct pt_regs *regs)
>  {
> @@ -621,14 +625,23 @@ int poke_int3_handler(struct pt_regs *regs)
>  	if (likely(!bp_patching_in_progress))
>  		return 0;
>  
> -	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
> +	if (user_mode_vm(regs))
>  		return 0;
>  
> -	/* set up the specified breakpoint handler */
> -	regs->ip = (unsigned long) bp_int3_handler;
> +	/* Check if address is handled by text_poke_bp */
> +	if (bp_int3_handler && regs->ip == (unsigned long)bp_int3_addr) {
> +		regs->ip = (unsigned long)bp_int3_handler;
> +		return 1;
> +	}
>  
> -	return 1;
> +	/* Check if address is handled by text_poke_bp_list */
> +	if (bp_int3_is_handled && bp_int3_is_handled(regs->ip)) {
> +		/* just skip the instruction */
> +		regs->ip += bp_int3_len - 1;
> +		return 1;
> +	}
>  
> +	return 0;
>  }
>  
>  /**
> @@ -655,11 +668,13 @@ int poke_int3_handler(struct pt_regs *regs)
>   */
>  int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  {
> -	unsigned char int3 = 0xcc;
> -	int ret = 0;
> +	int ret;
>  
> +	bp_int3 = 0xcc;

We could remove this as it should be constant.

>  	bp_int3_handler = handler;
> -	bp_int3_addr = (u8 *)addr + sizeof(int3);
> +	bp_int3_addr = (u8 *)addr + sizeof(bp_int3);
> +	bp_int3_len = len;
> +	bp_int3_is_handled = NULL;
>  	bp_patching_in_progress = true;
>  	/*
>  	 * Corresponding read barrier in int3 notifier for
> @@ -668,20 +683,20 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	 */
>  	smp_wmb();
>  
> -	ret = text_poke(addr, &int3, sizeof(int3));
> +	ret = text_poke(addr, &bp_int3, sizeof(bp_int3));
>  	if (unlikely(ret))
>  		goto fail;
>  
>  	run_sync();
>  
> -	if (len - sizeof(int3) > 0) {
> +	if (len - sizeof(bp_int3) > 0) {
>  		/*
>  		 * Patch all but the first byte. We do not know how to recover
>  		 * from an error at this stage.
>  		 */
> -		text_poke_or_die((char *)addr + sizeof(int3),
> -				 (const char *) opcode + sizeof(int3),
> -				 len - sizeof(int3));
> +		text_poke_or_die((char *)addr + sizeof(bp_int3),
> +				 (const char *) opcode + sizeof(bp_int3),
> +				 len - sizeof(bp_int3));
>  		/*
>  		 * According to Intel, this core syncing is very likely
>  		 * not necessary and we'd be safe even without it. But
> @@ -691,7 +706,7 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	}
>  
>  	/* Patch the first byte. We do not know how to recover from an error. */
> -	text_poke_or_die(addr, opcode, sizeof(int3));
> +	text_poke_or_die(addr, opcode, sizeof(bp_int3));
>  
>  	run_sync();

Shouldn't we be setting the bp_int3_handler back to NULL here?

>  
> @@ -710,3 +725,219 @@ void text_poke_bp_or_die(void *addr, const void *opcode, size_t len,
>  	err = text_poke_bp(addr, opcode, len, handler);
>  	BUG_ON(err);
>  }
> +
> +static int text_poke_check(void *addr, const void *opcode, size_t len)
> +{
> +	unsigned char actual[MAX_PATCH_LEN];
> +	int ret;
> +
> +	ret = probe_kernel_read(actual, addr, len);
> +	if (unlikely(ret))
> +		return -EFAULT;
> +
> +	ret = memcmp(actual, opcode, len);
> +	if (unlikely(ret))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int add_iter_breakpoint(struct text_poke_bp_iter *iterator,
> +				       void *iter)
> +{
> +	void *addr;
> +	const void *old_opcode;
> +	int ret = 0;
> +
> +	/* nope if the code is not defined */

The above comment does not make sense.

> +	old_opcode = iterator->get_old_opcode(iter);
> +	if (!old_opcode)
> +		return 0;
> +
> +	addr = iterator->get_addr(iter);
> +	ret = text_poke_check(addr, old_opcode, bp_int3_len);
> +
> +	if (likely(!ret))
> +		/* write the breakpoint */

Comment is redundant and can be removed.

> +		ret = text_poke(addr, &bp_int3, sizeof(bp_int3));
> +
> +	return ret;
> +}
> +
> +static int update_iter_code(struct text_poke_bp_iter *iterator,
> +				   void *iter)
> +{
> +	void *addr;
> +	const void *opcode;
> +
> +	/* nope if the code is not defined */

Still does not make sense :-)

> +	opcode = iterator->get_opcode(iter);
> +	if (!opcode)
> +		return 0;
> +
> +	/* write all but the first byte */
> +	addr = iterator->get_addr(iter);
> +	return text_poke(addr + sizeof(bp_int3),
> +			 opcode + sizeof(bp_int3),
> +			 bp_int3_len - sizeof(bp_int3));
> +}
> +
> +static int finish_iter_update(struct text_poke_bp_iter *iterator,
> +				      void *iter)
> +{
> +	void *addr;
> +	const void *opcode;
> +	int ret = 0;
> +
> +	opcode = iterator->get_opcode(iter);
> +	if (opcode) {
> +		/* write the first byte if defined */
> +		addr = iterator->get_addr(iter);
> +		ret = text_poke(addr, opcode, sizeof(bp_int3));
> +	}
> +
> +	/* Patching has finished. Let's update the status flag if any. */
> +	if (!ret && iterator->finish)
> +		ret = iterator->finish(iter);
> +
> +	return ret;
> +}
> +
> +static void recover_iter(struct text_poke_bp_iter *iterator,
> +				void *iter)
> +{
> +	void *addr;
> +	const void *old_opcode;
> +	unsigned char actual[MAX_PATCH_LEN];
> +	int err;
> +
> +	/* If opcode is not defined, we did not change this address at all */
> +	old_opcode = iterator->get_old_opcode(iter);
> +	if(!old_opcode)
> +		return;
> +
> +	addr = iterator->get_addr(iter);
> +	err = probe_kernel_read(actual, addr, bp_int3_len);
> +	/* There is no way to recover the system if we even can not read */

"... if we could not even read"

But this begs the question. If we fail on reading, we call the recovery
mode, and this code will run on the place that we tried to read, and
here we bug, never going back to the caller telling us where we bugged
and why.

> +	BUG_ON(err);
> +
> +	/* We are done if there is no interrupt */
> +	if (actual[0] != bp_int3)
> +		return;
> +
> +	/* Put the old code back behind the interrupt if it is not there */
> +	if (memcmp(actual + sizeof(bp_int3),
> +		   old_opcode + sizeof(bp_int3),
> +		   bp_int3_len - sizeof(bp_int3)) != 0) {
> +		err = text_poke(addr + sizeof(bp_int3),
> +				old_opcode + sizeof(bp_int3),
> +				bp_int3_len - sizeof(bp_int3));
> +		/* we should not continue if recovering has failed */
> +		BUG_ON(err);
> +		/*
> +		 * It is not optimal to sync for each repaired address.
> +		 * But this is a corner case and we are in bad state anyway.
> +		 * Note that this is not needed on Intel, see text_poke_bp
> +		 */
> +		run_sync();
> +	}
> +
> +	/* Finally, put back the first byte from the old code */
> +	err = text_poke(addr, old_opcode, sizeof(bp_int3));
> +	/* we can not continue if the interrupt is still there */
> +	BUG_ON(err);
> +}
> +
> +#define for_text_poke_bp_iter(iterator,iter)	     \

Nit, but swap the above arguments to stay consistent with other for_*()
macros. Such as list_for_each_entry() and such. That is, the iterator
is the first parameter. Also make sure there's a space after the ','.

> +	for (iter = iterator->start(iterator->init); \
> +	     iter;				     \
> +	     iter = iterator->next(iter))
> +
> +/**
> + * text_poke_bp_list() -- update instructions on live kernel on SMP
> + * @iterator:	structure that allows to iterate over the patched addressed
> + * 		and get all the needed information

There's a hidden space before the two tabs above.
(checkpatch.pl complains).

> + *
> + * Modify several instructions by using int3 breakpoint on SMP in parallel.
> + * The principle is the same as in text_poke_bp. But synchronization of all CPUs
> + * is relatively slow operation, so we need to reduce it. Hence we add interrupt
> + * for all instructions before we modify the other bytes, etc.

The last sentence does not make sense. Do you mean "Hence we place a
breakpoint to all instructions before we modify the other bytes"?

> + *
> + * The operation wants to keep a consistent state. If anything goes wrong,
> + * it does the best effort to restore the original state. The only exception
> + * are addresses where the patching has finished. But the caller can be informed
> + * about this via the finish callback.
> + *
> + * It is a bit more paranoid than text_poke_bp because it checks the actual
> + * code before patching. This is a good practice proposed by the ftrace code.
> + *
> + * Note: This function must be called under text_mutex.
> + */
> +int text_poke_bp_list(struct text_poke_bp_iter *iterator)
> +{
> +	void *iter;
> +	const char *report = "adding breakpoints";
> +	int count = 0;
> +	int ret = 0;
> +
> +	bp_int3 = 0xcc;
> +	bp_int3_addr = NULL;
> +	bp_int3_len = iterator->len;
> +	bp_int3_handler = NULL;
> +	bp_int3_is_handled = iterator->is_handled;
> +	bp_patching_in_progress = true;
> +
> +	smp_wmb();
> +
> +	/* add interrupts */
> +	for_text_poke_bp_iter(iterator, iter) {
> +		ret = add_iter_breakpoint(iterator, iter);
> +		if (ret)
> +			goto fail;
> +		count++;
> +	}
> +	run_sync();
> +
> +	report = "updating code";
> +	if (bp_int3_len - sizeof(bp_int3) > 0) {
> +		count = 0;
> +		/* patch all but the first byte */
> +		for_text_poke_bp_iter(iterator, iter) {
> +			ret = update_iter_code(iterator, iter);
> +			if (ret)
> +				goto fail;
> +			count++;
> +		}
> +		run_sync();
> +	}
> +
> +	/* patch the first byte */
> +	report = "finishing update";
> +	count = 0;
> +	for_text_poke_bp_iter(iterator, iter) {
> +		ret = finish_iter_update(iterator, iter);
> +		if (ret)
> +			goto fail;
> +		count++;
> +	}
> +	run_sync();
> +
> +fail:
> +	if (unlikely(ret)) {
> +		printk(KERN_WARNING "text_poke_bp_iter failed on %s (%d):\n",
> +		       report, count);
> +		/* save information about the failure */
> +		iterator->fail_count = count;
> +		iterator->fail_addr = iterator->get_addr(iter);
> +		/* try to recover the old state */
> +		for_text_poke_bp_iter(iterator, iter) {

This can not be a blind recovery. Only failure of adding the breakpoint
should recover, as it should do the read/compare/write test first. If
it fails after that, then it was something else and it is OK to bug.

But in any case, the recover_iter() should only be called "count"
times. We should put back the breakpoint only on those that were set,
and not try anything else.

-- Steve


> +			recover_iter(iterator, iter);
> +		}
> +		run_sync();
> +	}
> +
> +	bp_patching_in_progress = false;
> +	smp_wmb();
> +
> +	return ret;
> +}

