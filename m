Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaKZNrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:47:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaKZNru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:47:50 -0500
Date: Wed, 26 Nov 2014 15:47:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next V2] tun/macvtap: use consume_skb() instead of
 kfree_skb() when needed
Message-ID: <20141126134742.GA5358@redhat.com>
References: <1416987810-23263-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416987810-23263-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 03:43:30PM +0800, Jason Wang wrote:
> To be more friendly with drop monitor, we should only call kfree_skb() when
> the packets were dropped and use consume_skb() in other cases.
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - check the return value of tun/macvtap_put_user()
> ---
>  drivers/net/macvtap.c | 5 ++++-
>  drivers/net/tun.c     | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 42a80d3..c171ab6 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -862,7 +862,10 @@ static ssize_t macvtap_do_read(struct macvtap_queue *q,
>  		}
>  		iov_iter_init(&iter, READ, iv, segs, len);
>  		ret = macvtap_put_user(q, skb, &iter);
> -		kfree_skb(skb);
> +		if (ret < 0)

Maybe unlikely() here?

> +			kfree_skb(skb);
> +		else
> +			consume_skb(skb);
>  		break;
>  	}
>  
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index ac53a73..a21c130 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1363,7 +1363,10 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
>  
>  	iov_iter_init(&iter, READ, iv, segs, len);
>  	ret = tun_put_user(tun, tfile, skb, &iter);
> -	kfree_skb(skb);
> +	if (ret < 0)
> +		kfree_skb(skb);
> +	else
> +		consume_skb(skb);
>  
>  	return ret;
>  }
> -- 
> 1.9.1
