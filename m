Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbaDHUg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:36:58 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58076 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaDHUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:36:56 -0400
Subject: Re: [RFC PATCH 1/6] uprobes/x86: Emulate unconditional
 rip-relative jmp's
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
In-Reply-To: <20140406201617.GA493@redhat.com>
References: <20140406201617.GA493@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Apr 2014 13:36:51 -0700
Message-ID: <1396989411.5056.16.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040820-0928-0000-0000-000001175B06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
> 0xeb and 0xe9. Anything else?

For unconditional rip-relative jumps, yes, I'm pretty sure that's it.

> 
> TODO: move ->fixup into the union along with rip_rela_target_address.
> 
> Reported-by: Jonathan Lebon <jlebon@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/include/asm/uprobes.h |    8 +++++++-
>  arch/x86/kernel/uprobes.c      |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 9f8210b..cca62c5 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -44,9 +44,15 @@ struct arch_uprobe {
>  	u16				fixups;
>  	const struct uprobe_xol_ops	*ops;
> 
> +	union {
>  #ifdef CONFIG_X86_64
> -	unsigned long			rip_rela_target_address;
> +		unsigned long			rip_rela_target_address;
>  #endif
> +		struct {
> +			s32	disp;
> +			u8	ilen;
> +		}				ttt;

Are you planning to stick with ttt as the name/prefix for all this
jump-emulation code?  Seems like you could come up with something more
descriptive without adding a lot of characters.
 
> +	};
>  };
> 
>  struct arch_uprobe_task {
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 1ea7e1a..32ab147 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -466,6 +466,42 @@ static struct uprobe_xol_ops default_xol_ops = {
>  	.post_xol = default_post_xol_op,
>  };
> 
> +static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	regs->ip += auprobe->ttt.ilen + auprobe->ttt.disp;
> +	return true;
> +}
> +
> +static struct uprobe_xol_ops ttt_xol_ops = {
> +	.emulate  = ttt_emulate_op,
> +};
> +
> +static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
> +{
> +
> +	switch (OPCODE1(insn)) {
> +	case 0xeb:	/* jmp 8 */
> +	case 0xe9:	/* jmp 32 */
> +		break;
> +	default:
> +		return -ENOSYS;

-ENOSYS looks like an error return, as opposed to what it is, the normal
return when the probed instruction is something other than a jump.  This
gets more bewildering as you add patches and this switch grows and gets
more complicated.  Add a comment here?

> +	}
> +
> +	/* has the side-effect of processing the entire instruction */
> +	insn_get_length(insn);
> +	if (WARN_ON_ONCE(!insn_complete(insn)))
> +		return -ENOEXEC;
> +
> +	auprobe->ttt.ilen = insn->length;
> +	auprobe->ttt.disp = insn->moffset1.value;
> +	/* so far we assume that it fits into ->moffset1 */
> +	if (WARN_ON_ONCE(insn->moffset2.nbytes))
> +		return -ENOEXEC;

s/moffset1/immediate/ -- which you've already addressed.

> +
> +	auprobe->ops = &ttt_xol_ops;
> +	return 0;
> +}
> +
>  /**
>   * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
>   * @mm: the probed address space.
> @@ -483,6 +519,10 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	if (ret)
>  		return ret;
> 
> +	ret = ttt_setup_xol_ops(auprobe, &insn);
> +	if (ret == 0 || ret != ENOSYS)

This looks wrong in a couple of ways:
a. I think you intend to compare against -ENOSYS, not ENOSYS.
b. Given the (ret != [-]ENOSYS) test, the  (ret == 0) test is
superfluous.


> +		return ret;
> +
>  	/*
>  	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
>  	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups

Jim

