Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaD1Pb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaD1Pby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:31:54 -0400
Date: Mon, 28 Apr 2014 17:31:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2] uprobes: simplify rip-relative handling
Message-ID: <20140428153143.GA20901@redhat.com>
References: <1398697605-7519-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398697605-7519-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Denys Vlasenko wrote:
>
> It is possible to replace rip-relative addressing mode
> with addressing mode of the same length: (reg+disp32).
> This eliminates the need to fix up immediate
> and instruction length.

"and change instruction length", I presume.

I like this patch very much, and I would be happy to ack everything
except this part:

> @@ -307,22 +313,13 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  		 * #1) for the scratch register.
>  		 */
>  		auprobe->def.fixups |= UPROBE_FIX_RIP_CX;
> -		/* Change modrm from 00 000 101 to 00 000 001. */
> -		*cursor = 0x1;
> +		/* Change modrm from 00 000 101 to 10 000 001. */
> +		*cursor = 0x81;
>  	} else {
>  		/* Use %rax (register #0) for the scratch register. */
>  		auprobe->def.fixups |= UPROBE_FIX_RIP_AX;
> -		/* Change modrm from 00 xxx 101 to 00 xxx 000 */
> -		*cursor = (reg << 3);
> -	}
> -
> -	/* Target address = address of next instruction + (signed) offset */
> -	auprobe->def.riprel_target = (long)insn->length + insn->displacement.value;
> -
> -	/* Displacement field is gone; slide immediate field (if any) over. */
> -	if (insn->immediate.nbytes) {
> -		cursor++;
> -		memmove(cursor, cursor + insn->displacement.nbytes, insn->immediate.nbytes);
> +		/* Change modrm from 00 xxx 101 to 10 xxx 000 */
> +		*cursor = (reg << 3) | 0x80;
>  	}

As you know, this is black magic for me.

Masami, Jim, please review and ack/nack?

> @@ -343,26 +340,17 @@ static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  		unsigned long *sr = scratch_reg(auprobe, regs);
>  
>  		utask->autask.saved_scratch_register = *sr;
> -		*sr = utask->vaddr + auprobe->def.riprel_target;
> +		*sr = utask->vaddr + (int)auprobe->def.ilen;
                                     ^^^^^

Why? This is pointless and even misleading. I'll remove this part if you
do not object.

Oleg.

