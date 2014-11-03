Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaKCDmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:42:11 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43300 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaKCDmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:42:08 -0500
Message-ID: <1414986126.31792.43.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] ipv4: avoid divide 0 error in tcp_incr_quickack
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chen Weilong <chenweilong@huawei.com>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 02 Nov 2014 19:42:06 -0800
In-Reply-To: <1414978173-6948-1-git-send-email-chenweilong@huawei.com>
References: <1414978173-6948-1-git-send-email-chenweilong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 09:29 +0800, Chen Weilong wrote:
> From: Weilong Chen <chenweilong@huawei.com>
> 
> We got a problem like this:

> There was a wrong ack packet coming during TCP handshake. The socket's state
> was TCP_SYN_RECV, its rcv_mss was not initialize yet. So
> tcp_send_dupack -> tcp_enter_quickack_mode got a divide 0 error.
> This patch add a state check before tcp_enter_quickack_mode.
> 
> Signed-off-by: Weilong Chen <chenweilong@huawei.com>
> ---
>  net/ipv4/tcp_input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 4e4617e..9eb56dc 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3986,7 +3986,8 @@ static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
>  	if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
>  	    before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt)) {
>  		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
> -		tcp_enter_quickack_mode(sk);
> +		if (sk->sk_state != TCP_SYN_RECV)
> +			tcp_enter_quickack_mode(sk);
>  
>  		if (tcp_is_sack(tp) && sysctl_tcp_dsack) {
>  			u32 end_seq = TCP_SKB_CB(skb)->end_seq;


Sorry I do not think this is the right fix.

We have to not simply avoid the divide, but fix this issue by
understanding the missing steps.



