Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3KNLMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:12:44 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41450 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3KNLMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:12:42 -0500
Message-ID: <5284B025.607@hitachi.com>
Date: Thu, 14 Nov 2013 20:12:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v3 2/8] x86: allow to call text_poke_bp during boot
References: <1384425686-21018-1-git-send-email-pmladek@suse.cz> <1384425686-21018-3-git-send-email-pmladek@suse.cz>
In-Reply-To: <1384425686-21018-3-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/14 19:41), Petr Mladek wrote:
> We would like to use text_poke_bp in ftrace. It might be called also during
> boot when there is only one CPU and we do not need to sync the others.
> 
> The check is must to have because there are also disabled interrupts during
> the boot. Then the call would cause a deadlock, see the warning in
> "smp_call_function_many", kernel/smp.c:371.
> 
> The change is inspired by the code in arch/x86/kernel/ftrace.c.

Looks good for me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/alternative.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 2aebe54..125fb16 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -603,6 +603,17 @@ static void do_sync_core(void *info)
>  	sync_core();
>  }
>  
> +static void run_sync(void)
> +{
> +	/*
> +	 * We do not need to sync other cores during boot when there is only one
> +	 * CPU enabled. In fact, we must not because there are also disabled
> +	 * interrupts. The call would fail because of a potential deadlock.
> +	 */
> +	if (num_online_cpus() != 1)
> +		on_each_cpu(do_sync_core, NULL, 1);
> +}
> +
>  static bool bp_patching_in_progress;
>  static void *bp_int3_handler, *bp_int3_addr;
>  
> @@ -665,7 +676,7 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  	if (unlikely(ret))
>  		goto fail;
>  
> -	on_each_cpu(do_sync_core, NULL, 1);
> +	run_sync();
>  
>  	if (len - sizeof(int3) > 0) {
>  		/* patch all but the first byte */
> @@ -678,14 +689,14 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>  		 * not necessary and we'd be safe even without it. But
>  		 * better safe than sorry (plus there's not only Intel).
>  		 */
> -		on_each_cpu(do_sync_core, NULL, 1);
> +		run_sync();
>  	}
>  
>  	/* patch the first byte */
>  	ret = text_poke(addr, opcode, sizeof(int3));
>  	BUG_ON(ret);
>  
> -	on_each_cpu(do_sync_core, NULL, 1);
> +	run_sync();
>  
>  fail:
>  	bp_patching_in_progress = false;
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


