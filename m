Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3JSPCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:02:36 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54563 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3JSPCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 11:02:35 -0400
Message-ID: <52629F08.2010609@hitachi.com>
Date: Sun, 20 Oct 2013 00:02:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/6] x86: allow to call text_poke_bp during boot
References: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
In-Reply-To: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/18 23:27), Petr Mladek wrote:
> We would like to use text_poke_bp in ftrace. It might be called also during
> boot when the interupts are disabled. We need to enable them for syncing
> the cores on each CPU. Otherwise, there might be a deadlock, see the
> warning in "smp_call_function_many", kernel/smp.c:371.

Steven, is this really needed?
I think if this is the special use(e.g. boottime test),
we'd better to run it after boot...

Thank you,

> 
> This change is taken from the current code in arch/x86/kernel/ftrace.c.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/alternative.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index f714316..13cae15 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -629,6 +629,20 @@ static void do_sync_core(void *info)
>  	sync_core();
>  }
>  
> +static void run_sync(void)
> +{
> +	int enable_irqs = irqs_disabled();
> +
> +	/* We may be called with interrupts disbled (on bootup). */
> +	if (enable_irqs)
> +		local_irq_enable();
> +
> +	on_each_cpu(do_sync_core, NULL, 1);
> +
> +	if (enable_irqs)
> +		local_irq_disable();
> +}
> +
>  static bool bp_patching_in_progress;
>  static void *bp_int3_handler, *bp_int3_addr;
>  
> @@ -688,7 +702,7 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  
>  	text_poke_part(addr, &int3, sizeof(int3));
>  
> -	on_each_cpu(do_sync_core, NULL, 1);
> +	run_sync();
>  
>  	if (len - sizeof(int3) > 0) {
>  		/* patch all but the first byte */
> @@ -700,13 +714,13 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  		 * not necessary and we'd be safe even without it. But
>  		 * better safe than sorry (plus there's not only Intel).
>  		 */
> -		on_each_cpu(do_sync_core, NULL, 1);
> +		run_sync();
>  	}
>  
>  	/* patch the first byte */
>  	text_poke_part(addr, opcode, sizeof(int3));
>  
> -	on_each_cpu(do_sync_core, NULL, 1);
> +	run_sync();
>  
>  	bp_patching_in_progress = false;
>  	smp_wmb();
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


