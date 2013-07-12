Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab3GLCHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:07:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab3GLCH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:07:29 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=c_B5fg8LQ7AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6K3jcYMAzPUA:10 a=Cc46N-iNs35OFKuKWxgA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=1FsCDTXh4kY4MgIG:21 a=rksM8xcDh8D3eDYT:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373594847.17876.75.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@akamai.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Jul 2013 22:07:27 -0400
In-Reply-To: <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 22:26 +0200, Jiri Kosina wrote:

Nitpick, and Joe Perches mentioned this earlier too. The below should be
in kerneldoc format. That is:

 /**
  * text_poke_bp() -- update instructions on live kernel on SMP


> +/*
> + * text_poke_bp() -- update instructions on live kernel on SMP
> + * @addr:	address to patch
> + * @opcode:	opcode of new instruction
> + * @len:	length to copy
> + * @handler:	address to jump to when the temporary breakpoint is hit
> + *
> +
> + * Modify multi-byte instruction by using int3 breakpoint on SMP.

Also, you have a missing asterisk.

See Documentation/kernel-doc-nano-HOWTO.txt for more info.


But other than that, you can add my:

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> + * In contrary to text_poke_smp(), we completely avoid stop_machine() here,
> + * and achieve the synchronization using int3 breakpoint.
> + *
> + * The way it is done:
> + *	- add a int3 trap to the address that will be patched
> + *	- sync cores
> + *	- update all but the first byte of the patched range
> + *	- sync cores
> + *	- replace the first byte (int3) by the first byte of
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
> +	 * Corresponding read barrier in int3 notifier for
> +	 * making sure the in_progress flags is correctly ordered wrt.
> +	 * patching
> +	 */
> +	smp_wmb();
> +
> +	text_poke(addr, &int3, sizeof(int3));
> +
> +	on_each_cpu(do_sync_core, NULL, 1);
> +
> +	if (len - sizeof(int3) > 0) {
> +		/* patch all but the first byte */
> +		text_poke((char *)addr + sizeof(int3),
> +			  (const char *) opcode + sizeof(int3),
> +			  len - sizeof(int3));
> +		/*
> +		 * According to Intel, this core syncing is very likely
> +		 * not necessary and we'd be safe even without it. But
> +		 * better safe than sorry (plus there's not only Intel).
> +		 */
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


