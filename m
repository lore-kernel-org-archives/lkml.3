Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbaH1Jjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:39:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58668 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934842AbaH1Jjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:39:47 -0400
Message-ID: <53FEF8DC.5010607@hitachi.com>
Date: Thu, 28 Aug 2014 18:39:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "David A. Long" <dave.long@linaro.org>, Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will.deacon@arm.com>, Pei Feiyue <peifeiyue@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] kprobes: copy ainsn after alloc aggr kprobe
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com> <1409144552-12751-3-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1409144552-12751-3-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/27 22:02), Wang Nan wrote:
> Copy old kprobe to newly alloced optimized_kprobe before
> arch_prepare_optimized_kprobe(). Original kprove can brings more
> information to optimizer.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: "David A. Long" <dave.long@linaro.org> 
> Cc: Jon Medhurst <tixy@linaro.org>
> Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> Cc: Ben Dooks <ben.dooks@codethink.co.uk>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  kernel/kprobes.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3995f54..33cf568 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -730,7 +730,12 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  		return NULL;
>  
>  	INIT_LIST_HEAD(&op->list);
> -	op->kp.addr = p->addr;

Do not remove this, since copy_kprobe() doesn't copy kp.addr.

static inline void copy_kprobe(struct kprobe *ap, struct kprobe *p)
{
        memcpy(&p->opcode, &ap->opcode, sizeof(kprobe_opcode_t));
        memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));
}

Thank you,

> +
> +	/*
> +	 * copy gives arch_prepare_optimized_kprobe
> +	 * more information
> +	 */
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


