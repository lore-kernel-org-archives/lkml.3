Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaJ0MZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:25:08 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54185 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJ0MZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:25:06 -0400
Message-ID: <544E3999.2010802@hitachi.com>
Date: Mon, 27 Oct 2014 21:24:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, will.deacon@arm.com,
        dave.long@linaro.org, taras.kondratiuk@linaro.org,
        ben.dooks@codethink.co.uk, cl@linux.com, rabin@rab.in,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lizefan@huawei.com
Subject: Re: [PATCH v7 1/2] kprobes: copy ainsn after alloc aggr kprobe
References: <1414219865-35988-1-git-send-email-wangnan0@huawei.com> <1414219865-35988-2-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1414219865-35988-2-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/25 15:51), Wang Nan wrote:
> Copy old kprobe to newly alloced optimized_kprobe before
> arch_prepare_optimized_kprobe(). Original kprove can brings more
> information to optimizer.

Hmm, yes, but this also call copy_kprobe twice in try_to_optimize_kprobe().
If you really need the original kprobe information, I think you'd better
change the arch_prepare_optimized_kprobe as below;

/* Pass both of new optprobe and original kprobe */
arch_prepare_optimized_kprobe(op, p);

Thank you,

> 
> v1 -> v2:
>  -  Bugfix: copy p->addr when alloc_aggr_kprobe.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  kernel/kprobes.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3995f54..e9868ec 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -730,7 +730,13 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  		return NULL;
>  
>  	INIT_LIST_HEAD(&op->list);
> +
> +	/*
> +	 * copy gives arch_prepare_optimized_kprobe
> +	 * more information
> +	 */
>  	op->kp.addr = p->addr;
> +	copy_kprobe(p, &op->kp);
>  	arch_prepare_optimized_kprobe(op);
>  
>  	return &op->kp;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


