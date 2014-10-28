Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaJ1MAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:00:31 -0400
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:49386 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbaJ1MA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:00:29 -0400
Message-ID: <1414497605.1433.3.camel@linaro.org>
Subject: Re: [PATCH 4/4] ARM: kprobes: disallow probing stack consuming
 instructions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        will.deacon@arm.com, dave.long@linaro.org, taras.kondratiuk@linaro.org,
        ben.dooks@codethink.co.uk, cl@linux.com, rabin@rab.in,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lizefan@huawei.com
Date: Tue, 28 Oct 2014 12:00:05 +0000
In-Reply-To: <1414219373-20070-5-git-send-email-wangnan0@huawei.com>
References: <1414219373-20070-1-git-send-email-wangnan0@huawei.com>
	 <1414219373-20070-5-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-25 at 14:42 +0800, Wang Nan wrote:
> This patch prohibit probing instructions for which the stack
> requirement are unable to be determined statically. Some test cases
> are found not work again after the modification, this patch also
> removes them.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
[...] 
> diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
> index 618531d..59f5e64 100644
> --- a/arch/arm/kernel/kprobes.c
> +++ b/arch/arm/kernel/kprobes.c
> @@ -124,6 +124,14 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  		break;
>  	}
>  
> +	/*
> +	 * Unable to instrument insn like 'str r0, [sp, +/-r1]'.
> +	 * __und_svc protects 64 bytes stack, so instrumenting insn
> +	 * likes 'str r0, [sp, #-68]' should be prohibited.
> +	 */
> +	if ((p->ainsn.stack_space < 0) || (p->ainsn.stack_space > 64))

Rather than using the hard coded value 64 it would be safest to create a
#define for the value (in arch/arm/include/asm/kprobes.h) and use that
define in __und_svc too.

Actually, there is already a define there for MAX_STACK_SIZE which is
used as the size of the stack for jprobes and the amount copied by
setjmp_pre_handler and longjmp_break_handler, which looks like it has
the same purpose as we want i.e. allowing space for probed instructions
to push things onto the stack. So we should probably use that define in
this patch and update __und_svc too.

Also, jprobe_return has this comment

 * We allocate some slack between the original SP and start of
 * our fabricated regs. To be precise we want to have worst case
 * covered which is STMFD with all 16 regs so we allocate 2 *
 * sizeof(struct_pt_regs)).
 *
 * This is to prevent any simulated instruction from writing
 * over the regs when they are accessing the stack.

which looking at the code should probably more accurately specified as
sizeof(struct_pt_regs)+MAX_STACK_SIZE rather than
2*sizeof(struct_pt_regs)

I've not looked at the jprobes specific code before, so it would be good
to have someone else's option on what I save above about how
MAX_STACK_SIZE is and should be used.

-- 
Tixy

