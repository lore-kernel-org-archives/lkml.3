Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaJUJbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:31:07 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56895 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJUJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:31:05 -0400
Message-ID: <544627D0.60309@hitachi.com>
Date: Tue, 21 Oct 2014 18:30:56 +0900
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
Subject: Re: [PATCH v3 1/2] kprobes: introduce weak arch_check_ftrace_location()
 helper function
References: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com> <1413880229-4796-2-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1413880229-4796-2-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/21 17:30), Heiko Carstens wrote:
> Introduce weak arch_check_ftrace_location() helper function which
> architectures can override in order to implement handling of kprobes
> on function tracer call sites on their own, without depending on
> common code or implementing the KPROBES_ON_FTRACE feature.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  include/linux/kprobes.h |  1 +
>  kernel/kprobes.c        | 18 +++++++++++-------
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index f7296e57d614..5297f9fa0ef2 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -335,6 +335,7 @@ extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
>  extern int arch_prepare_kprobe_ftrace(struct kprobe *p);
>  #endif
>  
> +int arch_check_ftrace_location(struct kprobe *p);
>  
>  /* Get the kprobe at this addr (if any) - called with preemption disabled */
>  struct kprobe *get_kprobe(void *addr);
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3995f546d0f3..317eb8ad28dd 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1410,16 +1410,10 @@ static inline int check_kprobe_rereg(struct kprobe *p)
>  	return ret;
>  }
>  
> -static int check_kprobe_address_safe(struct kprobe *p,
> -				     struct module **probed_mod)
> +int __weak arch_check_ftrace_location(struct kprobe *p)
>  {
> -	int ret = 0;
>  	unsigned long ftrace_addr;
>  
> -	/*
> -	 * If the address is located on a ftrace nop, set the
> -	 * breakpoint to the following instruction.
> -	 */
>  	ftrace_addr = ftrace_location((unsigned long)p->addr);
>  	if (ftrace_addr) {
>  #ifdef CONFIG_KPROBES_ON_FTRACE
> @@ -1431,7 +1425,17 @@ static int check_kprobe_address_safe(struct kprobe *p,
>  		return -EINVAL;
>  #endif
>  	}
> +	return 0;
> +}
>  
> +static int check_kprobe_address_safe(struct kprobe *p,
> +				     struct module **probed_mod)
> +{
> +	int ret;
> +
> +	ret = arch_check_ftrace_location(p);
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


