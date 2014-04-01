Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaDADLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:11:08 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55621 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaDADLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:11:03 -0400
Message-ID: <533A2E3F.7060705@hitachi.com>
Date: Tue, 01 Apr 2014 12:10:55 +0900
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
Subject: Re: [PATCH 4/7] uprobes/x86: Kill the "ia32_compat" check in handle_riprel_insn(),
 remove "mm" arg
References: <20140331194405.GA9290@redhat.com>
In-Reply-To: <20140331194405.GA9290@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 4:44), Oleg Nesterov wrote:
> Kill the "mm->context.ia32_compat" check in handle_riprel_insn(), if
> it is true insn_rip_relative() must return false. validate_insn_bits()
> passed "ia32_compat" as !x86_64 to insn_init(), and insn_rip_relative()
> checks insn->x86_64.
> 
> Also, remove the no longer needed "struct mm_struct *mm" argument and
> the unnecessary "return" at the end.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

This looks good to me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
>  arch/x86/kernel/uprobes.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index d72dfbf..382a69d 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -253,14 +253,11 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
>   *  - The displacement is always 4 bytes.
>   */
>  static void
> -handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
> +handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
>  {
>  	u8 *cursor;
>  	u8 reg;
>  
> -	if (mm->context.ia32_compat)
> -		return;
> -
>  	if (!insn_rip_relative(insn))
>  		return;
>  
> @@ -314,7 +311,6 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct ins
>  		cursor++;
>  		memmove(cursor, cursor + insn->displacement.nbytes, insn->immediate.nbytes);
>  	}
> -	return;
>  }
>  
>  static int validate_insn_64bits(struct arch_uprobe *auprobe, struct insn *insn)
> @@ -343,7 +339,7 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	return validate_insn_64bits(auprobe, insn);
>  }
>  #else /* 32-bit: */
> -static void handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
> +static void handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
>  {
>  	/* No RIP-relative addressing on 32-bit */
>  }
> @@ -406,7 +402,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  		}
>  		/* fall through */
>  	default:
> -		handle_riprel_insn(auprobe, mm, &insn);
> +		handle_riprel_insn(auprobe, &insn);
>  	}
>  
>  	if (fix_ip)
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


