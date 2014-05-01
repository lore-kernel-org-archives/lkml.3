Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaEASvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaEASvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:51:13 -0400
Date: Thu, 1 May 2014 20:50:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHv4] uprobes: simplify rip-relative handling
Message-ID: <20140501185058.GA17450@redhat.com>
References: <1398955966-7771-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398955966-7771-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I hope that Jim's ack still applies to this version.

On 05/01, Denys Vlasenko wrote:
>
> v4: Changed arch_uprobe_xol_was_trapped() comment to reflect new logic.

Hmm. I guess you meant arch_uprobe_post_xol()... please see below.

>  static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  	struct uprobe_task *utask = current->utask;
> -	long correction = (long)(utask->vaddr - utask->xol_vaddr);
>  
> -	riprel_post_xol(auprobe, regs, &correction);
> +	riprel_post_xol(auprobe, regs);
>  	if (auprobe->def.fixups & UPROBE_FIX_IP) {
> +		long correction = (long)(utask->vaddr - utask->xol_vaddr);

Can't resist, I'll remove this pointless cast ;)

>   * If the original instruction was a rip-relative instruction such as
>   * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
> - * instruction using a scratch register -- e.g., "movl %edx,(%rax)".
> - * We need to restore the contents of the scratch register and adjust
> - * the ip, keeping in mind that the instruction we executed is 4 bytes
> - * shorter than the original instruction (since we squeezed out the offset
> - * field).  (FIX_RIP_AX or FIX_RIP_CX)
> + * instruction using a scratch register -- e.g., "movl %edx,0xnnnn(%rax)".
> + * We need to restore the contents of the scratch register
> + * (FIX_RIP_AX or FIX_RIP_CX).
>   */
>  int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)

Perhaps it makes sense to move this part of the comment above
default_post_xol_op() which actually does this...

I won't insist, I do not really care because I almost never read the comments
anyway ;)

Oleg.

