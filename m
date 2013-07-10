Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3GJGOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:14:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3GJGOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:14:30 -0400
Date: Wed, 10 Jul 2013 09:15:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 2/2] macvtap: correctly linearize skb when
 zerocopy is used
Message-ID: <20130710061542.GE19759@redhat.com>
References: <1373435008-19407-1-git-send-email-jasowang@redhat.com>
 <1373435008-19407-2-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373435008-19407-2-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 01:43:28PM +0800, Jason Wang wrote:
> Userspace may produce vectors greater than MAX_SKB_FRAGS. When we try to
> linearize parts of the skb to let the rest of iov to be fit in
> the frags, we need count copylen into linear when calling macvtap_alloc_skb()
> instead of partly counting it into data_len. Since this breaks
> zerocopy_sg_from_iovec() since its inner counter assumes nr_frags should
> be zero at beginning. This cause nr_frags to be increased wrongly without
> setting the correct frags.
> 
> This bug were introduced from b92946e2919134ebe2a4083e4302236295ea2a73
> (macvtap: zerocopy: validate vectors before building skb).
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> - This patch is needed for stable.
> - Changes from v1: introduce a local variable to track linear size.
> ---
>  drivers/net/macvtap.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index b6dd6a7..502d948 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -647,6 +647,7 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
>  	int vnet_hdr_len = 0;
>  	int copylen = 0;
>  	bool zerocopy = false;
> +	size_t linear;
>  
>  	if (q->flags & IFF_VNET_HDR) {
>  		vnet_hdr_len = q->vnet_hdr_sz;
> @@ -701,11 +702,14 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
>  			copylen = vnet_hdr.hdr_len;
>  		if (!copylen)
>  			copylen = GOODCOPY_LEN;
> -	} else
> +		linear = copylen;
> +	} else {
>  		copylen = len;
> +		linear = vnet_hdr.hdr_len;
> +	}
>  
>  	skb = macvtap_alloc_skb(&q->sk, NET_IP_ALIGN, copylen,
> -				vnet_hdr.hdr_len, noblock, &err);
> +				linear, noblock, &err);
>  	if (!skb)
>  		goto err;
>  
> -- 
> 1.7.1
