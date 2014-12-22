Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaLVKKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:10:50 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:53545 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaLVKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <1416292375-29560-2-git-send-email-dave.long@linaro.org>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
	<1416292375-29560-2-git-send-email-dave.long@linaro.org>
Date: Mon, 22 Dec 2014 15:40:48 +0530
Message-ID: <CAHM4w1n4MZ7o2M9ZV+6ZO1QAXWZkFi5fvPfjStY9Xdc+=tgyRg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] arm64: Kprobes with single stepping support
From: Pratyush Anand <pratyush.anand@gmail.com>
To: David Long <dave.long@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        William Cohen <wcohen@redhat.com>, davem@davemloft.net,
        Pratyush Anand <panand@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, Nov 18, 2014 at 12:02 PM, David Long <dave.long@linaro.org> wrote:
> From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>
> Add support for basic kernel probes(kprobes) and jump probes
> (jprobes) for ARM64.

Some part of the code can be reused for uprobes as well. I think,
there would still be next
revision. So, if you can re-factor those parts in v4.

[...]


> +++ b/arch/arm64/include/asm/probes.h
> @@ -0,0 +1,50 @@
> +/*
> + * arch/arm64/include/asm/probes.h
> + *
> + * Copyright (C) 2013 Linaro Limited
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
> +#ifndef _ARM_PROBES_H
> +#define _ARM_PROBES_H
> +
> +struct kprobe;
> +struct arch_specific_insn;
> +
> +typedef u32 kprobe_opcode_t;
> +typedef unsigned long (kprobes_pstate_check_t)(unsigned long);
> +typedef unsigned long
> +(kprobes_condition_check_t)(struct kprobe *p, struct pt_regs *);

To be used for uprobe:
p->opcode and p->ainsn can be passed in stead of p.

> +typedef void
> +(kprobes_prepare_t)(struct kprobe *, struct arch_specific_insn *);

ditto.. can pass p->opcode in stead of p.

> +typedef void (kprobes_handler_t) (u32 opcode, long addr, struct pt_regs *);
> +
> +enum pc_restore_type {
> +       NO_RESTORE,
> +       RESTORE_PC,
> +};
> +
> +struct kprobe_pc_restore {
> +       enum pc_restore_type type;
> +       unsigned long addr;
> +};
> +
> +/* architecture specific copy of original instruction */
> +struct arch_specific_insn {
> +       kprobe_opcode_t *insn;
> +       kprobes_pstate_check_t *pstate_cc;
> +       kprobes_condition_check_t *check_condn;
> +       kprobes_prepare_t *prepare;
> +       kprobes_handler_t *handler;
> +       /* restore address after step xol */
> +       struct kprobe_pc_restore restore;
> +};

Probably it would be better to keep name as probe_xxxx in stead of kprobe_xxxx.

> +
> +#endif

[...]

> diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/kprobes-arm64.c

I think most of the stuff of this file can be used for uprobe. So what
about keeping
name as probes-arm64.c


> new file mode 100644
> index 0000000..30d1c14

[...]

[...]

> +enum kprobe_insn __kprobes
> +arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +{
> +       return kprobe_decode_insn(insn, asi, aarch64_decode_table);
> +}

may be we can replace kprobe to probe for the above function as well.


[...]



> +/*
> + * arch/arm64/kernel/kprobes.h
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
> +#ifndef _ARM_KERNEL_KPROBES_H
> +#define _ARM_KERNEL_KPROBES_H
> +
> +/* BRK opcodes with ESR encoding  */
> +#define BRK64_ESR_MASK         0xFFFF
> +#define BRK64_ESR_KPROBES      0x0004
> +#define BRK64_OPCODE_KPROBES   0xD4200080      /* "brk 0x4" */
> +#define ARCH64_NOP_OPCODE      0xD503201F

Probably these definitions can be kept in asm/insn.h. There we can add another
BRK64_OPCODE_UPROBES with different brk code.


~Pratyush
