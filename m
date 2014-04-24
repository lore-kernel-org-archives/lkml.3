Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbaDXRdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbaDXRds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:33:48 -0400
Date: Thu, 24 Apr 2014 19:33:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] uprobes/x86: Refuse to attach uprobe to "word-sized"
	branch insns
Message-ID: <20140424173333.GA416@redhat.com>
References: <1398359304-26472-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398359304-26472-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Masami, Jim, any acks?

On 04/24, Denys Vlasenko wrote:
>
> All branch insns on x86 can be prefixed with the operand-size
> override prefix, 0x66. It was only ever useful for performing
> jumps to 32-bit offsets in 16-bit code segments.
>
> In 32-bit code, such instructions are useless since
> they cause IP truncation to 16 bits, and in case of call insns,
> they save only 16 bits of return address and misalign
> the stack pointer as a "bonus".
>
> In 64-bit code, such instructions are treated differently by Intel
> and AMD CPUs: Intel ignores the prefix altogether,
> AMD treats them the same as in 32-bit mode.
>
> Before this patch, the emulation code would execute
> the instructions as if they have no 0x66 prefix.
>
> With this patch, we refuse to attach uprobes to such insns.
>
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/uprobes.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index ace2291..29b152d 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -582,6 +582,7 @@ static struct uprobe_xol_ops branch_xol_ops = {
>  /* Returns -ENOSYS if branch_xol_ops doesn't handle this insn */
>  static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
>  {
> +	int i;
>  	u8 opc1 = OPCODE1(insn);
>
>  	/* has the side-effect of processing the entire instruction */
> @@ -612,6 +613,17 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
>  			return -ENOSYS;
>  	}
>
> +	/*
> +	 * 16-bit overrides such as CALLW (66 e8 nn nn) are not supported.
> +	 * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
> +	 * No one uses these insns.
> +	 * Reject any branch insns with such prefix.
> +	 */
> +	for (i = 0; i < insn->prefixes.nbytes; i++) {
> +		if (insn->prefixes.bytes[i] == 0x66)
> +			return -ENOTSUPP;
> +	}
> +
>  	auprobe->branch.opc1 = opc1;
>  	auprobe->branch.ilen = insn->length;
>  	auprobe->branch.offs = insn->immediate.value;
> --
> 1.8.1.4
>

