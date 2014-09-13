Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaIMLuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 07:50:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56717 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaIMLuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 07:50:24 -0400
Message-ID: <1410609022.7106.132.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] Freeing dst when the reference count <0 causes general
 protection fault, it could be a major security flaw as rogue app can modify
 dst to crash kernel.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shakil A Khan <shakilk1729@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net
Date: Sat, 13 Sep 2014 04:50:22 -0700
In-Reply-To: <1410596833-2548-1-git-send-email-shakilk1729@gmail.com>
References: <1410596833-2548-1-git-send-email-shakilk1729@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-13 at 01:27 -0700, Shakil A Khan wrote:
> Signed-off-by: Shakil A Khan <shakilk1729@gmail.com>
> ---
>  net/core/dst.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dst.c b/net/core/dst.c
> index a028409..6a848b0 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -284,7 +284,10 @@ void dst_release(struct dst_entry *dst)
>  		int newrefcnt;
>  
>  		newrefcnt = atomic_dec_return(&dst->__refcnt);
> -		WARN_ON(newrefcnt < 0);
> +
> +		if (WARN(newrefcnt < 0, "dst reference count less than zero"))
> +			return;
> +
>  		if (unlikely(dst->flags & DST_NOCACHE) && !newrefcnt)
>  			call_rcu(&dst->rcu_head, dst_destroy_rcu);
>  	}


A rogue application can not do trigger this, unless a major bug in the
kernel exists.

Instead of trying to hide the kernel bug, we need to fix it.

Can you describe how this could trigger with a pristine kernel ?



