Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaCXLMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:12:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39555 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaCXLMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:12:10 -0400
Date: Mon, 24 Mar 2014 07:11:44 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: davem@davemloft.net, ebiederm@xmission.com, cwang@twopensource.com,
        kaber@trash.net, antonio@meshcoding.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/core: Use RCU_INIT_POINTER(x, NULL) in netpoll.c
Message-ID: <20140324111144.GA19368@hmsreliant.think-freely.org>
References: <1395601966-12490-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395601966-12490-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 12:42:46AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> And in the case of the NULL pointer, there is no structure to initialize. 
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
No, I don't think this is right. __netpoll_cleanup can be called in parallel
with bottom half access to dev->npinfo.  rcu_assign pointer is safe against
those accesses, but RCU_INIT_POINTER is not.

Neil

> ---
>  net/core/netpoll.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index 7291dde..41c4e9c 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -809,7 +809,7 @@ void __netpoll_cleanup(struct netpoll *np)
>  		if (ops->ndo_netpoll_cleanup)
>  			ops->ndo_netpoll_cleanup(np->dev);
>  
> -		rcu_assign_pointer(np->dev->npinfo, NULL);
> +		RCU_INIT_POINTER(np->dev->npinfo, NULL);
>  		call_rcu_bh(&npinfo->rcu, rcu_cleanup_netpoll_info);
>  	}
>  }
> -- 
> 1.7.9.5
> 
> 
