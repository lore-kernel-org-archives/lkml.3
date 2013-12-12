Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3LLOSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:18:24 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61482 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3LLOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:18:22 -0500
Message-ID: <1386857899.19078.49.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net/sched/sch_tbf.c: fix linking error
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Date: Thu, 12 Dec 2013 06:18:19 -0800
In-Reply-To: <1386851936-1582-1-git-send-email-qais.yousef@imgtec.com>
References: <1386851936-1582-1-git-send-email-qais.yousef@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 12:38 +0000, Qais Yousef wrote:
> ERROR: "__udivdi3" [net/sched/sch_tbf.ko] undefined!
> 
> introduced by: cc106e441a63 (net: sched: tbf: fix the calculation of max_size)
> 
> which adds a 64 by 32 bit division without using do_div().
> Fix it by using do_div(len/ 53) instead of len/53.
> 
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-next@vger.kernel.org
> ---
> We caught this error on linux-next today. This is my quick attemp of a fix.
> If it's not appropriate or doesn't make sense my apologies and feel free to
> resend a better fix :)
> 
>  net/sched/sch_tbf.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
> index a44928c..771cbec 100644
> --- a/net/sched/sch_tbf.c
> +++ b/net/sched/sch_tbf.c
> @@ -131,8 +131,10 @@ static u64 psched_ns_t2l(const struct psched_ratecfg *r,
>  
>  	do_div(len, NSEC_PER_SEC);
>  
> -	if (unlikely(r->linklayer == TC_LINKLAYER_ATM))
> -		len = (len / 53) * 48;
> +	if (unlikely(r->linklayer == TC_LINKLAYER_ATM)) {
> +		do_div(len, 53);
> +		len *= 48;
> +	}
>  
>  	if (len > r->overhead)
>  		len -= r->overhead;

This looks like this was already fixed yesterday in David net tree : 

http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=d55d282e6af88120ad90e93a88f70e3116dc0e3d


