Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaFXBZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:25:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:56066 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200AbaFXBZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:25:33 -0400
X-IronPort-AV: E=Sophos;i="5.00,765,1396972800"; 
   d="scan'208";a="32324171"
Message-ID: <53A8D3B0.8090004@cn.fujitsu.com>
Date: Tue, 24 Jun 2014 09:26:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tetra2005@gmail.com>,
        <preobr@google.com>, <dvyukov@google.com>, <kcc@google.com>,
        <koct9i@gmail.com>
Subject: Re: [PATCH] lib: idr: fix out-of-bounds pointer dereference
References: <1403530628-32306-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1403530628-32306-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 09:37 PM, Andrey Ryabinin wrote:
> I'm working on address sanitizer project for kernel. Recently we started
> experiments with stack instrumentation, to detect out-of-bounds
> read/write bugs on stack.
> 
> Just after booting I've hit out-of-bounds read on stack in idr_for_each
> (and in __idr_remove_all as well):
> 
> 	struct idr_layer **paa = &pa[0];
> 
> 	while (id >= 0 && id <= max) {
> 		...
> 		while (n < fls(id)) {
> 			n += IDR_BITS;
> 			p = *--paa; <--- here we are reading pa[-1] value.
> 		}
> 	}

I prefer to moving the loop-exit-condition-checking code down:

	if (id < 0 || id > max)		/* only idr_get_next() needs this branch */
		return ...

	for (;;) {			/* move out from here */
		...
		increase the @id;
		if (id < 0 || id > max)	/* move to here */
			break;
		while (n < fls(id)) {
			...
		}
	}


> 
> Despite the fact that after this dereference we are exiting out of loop and
> never use p, such behaviour is undefined and should be avoided.
> 
> Fix this by moving pointer derference to the beggining of the loop, right
> before we will use it.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  lib/idr.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index 39158ab..50be3fa 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -590,26 +590,27 @@ static void __idr_remove_all(struct idr *idp)
>  	struct idr_layer **paa = &pa[0];
>  
>  	n = idp->layers * IDR_BITS;
> -	p = idp->top;
> +	*paa = idp->top;
>  	RCU_INIT_POINTER(idp->top, NULL);
>  	max = idr_max(idp->layers);
>  
>  	id = 0;
>  	while (id >= 0 && id <= max) {
> +		p = *paa;
>  		while (n > IDR_BITS && p) {
>  			n -= IDR_BITS;
> -			*paa++ = p;
>  			p = p->ary[(id >> n) & IDR_MASK];
> +			*++paa = p;
>  		}
>  
>  		bt_mask = id;
>  		id += 1 << n;
>  		/* Get the highest bit that the above add changed from 0->1. */
>  		while (n < fls(id ^ bt_mask)) {
> -			if (p)
> -				free_layer(idp, p);
> +			if (*paa)
> +				free_layer(idp, *paa);
>  			n += IDR_BITS;
> -			p = *--paa;
> +			--paa;
>  		}
>  	}
>  	idp->layers = 0;
> @@ -692,15 +693,16 @@ int idr_for_each(struct idr *idp,
>  	struct idr_layer **paa = &pa[0];
>  
>  	n = idp->layers * IDR_BITS;
> -	p = rcu_dereference_raw(idp->top);
> +	*paa = rcu_dereference_raw(idp->top);
>  	max = idr_max(idp->layers);
>  
>  	id = 0;
>  	while (id >= 0 && id <= max) {
> +		p = *paa;
>  		while (n > 0 && p) {
>  			n -= IDR_BITS;
> -			*paa++ = p;
>  			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
> +			*++paa = p;
>  		}
>  
>  		if (p) {
> @@ -712,7 +714,7 @@ int idr_for_each(struct idr *idp,
>  		id += 1 << n;
>  		while (n < fls(id)) {
>  			n += IDR_BITS;
> -			p = *--paa;
> +			--paa;
>  		}
>  	}
>  
> @@ -740,17 +742,18 @@ void *idr_get_next(struct idr *idp, int *nextidp)
>  	int n, max;
>  
>  	/* find first ent */
> -	p = rcu_dereference_raw(idp->top);
> +	p = *paa = rcu_dereference_raw(idp->top);
>  	if (!p)
>  		return NULL;
>  	n = (p->layer + 1) * IDR_BITS;
>  	max = idr_max(p->layer + 1);
>  
>  	while (id >= 0 && id <= max) {
> +		p = *paa;
>  		while (n > 0 && p) {
>  			n -= IDR_BITS;
> -			*paa++ = p;
>  			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
> +			*++paa = p;
>  		}
>  
>  		if (p) {
> @@ -768,7 +771,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
>  		id = round_up(id + 1, 1 << n);
>  		while (n < fls(id)) {
>  			n += IDR_BITS;
> -			p = *--paa;
> +			--paa;
>  		}
>  	}
>  	return NULL;

