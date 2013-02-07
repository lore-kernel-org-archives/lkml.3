Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295Ab3BGVed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:34:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030252Ab3BGVec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:34:32 -0500
Date: Thu, 7 Feb 2013 13:34:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: peter.senna@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
Message-Id: <20130207133430.082512cc.akpm@linux-foundation.org>
In-Reply-To: <1359597622-31532-1-git-send-email-sasha.levin@oracle.com>
References: <1359597622-31532-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 21:00:22 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> I'm not sure why, but the hlist for each entry iterators were conceived
> differently from the list ones. While the list ones are nice and elegant:
> 
>         list_for_each_entry(pos, head, member)
> 
> The hlist ones were greedy and wanted an extra parameter:
> 
>         hlist_for_each_entry(tpos, pos, head, member)
> 
> Why did they need an extra pos parameter? I'm not quite sure. Not only
> they don't really need it, it also prevents the iterator from looking
> exactly like the list iterator, which is unfortunate.
>
> ...
>
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -111,9 +111,7 @@ EXPORT_SYMBOL_GPL(raw_unhash_sk);
>  static struct sock *__raw_v4_lookup(struct net *net, struct sock *sk,
>  		unsigned short num, __be32 raddr, __be32 laddr, int dif)
>  {
> -	struct hlist_node *node;
> -
> -	sk_for_each_from(sk, node) {
> +	sk_for_each_from(sk) {
>  		struct inet_sock *inet = inet_sk(sk);
>  
>  		if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
> @@ -122,6 +120,11 @@ static struct sock *__raw_v4_lookup(struct net *net, struct sock *sk,
>  		    !(sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif))
>  			goto found; /* gotcha */
>  	}
> +	sk_for_each_from (sk) {
> +		struct inet_sock *inet=inet_sk(sk);
> +		if (net_eq(sock_net(sk), net) && inet->inet_num == num && !(inet->inet_daddr && inet->inet_daddr != raddr) && !(inet->inet_rcv_saddr && inet->inet_rcv_saddr != laddr) && !(sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif))
> +			goto found;
> +		}
>  	sk = NULL;
>  found:
>  	return sk;

The second hunk is bogus and I dropped it.  This didn't increase my
confidence in the patch :(

