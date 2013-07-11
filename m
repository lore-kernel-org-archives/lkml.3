Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab3GKP5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:57:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3GKP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:57:07 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nbHVgzOhg_YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QEdfzldPcAgA:10 a=ZdgnrLzgjQ0o_kXTxQQA:9 a=QEXdDO2ut3YA:10 a=aycjC0tcZMbHTO8H:21 a=UHWIQDunqRRVovmJ:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373558223.17876.22.camel@gandalf.local.home>
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>
Date: Thu, 11 Jul 2013 11:57:03 -0400
In-Reply-To: <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 23:31 +0200, Jiri Kosina wrote:
> Changes:
> 
> v1 -> v2:
>   + fixed kerneldoc
>   + fixed checkpatch errors (reported by Borislav)
> 
>  arch/x86/include/asm/alternative.h |    1 +
>  arch/x86/kernel/alternative.c      |  101 ++++++++++++++++++++++++++++++++++++
>  kernel/kprobes.c                   |    2 +-
>  3 files changed, 103 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index 58ed6d9..3abf8dd 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -233,6 +233,7 @@ struct text_poke_param {
>  };
>  
>  extern void *text_poke(void *addr, const void *opcode, size_t len);
> +extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
>  extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
>  extern void text_poke_smp_batch(struct text_poke_param *params, int n);
>  
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index c15cf9a..ee1f51c 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -11,6 +11,7 @@
>  #include <linux/memory.h>
>  #include <linux/stop_machine.h>
>  #include <linux/slab.h>
> +#include <linux/kdebug.h>
>  #include <asm/alternative.h>
>  #include <asm/sections.h>
>  #include <asm/pgtable.h>
> @@ -596,6 +597,106 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  	return addr;
>  }
>  
> +static void do_sync_core(void *info)
> +{
> +	sync_core();
> +}
> +
> +static bool bp_patching_in_progress;
> +static void *bp_int3_handler, *bp_int3_addr;
> +
> +static int int3_notify(struct notifier_block *self, unsigned long val, void *data)
> +{
> +	struct die_args *args = data;
> +	struct pt_regs *regs = args->regs;
> +
> +	/* bp_patching_in_progress */
> +	smp_rmb();
> +
> +	if (likely(!bp_patching_in_progress))
> +		return NOTIFY_DONE;
> +
> +	/* we are not interested in non-int3 faults and ring > 0 faults */
> +	if (val != DIE_INT3 || !regs || user_mode_vm(regs)
> +			    || (unsigned long) bp_int3_addr != regs->ip)
> +		return NOTIFY_DONE;
> +
> +	/* set up the specified breakpoint handler */
> +	args->regs->ip = (unsigned long) bp_int3_handler;
> +
> +	return NOTIFY_STOP;
> +}
> +/*
> + * text_poke_bp() -- update instructions on live kernel on SMP
> + * @addr:	address to patch
> + * @opcode:	opcode of new instruction
> + * @len:	length to copy
> + * @handler:	address to jump to when the temporary breakpoint is hit
> + *
> +
> + * Modify multi-byte instruction by using int3 breakpoint on SMP.
> + * In contrary to text_poke_smp(), we completely avoid stop_machine() here,
> + * and achieve the synchronization using int3 breakpoint.
> + *
> + * The way it is done:
> + *	- add a int3 trap to the address that will be patched
> + *	- sync cores
> + *	- update all but the first byte of the patched range
> + *	- sync cores
> + *	- replalace the first byte (int3) by the first byte of
> + *	  replacing opcode
> + *	- sync cores
> + *
> + * Note: must be called under text_mutex.
> + */
> +void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
> +{
> +	unsigned char int3 = 0xcc;
> +
> +	bp_int3_handler = handler;
> +	bp_int3_addr = (u8 *)addr + sizeof(int3);
> +	bp_patching_in_progress = true;
> +	/*
> +	 * corresponding read barrier in int3 notifier for
> +	 * making sure the in_progress flags is correctly ordered wrt.
> +	 * patching */

Nitpick, but this should be:

	/*
	 * Corresponding read barrier in int3 notifier for
	 * making sure the in_progress flags is correctly ordered wrt.
	 * patching.
	 */

> +	smp_wmb();
> +
> +	text_poke(addr, &int3, sizeof(int3));
> +
> +	if (len - sizeof(int3) > 0) {

I believe we need a sync here. Otherwise, if the instruction crosses
cache lines, the original first byte could have been pulled in, and then
after the text_poke() below, it gets the updated version, causing a
crash on that CPU.

		on_each_cpu(do_sync_core, NULL, 1);

-- Steve

> +		/* patch all but the first byte */
> +		text_poke((char *)addr + sizeof(int3),
> +			  (const char *) opcode + sizeof(int3),
> +			  len - sizeof(int3));
> +
> +		on_each_cpu(do_sync_core, NULL, 1);
> +	}
> +
> +	/* patch the first byte */
> +	text_poke(addr, opcode, sizeof(int3));
> +
> +	on_each_cpu(do_sync_core, NULL, 1);
> +
> +	bp_patching_in_progress = false;
> +	smp_wmb();
> +
> +	return addr;
> +}
> +
> +/* this one needs to run before anything else handles it as a
> + * regular exception */
> +static struct notifier_block int3_nb = {
> +	.priority = 0x7fffffff,
> +	.notifier_call = int3_notify
> +};
> +
> +static int __init int3_init(void)
> +{
> +	return register_die_notifier(&int3_nb);
> +}
> +
> +arch_initcall(int3_init);
>  /*
>   * Cross-modifying kernel text with stop_machine().
>   * This code originally comes from immediate value.
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index bddf3b2..d6db7bd 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1709,7 +1709,7 @@ EXPORT_SYMBOL_GPL(unregister_kprobes);
>  
>  static struct notifier_block kprobe_exceptions_nb = {
>  	.notifier_call = kprobe_exceptions_notify,
> -	.priority = 0x7fffffff /* we need to be notified first */
> +	.priority = 0x7ffffff0 /* High priority, but not first.  */
>  };
>  
>  unsigned long __weak arch_deref_entry_point(void *entry)


