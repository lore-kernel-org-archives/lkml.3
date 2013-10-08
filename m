Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3JHCvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3JHCvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:51:35 -0400
Message-ID: <525372EF.9090307@redhat.com>
Date: Tue, 08 Oct 2013 10:50:23 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] tun: don't look at current when non-blocking
References: <20131006182512.GA16504@redhat.com>
In-Reply-To: <20131006182512.GA16504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 02:25 AM, Michael S. Tsirkin wrote:
> We play with a wait queue even if socket is
> non blocking. This is an obvious waste.
> Besides, it will prevent calling the non blocking
> variant when current is not valid.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>
>  drivers/net/tun.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 807815f..7cb105c 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1293,7 +1293,8 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
>  	if (unlikely(!noblock))
>  		add_wait_queue(&tfile->wq.wait, &wait);
>  	while (len) {
> -		current->state = TASK_INTERRUPTIBLE;
> +		if (unlikely(!noblock))
> +			current->state = TASK_INTERRUPTIBLE;
>  
>  		/* Read frames from the queue */
>  		if (!(skb = skb_dequeue(&tfile->socket.sk->sk_receive_queue))) {
> @@ -1320,9 +1321,10 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
>  		break;
>  	}
>  
> -	current->state = TASK_RUNNING;
> -	if (unlikely(!noblock))
> +	if (unlikely(!noblock)) {
> +		current->state = TASK_RUNNING;
>  		remove_wait_queue(&tfile->wq.wait, &wait);
> +	}
>  
>  	return ret;
>  }

