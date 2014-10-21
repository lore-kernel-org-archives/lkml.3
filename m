Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaJUDte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:49:34 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42025 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJUDtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:49:33 -0400
Message-ID: <5445D7C5.1080006@hitachi.com>
Date: Tue, 21 Oct 2014 12:49:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kprobes: introduce ARCH_HANDLES_KPROBES_ON_FTRACE
References: <1413802794-38998-1-git-send-email-heiko.carstens@de.ibm.com> <1413802794-38998-2-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1413802794-38998-2-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/20 19:59), Heiko Carstens wrote:
> Allow architectures to implement handling of kprobes on function
> tracer call sites on their own, without depending on common code.
> 
> This patch removes the kprobes check if a kprobe is being placed
> on a function tracer call site and therefore gives full responsibility
> of handling this correctly to the architecture.
> 
> This patch also introduces a user space visible change: if a kprobe
> is placed into the middle of an ftrace instruction the return value
> is changed from -EINVAL to -EILSEQ also for architectures which do
> not support KPROBES_ON_FTRACE.
> However in reality this change shouldn't matter at all.

Could you try to remove new kconfig by using a weak function?
This could be done with below functions:

In kernel/kprobes.c:

int __weak arch_check_ftrace_location(struct kprobe *p)
{
	unsigned long ftrace_addr = ftrace_location((unsigned long)p->addr);
	if (ftrace_addr) {
		...
}

And in arch/s390/kernel/kprobes.c:
int arch_check_ftrace_location(struct kprobe *p)
{
	return 0;
}

And in include/linux/kprobes.h
int arch_check_ftrace_location(struct kprobe *p);

Then, we don't need to add any macros or kconfigs.

Thank you,

> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/Kconfig     |  8 ++++++++
>  kernel/kprobes.c | 36 +++++++++++++++++++++---------------
>  2 files changed, 29 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 05d7a8a458d5..e1a8e0edf03f 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -85,6 +85,14 @@ config KPROBES_ON_FTRACE
>  	 passing of pt_regs to function tracing, then kprobes can
>  	 optimize on top of function tracing.
>  
> +config ARCH_HANDLES_KPROBES_ON_FTRACE
> +	def_bool n
> +	help
> +	 If an architecture can handle kprobes on function tracer call
> +	 sites on own, then this option should be selected. This option
> +	 removes the check which otherwise prevents to set kprobes on
> +	 function tracer call sites.
> +
>  config UPROBES
>  	def_bool n
>  	select PERCPU_RWSEM
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3995f546d0f3..4b57fe9fbeb7 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1410,28 +1410,34 @@ static inline int check_kprobe_rereg(struct kprobe *p)
>  	return ret;
>  }
>  
> -static int check_kprobe_address_safe(struct kprobe *p,
> -				     struct module **probed_mod)
> +static int check_ftrace_location(struct kprobe *p)
>  {
> -	int ret = 0;
>  	unsigned long ftrace_addr;
>  
> -	/*
> -	 * If the address is located on a ftrace nop, set the
> -	 * breakpoint to the following instruction.
> -	 */
>  	ftrace_addr = ftrace_location((unsigned long)p->addr);
> -	if (ftrace_addr) {
> -#ifdef CONFIG_KPROBES_ON_FTRACE
> -		/* Given address is not on the instruction boundary */
> -		if ((unsigned long)p->addr != ftrace_addr)
> -			return -EILSEQ;
> +	if (!ftrace_addr)
> +		return 0;
> +	/* Given address is not on the instruction boundary */
> +	if ((unsigned long)p->addr != ftrace_addr)
> +		return -EILSEQ;
> +	/* If an architecture handles kprobes on ftrace, we're done */
> +	if (IS_ENABLED(CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE))
> +		return 0;
> +	if (IS_ENABLED(CONFIG_KPROBES_ON_FTRACE)) {
>  		p->flags |= KPROBE_FLAG_FTRACE;
> -#else	/* !CONFIG_KPROBES_ON_FTRACE */
> -		return -EINVAL;
> -#endif
> +		return 0;
>  	}
> +	return -EINVAL;
> +}
> +
> +static int check_kprobe_address_safe(struct kprobe *p,
> +				     struct module **probed_mod)
> +{
> +	int ret;
>  
> +	ret = check_ftrace_location(p);
> +	if (ret)
> +		return ret;
>  	jump_label_lock();
>  	preempt_disable();
>  
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


