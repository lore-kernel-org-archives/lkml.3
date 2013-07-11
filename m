Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3GKKXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:23:24 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36513 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3GKKXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:23:23 -0400
Message-ID: <51DE8799.9020904@hitachi.com>
Date: Thu, 11 Jul 2013 19:23:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/11 6:31), Jiri Kosina wrote:
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

You don't need this "sync cores". (and your code didn't) :)

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

Here, you have to protect this code from others, since bp_* are
global.

> +	bp_int3_handler = handler;
> +	bp_int3_addr = (u8 *)addr + sizeof(int3);
> +	bp_patching_in_progress = true;
> +	/*
> +	 * corresponding read barrier in int3 notifier for
> +	 * making sure the in_progress flags is correctly ordered wrt.
> +	 * patching */
> +	smp_wmb();
> +
> +	text_poke(addr, &int3, sizeof(int3));
> +
> +	if (len - sizeof(int3) > 0) {
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
> 

Thanks,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


