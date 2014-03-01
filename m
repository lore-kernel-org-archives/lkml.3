Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaCADx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 22:53:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:11451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753026AbaCADwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:52:44 -0500
Message-Id: <20140301035237.424335985@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 28 Feb 2014 22:52:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RT 11/14] net: ip_send_unicast_reply: add missing local serialization
References: <20140301035209.031474616@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0011-net-ip_send_unicast_reply-add-missing-local-serializ.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.32-rt31-rc2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicholas Mc Guire <der.herr@hofr.at>

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
Cc: stable-rt@vger.kernel.org
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/ip_output.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 2d69b1b..ab674e8 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -79,6 +79,7 @@
 #include <linux/mroute.h>
 #include <linux/netlink.h>
 #include <linux/tcp.h>
+#include <linux/locallock.h>
 
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 EXPORT_SYMBOL(sysctl_ip_default_ttl);
@@ -1471,6 +1472,9 @@ static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
 	.uc_ttl		= -1,
 };
 
+/* serialize concurrent calls on the same CPU to ip_send_unicast_reply */
+static DEFINE_LOCAL_IRQ_LOCK(unicast_lock);
+
 void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 			   __be32 saddr, const struct ip_reply_arg *arg,
 			   unsigned int len)
@@ -1508,8 +1512,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	if (IS_ERR(rt))
 		return;
 
-	get_cpu_light();
-	inet = &__get_cpu_var(unicast_sock);
+	inet = &get_locked_var(unicast_lock, unicast_sock);
 
 	inet->tos = arg->tos;
 	sk = &inet->sk;
@@ -1533,7 +1536,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		ip_push_pending_frames(sk, &fl4);
 	}
 
-	put_cpu_light();
+	put_locked_var(unicast_lock, unicast_sock);
 
 	ip_rt_put(rt);
 }
-- 
1.8.5.3


