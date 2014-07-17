Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaGQSVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:21:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:50389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751349AbaGQSVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:21:54 -0400
Date: Thu, 17 Jul 2014 14:21:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH ftrace/core v3 1/3] [BUGFIX]kprobes/ftrace: Recover
 original IP if pre_handler doesn't change it
Message-ID: <20140717142151.51bde92c@gandalf.local.home>
In-Reply-To: <20140715060021.12195.9680.stgit@kbuild-fedora.novalocal>
References: <20140715060015.12195.74457.stgit@kbuild-fedora.novalocal>
	<20140715060021.12195.9680.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks to require an acked-by from hpa.

On Tue, 15 Jul 2014 06:00:21 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Recover original IP register if the pre_handler doesn't change it.
> Since current kprobes doesn't expect that another ftrace handler
> may change regs->ip, it sets kprobe.addr + MCOUNT_INSN_SIZE to
> regs->ip and returns to ftrace.
> This seems wrong behavior since kprobes can recover regs->ip
> and safely pass it to other handler.

s/other/another/

> 
> This adds a code which recovers original regs->ip passed from

 "... adds code which recovers the original ..."

> ftrace right before returning ftrace, so that another ftrace user

 "... returning to ftrace, ..."

> can change regs->ip.

You say BUGFIX in the subject, but as nothing changes the regs->ip
currently from ftrace, is this currently a real bug?

-- Steve

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  arch/x86/kernel/kprobes/ftrace.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
> index 717b02a..5f8f0b3 100644
> --- a/arch/x86/kernel/kprobes/ftrace.c
> +++ b/arch/x86/kernel/kprobes/ftrace.c
> @@ -27,7 +27,7 @@
>  
>  static nokprobe_inline
>  int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
> -		      struct kprobe_ctlblk *kcb)
> +		      struct kprobe_ctlblk *kcb, unsigned long orig_ip)
>  {
>  	/*
>  	 * Emulate singlestep (and also recover regs->ip)
> @@ -39,6 +39,8 @@ int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
>  		p->post_handler(p, regs, 0);
>  	}
>  	__this_cpu_write(current_kprobe, NULL);
> +	if (orig_ip)
> +		regs->ip = orig_ip;
>  	return 1;
>  }
>  
> @@ -46,7 +48,7 @@ int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
>  		    struct kprobe_ctlblk *kcb)
>  {
>  	if (kprobe_ftrace(p))
> -		return __skip_singlestep(p, regs, kcb);
> +		return __skip_singlestep(p, regs, kcb, 0);
>  	else
>  		return 0;
>  }
> @@ -71,13 +73,14 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
>  	if (kprobe_running()) {
>  		kprobes_inc_nmissed_count(p);
>  	} else {
> +		unsigned long orig_ip = regs->ip;
>  		/* Kprobe handler expects regs->ip = ip + 1 as breakpoint hit */
>  		regs->ip = ip + sizeof(kprobe_opcode_t);
>  
>  		__this_cpu_write(current_kprobe, p);
>  		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
>  		if (!p->pre_handler || !p->pre_handler(p, regs))
> -			__skip_singlestep(p, regs, kcb);
> +			__skip_singlestep(p, regs, kcb, orig_ip);
>  		/*
>  		 * If pre_handler returns !0, it sets regs->ip and
>  		 * resets current kprobe.
> 

