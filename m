Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3FEKdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:33:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3FEKc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:32:59 -0400
Date: Wed, 5 Jun 2013 13:33:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tuntap: fix a possible race between queue selection and
 changing queues
Message-ID: <20130605103332.GD31830@redhat.com>
References: <1370421897-30933-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370421897-30933-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 04:44:57PM +0800, Jason Wang wrote:
> Complier may generate codes that re-read the tun->numqueues during
> tun_select_queue(). This may be a race if vlan->numqueues were changed in the
> same time and can lead unexpected result (e.g. very huge value).
> 
> We need prevent the compiler from generating such codes by adding an
> ACCESS_ONCE() to make sure tun->numqueues were only read once.
> 
> Bug were introduced by commit c8d68e6be1c3b242f1c598595830890b65cea64a
> (tuntap: multiqueue support).
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

This is a theoretical problem, right?
So no need for stable.

> ---
>  drivers/net/tun.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index f042b03..adfcde7 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -352,7 +352,7 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb)
>  	u32 numqueues = 0;
>  
>  	rcu_read_lock();
> -	numqueues = tun->numqueues;
> +	numqueues = ACCESS_ONCE(tun->numqueues);
>  
>  	txq = skb_get_rxhash(skb);
>  	if (txq) {
> -- 
> 1.7.1
