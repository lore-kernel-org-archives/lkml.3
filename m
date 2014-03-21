Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767AbaCUNfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:35:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28920 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761025AbaCUNei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:34:38 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, netdev@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 1/3] tcp: allow to enable repair mode for sockets in any state
Date: Fri, 21 Mar 2014 17:32:59 +0400
Message-Id: <1395408781-8145-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395408781-8145-1-git-send-email-avagin@openvz.org>
References: <1395408781-8145-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The repair mode is used for dumping state of tcp connections
(sequence numbers, queues, options, etc).

Currently the repair mode can be enalbed only for sockets in the
TCP_ESTABLISHED state. If a socket in another state, its internal
state can not be dumped.

Same time there is no guarantee that a connection won't be in other
states when we are dumping it, thus to be able to dump and restore
such states we need to get rid of CLOSE,ESTABLISHED in-kernel
limitation.

I see nothing wrong to allow enabling of the repair mode for connected
sockets in any states.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 net/ipv4/tcp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 97c8f56..267adb7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1106,15 +1106,18 @@ int tcp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	}
 
 	if (unlikely(tp->repair)) {
+		err = -EINVAL;
+		if (tp->repair_queue == TCP_NO_QUEUE)
+			goto out_err;
+
+		if (sk->sk_state != TCP_ESTABLISHED)
+			goto out_err;
+
 		if (tp->repair_queue == TCP_RECV_QUEUE) {
 			copied = tcp_send_rcvq(sk, msg, size);
 			goto out;
 		}
 
-		err = -EINVAL;
-		if (tp->repair_queue == TCP_NO_QUEUE)
-			goto out_err;
-
 		/* 'common' sending to sendq */
 	}
 
@@ -2375,7 +2378,7 @@ void tcp_sock_destruct(struct sock *sk)
 static inline bool tcp_can_repair_sock(const struct sock *sk)
 {
 	return ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN) &&
-		((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_ESTABLISHED));
+		(sk->sk_state != TCP_LISTEN);
 }
 
 static int tcp_repair_options_est(struct tcp_sock *tp,
-- 
1.8.5.3

