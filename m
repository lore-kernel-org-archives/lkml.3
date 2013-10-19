Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3JSO5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 10:57:05 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54419 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3JSO5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 10:57:03 -0400
Message-ID: <52629DBB.6000800@hitachi.com>
Date: Sat, 19 Oct 2013 23:56:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 1/6] x86: speed up int3-based patching using less paranoid
 write
References: <1382106445-31468-2-git-send-email-pmladek@suse.cz>
In-Reply-To: <1382106445-31468-2-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/18 23:27), Petr Mladek wrote:
> This change is inspired by the int3-based patching code used in
> ftrace. See the commit fd4363fff3d9 (x86: Introduce int3
> (breakpoint)-based instruction patching).
> 
> When trying to use text_poke_bp in ftrace, the result was slower
> than the original implementation. For example, I tried to modify
> the ftrace function, enable, and disable the tracer in a cycle.
> With 9 different trace functions and 500 cycles, I got these times:
> 
> 	original code:			with text_poke_bp using text_poke
> 
> 	real    19m51.667s		real    26m31.277s
> 	user    0m0.004s		user    0m0.024s
> 	sys     0m27.124s		sys     0m28.180s
> 
> It turned out that the difference was in text_poke vs. ftrace_write.
> text_poke did many extra operations to make sure that the change
> was atomic.
> 
> In fact, we do not need this luxury in text_poke_bp because
> the modified code is guarded by the int3 handler. The int3
> interupt itself is added and removed by an atomic operation
> because we modify only one byte.
> 
> This patch adds text_poke_part which is inspired by ftrace_write.
> Then it is used in text_poke_bp instead of the paranoid text_poke.

OK, as far as the handler correctly handles int3, we don't need
to use fixmaps for this purpose.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/alternative.c | 49 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index df94598..f714316 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -8,6 +8,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
> +#include <linux/uaccess.h>
>  #include <linux/memory.h>
>  #include <linux/stop_machine.h>
>  #include <linux/slab.h>
> @@ -586,6 +587,43 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  	return addr;
>  }
>  
> +/**
> + * text_poke_part - Update part of the instruction on a live kernel when using
> + * 		    int3 breakpoint
> + * @addr:   address to modify
> + * @opcode: source of the copy
> + * @len:    length to copy
> + *
> + * If we patch instructions using int3 interupt, we do not need to be so careful
> + * about an atomic write. Adding and removing the interupt is atomic because
> + * we modify only one byte. The rest of the instruction could be modified in
> + * several steps because it is quarded by the interupt handler. Hence we could
> + * use faster code here. See also text_poke_bp below for more details.
> + *
> + * Note: Must be called under text_mutex.
> + */
> +static void *text_poke_part(void *addr, const void *opcode, size_t len)
> +{
> +	/*
> +	 * On x86_64, kernel text mappings are mapped read-only with
> +	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
> +	 * of the kernel text mapping to modify the kernel text.
> +	 *
> +	 * For 32bit kernels, these mappings are same and we can use
> +	 * kernel identity mapping to modify code.
> +	 */
> +	if (((unsigned long)addr >= (unsigned long)_text) &&
> +	    ((unsigned long)addr < (unsigned long)_etext))
> +		addr = __va(__pa_symbol(addr));
> +
> +	if (probe_kernel_write(addr, opcode, len))
> +		return NULL;
> +
> +	sync_core();
> +
> +	return addr;
> +}
> +
>  static void do_sync_core(void *info)
>  {
>  	sync_core();
> @@ -648,15 +686,15 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	 */
>  	smp_wmb();
>  
> -	text_poke(addr, &int3, sizeof(int3));
> +	text_poke_part(addr, &int3, sizeof(int3));
>  
>  	on_each_cpu(do_sync_core, NULL, 1);
>  
>  	if (len - sizeof(int3) > 0) {
>  		/* patch all but the first byte */
> -		text_poke((char *)addr + sizeof(int3),
> -			  (const char *) opcode + sizeof(int3),
> -			  len - sizeof(int3));
> +		text_poke_part((char *)addr + sizeof(int3),
> +			       (const char *) opcode + sizeof(int3),
> +			       len - sizeof(int3));
>  		/*
>  		 * According to Intel, this core syncing is very likely
>  		 * not necessary and we'd be safe even without it. But
> @@ -666,7 +704,7 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	}
>  
>  	/* patch the first byte */
> -	text_poke(addr, opcode, sizeof(int3));
> +	text_poke_part(addr, opcode, sizeof(int3));
>  
>  	on_each_cpu(do_sync_core, NULL, 1);
>  
> @@ -675,4 +713,3 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  
>  	return addr;
>  }
> -
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


