Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaAOApY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:45:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:28399 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880AbaAOApV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:45:21 -0500
Date: Tue, 14 Jan 2014 19:45:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 4/8] x86: speed up int3-based patching using direct
 write
Message-ID: <20140114194519.743261c4@gandalf.local.home>
In-Reply-To: <1386690140-19941-5-git-send-email-pmladek@suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-5-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 16:42:16 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> When trying to use text_poke_bp_iter in ftrace, the result was slower than
> the original implementation.
> 
> It turned out that one difference was in text_poke vs. ftrace_write.
> text_poke did many extra operations to make sure that code was read-write
> and the change was atomic.
> 
> In fact, we do not need the atomic operation inside text_poke_bp_iter because
> the modified code is guarded by the int3 handler. The int3 interrupt itself
> is added and removed by an atomic operation because we modify only one byte.
> 
> Also if we patch many functions, it is more effective to set the whole text code
> read-write instead of remapping each address into a helper address space.
> 
> This patch adds text_poke_part which is inspired by ftrace_write.
> Then it is used in text_poke_bp_iter instead of the slower text_poke.
> It adds the limitation that text_poke_bp_iter user is responsible for
> setting the patched code read-write.
> 
> Note that we can't use it in text_poke because it is not effective
> to set the page or two read-write just because patching one piece.
> 
> For example, I tried to switch between 7 tracers: blk, branch, function_graph,
> wakeup_rt, irqsoff, function, and nop. Every tracer has also been enabled and
> disabled. With 100 cycles, I got these times with text_poke:
> 
>     real    25m7.380s     25m13.44s     25m9.072s
>     user    0m0.004s      0m0.004s      0m0.004s
>     sys     0m3.480s      0m3.508s      0m3.420s
> 
> and with text_poke_part:
> 
>     real    3m23.335s     3m24.422s     3m26.686s
>     user    0m0.004s      0m0.004s	0m0.004s
>     sys     0m3.724s      0m3.772s	0m3.588s
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  arch/x86/kernel/alternative.c | 67 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 57 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 8e57ac03a0e8..03abf9abf681 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -595,6 +595,51 @@ void __kprobes text_poke_or_die(void *addr, const void *opcode, size_t len)
>  	BUG_ON(err);
>  }
>  
> +/**
> + * text_poke_part - Update part of the instruction on a live kernel when using
> + * 		    int3 breakpoint
> + * @addr:   address to modify
> + * @opcode: source of the copy
> + * @len:    length to copy
> + *
> + * If we patch instructions using int3 interrupt, we do not need to be so
> + * careful about an atomic write. Adding and removing the interrupt is atomic
> + * because we modify only one byte. The rest of the instruction could be
> + * modified in several steps because it is guarded by the interrupt handler.

Another nit, because I'm anal. I know Intel confuses things by calling
int3 an interrupt, when in reality it is a trap. There's nothing
asynchronous about it and nothing is being interrupted. Can we use the
term "trap" or "breakpoint" instead of "interrupt"?

> + * Hence we could use faster code here. See also text_poke_bp_iter below
> + * for more details.
> + *
> + * Note: This function must be called under text_mutex. Also the caller is
> + * responsible for setting the patched code read-write. This is more effective
> + * only when you patch many addresses at the same time.

s/many/several/

> + */
> +static int text_poke_part(void *addr, const void *opcode, size_t len)
> +{
> +	int ret;
> +
> +	/* The patching makes sense only for a text code */

s/for a/for/

-- Steve

> +	if (unlikely((unsigned long)addr < (unsigned long)_text) ||
> +	    unlikely((unsigned long)addr >= (unsigned long)_etext))
> +		return -EFAULT;
> +
> +#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
> +	/*
> +	 * On x86_64, the kernel text mapping is always mapped read-only with
> +	 * CONFIG_DEBUG_RODATA. Instead, we need to use the kernel identity
> +	 * mapping that can be set read-write, for example using
> +	 * set_kernel_text_rw().
> +	 */
> +	addr = __va(__pa_symbol(addr));
> +#endif
> +
> +	ret = probe_kernel_write(addr, opcode, len);
> +	if (unlikely(ret))
> +		return -EPERM;
> +
> +	sync_core();
> +	return 0;
> +}
> +
