Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3HLFtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 01:49:43 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59090 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab3HLFtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 01:49:42 -0400
Message-ID: <52087770.1080500@hitachi.com>
Date: Mon, 12 Aug 2013 14:49:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tony Lu <zlu@tilera.com>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] tile: support kprobes on tilegx
References: <2c9c68a646dd67eb51d89d878966c08941efa055.1376076465.git.cmetcalf@tilera.com> <0ffcfe29ff57518f421b3ab86f08ea666c9649e4.1376076466.git.cmetcalf@tilera.com>
In-Reply-To: <0ffcfe29ff57518f421b3ab86f08ea666c9649e4.1376076466.git.cmetcalf@tilera.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony,

(2013/08/10 4:08), Tony Lu wrote:
> This change includes support for Kprobes, Jprobes and Return Probes.

Thank you for the effort, this looks good for the first step.

However, it seems this only supports instructions which doesn't touch
the execution path. I don't know tile ISA, but it should have jump/branch/
call/return etc. Those should be fixed after singlestep out-of-line in
resume_execution(). Or, kprobes should reject to probe on such instructions
by arch_prepare_kprobe().

> +int __kprobes arch_prepare_kprobe(struct kprobe *p)
> +{
> +	unsigned long addr = (unsigned long)p->addr;
> +
> +	if (addr & (sizeof(kprobe_opcode_t) - 1))
> +		return -EINVAL;
> +
> +	/* insn: must be on special executable page on tile. */
> +	p->ainsn.insn = get_insn_slot();
> +	if (!p->ainsn.insn)
> +		return -ENOMEM;
> +
> +	/*
> +	 * In the kprobe->ainsn.insn[] array we store the original
> +	 * instruction at index zero and a break trap instruction at
> +	 * index one.
> +	 */
> +	memcpy(&p->ainsn.insn[0], p->addr, sizeof(kprobe_opcode_t));
> +	p->ainsn.insn[1] = breakpoint2_insn;
> +	p->opcode = *p->addr;
> +
> +	return 0;
> +}
[...]
> +/*
> + * Called after single-stepping.  p->addr is the address of the
> + * instruction whose first byte has been replaced by the "break 0"
> + * temporarily put back the original opcode to single-step, we
> + * single-stepped a copy of the instruction.  The address of this
> + * copy is p->ainsn.insn.
> + *
> + * This function prepares to return from the post-single-step
> + * breakpoint trap.
> + */
> +static void __kprobes resume_execution(struct kprobe *p,
> +				       struct pt_regs *regs,
> +				       struct kprobe_ctlblk *kcb)
> +{
> +	unsigned long orig_pc = kcb->kprobe_saved_pc;
> +	regs->pc = orig_pc + 8;
> +}
> +

I recommend you to fix that, at least filter out non-supported instructions
by arch_prepare_kprobe(), because no other users don't know which
instruction they can probe. :)

Thank you again!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


