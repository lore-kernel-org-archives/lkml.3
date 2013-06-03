Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3FCNFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:05:09 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39313 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCNFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:05:07 -0400
Message-ID: <1370264704.24311.129.camel@edumazet-glaptop>
Subject: Re: [PATCH v8 net-next 2/7] net: add low latency socket poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 03 Jun 2013 06:05:04 -0700
In-Reply-To: <20130603080128.18273.2408.stgit@ladj378.jer.intel.com>
References: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com>
	 <20130603080128.18273.2408.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 11:01 +0300, Eliezer Tamir wrote:
> Adds an ndo_ll_poll method and the code that supports it.
> This method can be used by low latency applications to busy-poll
> Ethernet device queues directly from the socket code.
> sysctl_net_ll_poll controls how many microseconds to poll.
> Default is zero (disabled).
> Individual protocol support will be added by subsequent patches.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
...
> diff --git a/include/net/ll_poll.h b/include/net/ll_poll.h

> +
> +static inline bool sk_valid_ll(struct sock *sk)
> +{
> +	return 0;

	return false;

> +}
> +
> +static inline bool sk_poll_ll(struct sock *sk, int nonblock)
> +{
> +	return 0;

	return false;
> +}
> +
> +static inline void skb_mark_ll(struct sk_buff *skb, struct napi_struct *napi)
> +{
> +}


>  	/*
>  	 * Before updating sk_refcnt, we must commit prior changes to memory
>  	 * (Documentation/RCU/rculist_nulls.txt for details)
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 741db5fc..ae98c95 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -19,6 +19,7 @@
>  #include <net/ip.h>
>  #include <net/sock.h>
>  #include <net/net_ratelimit.h>
> +#include <net/ll_poll.h>
>  
>  static int one = 1;
>  
> @@ -284,6 +285,15 @@ static struct ctl_table net_core_table[] = {
>  		.proc_handler	= flow_limit_table_len_sysctl
>  	},
>  #endif /* CONFIG_NET_FLOW_LIMIT */
> +#ifdef CONFIG_NET_LL_RX_POLL
> +	{
> +		.procname	= "low_latency_poll",
> +		.data		= &sysctl_net_ll_poll,
> +		.maxlen		= sizeof(unsigned long),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec

proc_doulongvec_minmax



