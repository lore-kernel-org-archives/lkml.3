Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaDACBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:01:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44083 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaDACBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:01:06 -0400
Message-ID: <533A1DDA.4080308@hitachi.com>
Date: Tue, 01 Apr 2014 11:00:58 +0900
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
Subject: Re: [PATCH 2/7] uprobes/x86: Fold prepare_fixups() into arch_uprobe_analyze_insn()
References: <20140331194359.GA9278@redhat.com>
In-Reply-To: <20140331194359.GA9278@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 4:43), Oleg Nesterov wrote:
> No functional changes, preparation.
> 
> Shift the code from prepare_fixups() to arch_uprobe_analyze_insn()
> with the following modifications:
> 
> 	- Do not call insn_get_opcode() again, it was already called
> 	  by validate_insn_bits().
> 
> 	- Move "case 0xea" up. This way "case 0xff" can fall through
> 	  to default case.
> 
> 	- change "case 0xff" to use the nested "switch (MODRM_REG)",
> 	  this way the code looks a bit simpler.
> 
> 	- Make the comments look consistent.

Interesting. Similar cleanup should be applied to kprobes too. :)

> 
> While at it, kill the initialization of rip_rela_target_address and
> ->fixups, we can rely on kzalloc(). We will add the new members into
> arch_uprobe, it would be better to assume that everything is zero by
> default.
> 
> TODO: cleanup/fix the mess in validate_insn_bits() paths:
> 
> 	- validate_insn_64bits() and validate_insn_32bits() should be
> 	  unified.
> 
> 	- "ifdef" is not used consistently; if good_insns_64 depends
> 	  on CONFIG_X86_64, then probably good_insns_32 should depend
> 	  on CONFIG_X86_32/EMULATION
> 
> 	- the usage of mm->context.ia32_compat looks wrong if the task
> 	  is TIF_X32.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  arch/x86/kernel/uprobes.c |  110 +++++++++++++++++++--------------------------
>  1 files changed, 47 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 2ed8459..098e56e 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -53,7 +53,7 @@
>  #define OPCODE1(insn)		((insn)->opcode.bytes[0])
>  #define OPCODE2(insn)		((insn)->opcode.bytes[1])
>  #define OPCODE3(insn)		((insn)->opcode.bytes[2])
> -#define MODRM_REG(insn)		X86_MODRM_REG(insn->modrm.value)
> +#define MODRM_REG(insn)		X86_MODRM_REG((insn)->modrm.value)
>  
>  #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
>  	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
> @@ -229,63 +229,6 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
>  	return -ENOTSUPP;
>  }
>  
> -/*
> - * Figure out which fixups arch_uprobe_post_xol() will need to perform, and
> - * annotate arch_uprobe->fixups accordingly.  To start with,
> - * arch_uprobe->fixups is either zero or it reflects rip-related fixups.
> - */
> -static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
> -{
> -	bool fix_ip = true, fix_call = false;	/* defaults */
> -	int reg;
> -
> -	insn_get_opcode(insn);	/* should be a nop */
> -
> -	switch (OPCODE1(insn)) {
> -	case 0x9d:
> -		/* popf */
> -		auprobe->fixups |= UPROBE_FIX_SETF;
> -		break;
> -	case 0xc3:		/* ret/lret */
> -	case 0xcb:
> -	case 0xc2:
> -	case 0xca:
> -		/* ip is correct */
> -		fix_ip = false;
> -		break;
> -	case 0xe8:		/* call relative - Fix return addr */
> -		fix_call = true;
> -		break;
> -	case 0x9a:		/* call absolute - Fix return addr, not ip */
> -		fix_call = true;
> -		fix_ip = false;
> -		break;
> -	case 0xff:
> -		insn_get_modrm(insn);
> -		reg = MODRM_REG(insn);
> -		if (reg == 2 || reg == 3) {
> -			/* call or lcall, indirect */
> -			/* Fix return addr; ip is correct. */
> -			fix_call = true;
> -			fix_ip = false;
> -		} else if (reg == 4 || reg == 5) {
> -			/* jmp or ljmp, indirect */
> -			/* ip is correct. */
> -			fix_ip = false;
> -		}
> -		break;
> -	case 0xea:		/* jmp absolute -- ip is correct */
> -		fix_ip = false;
> -		break;
> -	default:
> -		break;
> -	}
> -	if (fix_ip)
> -		auprobe->fixups |= UPROBE_FIX_IP;
> -	if (fix_call)
> -		auprobe->fixups |= UPROBE_FIX_CALL;
> -}
> -
>  #ifdef CONFIG_X86_64
>  /*
>   * If arch_uprobe->insn doesn't use rip-relative addressing, return
> @@ -318,7 +261,6 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct ins
>  	if (mm->context.ia32_compat)
>  		return;
>  
> -	auprobe->rip_rela_target_address = 0x0;
>  	if (!insn_rip_relative(insn))
>  		return;
>  
> @@ -421,16 +363,58 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
>   */
>  int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
>  {
> -	int ret;
>  	struct insn insn;
> +	bool fix_ip = true, fix_call = false;
> +	int ret;
>  
> -	auprobe->fixups = 0;
>  	ret = validate_insn_bits(auprobe, mm, &insn);
> -	if (ret != 0)
> +	if (ret)
>  		return ret;
>  
> +	/*
> +	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
> +	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
> +	 * is either zero or it reflects rip-related fixups.
> +	 */
>  	handle_riprel_insn(auprobe, mm, &insn);
> -	prepare_fixups(auprobe, &insn);
> +
> +	switch (OPCODE1(&insn)) {
> +	case 0x9d:		/* popf */
> +		auprobe->fixups |= UPROBE_FIX_SETF;
> +		break;
> +	case 0xc3:		/* ret or lret -- ip is correct */
> +	case 0xcb:
> +	case 0xc2:
> +	case 0xca:
> +		fix_ip = false;
> +		break;
> +	case 0xe8:		/* call relative - Fix return addr */
> +		fix_call = true;
> +		break;
> +	case 0x9a:		/* call absolute - Fix return addr, not ip */
> +		fix_call = true;
> +		fix_ip = false;
> +		break;
> +	case 0xea:		/* jmp absolute -- ip is correct */
> +		fix_ip = false;
> +		break;
> +	case 0xff:
> +		insn_get_modrm(&insn);
> +		switch (MODRM_REG(&insn)) {
> +		case 2: case 3:			/* call or lcall, indirect */
> +			fix_call = true;
> +		case 4: case 5:			/* jmp or ljmp, indirect */
> +			fix_ip = false;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (fix_ip)
> +		auprobe->fixups |= UPROBE_FIX_IP;
> +	if (fix_call)
> +		auprobe->fixups |= UPROBE_FIX_CALL;
>  
>  	return 0;
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


