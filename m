Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaCFUDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:03:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60669 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCFUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:03:40 -0500
Date: Thu, 06 Mar 2014 15:03:37 -0500 (EST)
Message-Id: <20140306.150337.187768633462445082.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sergey.senozhatsky@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: use raw_cpu ops in snmp stats bh
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394118272.27473.36.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1394110536-4532-1-git-send-email-sergey.senozhatsky@gmail.com>
	<1394117074.27473.29.camel@edumazet-glaptop2.roam.corp.google.com>
	<1394118272.27473.36.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 12:03:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 06 Mar 2014 07:04:32 -0800

> On Thu, 2014-03-06 at 06:44 -0800, Eric Dumazet wrote:
> 
>> I think you missed a lot of mails sent by Chrisoph Lameter recently...
> 
> s/Chrisoph/Christoph/
> 
> Appropriate fix would be the following one, please submit this formally.
> 
> 
> Fixes: f19c29e3e391 ("tcp: snmp stats for Fast Open, SYN rtx, and data pkts")
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 5286228679bd..df063a32a177 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -87,7 +87,7 @@ static void tcp_event_new_data_sent(struct sock *sk, const struct sk_buff *skb)
>  		tcp_rearm_rto(sk);
>  	}
>  
> -	NET_ADD_STATS_BH(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
> +	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
>  			 tcp_skb_pcount(skb));
>  }

I'll take care of this, as follows:

====================
>From 2997439191bc16340abcf51b18a7152b372a057e Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Thu, 6 Mar 2014 15:03:17 -0500
Subject: [PATCH] tcp: Use NET_ADD_STATS instead of NET_ADD_STATS_BH in
 tcp_event_new_data_sent()

Can be invoked from non-BH context.

Based upon a patch by Eric Dumazet.

Fixes: f19c29e3e391 ("tcp: snmp stats for Fast Open, SYN rtx, and data pkts")
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/ip.h      | 1 +
 net/ipv4/tcp_output.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index b885d75..25064c2 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -187,6 +187,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 #define NET_INC_STATS(net, field)	SNMP_INC_STATS((net)->mib.net_statistics, field)
 #define NET_INC_STATS_BH(net, field)	SNMP_INC_STATS_BH((net)->mib.net_statistics, field)
 #define NET_INC_STATS_USER(net, field) 	SNMP_INC_STATS_USER((net)->mib.net_statistics, field)
+#define NET_ADD_STATS(net, field, adnd)	SNMP_ADD_STATS((net)->mib.net_statistics, field, adnd)
 #define NET_ADD_STATS_BH(net, field, adnd) SNMP_ADD_STATS_BH((net)->mib.net_statistics, field, adnd)
 #define NET_ADD_STATS_USER(net, field, adnd) SNMP_ADD_STATS_USER((net)->mib.net_statistics, field, adnd)
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5286228..a02c884 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -87,8 +87,8 @@ static void tcp_event_new_data_sent(struct sock *sk, const struct sk_buff *skb)
 		tcp_rearm_rto(sk);
 	}
 
-	NET_ADD_STATS_BH(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
-			 tcp_skb_pcount(skb));
+	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
+		      tcp_skb_pcount(skb));
 }
 
 /* SND.NXT, if window was not shrunk.
-- 
1.7.11.7

