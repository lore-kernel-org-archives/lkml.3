Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaAQPAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:00:00 -0500
Received: from hofr.at ([212.69.189.236]:41127 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaAQO75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:59:57 -0500
Date: Fri, 17 Jan 2014 15:59:55 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org,
        Sami Pietikainen <Sami.Pietikainen@wapice.com>,
        Jouko Haapaluoma <jouko.haapaluoma@wapice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RT] add missing local serialization in ip_output.c
Message-ID: <20140117145955.GA5637@opentech.at>
References: <20131229171154.GA23586@opentech.at> <20140117144729.GB5785@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117144729.GB5785@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jan 2014, Sebastian Andrzej Siewior wrote:

> This is what I am going to apply. It also dropped the get_cpu_light()
> call which was added in a patch to remove the get_cpu_var() and is now
> no longer required since we have the get_locked_var() thingy now.
>

I do not think you can drop that - what is preventing migration now ?

#define get_locked_var(lvar, var)                                       \
        (*({                                                            \
                local_lock(lvar);                                       \
                &__get_cpu_var(var);                                    \
        }))

No migrate_disable here - so how is this protected against migration ?
Note that I did send out mail on this because I believe get_locked_var
should actually be doing a a migrate_disable/enable but got no feedback on that
yet.

So for now I think you need to retain the get_cpu_light/put_cpu_light
   
thx!
hofrat
 
> From: Nicholas Mc Guire <der.herr@hofr.at>
> Date: Sun, 29 Dec 2013 18:11:54 +0100
> Subject: [PATCH] net: ip_send_unicast_reply: add missing local serialization
> 
> in response to the oops in ip_output.c:ip_send_unicast_reply under high
> network load with CONFIG_PREEMPT_RT_FULL=y, reported by Sami Pietikainen
> <Sami.Pietikainen@wapice.com>, this patch adds local serialization in
> ip_send_unicast_reply.
> 
> from ip_output.c:
> /*
>  *      Generic function to send a packet as reply to another packet.
>  *      Used to send some TCP resets/acks so far.
>  *
>  *      Use a fake percpu inet socket to avoid false sharing and contention.
>  */
> static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
> ...
> 
> which was added in commit be9f4a44 in linux-stable. The git log, wich
> introduced the PER_CPU unicast_sock, states:
> <snip>
> commit be9f4a44e7d41cee50ddb5f038fc2391cbbb4046
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Jul 19 07:34:03 2012 +0000
> 
>     ipv4: tcp: remove per net tcp_sock
> 
>     tcp_v4_send_reset() and tcp_v4_send_ack() use a single socket
>     per network namespace.
> 
>     This leads to bad behavior on multiqueue NICS, because many cpus
>     contend for the socket lock and once socket lock is acquired, extra
>     false sharing on various socket fields slow down the operations.
> 
>     To better resist to attacks, we use a percpu socket. Each cpu can
>     run without contention, using appropriate memory (local node)
> <snip>
> 
> The per-cpu here thus is assuming exclusivity serializing per cpu - so
> the use of get_cpu_ligh introduced in
> net-use-cpu-light-in-ip-send-unicast-reply.patch, which droped the
> preempt_disable in favor of a migrate_disable is probably wrong as this
> only handles the referencial consistency but not the serialization. To
> evade a preempt_disable here a local lock would be needed.
> 
> Therapie:
>  * add local lock:
>  * and re-introduce local serialization:
> 
> Tested on x86 with high network load using the testcase from Sami Pietikainen
>   while : ; do wget -O - ftp://LOCAL_SERVER/empty_file > /dev/null 2>&1; done
> 
> Link: http://www.spinics.net/lists/linux-rt-users/msg11007.html
> Cc: stable-rt@vger.kernel.org
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/ipv4/ip_output.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index e9fa68c..8bb3b4a 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -79,6 +79,7 @@
>  #include <linux/mroute.h>
>  #include <linux/netlink.h>
>  #include <linux/tcp.h>
> +#include <linux/locallock.h>
>  
>  int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
>  EXPORT_SYMBOL(sysctl_ip_default_ttl);
> @@ -1468,6 +1469,9 @@ static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
>  	.uc_ttl		= -1,
>  };
>  
> +/* serialize concurrent calls on the same CPU to ip_send_unicast_reply */
> +static DEFINE_LOCAL_IRQ_LOCK(unicast_lock);
> +
>  void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
>  			   __be32 saddr, const struct ip_reply_arg *arg,
>  			   unsigned int len)
> @@ -1505,8 +1509,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
>  	if (IS_ERR(rt))
>  		return;
>  
> -	get_cpu_light();
> -	inet = &__get_cpu_var(unicast_sock);
> +	inet = &get_locked_var(unicast_lock, unicast_sock);
>  
>  	inet->tos = arg->tos;
>  	sk = &inet->sk;
> @@ -1530,7 +1533,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
>  		ip_push_pending_frames(sk, &fl4);
>  	}
>  
> -	put_cpu_light();
> +	put_locked_var(unicast_lock, unicast_sock);
>  
>  	ip_rt_put(rt);
>  }
> -- 
> 1.8.5.2
> 
