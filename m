Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaJTBzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 21:55:39 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39556 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaJTBzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 21:55:38 -0400
Message-ID: <54446B92.1040507@hitachi.com>
Date: Mon, 20 Oct 2014 10:55:30 +0900
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
Subject: Re: [PATCH 1/2] kprobes: introduce ARCH_HANDLES_KPROBES_ON_FTRACE
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com> <1413387978-984-2-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1413387978-984-2-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/16 0:46), Heiko Carstens wrote:
> Allow architectures to implement handling of kprobes on function
> tracer call sites on their own, without depending on common code.
> 
> This patch removes the kprobes check if a kprobe is being placed
> on a function tracer call site and therefore gives full responsibility
> of handling this correctly to the architecture.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/Kconfig     | 8 ++++++++
>  kernel/kprobes.c | 3 ++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
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
> index 3995f546d0f3..4cc48aa67635 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1428,7 +1428,8 @@ static int check_kprobe_address_safe(struct kprobe *p,
>  			return -EILSEQ;
>  		p->flags |= KPROBE_FLAG_FTRACE;
>  #else	/* !CONFIG_KPROBES_ON_FTRACE */
> -		return -EINVAL;
> +		if (!IS_ENABLED(CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE))
> +			return -EINVAL;
>  #endif
>  	}

Hmm, this looks a bit not straight. Maybe we'd better introduce a local
check_ftrace_location() function which always returns 0 if
CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE(with a comment! :)) as below.

int check_ftrace_location(kp)
{
	unsigned long ftrace_address;

	/* If an architecture handles kprobes on ftrace, we don't check it */
	if (IS_ENABLED(CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE))
		return 0;

	...
}

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


