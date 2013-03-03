Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3CCSfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 13:35:10 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:60006 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3CCSfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 13:35:08 -0500
Message-ID: <1362335704.15793.81.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Sun, 03 Mar 2013 10:35:04 -0800
In-Reply-To: <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 09:55 -0800, Eliezer Tamir wrote:

> index 821c7f4..d1d1016 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -408,6 +408,10 @@ struct sk_buff {
>  	struct sock		*sk;
>  	struct net_device	*dev;
>  
> +#ifdef CONFIG_INET_LL_RX_POLL
> +	struct napi_struct	*dev_ref; /* where this skb came from */
> +#endif
> +
>  	/*
>  	 * This is the control buffer. It is free to use for every
>  	 * layer. Please put your private variables there. If you

Yes, thats the killer, because :

1) It adds 8 bytes per skb, and we are going to reach the 256 bytes per
sk_buff boundary. cloned skbs will use an extra cache line.

It might make sense to union this on dma_cookie, as dma_cookie is only
used on TX path.

2) We need to reference count napi structs.

For 2) , we would need to add a percpu ref counter (a bit like struct
netdevice -> pcpu_refcnt)

Alternative to 2) would be to use a generation id, incremented every
time a napi used in spin polling enabled driver is dismantled (and freed
after RCU grace period)

And store in sockets not only the pointer to napi_struct, but the
current generation id : If the generation id doesnt match, disable
the spinpoll until next packet rebuilds the cache again.



