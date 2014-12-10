Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaLJNX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:23:29 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:38806 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbaLJNX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:23:26 -0500
Message-ID: <1418217797.3661.22.camel@linaro.org>
Subject: Re: [RESEND][PATCH v15 6/7] kprobes: Pass the original kprobe for
 preparing optimized kprobe
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: masami.hiramatsu.pt@hitachi.com
Cc: Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 10 Dec 2014 13:23:17 +0000
In-Reply-To: <1418047765-53197-7-git-send-email-wangnan0@huawei.com>
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>
	 <1418047765-53197-7-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami Hiramatsu

How should this patch find its way into the mainline? Is it OK to submit
this as part of the ARM kprobe changes (which presumably will go in via
Russell's tree)?
 
-- 
Tixy

On Mon, 2014-12-08 at 22:09 +0800, Wang Nan wrote:
> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Pass the original kprobe for preparing an optimized kprobe arch-dep
> part, since for some architecture (e.g. ARM32) requires the information
> in original kprobe.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  arch/x86/kernel/kprobes/opt.c | 3 ++-
>  include/linux/kprobes.h       | 3 ++-
>  kernel/kprobes.c              | 4 ++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
> index f1314d0..7028296 100644
> --- a/arch/x86/kernel/kprobes/opt.c
> +++ b/arch/x86/kernel/kprobes/opt.c
> @@ -320,7 +320,8 @@ void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
>   * Target instructions MUST be relocatable (checked inside)
>   * This is called when new aggr(opt)probe is allocated or reused.
>   */
> -int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
> +int arch_prepare_optimized_kprobe(struct optimized_kprobe *op,
> +				  struct kprobe *__unused)
>  {
>  	u8 *buf;
>  	int ret;
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index f7296e5..7ab2c93 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -308,7 +308,8 @@ struct optimized_kprobe {
>  /* Architecture dependent functions for direct jump optimization */
>  extern int arch_prepared_optinsn(struct arch_optimized_insn *optinsn);
>  extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
> -extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
> +extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op,
> +					 struct kprobe *orig);
>  extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
>  extern void arch_optimize_kprobes(struct list_head *oplist);
>  extern void arch_unoptimize_kprobes(struct list_head *oplist,
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3995f54..9f28aa7 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -717,7 +717,7 @@ static void prepare_optimized_kprobe(struct kprobe *p)
>  	struct optimized_kprobe *op;
>  
>  	op = container_of(p, struct optimized_kprobe, kp);
> -	arch_prepare_optimized_kprobe(op);
> +	arch_prepare_optimized_kprobe(op, p);
>  }
>  
>  /* Allocate new optimized_kprobe and try to prepare optimized instructions */
> @@ -731,7 +731,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  
>  	INIT_LIST_HEAD(&op->list);
>  	op->kp.addr = p->addr;
> -	arch_prepare_optimized_kprobe(op);
> +	arch_prepare_optimized_kprobe(op, p);
>  
>  	return &op->kp;
>  }


