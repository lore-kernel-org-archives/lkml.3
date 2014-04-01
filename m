Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDADSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:18:04 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56787 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaDADSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:18:02 -0400
Message-ID: <533A2FE3.3050101@hitachi.com>
Date: Tue, 01 Apr 2014 12:17:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes/x86: Conditionalize the usage of handle_riprel_insn()
References: <20140331194402.GA9287@redhat.com>
In-Reply-To: <20140331194402.GA9287@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 4:44), Oleg Nesterov wrote:
> arch_uprobe_analyze_insn() calls handle_riprel_insn() at the start,
> but only "0xff" and "default" cases need the UPROBE_FIX_RIP_ logic.
> Move the callsite into "default" case and change the "0xff" case to
> fall-through.
> 
> We are going to add the various hooks to handle the rip-relative
> jmp/call instructions (and more), we need this change to enforce the
> fact that the new code can't conflict with is_riprel_insn() code.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Hmm, this seems not obviously reasonable at this point.
However, the code itself is not wrong. Could you merge
this change to that new hooks?

Thank you,

> ---
>  arch/x86/kernel/uprobes.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 098e56e..d72dfbf 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -376,8 +376,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
>  	 * is either zero or it reflects rip-related fixups.
>  	 */
> -	handle_riprel_insn(auprobe, mm, &insn);
> -
>  	switch (OPCODE1(&insn)) {
>  	case 0x9d:		/* popf */
>  		auprobe->fixups |= UPROBE_FIX_SETF;
> @@ -406,9 +404,9 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  		case 4: case 5:			/* jmp or ljmp, indirect */
>  			fix_ip = false;
>  		}
> -		break;
> +		/* fall through */
>  	default:
> -		break;
> +		handle_riprel_insn(auprobe, mm, &insn);
>  	}
>  
>  	if (fix_ip)
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


