Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3FKOpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:45:38 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:52115 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3FKOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:45:35 -0400
Message-ID: <1370961930.3252.32.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 2/2] net:add socket option for low latency
 polling
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
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 11 Jun 2013 07:45:30 -0700
In-Reply-To: <20130611142438.17879.6389.stgit@ladj378.jer.intel.com>
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>
	 <20130611142438.17879.6389.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 17:24 +0300, Eliezer Tamir wrote:
> adds a socket option for low latency polling.
> This allows overriding the global sysctl value with a per-socket one.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  
> -static inline cycles_t ll_end_time(void)
> +static inline cycles_t ll_end_time(struct sock *sk)
>  {
> -	return TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll) + get_cycles();
> +	return TSC_MHZ * ACCESS_ONCE(sk->sk_ll_usec) + get_cycles();
>  }

Hmm, sk_ll_usec is an unsigned int.

(cycles_t)TSC_MHZ * ACCESS_ONCE(sk->sk_ll_usec) + get_cycles();

>  
> +#ifdef CONFIG_NET_LL_RX_POLL
> +	case SO_LL:
> +		if (!capable(CAP_NET_ADMIN))
> +			ret = -EACCES;
> +		else {
> +			unsigned long ulval;

Why an "unsigned long" ?


> +
> +			if (!copy_from_user(&ulval, optval, sizeof(ulval))
> +							&& ulval >= 0)
> +				sk->sk_ll_usec = ulval;
> +
> +			else
> +				ret = -EINVAL;

Just use
	sk->sk_ll_usec = val;

> +
> +		}
> +		break;
> +#endif
>  	default:
>  		ret = -ENOPROTOOPT;
>  		break;
> @@ -944,6 +961,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>  
>  	union {
>  		int val;
> +		unsigned long ulval;

Why an unsigned long ? 32bit are more than enough.

>  		struct linger ling;
>  		struct timeval tm;
>  	} v;
> @@ -1170,6 +1188,13 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>  		v.val = sock_flag(sk, SOCK_SELECT_ERR_QUEUE);
>  		break;
>  
> +#ifdef CONFIG_NET_LL_RX_POLL
> +	case SO_LL:
> +		len = sizeof(v.ulval);
> +		v.ulval = sk->sk_ll_usec;
> +		break;
> +#endif
> +



