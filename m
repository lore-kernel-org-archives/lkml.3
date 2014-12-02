Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaLBC7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 21:59:06 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42599 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaLBC7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 21:59:04 -0500
Message-ID: <1417489141.4442.24.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next] udp: Neaten and reduce size of compute_score
 functions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 01 Dec 2014 18:59:01 -0800
In-Reply-To: <1417484341.4894.6.camel@perches.com>
References: <1417484341.4894.6.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 17:39 -0800, Joe Perches wrote:
> The compute_score functions are a bit difficult to read.
> 
> Neaten them a bit to reduce object sizes and make them a
> bit more intelligible.
> 
> Return early to avoid indentation and avoid unnecessary
> initializations.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/ipv4/udp.c | 111 +++++++++++++++++++++++++++++++-------------------------
>  net/ipv6/udp.c | 113 ++++++++++++++++++++++++++++++++-------------------------
>  2 files changed, 125 insertions(+), 99 deletions(-)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index b2d6068..227e6ad 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -336,38 +336,45 @@ int udp_v4_get_port(struct sock *sk, unsigned short snum)
>  	return udp_lib_get_port(sk, snum, ipv4_rcv_saddr_equal, hash2_nulladdr);
>  }
>  
> -static inline int compute_score(struct sock *sk, struct net *net, __be32 saddr,
> -			 unsigned short hnum,
> -			 __be16 sport, __be32 daddr, __be16 dport, int dif)
> +static inline int compute_score(struct sock *sk, struct net *net,
> +				__be32 saddr, unsigned short hnum, __be16 sport,
> +				__be32 daddr, __be16 dport, int dif)
>  {
> -	int score = -1;
> +	int score;
> +	struct inet_sock *inet;
>  
> -	if (net_eq(sock_net(sk), net) && udp_sk(sk)->udp_port_hash == hnum &&
> -			!ipv6_only_sock(sk)) {
> -		struct inet_sock *inet = inet_sk(sk);
> +	if (!(net_eq(sock_net(sk), net) &&
> +	      udp_sk(sk)->udp_port_hash == hnum &&
> +	      !ipv6_only_sock(sk)))
> +		return -1

Or even better :


	if (!net_eq(sock_net(sk), net) ||
	    udp_sk(sk)->udp_port_hash != hnum ||
	    ipv6_only_sock(sk))
		return -1;


