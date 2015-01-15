Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbbAODEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 22:04:22 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49580 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbbAODEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 22:04:21 -0500
Message-ID: <54B72E2D.5000507@hitachi.com>
Date: Thu, 15 Jan 2015 12:04:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 2/2] kprobes: compile out IPMODIFY support if ftrace doesn't
 support it
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz> <20141223094607.GA16445@infradead.org> <20141223151056.GA4789@treble.redhat.com> <20141226155613.36dd95b9@canb.auug.org.au> <20150107144317.61ab2080877a4d8227990551@linux-foundation.org> <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz> <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org> <alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz> <20150107155701.4839545f63701412003edd88@linux-foundation.org> <alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz> <54B3C1DD.6090400@hitachi.com> <alpine.LNX.2.00.1501132345080.4162@pobox.suse.cz> <20150113211223.18908f21@grimm.local.home> <alpine.LNX.2.00.1501140945520.4162@pobox.suse.cz> <alpine.LNX.2.00.1501140947540.4162@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1501140947540.4162@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/14 17:48), Jiri Kosina wrote:
> If ftrace doesn't claim to support IPMODIFY support, there is no need to 
> compile IPMODIFY support in kprobes either.
> 

This looks good to me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  kernel/kprobes.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 06f5830..49a69d7 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -912,7 +912,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  }
>  #endif /* CONFIG_OPTPROBES */
>  
> -#ifdef CONFIG_KPROBES_ON_FTRACE
> +#if defined(CONFIG_KPROBES_ON_FTRACE) && (ftrace_ipmodify_supported == 1)
>  static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
>  	.func = kprobe_ftrace_handler,
>  	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
> @@ -957,7 +957,7 @@ static void disarm_kprobe_ftrace(struct kprobe *p)
>  			   (unsigned long)p->addr, 1, 0);
>  	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n", p->addr, ret);
>  }
> -#else	/* !CONFIG_KPROBES_ON_FTRACE */
> +#else	/* !CONFIG_KPROBES_ON_FTRACE || ftrace_ipmodify_supported == 0 */
>  #define prepare_kprobe(p)	arch_prepare_kprobe(p)
>  #define arm_kprobe_ftrace(p)	do {} while (0)
>  #define disarm_kprobe_ftrace(p)	do {} while (0)
> @@ -1416,12 +1416,12 @@ int __weak arch_check_ftrace_location(struct kprobe *p)
>  
>  	ftrace_addr = ftrace_location((unsigned long)p->addr);
>  	if (ftrace_addr) {
> -#ifdef CONFIG_KPROBES_ON_FTRACE
> +#if defined(CONFIG_KPROBES_ON_FTRACE) && (ftrace_ipmodify_supported == 1)
>  		/* Given address is not on the instruction boundary */
>  		if ((unsigned long)p->addr != ftrace_addr)
>  			return -EILSEQ;
>  		p->flags |= KPROBE_FLAG_FTRACE;
> -#else	/* !CONFIG_KPROBES_ON_FTRACE */
> +#else	/* !CONFIG_KPROBES_ON_FTRACE || ftrace_ipmodify_supported == 0 */
>  		return -EINVAL;
>  #endif
>  	}
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


