Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbaESTNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:13:44 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47136 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaESTNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:13:42 -0400
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <537A57E2.7010505@mit.edu>
Date: Mon, 19 May 2014 12:13:38 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Erik Bosman <erik@minemu.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] SROP mitigation: Architecture independent code for
 signal canaries
References: <20140515210914.GA9536@pizzadoos.com>
In-Reply-To: <20140515210914.GA9536@pizzadoos.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 02:09 PM, Erik Bosman wrote:
> 
> Architecture independent code for signal canaries
> 
> Add support for canary values in user-space signal frames.  These canaries
> function much like stack canaries/cookies, making it harder for an attacker to
> fake a call to {rt_,}sigreturn()
> 
> This patch deals with architecture independent changes needed to support
> these canaries.
> 
> 
> These patches are meant to make Sigreturn Oriented Programming (SROP) a much
> less attractive exploitation path.  In Sigreturn Oriented Programming, an
> attacker causes a user-space program to call the sigreturn system call in order
> to get complete control control over the entire userspace context in one go.
> 
> ( see: http://www.cs.vu.nl/~herbertb/papers/srop_sp14.pdf )
> 
> While mitigating SROP will probably not stop determined attackers from
> exploiting a program, as there's always the much more well-known Return
> Oriented Programming, we still think SROP's relative ease warrants mitigation,
> especially since the mitigation is so cheap.

If you're willing to make the mitigation a bit more sneaky, you could
make the canary value depend on the address that the canary is at.  For
example, it could be H(some per-exec secret || address) for your
favorite hash function H.

Also, I would have sigreturn clear the canary on the stack.

This would mitigate attacks based on trying to read the canary value
from some unused / leaked stack space.

--Andy


> 
> 
> Signed-off-by: Erik Bosman <erik@minemu.org>
> 
> ---
>  arch/Kconfig          | 16 ++++++++++++++++
>  fs/exec.c             |  8 ++++++++
>  include/linux/sched.h |  5 +++++
>  3 files changed, 29 insertions(+)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 97ff872..8319984 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -399,6 +399,22 @@ config CC_STACKPROTECTOR_STRONG
>  
>  endchoice
>  
> +config HAVE_SIGNAL_CANARY
> +	bool
> +	help
> +	  An arch should select this symbol if:
> +	  - its struct sigframe contains a canary field
> +	  - it has implemented signal canary checking
> +
> +config SIGNAL_CANARY
> +	bool "signal canary"
> +	default y
> +	depends on HAVE_SIGNAL_CANARY
> +	help
> +	  Mitigate against a userland exploitation techinque called
> +	  sigreturn oriented programming by putting a canary value on a
> +	  signal's struct sigframe
> +
>  config HAVE_CONTEXT_TRACKING
>  	bool
>  	help
> diff --git a/fs/exec.c b/fs/exec.c
> index 476f3eb..883f456 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -56,6 +56,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/oom.h>
>  #include <linux/compat.h>
> +#include <linux/random.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
> @@ -1105,6 +1106,13 @@ void setup_new_exec(struct linux_binprm * bprm)
>  	/* This is the point of no return */
>  	current->sas_ss_sp = current->sas_ss_size = 0;
>  
> +#ifdef CONFIG_SIGNAL_CANARY
> +	/* canary value to mitigate the use of sigreturn in (userland) exploits
> +	 * get_random_int() should be random enough also for 64bit
> +	 */
> +	current->signal_canary = (unsigned long)get_random_int();
> +#endif
> +
>  	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
>  		set_dumpable(current->mm, SUID_DUMP_USER);
>  	else
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 25f54c7..cb8b54b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1364,6 +1364,11 @@ struct task_struct {
>  
>  	unsigned long sas_ss_sp;
>  	size_t sas_ss_size;
> +
> +#ifdef CONFIG_SIGNAL_CANARY
> +	u32 signal_canary; /* sigreturn exploit mitigation */
> +#endif
> +
>  	int (*notifier)(void *priv);
>  	void *notifier_data;
>  	sigset_t *notifier_mask;
> 

