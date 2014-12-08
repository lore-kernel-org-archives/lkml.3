Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaLHNWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:22:24 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:46547 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbaLHNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:22:22 -0500
Message-ID: <1418044934.3647.61.camel@linaro.org>
Subject: Re: [PATCH v14 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 08 Dec 2014 13:22:14 +0000
In-Reply-To: <54859A2C.8030009@huawei.com>
References: <1418020040-68977-1-git-send-email-wangnan0@huawei.com>
			 <1418020131-69375-1-git-send-email-wangnan0@huawei.com>
		 <1418036666.3647.33.camel@linaro.org> <5485886E.2060303@huawei.com>
	 <1418039451.3647.48.camel@linaro.org> <54859454.30603@huawei.com>
	 <54859A2C.8030009@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 20:31 +0800, Wang Nan wrote:
> On 2014/12/8 20:06, Wang Nan wrote:
> > On 2014/12/8 19:50, Jon Medhurst (Tixy) wrote:
> >> On Mon, 2014-12-08 at 19:15 +0800, Wang Nan wrote:
> >>> On 2014/12/8 19:04, Jon Medhurst (Tixy) wrote:
> >>>> On Mon, 2014-12-08 at 14:28 +0800, Wang Nan wrote:
> [...]
> >>
> >> so another CPU could find and delete next before this one has finished
> >> doing so. Would the list end up in a consistent state where no loops
> >> develop and no probes are missed? I don't know the answer and a full
> >> analysis would be complicated, but my gut feeling is that if a cpu can
> >> observe the links in the list in an inconsistent state then only bad
> >> things can result.
> >>
> > 
> > I see the problem.
> > 
> > I'm thinking about making core.c and opt-arm.c to share stop_machine() code.
> > stop_machine() is required when removing breakpoint, so I'd like to define
> > a "remove_breakpoint" function in core.c and make opt-arm.c to call it.
> > Do you think it is a good idea?
> > 
> > 
> 
> What I mean is something like this:

Yes, that should work, though as remove_breakpoint is a globally visible
symbol, I suggest a less generic name for it, perhaps
remove_kprobe_breakpoint ?

-- 
Tixy


> diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
> index 3a58db4..efd8ab1 100644
> --- a/arch/arm/probes/kprobes/core.c
> +++ b/arch/arm/probes/kprobes/core.c
> @@ -163,19 +163,31 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
>   * memory. It is also needed to atomically set the two half-words of a 32-bit
>   * Thumb breakpoint.
>   */
> -int __kprobes __arch_disarm_kprobe(void *p)
> -{
> -	struct kprobe *kp = p;
> -	void *addr = (void *)((uintptr_t)kp->addr & ~1);
> -
> -	__patch_text(addr, kp->opcode);
> +struct patch {
> +	void *addr;
> +	unsigned int insn;
> +};
> 
> +static int __remove_breakpoint(void *data)
> +{
> +	struct patch *p = data;
> +	__patch_text(p->addr, p->insn);
>  	return 0;
>  }
> 
> +void __kprobes remove_breakpoint(void *addr, unsigned int insn)
> +{
> +	struct patch p = {
> +		.addr = addr,
> +		.insn = insn,
> +	};
> +	stop_machine(__remove_breakpoint, &p, cpu_online_mask);
> +}
> +
>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> -	stop_machine(__arch_disarm_kprobe, p, cpu_online_mask);
> +	remove_breakpoint((void *)((uintptr_t)p->addr & ~1),
> +			p->opcode);
>  }
> 
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> diff --git a/arch/arm/probes/kprobes/core.h b/arch/arm/probes/kprobes/core.h
> index f88c79f..7b7c334 100644
> --- a/arch/arm/probes/kprobes/core.h
> +++ b/arch/arm/probes/kprobes/core.h
> @@ -30,6 +30,8 @@
>  #define KPROBE_THUMB16_BREAKPOINT_INSTRUCTION	0xde18
>  #define KPROBE_THUMB32_BREAKPOINT_INSTRUCTION	0xf7f0a018
> 
> +extern void remove_breakpoint(void *addr, unsigned int insn);
> +
>  enum probes_insn __kprobes
>  kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_probes_insn *asi,
>  		const struct decode_header *h);
> diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
> index afbfeef..a1a1882 100644
> --- a/arch/arm/probes/kprobes/opt-arm.c
> +++ b/arch/arm/probes/kprobes/opt-arm.c
> @@ -28,8 +28,9 @@
>  #include <asm/insn.h>
>  /* for patch_text */
>  #include <asm/patch.h>
> -/* for stop_machine */
> -#include <linux/stop_machine.h>
> +
> +#include "core.h"
> +
>  /*
>   * NOTE: the first sub and add instruction will be modified according
>   * to the stack cost of the instruction.
> @@ -245,13 +246,8 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *or
>  	return 0;
>  }
> 
> -/*
> - * Similar to __arch_disarm_kprobe, operations which removing
> - * breakpoints must be wrapped by stop_machine to avoid racing.
> - */
> -static __kprobes int __arch_optimize_kprobes(void *p)
> +void __kprobes arch_optimize_kprobes(struct list_head *oplist)
>  {
> -	struct list_head *oplist = p;
>  	struct optimized_kprobe *op, *tmp;
> 
>  	list_for_each_entry_safe(op, tmp, oplist, list) {
> @@ -277,16 +273,15 @@ static __kprobes int __arch_optimize_kprobes(void *p)
>  			  op->optinsn.copied_insn[0]) & 0xf0000000) |
>  			(insn & 0x0fffffff);
> 
> -		patch_text(op->kp.addr, insn);
> +		/*
> +		 * Similar to __arch_disarm_kprobe, operations which
> +		 * removing breakpoints must be wrapped by stop_machine
> +		 * to avoid racing.
> +		 */
> +		remove_breakpoint(op->kp.addr, insn);
> 
>  		list_del_init(&op->list);
>  	}
> -	return 0;
> -}
> -
> -void arch_optimize_kprobes(struct list_head *oplist)
> -{
> -	stop_machine(__arch_optimize_kprobes, oplist, cpu_online_mask);
>  }
> 
>  void arch_unoptimize_kprobe(struct optimized_kprobe *op)



