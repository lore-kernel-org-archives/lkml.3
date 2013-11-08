Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3KHRDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:03:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40610 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757145Ab3KHRDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:03:47 -0500
Date: Fri, 8 Nov 2013 17:03:33 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>
Subject: Re: [PATCH RFC 3/6] arm64: Kprobes instruction simulation support
Message-ID: <20131108170333.GE15074@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
 <1382008671-4515-4-git-send-email-sandeepa.prabhu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382008671-4515-4-git-send-email-sandeepa.prabhu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 12:17:48PM +0100, Sandeepa Prabhu wrote:
> Add support for AArch64 instruction simulation in kprobes.
> 
> Kprobes need simulation of instructions that cannot be stepped
> right-away from different memory location. i.e. those instructions
> that uses PC-relative addressing. In simulation, the behaviour
> of the instruction is implemented using copy of pt_regs.
> 
> Following instruction catagories are simulated:
>  - All branching instructions(conditional, register, and immediate)
>  - Literal access instructions(load-literal, adr/adrp)
> 
> conditional execution are limited to branching instructions in
> ARM v8. If conditions at PSTATE does not match the condition fields
> of opcode, the instruction is effectively NOP. Kprobes consider
> this case as 'miss'.

[...]

> diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/kprobes-arm64.c
> index 30d1c14..c690be3 100644
> --- a/arch/arm64/kernel/kprobes-arm64.c
> +++ b/arch/arm64/kernel/kprobes-arm64.c
> @@ -20,6 +20,101 @@
> 
>  #include "probes-decode.h"
>  #include "kprobes-arm64.h"
> +#include "simulate-insn.h"
> +
> +/*
> + * condition check functions for kprobes simulation
> + */
> +static unsigned long __kprobes
> +__check_pstate(struct kprobe *p, struct pt_regs *regs)
> +{
> +       struct arch_specific_insn *asi = &p->ainsn;
> +       unsigned long pstate = regs->pstate & 0xffffffff;
> +
> +       return asi->pstate_cc(pstate);
> +}
> +
> +static unsigned long __kprobes
> +__check_cbz(struct kprobe *p, struct pt_regs *regs)
> +{
> +       return check_cbz((u32)p->opcode, regs);

Isn't p->opcode already a u32? (by your definition of kprobe_opcode_t).

> diff --git a/arch/arm64/kernel/simulate-insn.c b/arch/arm64/kernel/simulate-insn.c
> new file mode 100644
> index 0000000..10173cf
> --- /dev/null
> +++ b/arch/arm64/kernel/simulate-insn.c
> @@ -0,0 +1,184 @@
> +/*
> + * arch/arm64/kernel/simulate-insn.c
> + *
> + * Copyright (C) 2013 Linaro Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/kprobes.h>
> +#include <linux/module.h>
> +
> +#include "simulate-insn.h"
> +
> +#define sign_extend(x, signbit)                \
> +       ((x) | (0 - ((x) & (1 << (signbit)))))
> +
> +#define bbl_displacement(insn)         \
> +       sign_extend(((insn) & 0x3ffffff) << 2, 27)
> +
> +#define bcond_displacement(insn)       \
> +       sign_extend(((insn >> 5) & 0xfffff) << 2, 21)
> +
> +#define cbz_displacement(insn) \
> +       sign_extend(((insn >> 5) & 0xfffff) << 2, 21)
> +
> +#define tbz_displacement(insn) \
> +       sign_extend(((insn >> 5) & 0x3fff) << 2, 15)
> +
> +#define ldr_displacement(insn) \
> +       sign_extend(((insn >> 5) & 0xfffff) << 2, 21)

The mask, shift and signbit position are all related here, so you could
rework the definition of sign_extend to avoid having three magic numbers.

Will
