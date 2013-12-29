Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3L2RMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 12:12:01 -0500
Received: from hofr.at ([212.69.189.236]:40185 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab3L2RL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 12:11:59 -0500
Date: Sun, 29 Dec 2013 18:11:54 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: Sami Pietikainen <Sami.Pietikainen@wapice.com>,
        Jouko Haapaluoma <jouko.haapaluoma@wapice.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RT] add missing local serialization in ip_output.c
Message-ID: <20131229171154.GA23586@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in response to the oops in ip_output.c:ip_send_unicast_reply under high 
network load with CONFIG_PREEMPT_RT_FULL=y, reported by Sami Pietikainen 
<Sami.Pietikainen@wapice.com>, this patch adds local serialization in 
ip_send_unicast_reply.

from ip_output.c:
/*
 *      Generic function to send a packet as reply to another packet.
 *      Used to send some TCP resets/acks so far.
 *
 *      Use a fake percpu inet socket to avoid false sharing and contention.
 */
static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
...

which was added in commit be9f4a44 in linux-stable. The git log, wich
introduced the PER_CPU unicast_sock, states:
<snip>
commit be9f4a44e7d41cee50ddb5f038fc2391cbbb4046
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Jul 19 07:34:03 2012 +0000

    ipv4: tcp: remove per net tcp_sock
    
    tcp_v4_send_reset() and tcp_v4_send_ack() use a single socket
    per network namespace.
    
    This leads to bad behavior on multiqueue NICS, because many cpus
    contend for the socket lock and once socket lock is acquired, extra
    false sharing on various socket fields slow down the operations.
    
    To better resist to attacks, we use a percpu socket. Each cpu can
    run without contention, using appropriate memory (local node)
<snip>

The per-cpu here thus is assuming exclusivity serializing per cpu - so 
the use of get_cpu_ligh introduced in 
net-use-cpu-light-in-ip-send-unicast-reply.patch, which droped the 
preempt_disable in favor of a migrate_disable is probably wrong as this 
only handles the referencial consistency but not the serialization. To
evade a preempt_disable here a local lock would be needed.

Therapie: 
 * add local lock: 
 * and re-introduce local serialization:
 
Tested on x86 with high network load using the testcase from Sami Pietikainen
  while : ; do wget -O - ftp://LOCAL_SERVER/empty_file > /dev/null 2>&1; done

Link: http://www.spinics.net/lists/linux-rt-users/msg11007.html
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 net/ipv4/ip_output.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e9fa68c..1e68f65 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -79,6 +79,7 @@
 #include <linux/mroute.h>
 #include <linux/netlink.h>
 #include <linux/tcp.h>
+#include <linux/locallock.h>
 
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 EXPORT_SYMBOL(sysctl_ip_default_ttl);
@@ -1468,6 +1469,9 @@ static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
 	.uc_ttl		= -1,
 };
 
+/* serialize concurrent calls on the same CPU to ip_send_unicast_reply */
+static DEFINE_LOCAL_IRQ_LOCK(unicast_lock);
+
 void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 			   __be32 saddr, const struct ip_reply_arg *arg,
 			   unsigned int len)
@@ -1506,7 +1510,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		return;
 
 	get_cpu_light();
-	inet = &__get_cpu_var(unicast_sock);
+	inet = &get_locked_var(unicast_lock, unicast_sock);
 
 	inet->tos = arg->tos;
 	sk = &inet->sk;
@@ -1530,6 +1534,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		ip_push_pending_frames(sk, &fl4);
 	}
 
+	put_locked_var(unicast_lock, unicast_sock);
 	put_cpu_light();
 
 	ip_rt_put(rt);
-- 
1.7.2.5

