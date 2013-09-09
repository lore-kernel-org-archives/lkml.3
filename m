Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3IICI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:08:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24266 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3IICIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:08:25 -0400
Message-ID: <522D2D82.2070604@huawei.com>
Date: Mon, 9 Sep 2013 10:08:02 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Wang YanQing <udknight@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        liguang <lig.fnst@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/3] SMP: simpilify function generic_smp_call_function_single_interrupt()
References: <1378653745-8343-1-git-send-email-liuj97@gmail.com> <1378653745-8343-2-git-send-email-liuj97@gmail.com>
In-Reply-To: <1378653745-8343-2-git-send-email-liuj97@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/8 23:22, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Now the call_single_data data structure is always locked by invoking
> csd_lock() before inserting it into corresponding call_single_queue
> list, so no need to save and check csd->flags in function
> generic_smp_call_function_single_interrupt().
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Wang YanQing <udknight@gmail.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: liguang <lig.fnst@cn.fujitsu.com>
> Cc: linux-kernel@vger.kernel.org

Hi, I've sent a same patch before and it has been applied by Ingo.
See http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=46591962cb5bfd2bfb0baf42497119c816503598

> ---
>  kernel/smp.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index a034712..baa2a65 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -181,25 +181,11 @@ void generic_smp_call_function_single_interrupt(void)
>  
>  	while (!list_empty(&list)) {
>  		struct call_single_data *csd;
> -		unsigned int csd_flags;
>  
>  		csd = list_entry(list.next, struct call_single_data, list);
>  		list_del(&csd->list);
> -
> -		/*
> -		 * 'csd' can be invalid after this call if flags == 0
> -		 * (when called through generic_exec_single()),
> -		 * so save them away before making the call:
> -		 */
> -		csd_flags = csd->flags;
> -
>  		csd->func(csd->info);
> -
> -		/*
> -		 * Unlocked CSDs are valid through generic_exec_single():
> -		 */
> -		if (csd_flags & CSD_FLAG_LOCK)
> -			csd_unlock(csd);
> +		csd_unlock(csd);
>  	}
>  }
>  
> 


