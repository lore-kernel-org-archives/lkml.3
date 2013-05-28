Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab3E1Ag5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 20:36:57 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36171 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab3E1Agz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 20:36:55 -0400
Message-ID: <1369701413.3301.506.camel@edumazet-glaptop>
Subject: Re: [PATCH v5 net-next 3/5] tcp: add TCP support for low latency
 receive poll.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 27 May 2013 17:36:53 -0700
In-Reply-To: <20130527074421.29882.73968.stgit@ladj378.jer.intel.com>
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>
	 <20130527074421.29882.73968.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 10:44 +0300, Eliezer Tamir wrote:
> adds busy-poll support for TCP.
> 

Really, this is a small changelog for such an addition :(

How poll()/epoll() is supported ?

> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  net/ipv4/tcp.c       |    5 +++++
>  net/ipv4/tcp_input.c |    1 +
>  net/ipv4/tcp_ipv4.c  |    2 ++
>  3 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index d87ce72..652c75a 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -279,6 +279,7 @@
>  
>  #include <asm/uaccess.h>
>  #include <asm/ioctls.h>
> +#include <net/ll_poll.h>
>  
>  int sysctl_tcp_fin_timeout __read_mostly = TCP_FIN_TIMEOUT;
>  
> @@ -1551,6 +1552,10 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
>  	struct sk_buff *skb;
>  	u32 urg_hole = 0;
>  
> +	if (sk_valid_ll(sk) && skb_queue_empty(&sk->sk_receive_queue)
> +	    && (sk->sk_state == TCP_ESTABLISHED))
> +		sk_poll_ll(sk, nonblock);
> +
>  	lock_sock(sk);
>  
>  	err = -ENOTCONN;
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 9579e1a..4d82939 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -74,6 +74,7 @@
>  #include <linux/ipsec.h>
>  #include <asm/unaligned.h>
>  #include <net/netdma.h>
> +#include <net/ll_poll.h>
>  


Not sure why this include is needed in this file ?

You added nothing else but this line.

>  int sysctl_tcp_timestamps __read_mostly = 1;
>  int sysctl_tcp_window_scaling __read_mostly = 1;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index d20ede0..35fd8bc 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -75,6 +75,7 @@
>  #include <net/netdma.h>
>  #include <net/secure_seq.h>
>  #include <net/tcp_memcontrol.h>
> +#include <net/ll_poll.h>
>  
>  #include <linux/inet.h>
>  #include <linux/ipv6.h>
> @@ -2011,6 +2012,7 @@ process:
>  	if (sk_filter(sk, skb))
>  		goto discard_and_relse;
>  
> +	sk_mark_ll(sk, skb);
>  	skb->dev = NULL;
>  
>  	bh_lock_sock_nested(sk);

How IPv6 is handled ?



