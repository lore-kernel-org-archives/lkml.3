Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3LJPqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:46:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44823 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab3LJPqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:46:19 -0500
Date: Tue, 10 Dec 2013 16:46:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 2/8] x86: allow to call text_poke_bp during boot
Message-ID: <20131210154612.GA31490@pd.tnic>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
 <1386690140-19941-3-git-send-email-pmladek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386690140-19941-3-git-send-email-pmladek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 04:42:14PM +0100, Petr Mladek wrote:
> We would like to use text_poke_bp in ftrace. It might be called also during
> boot when there is only one CPU and we do not need to sync the others.
> 
> The check is must to have because there are also disabled interrupts during
> the boot. Then the call would cause a deadlock, see the warning in
> "smp_call_function_many", kernel/smp.c:371.
> 
> The change is inspired by the code in arch/x86/kernel/ftrace.c.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  arch/x86/kernel/alternative.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index eabed9326d2a..6436beec7b0c 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -599,6 +599,17 @@ static void do_sync_core(void *info)
>  	sync_core();
>  }
>  
> +static void run_sync(void)

Can we call this sync_cores()?

It is what it does. :)

> +{
> +	/*
> +	 * We do not need to sync other cores during boot when there is only one
> +	 * CPU enabled. In fact, we must not because there are also disabled
> +	 * interrupts. The call would fail because of a potential deadlock.
> +	 */
> +	if (num_online_cpus() != 1)
> +		on_each_cpu(do_sync_core, NULL, 1);
> +}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
