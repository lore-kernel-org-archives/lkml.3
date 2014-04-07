Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbaDGUm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:42:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41845 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaDGUmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:42:55 -0400
Subject: Re: [RFC PATCH 3/6] uprobes/x86: Introduce sizeof_long(), cleanup
 adjust_ret_addr() and arch_uretprobe_hijack_return_addr()
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1396902865.9333.29.camel@oc7886638347.ibm.com.usor.ibm.com>
References: <20140406201625.GA504@redhat.com>
	 <1396902865.9333.29.camel@oc7886638347.ibm.com.usor.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Apr 2014 13:42:47 -0700
Message-ID: <1396903367.9333.33.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040720-8236-0000-0000-0000015CB1BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 13:34 -0700, Jim Keniston wrote:
> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
> > 1. Add the trivial sizeof_long() helper and change other callers of
> >    is_ia32_task() to use it.
> > 
> ...
> 
> This hunk #3 doesn't apply for me.  I can't find in your patch sets
> where you added the lines being replaced (and they weren't there
> originally).

False alarm, I think.  I didn't have your patch #9 v3 from Saturday.
Jim

> 
> After I fixed up this hunk, this patch and the rest applied OK.
> 
> > @@ -450,10 +448,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
> > 
> >  	if (auprobe->fixups & UPROBE_FIX_CALL) {
> >  		if (adjust_ret_addr(regs->sp, correction)) {
> > -			if (is_ia32_task())
> > -				regs->sp += 4;
> > -			else
> > -				regs->sp += 8;
> > +			regs->sp += sizeof_long();
> >  			return -ERESTART;
> >  		}
> >  	}
> > @@ -738,23 +733,21 @@ if (ret) pr_crit("EMULATE: %lx -> %lx\n", ip, regs->ip);
> ...
> 
> This modified hunk worked for me.
> @@ -450,7 +448,9 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
> 
>  	if (auprobe->fixups & UPROBE_FIX_CALL) {
> -		if (adjust_ret_addr(regs->sp, correction))
> +		if (adjust_ret_addr(regs->sp, correction)) {
> +			regs->sp += sizeof_long();
>  			return -ERESTART;
> +		}
>  	}
>  
>  	return 0;
> 
> Jim


